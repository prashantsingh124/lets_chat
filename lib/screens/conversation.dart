import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lets_chat/Helper/constants.dart';
import 'package:lets_chat/database.dart';
import 'package:lets_chat/widget.dart';
import 'package:lets_chat/screens/chatRooms.dart';



class ConversationScreen extends StatefulWidget {
   final String chatRoomId;
   final String userName;
   //Map<String, dynamic> userMap;
   ConversationScreen(this.chatRoomId,this.userName);
  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;

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
      print(userMap);
    });
  }

  Database database =new Database();
  Stream messageStream;
  TextEditingController messageController= new TextEditingController();

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
              print(snapshot.data.docs[index].data()["message"]);
              return MessageTile(snapshot.data.docs[index].data()["message"],snapshot.data.docs[index].data()["sendBy"]==Constants.myName);
          }),
        );
      },
    );
  }

  String userEmail,documentId;

  sendMessage(){
    if(messageController.text.isNotEmpty){
      Map<String,dynamic> messageMap={
      "message":messageController.text,
        "sendBy":Constants.myName,
        "time":DateTime.now().millisecondsSinceEpoch,
      };
      database.addConversationMessages(widget.chatRoomId, messageMap);
      messageController.text="";
    }
  }
  Stream snapVal;

  @override
  void initState() {
    getSecondUserMap(widget.userName);
    //userCurrentId();
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

    return Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.green[900],
        title: StreamBuilder<DocumentSnapshot>(
          stream:_firestore.collection("users").doc(userMap['uid']).snapshots() ,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
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
                      snapshot.data['status'],
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
              alignment: Alignment.bottomCenter,
              child: Container(
                color: Colors.blueGrey[700],
                padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                child: Row(
                  children: [
                    Expanded(
                        child: TextField(
                          controller: messageController,
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
                        sendMessage();
                      },
                      child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color(0x36FFFFFF),
                                Color(0x0FFFFFFF),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(48),
                          ),
                          child: Icon(Icons.send),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message,this.isSendByMe);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: isSendByMe ?0:24 , right: isSendByMe ? 24:0),
      margin: EdgeInsets.symmetric(vertical: 8),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: isSendByMe ? [
              const Color(0xff007EF4),
              const Color(0xff2A75BC),
              ]
              : [
              const Color(0x1AFFFFFF),
             const Color(0x1AFFFFFF),
          ],
        ),
          borderRadius: isSendByMe ? BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomLeft: Radius.circular(23)) :
          BorderRadius.only(topLeft: Radius.circular(23),topRight: Radius.circular(23),bottomRight: Radius.circular(23)),
      ),
        child: Text(
            message,
          style: TextStyle(
            color: Colors.white,
          ),
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