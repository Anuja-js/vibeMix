import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/global.dart';
import 'package:vibemix/models/hive.dart';
import 'package:vibemix/screens/onboarding/splash_screen.dart';
import 'package:vibemix/services/notification_handler.dart';
import 'models/recent.dart';
late AudioHandler audioHandler;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SongHiveModelAdapter());
  Hive.registerAdapter(RecentModelAdapter());
  getModeData();
  getAccentData();

  // Initialize AudioHandler
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config:  AudioServiceConfig(
      androidNotificationChannelId: 'com.vibemix.vibemix',
      androidNotificationChannelName: 'Audio playback',
      androidNotificationOngoing: true,
      androidShowNotificationBadge: true,
    ),
  );
  runApp(const MyApp());
}

// Initialize the AudioHandler
Future<AudioHandler> initAudioHandler() async {
  try {
    final handler = await AudioService.init(
      builder: () => MyAudioHandler(),
      config: AudioServiceConfig(
        androidNotificationChannelId: 'com.vibemix.vibemix',
        androidNotificationChannelName: 'Music playback',
        androidNotificationOngoing: true,
        androidShowNotificationBadge: true,
      ),
    );
    return handler;
  } catch (e) {
    print('Error initializing AudioService: $e');
    rethrow;
  }
}


Future<void> getModeData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final mode = prefs.getBool('dark') ?? true;
  dark = mode;
  if (mode) {
    background = Colors.black;
    foreground = Colors.white;
  } else {
    foreground = Colors.black;
    background = Colors.white;
  }
}

Future<void> getAccentData() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final accent = prefs.getString("accent") ?? "0xffE07373";
  if (accent == "0xffE07373") {
    textPink = const Color(0xffE07373);
  } else if (accent == "blue") {
    textPink = Colors.blue;
  } else if (accent == "red") {
    textPink = Colors.red;
  } else if (accent == "green") {
    textPink = Colors.green;
  } else if (accent == "0xffE07373") {
    textPink = const Color(0xffE07373);
  } else if (accent == "purple") {
    textPink = Colors.purple;
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