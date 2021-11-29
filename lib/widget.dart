import 'package:flutter/material.dart';

Widget appBarMain(BuildContext context){
  return AppBar(
      backgroundColor: Colors.green[900],
    title:Text(
      'Lets Chat',
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
InputDecoration textDeclaration(String hintText){
  return InputDecoration(
    hintText: hintText,
    hintStyle: TextStyle(
      color: Colors.white54,
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(
        color: Colors.white,
      ),
    ),
    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  );
}