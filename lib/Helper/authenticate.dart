import 'package:flutter/material.dart';
import 'package:lets_chat/screens/signin.dart';
import 'package:lets_chat/screens/signup.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key key}) : super(key: key);

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn=true;
  void toggle(){
    setState(() {
      showSignIn= !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
     if(showSignIn){
      return SignIn(toggle);
    }else{
      return SignUp(toggle);
    }
  }
}
