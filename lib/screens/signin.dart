import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/Helper/constants.dart';
import 'package:lets_chat/database.dart';
import 'package:lets_chat/screens/chatRooms.dart';
import 'package:lets_chat/services/auth.dart';
import 'package:lets_chat/widget.dart';
import 'package:lets_chat/Helper/helperfunction.dart';



class SignIn extends StatefulWidget {
  final Function toggle;
  SignIn(this.toggle);
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final formKey =GlobalKey<FormState>();
  AuthMethod authMethod=new AuthMethod();
  TextEditingController emailController =new TextEditingController();
  TextEditingController passwordController =new TextEditingController();
  bool isLoading=false;
  Database database=new Database();
  QuerySnapshot snapshotUserInfo;

  signIn(){
    if(formKey.currentState.validate()){
      HelperFunction.saveUserEmailKeySharedPreference(emailController.text);

      database.getUserByUserEmail(emailController.text).then((val){
        snapshotUserInfo=val;
        HelperFunction.saveUserNameSharedPreference(snapshotUserInfo.docs[0]["name"]);
      });

      setState(() {
      isLoading=true;
      });

      authMethod.signInWithEmailAndPassword(emailController.text, passwordController.text).then((val){

      if(val!=null){
        HelperFunction.saveUserLoggedInSharedPreference(true);
        Navigator.pushReplacement(context,MaterialPageRoute(builder:
            (context)=> ChatRoom(),
        ) );
      }
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

     appBar: appBarMain(context),
      body: Container(
        padding:EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          Form(
            key: formKey,
            child: Column(
              children:[
                TextFormField(
                  validator: (val){
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)?null : "Please provide a valid Email ID";
                  },
                  controller: emailController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: textDeclaration('Enter the Email'),
                ),
                TextFormField(
                  obscureText: true,
                  validator: (val){
                    return val.isEmpty ||val.length<6 ?"Please provide a valid Password length > 6" : null;
                  },
                  controller: passwordController,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  decoration: textDeclaration('Enter the Password'),
                ),
              ],
            ),
          ),
            SizedBox(height:10.0),
            Container(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                child:Text(
                  'Forget Password',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            //for the signin part......
            GestureDetector(
              onTap: (){
                signIn();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 20.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff007EF4),
                      Color(0xff2A75BC),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  'Sign In',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                ),
                ),
              ),
            ),
            SizedBox(height:10.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Don't have an account? ",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                ),
                ),
                GestureDetector(
                  onTap: (){
                    widget.toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Register",style: TextStyle(
                      color: Colors.white,
                      fontSize: 17.0,
                      decoration: TextDecoration.underline,
                    ),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

}
