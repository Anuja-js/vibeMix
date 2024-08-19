import 'package:flutter/material.dart';
import 'package:vibemix/screens/about_screen.dart';
import 'package:vibemix/screens/library/library_screen.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';
import 'package:vibemix/screens/onboarding/splash_screen.dart';
import 'package:vibemix/screens/settings/settings_screen.dart';
import 'package:vibemix/screens/terms_screen.dart';

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
      home:SettingScreen(),debugShowCheckedModeBanner: false,
    );
  }
}
