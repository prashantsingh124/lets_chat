import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/Helper/authenticate.dart';
import 'package:lets_chat/Helper/constants.dart';
import 'package:lets_chat/Helper/helperfunction.dart';
import 'package:lets_chat/database.dart';
import 'package:lets_chat/screens/conversation.dart';
import 'package:lets_chat/screens/signin.dart';
import 'package:lets_chat/search.dart';
import 'package:lets_chat/services/auth.dart';
import 'package:lets_chat/widget.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> with WidgetsBindingObserver{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;
  AuthMethod authMethod=new AuthMethod();
  Database database=new Database();
  Stream chatRoomStream;
  String secondUserName;

  Widget chatRoomList(){
    return StreamBuilder(
     stream: chatRoomStream,
     builder: (context,snapshot){
       if(!snapshot.hasData) {
         return Center(child: CircularProgressIndicator());
       }
        return ListView.builder(
            itemCount:snapshot.data.docs.length,
            itemBuilder: (context,index){
              secondUserName=snapshot.data.docs[index].data()["charooomid"].toString().replaceAll("_", "").replaceAll(Constants.myName,"");
              return ChatRoomTile(snapshot.data.docs[index].data()["charooomid"].toString().replaceAll("_", "").replaceAll(Constants.myName,""),
                  snapshot.data.docs[index].data()["charooomid"]);
            });
     },

   );
 }

  void setStatus(String status) async{
    await _firestore.collection("users").doc(_auth.currentUser.uid).update({
      "status":status,
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state){
    if(state==AppLifecycleState.resumed ){
      //online
      setStatus("Online");
    }else{
      //offline
      setStatus("Offline");
    }
  }

  @override
  void initState(){
    getUserInfo();
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    super.initState();
  }


 getUserInfo() async{
   Constants.myName=await HelperFunction.getUserNameSharedPreference();
   database.getChatRooms(Constants.myName).then((value){
     setState(() {
       chatRoomStream=value;
     });
   });
   setState(() {
    });
 }

  //AuthMethod authMethod=new AuthMethod();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        backgroundColor: Colors.green[900],
        title:Text(
          'Lets Chat',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: (){
              setStatus("offline");
              authMethod.SignOut();
              Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>Authenticate(),
              ));
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Icon(Icons.exit_to_app),
            ),
          )
        ],
      ),
      body: chatRoomList(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()
          ));
        },
      ),
    );
  }
}

        //*****************BODY*******************\\

class ChatRoomTile extends StatefulWidget {
final String userName;
final String chatRoomId;
ChatRoomTile(this.userName,this.chatRoomId);

  @override
  _ChatRoomTileState createState() => _ChatRoomTileState();
}

class _ChatRoomTileState extends State<ChatRoomTile> {
Map<String, dynamic> userMap={'uid':'XZHfFHvF9ZT0psxfSZ9HW8Zfyw02'};
Database database = new Database();
Stream userOnlineStatus;
void getSecondUserMap(String UserName) async{
   await FirebaseFirestore.instance
      .collection('users')
      .where("name", isEqualTo:UserName )
      .get()
      .then((value) {
    setState(() {
      userMap = value.docs[0].data();
    });
  });
   await database.getOnlinestatusOfUser(userMap).then((value){
     print(value);
    setState(() {
      userOnlineStatus=value;
    });
  });
}

 Widget colorForUserOnline(snapshot){
      if(snapshot.data!=null && snapshot.data['status']=="Online") {
        return Container(
          height: 10,
          width: 10,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(40),
          ),
        );
      }
      else{
        return Container(
          height: 10,
          width: 10,
        );
      }

 }

 @override
 void initState() {

  print(widget.userName);
  getSecondUserMap(widget.userName);
  super.initState();
}

  @override

  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=>ConversationScreen(widget.chatRoomId,widget.userName)));
      },
      child: Container(
        color:Colors.black87,
        padding: EdgeInsets.symmetric(horizontal:24 ,vertical: 16),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Text(
                  "${widget.userName.substring(0,1).toUpperCase()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8,),
            Container(
              width: 200,
              child: Text(
                  widget.userName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(width: 50,),
            StreamBuilder<Object>(
              stream: userOnlineStatus,
              builder: (context, snapshot) {
                return colorForUserOnline(snapshot);
              }
            ),
          ],
        ),
      ),
    );
  }
}


/*
*/