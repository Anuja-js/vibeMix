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
              height: 200,
              width: 200,
            ),
          ),
        ),
        showBottomNav: false, appBar: false, tittle: '',);
  }
  Future<void> gotoOnboarding()async{
    await Future.delayed(const Duration(seconds: 3));
    // ignore: use_build_context_synchronously
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => const OnboardingScreen()));

  }
}
