import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class Database{

  getUserByUsername(String username) async{
    return await FirebaseFirestore.instance.collection("users").where("name",isEqualTo: username).get();
  }
  getUserByUserEmail(String userEmail) async{
    return await FirebaseFirestore.instance.collection("users").where("email",isEqualTo: userEmail).get();
  }
  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("users").add(userMap);
  }
  createChatRoom(String chatRoomId,chatRoomMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).set(chatRoomMap).catchError((e){
      print(e.toString());
    });
  }

  getConversationMessages(String chatRoomId) async{
    return await FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").orderBy("time",descending: true).snapshots();
}

  addConversationMessages(String chatRoomId,messageMap){
    FirebaseFirestore.instance.collection("ChatRoom").doc(chatRoomId).collection("chats").doc(messageMap["message"]).set(messageMap).catchError((e){
      print(e.toString());
    });
  }
  getChatRooms(String userName) async{
  return await FirebaseFirestore.instance.collection("ChatRoom").where("users",arrayContains: userName).snapshots();
  }
  getOnlinestatusOfUser(userMap) async{
    return await FirebaseFirestore.instance.collection("users").doc(userMap['uid']).snapshots();
  }
}
