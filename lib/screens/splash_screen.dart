import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/screens/onboarding_secsion.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   gotoOnboarding();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return ScaffoldCustom(

        backButton: false,
        body: SafeArea(
          child: Center(
            child: Image.asset(
              "assets/images/logo.png",
              height: 150,
              width: 150,
            ),
          ),
        ),
        showBottomNav: false, appBar: false, tittle: '',);
  }
  Future<void> gotoOnboarding()async{
    await Future.delayed(const Duration(seconds: 3));
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const OnboardingScreen()));

  }
}
