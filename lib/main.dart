import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:vibemix/models/hive.dart';
import 'package:vibemix/screens/onboarding/splash_screen.dart';

import 'models/recent.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongHiveModelAdapter());
  Hive.registerAdapter(RecentModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter VibeMix',
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
