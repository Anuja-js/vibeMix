import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/screens/onboarding/greeting_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "",
      backButton: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                "assets/images/logo.png",
                height: 125,
                width: 90,
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextCustom(
                    color: textPink,
                    size: 45,
                    fontWeight: FontWeight.bold,
                    text: "VIBE MIX"),
                TextCustom(
                    color: foreground,
                    size: 45,
                    fontWeight: FontWeight.bold,
                    text: "MUSIC."),
              ],
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50,width: MediaQuery.of(context).size.width,
                  child: TextFormField(scrollPhysics: const NeverScrollableScrollPhysics(),
                    decoration: InputDecoration(
                      fillColor: foreground,
                      filled: true,
                      focusColor: foreground,
                      prefixIconColor: background,
                      labelText: 'Enter Your Name',
                      floatingLabelStyle: const TextStyle(
                          color: textPink,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      labelStyle: const TextStyle(
                          color: background,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                      prefixIcon: const Icon(
                        Icons.perm_identity_outlined,
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: containerPink),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: containerPink),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                sh25,
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (ctx) => const GreetingScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: containerPink,

            backgroundColor:containerPink ,
                    // side: BorderSide(color: Colors.black, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/3, vertical: 15), // Padding
                  ),
                  child: TextCustom(color: background, size: 14, fontWeight: FontWeight.w600, text: "Get Started.....")
                ),
                sh25,
                TextCustom(color: foreground, size: 15, fontWeight: FontWeight.bold, text: "Disclaimer:"),
                TextCustom(color: foreground, size: 14, fontWeight: FontWeight.normal, text: "We respect your privacy more than anything else.\nOnly your name, which you will enter here, will be recorded."),
                sh10
              ],
            ),
          ],
        ),
      ),
      showBottomNav: false,
      appBar: false,
    );
  }
}
