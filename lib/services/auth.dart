//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:lets_chat/Helper/constants.dart';
import 'package:lets_chat/model.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class AuthMethod{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Fuser _userfromfirebaseUser(User user){
    return user !=null ? Fuser(userId :user.uid) : null;
  }
  Future signInWithEmailAndPassword(String email,String password) async{
    try{
      UserCredential result =await _auth.signInWithEmailAndPassword(email: email, password: password);
      User firebaseUser=result.user;

      _firestore
          .collection('users')
          .doc(_auth.currentUser.uid)
          .get();
      return _userfromfirebaseUser(firebaseUser);
    }
    catch(e){
    print (e.toString());
    }
  }
  Future signUpWithEmailAndPassword(String email,String password,String userName) async{
    try{
      UserCredential result =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User firebaseUser=result.user;
      await _firestore.collection('users').doc(_auth.currentUser.uid).set({
        "name": userName,
        "email": email,
        "status": "Unavalible",
        "uid": _auth.currentUser.uid,
      });
      return _userfromfirebaseUser(firebaseUser);
    }
    catch(e){
      print (e.toString());
    }
  }
  Future SignOut() async{
    try{
      return await _auth.signOut();
    }
    catch(e){

    }
  }



}