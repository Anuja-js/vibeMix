import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
const white=Colors.white;
const black=Colors.black;
const foreground=white;
const background=black;
const textPink=Color(0xffE07373);
const iconFav=Color(0xffF60000);
const containerPink=Color(0xffBE9393);
const shadow=Color(0xff8685B3);
const sh25=SizedBox(height: 25,);
const sh50=SizedBox(height: 50,);
const sh10=SizedBox(height: 10,);
const sw10=SizedBox(width: 10,);
const sw15=SizedBox(width: 15,);
const sh5=SizedBox(height: 5,);



// Define your light theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor:foreground,
  scaffoldBackgroundColor:foreground,
  hintColor: Colors.pink,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: background),
    bodyMedium: TextStyle(color: background),
  ),
);

// Define your dark theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: background,
  scaffoldBackgroundColor: background,
  hintColor: Colors.pink,
  textTheme: TextTheme(
    bodyLarge: TextStyle(color: foreground),
    bodyMedium: TextStyle(color: foreground),
  ),
);
