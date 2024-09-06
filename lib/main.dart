import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/global.dart';
import 'package:vibemix/models/hive.dart';
import 'package:vibemix/screens/onboarding/splash_screen.dart';

import 'models/recent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongHiveModelAdapter());
  Hive.registerAdapter(RecentModelAdapter());
  getModeData();
  runApp(const MyApp());
}
Future<void> getModeData()async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
 final mode= prefs.getBool('dark')??true;
 dark=mode;
 if(mode){
   background=Colors.black;
   foreground=Colors.white;
 }
 else{
   foreground=Colors.black;
   background=Colors.white;
 }
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter VibeMix',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
