
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lets_chat/Helper/helperfunction.dart';
import 'package:lets_chat/database.dart';
import 'package:lets_chat/screens/chatRooms.dart';
import 'package:lets_chat/services/auth.dart';
import 'package:lets_chat/widget.dart';


class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {


  final formKey =GlobalKey<FormState>();
  bool isLoading = false;
  AuthMethod authMethod=new AuthMethod();
  TextEditingController userNameController =new TextEditingController();
  TextEditingController emailController =new TextEditingController();
  TextEditingController passwordController =new TextEditingController();

  Database database=new Database();
 signMeUp(){
   if(formKey.currentState.validate()){
     Map<String,String>m={
       "name": userNameController.text,
       "email": emailController.text,
       "status":"",
     };
     HelperFunction.saveUserNameSharedPreference(userNameController.text);
     HelperFunction.saveUserEmailKeySharedPreference(emailController.text);

    setState(() {
      isLoading =true;
      print(isLoading);
    });

     authMethod.signUpWithEmailAndPassword(emailController.text,passwordController.text,userNameController.text).then((val){
      // database.uploadUserInfo(m)*/;
       HelperFunction.saveUserLoggedInSharedPreference(true);
       Navigator.pushReplacement(context,MaterialPageRoute(builder:
          (context)=> ChatRoom(),
      ) );
     });
   }
 }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: appBarMain(context),
      body:isLoading ? Container(
        child: Center(child: CircularProgressIndicator(),),
      )
          :Container(
        padding:EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (val){
                      return val.isEmpty ||val.length<4 ?"Please provide a valid Username" : null;
                    },
                    controller :userNameController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textDeclaration('UserName'),
                  ),
                  TextFormField(
                    validator: (val){
                      return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)?null : "Please provide a valid Email ID";
                    },
                    controller :emailController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textDeclaration('Enter the Email'),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (val){
                      return val.isEmpty ||val.length<8 ?"Please provide a valid Password length > 6" : null;
                    },
                    controller :passwordController,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    decoration: textDeclaration('Enter the Password'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0,),

            GestureDetector(
              onTap: (){
                signMeUp();
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
                  'Sign Up',
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
                Text("Already have an account? ",
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
                    child: Text("SignIn here",style: TextStyle(
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
