import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/custom_elevated_button.dart';
import 'package:vibemix/customs/icon_images.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/customs/global.dart';
import 'package:vibemix/screens/onboarding/greeting_screen.dart';

class OnboardingScreen extends StatelessWidget {
  OnboardingScreen({super.key});
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      backButton: false,
      action: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
                child: IconImage(
              height: 125,
              width: 90,
            )),
            const AppName(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextForm(nameController: nameController),
                sh25,
                ElevatedCustomButton(
                  buttonName: "Get Started....",
                  onpress: () {
                    checkLogIn(context);
                  },
                ),
                sh10,
                TextCustom(
                  fontWeight: FontWeight.bold,
                  text: "Disclaimer:",
                  color: foreground,
                ),
                TextCustom(
                  size: 14,
                  text:
                      "We respect your privacy more than anything else.\nOnly your name, which you will enter here, will be recorded.",
                  color: foreground,
                ),
                sh10
              ],
            ),
          ],
        ),
      ),
      appBar: false,
    );
  }

  void checkLogIn(BuildContext ctx) async {
    final username = nameController.text;
    if (username.isNotEmpty) {
      final sharedprfs = await SharedPreferences.getInstance();
      await sharedprfs.setBool(save_Key, true);
      await sharedprfs.setString("name", nameController.text.toString());

      // ignore: use_build_context_synchronously
      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const GreetingScreen()));
    } else {
      if (kDebugMode) {
        print("User name null");
      }

      Navigator.of(ctx).pushReplacement(
          MaterialPageRoute(builder: (ctx) => const GreetingScreen()));
    }
  }
}

class TextForm extends StatelessWidget {
  const TextForm({
    super.key,
    required TextEditingController nameController,
  }) : _nameController = nameController;

  final TextEditingController _nameController;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        scrollPhysics: const NeverScrollableScrollPhysics(),
        controller: _nameController,
        style:
            TextStyle(color: grey, fontSize: 15, fontWeight: FontWeight.normal),
        decoration: InputDecoration(
          fillColor: foreground,
          filled: true,
          focusColor: foreground,
          prefixIconColor: background,
          labelText: 'Enter Your Name',
          floatingLabelBehavior: FloatingLabelBehavior.never,
          floatingLabelStyle: TextStyle(
              color: textPink, fontSize: 14, fontWeight: FontWeight.bold),
          labelStyle: TextStyle(
              color: grey, fontSize: 15, fontWeight: FontWeight.normal),
          prefixIcon: const Icon(
            Icons.perm_identity_outlined,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: containerPink),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: containerPink),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}

class AppName extends StatelessWidget {
  const AppName({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
            color: textPink,
            size: 45,
            fontWeight: FontWeight.bold,
            text: "VIBE MIX"),
        TextCustom(
          size: 45,
          fontWeight: FontWeight.bold,
          text: "MUSIC.",
          color: foreground,
        ),
      ],
    );
  }
}
