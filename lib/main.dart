import 'package:flutter/material.dart';
import 'package:vibemix/screens/onboarding/splash_screen.dart';
// ignore: constant_identifier_names
const save_Key = "userLoggedIn";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter VibeMix',
      home:SplashScreen(),debugShowCheckedModeBanner: false,
    );
  }
}
