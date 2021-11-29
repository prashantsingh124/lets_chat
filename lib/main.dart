import 'package:flutter/material.dart';
import 'package:lets_chat/Helper/authenticate.dart';
import 'package:lets_chat/Helper/helperfunction.dart';
import 'package:lets_chat/screens/chatRooms.dart';
import 'package:lets_chat/screens/signin.dart';
import 'package:lets_chat/screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:lets_chat/screens/welcome.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool userIsLoggedIn=false;
  @override
  void initState() {
    getLoggedInState();
    super.initState();
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title:'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: Color(0xff1F1F1F),
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home:userIsLoggedIn ? ChatRoom(): Authenticate(),
      home:WelcomeScreen(),
      /*home: userIsLoggedIn != null ?  userIsLoggedIn ? ChatRoom() : Authenticate()
          : Container(
        child: Center(
          child: Authenticate(),
        ),
      ),*/
      );
  }
}



