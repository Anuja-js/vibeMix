import 'package:flutter/material.dart';
import 'package:vibemix/screens/splash_screen.dart';
import 'package:vibemix/screens/terms_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter VibeMix',
      home: TermsAndCondition(),debugShowCheckedModeBanner: false,
    );
  }
}
