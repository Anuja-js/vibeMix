// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/nav/navbar.dart';
import 'package:vibemix/screens/onboarding/onboarding_secsion.dart';
import '../../customs/icon_images.dart';
import '../../global.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    checkUserLogedin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      action: false,
      backButton: false,
      body: SafeArea(
        child: Center(
          child: IconImage(
            height: 200,
            width: 200,
          ),
        ),
      ),
      appBar: false,
    );
  }
  Future<void> checkUserLogedin() async {
    final sharedprfs = await SharedPreferences.getInstance();
    final userLoggedIn = sharedprfs.getBool(save_Key);
    if (userLoggedIn == null || userLoggedIn == false) {
      gotoOnboarding();
    } else {
      await Future.delayed(const Duration(seconds: 3));
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (ctx) => NavBar(
                reset: true,
              )));
    }
  }
  Future<void> gotoOnboarding() async {
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (ctx) => OnboardingScreen()));
  }

}
