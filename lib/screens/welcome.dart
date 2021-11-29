
import 'package:flutter/material.dart';
import 'package:lets_chat/Helper/authenticate.dart';
import 'package:lets_chat/Helper/helperfunction.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'chatRooms.dart';

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{

  Duration delayDuration =new Duration(seconds: 3);
  AnimationController controller;
  Animation animation;
  bool userIsLoggedIn=false;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
    );
    animation=ColorTween(begin: Colors.blueGrey, end: Colors.lightGreen).animate(controller);
    controller.forward();
    controller.addListener(() {
      setState(() {
      });
    });

    getLoggedInState();
    super.initState();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder:
            (context)=>userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
                : Container(
              child: Center(
                child: Authenticate(),
              ),
            ),
        )
        );
      }
    });
  }
  @override
  void dispose(){
    controller.dispose();
    super.dispose();
  }

  getLoggedInState() async{
    await HelperFunction.getUserLoggedInSharedPreference().then((value){
      setState(() {
        userIsLoggedIn=value;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  //child: Image.asset('images/logo.png'),
                  child:Image.network('https://cdn1.iconfinder.com/data/icons/apps-and-software/256/WhatsApp-512.png'),
                  height: 100.0,
                ),
                TypewriterAnimatedTextKit(
                 speed:Duration(microseconds:198000),
                 text: ['Lets Chat'],
                  textStyle: TextStyle(
                    fontSize: 50.0,
                    fontWeight: FontWeight.w900,
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
