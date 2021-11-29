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
  int flag=0;
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final FirebaseFirestore _firestore =FirebaseFirestore.instance;

  AuthMethod authMethod=new AuthMethod();

  Database database=new Database();
  Stream chatRoomStream;

String secondUserName;

  Widget chatRoomList(){
    // getCurrentUserEmail();
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
    if(state==AppLifecycleState.resumed){
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
    setStatus("online");
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

////
class ChatRoomTile extends StatelessWidget {

final String userName;
final String chatRoomId;
ChatRoomTile(this.userName,this.chatRoomId);

  @override

  Widget build(BuildContext context) {
    print(userName);
    return GestureDetector(

      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder:
            (context)=>ConversationScreen(chatRoomId,userName)));
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
                  "${userName.substring(0,1).toUpperCase()}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 8,),
            Text(
                userName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
               // fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


/*
*/