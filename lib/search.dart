//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/Helper/constants.dart';
import 'package:lets_chat/Helper/helperfunction.dart';
import 'package:lets_chat/database.dart';
import 'package:lets_chat/screens/chatRooms.dart';
import 'package:lets_chat/screens/conversation.dart';
import 'package:lets_chat/widget.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

String _myName;
class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchEditing= new TextEditingController();
  Database database=new Database();
  QuerySnapshot searchSnapshot;

  ///Create chatRoom and User to conversation screen.....
  createChatRoomFOrConversation(String userName){
    if(userName!=Constants.myName){
      String chatRoomId=getChatRoomId(userName,Constants.myName);
      List <String> users= [userName,Constants.myName];
      Map<String,dynamic>chatRoomMap={
        "users":users,
        "charooomid":chatRoomId,
      };
      database.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(context, MaterialPageRoute(
        builder:(context)=>ChatRoom(),
      ));
    }else{
      print("You Can't send message to yourself");
    }
  }

  Widget searchList(){
    return searchSnapshot!=null? ListView.builder(
        itemCount:searchSnapshot.docs.length,
        shrinkWrap: true,
        itemBuilder: (context,index){
          return SearchTile(
            userName:searchSnapshot.docs[index]["name"],  //Error ...searchSnapshot.docs[index].data()["name"],
            userEmail:searchSnapshot.docs[index]["email"],
          );
        }):Container();
  }

  Widget SearchTile({String userName ,String userEmail}){
    return  Container(
      padding:EdgeInsets.symmetric(horizontal: 24,vertical: 16),
      child: Row(
          children :[
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    userEmail,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ]
            ),
            Spacer(),
            GestureDetector(
              onTap: (){
                createChatRoomFOrConversation(userName);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:EdgeInsets.symmetric(horizontal: 16,vertical: 8),
                child:Text("Message"),
              ),
            )
          ]
      ),
    );
  }

  initiateSearch(){
    database.getUserByUsername(searchEditing.text).then((val){
      setState(() {
        searchSnapshot=val;
      });
    });
  }



  @override
  void initState() {
    initiateSearch();
    super.initState();
  }

  getUserInfo() async{
    _myName = await HelperFunction.getUserNameSharedPreference();
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: Container(
        child: Column(
          children:[
            Container(
              color: Colors.blueGrey[700],
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 16),
              child: Row(
                children: [
                  Expanded(
                      child: TextField(
                        controller: searchEditing,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                        decoration: InputDecoration(
                          hintText: "search username",
                          hintStyle: TextStyle(
                            color: Colors.white60,
                          ),
                          border: InputBorder.none,
                        ),
                      )
                  ),
                  GestureDetector(
                    onTap: (){
                      initiateSearch();
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
                        child: Icon(Icons.search)
                    ),
                  ),
                ],
              ),
            ),
            searchList(),
        ]
        ),
      ),
    );
  }
}

getChatRoomId(String a,String b){
  if(a.substring(0,1).codeUnitAt(0)>b.substring(0,1).codeUnitAt(0)){
    return "$b\_$a";
  }else{
    return "$a\_$b";
  }
}

