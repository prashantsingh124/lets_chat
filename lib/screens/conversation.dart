import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/Helper/constants.dart';
import 'package:lets_chat/database.dart';
import 'package:lets_chat/widget.dart';
import 'package:lets_chat/screens/chatRooms.dart';
import 'package:intl/intl.dart';



class ConversationScreen extends StatefulWidget {
   final String chatRoomId;
   final String userName;
   ConversationScreen(this.chatRoomId,this.userName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {

  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  Database database =new Database();
  Stream messageStream;
  bool typingStatus=false;
  TextEditingController messageController= new TextEditingController();
  String timeString;
  String userEmail,documentId,statusText;
  Map<String, dynamic> userMap;

  void getSecondUserMap(String UserName) async{
    await _firestore
        .collection('users')
        .where("name", isEqualTo:UserName )
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
      });
    });
  }
  void setStatus() async{
    await _firestore.collection("users").doc(FirebaseAuth.instance.currentUser.uid).update({
      "typing": typingStatus,
    });
    //typingStatus=false;
  }

  Widget chatMessageList(){
    return StreamBuilder(
      stream: messageStream,
      builder: (context,snapshot){
        if(!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        return Container(
            height: MediaQuery.of(context).size.height,
           //padding: EdgeInsets.symmetric(horizontal: 24,vertical: 80),
          padding: EdgeInsets.only(left: 0,right: 0,top: 0,bottom: 80),
          child: ListView.builder(
            reverse: true,
            itemCount:snapshot.data.docs.length,
              itemBuilder: (context,index){
              return MessageTile(snapshot.data.docs[index].data()["message"],snapshot.data.docs[index].data()["sendBy"]==Constants.myName,widget.chatRoomId);
          }),
        );
      },
    );
  }

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap={
      "message":messageController.text,
        "sendBy":Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch,
        "getTime" : DateFormat('hh:mm a').format(DateTime.now()).toString(),
      };
      timeString= messageMap["getTime"];
      database.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text="";
    }
  }

  @override
  void initState() {
    getSecondUserMap(widget.userName);
    database.getConversationMessages(widget.chatRoomId).then((value){
    setState(() {
      print(widget.chatRoomId);
      messageStream=value;
    });
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    setStatus();
    return WillPopScope(
    onWillPop: () async {
      typingStatus=false;
      return true;
    },
      child: Scaffold(
        appBar:AppBar(
          backgroundColor: Colors.green[900],
          title: StreamBuilder<DocumentSnapshot>(
            stream:_firestore.collection("users").doc(userMap['uid']).snapshots() ,
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                statusText = snapshot.data['typing'] == false ? snapshot.data['status'] : "typing...";
                return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                       widget.userName,
                       style: TextStyle(
                         fontSize:20,
                         color: Colors.white,
                         fontWeight: FontWeight.bold,
                       ),
                      ),
                      SizedBox(height: 2,),

                      Text(
                        statusText,
                        style: TextStyle(
                            fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,

                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container();
              }
            },
          ),
        ),
        body: Container(
          child: Stack(
            children: [
              chatMessageList(),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
                alignment: Alignment.bottomCenter,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadiusDirectional.circular(30.0),
                    color: Colors.blueGrey[700],
                  ),

                  padding: EdgeInsets.symmetric(horizontal: 20,vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: TextField(
                            controller: messageController,
                            onChanged: (text) {
                              if(messageController.text.isEmpty){
                                typingStatus=false;
                              }else {
                                typingStatus = true;
                              }
                              setStatus();
                            },
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: "Message",
                              hintStyle: TextStyle(
                                color: Colors.white60,
                              ),
                              border: InputBorder.none,
                            ),
                          )
                      ),
                      GestureDetector(
                        onTap: (){
                          typingStatus=false;
                          setStatus();
                          sendMessage();
                        },
                        child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                CircleAvatar(
                                  radius: 22,
                                  backgroundImage: AssetImage('images/send.jpg'),
                                )
                              ],
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  String chatRoomIdForTiming;
  MessageTile(this.message,this.isSendByMe,this.chatRoomIdForTiming);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ?0:10 , right: isSendByMe ? 10:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe ? [
              const Color(0xff008000),
                const Color(0xff228b22),
              ]
              : [
              const Color(0x1AFFFFFF),
             const Color(0x1AFFFFFF),
          ],
        ),
          borderRadius: isSendByMe ? BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomLeft: Radius.circular(23)) :
          BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomRight: Radius.circular(23)),
      ),
        child:StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomIdForTiming).collection("chats").doc(message).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize:16,
                        color: Colors.white,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      snapshot.data['getTime'],
                      style: TextStyle(
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}

/*getCurrentUserEmail() {
    //final user = await _auth.currentUser.then((value) => userEmail = value.email);
    //  print(FirebaseAuth.instance.currentUser.email);
    userEmail=FirebaseAuth.instance.currentUser.email;
  }*/
/* void userCurrentId() async {
    getCurrentUserEmail();
    var collection = FirebaseFirestore.instance.collection('users');
    var querySnapshots = await collection.where("name", isEqualTo: widget.secondUserName)
        .get();
    for (var snapshot in querySnapshots.docs) {
      documentId = snapshot.id;
    }
    print(documentId);
  }*/
