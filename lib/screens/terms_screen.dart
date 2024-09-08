import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../global.dart';

// ignore: must_be_immutable
class TermsAndCondition extends StatelessWidget {
  TermsAndCondition({super.key});
  List<Map> terms = [
    {
      "head": "1. Acceptance of Terms",
      "sub":
          '''By downloading and using the Vibe Mix application ("App"), you agree to comply with and be bound by the following terms and conditions ("Terms of Service"). If you do not agree with these terms, please do not use the App.'''
    },
    {
      "head": "2.Change of Terms",
      "sub":
          '''We reserve the right to change, modify, or revise these terms at any time. Your continued use of Vibe Mix after any changes are made will constitute your acceptance of the new terms.'''
    },
    {
      "head": "3. Use of the App",
      "sub":
          '''You agree to use Vibe Mix for lawful purposes only. The App is designed to allow you to play music files stored on your device. You may not use Vibe Mix in any way that is unlawful, fraudulent, or harmful, or in connection with any unlawful, fraudulent, or harmful purpose or activity.'''
    },
    {
      "head": "4. User Content",
      "sub":
          '''Vibe Mix does not upload or share your music files. All music files remain on your device, and you retain full ownership of the content. We do not claim any rights over the music files you play using Vibe Mix.'''
    },
    {
      "head": "5. Privacy Policy",
      "sub":
          '''Vibe Mix respects your privacy. As an offline music player, the App does not collect, store, or share any personal information. For more details on our commitment to privacy, please review our Privacy Policy.'''
    },
    {
      "head": "6. Intellectual Property ",
      "sub":
          '''All intellectual property rights in Vibe Mix and content provided by us remain our property. You are granted a limited, non-exclusive license to use the App for personal, non-commercial use.'''
    },
    {
      "head": "7. Limitation of Liability",
      "sub":
          '''Vibe Mix is provided "as is" without any warranties, express or implied. We do not guarantee that the App will be free of errors or uninterrupted. In no event shall we be liable for any damages arising from the use or inability to use the App.'''
    },
    {
      "head": "8. Governing Law ",
      "sub":
          '''These terms and conditions are governed by and construed in accordance with the laws of [Your Country/State], and you irrevocably submit to the exclusive jurisdiction of the courts in that location.'''
    },
    {
      "head": "9. Contact Information",
      "sub":
          '''If you have any questions or concerns about these terms, please contact us at anujajs2002@gmail.com'''
    },
  ];
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Terms and Condition",
      backButton: true,
      body: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: const ScrollPhysics(),
          itemBuilder: (BuildContext context, index) {
            return ListTile(
              title: TextCustom(
                  color: foreground,
                  size: 18,
                  fontWeight: FontWeight.bold,
                  text: terms[index]["head"]!.toString()),
              subtitle: TextCustom(
                  color: foreground,
                  size: 13,
                  fontWeight: FontWeight.w300,
                  text: terms[index]["sub"]!.toString()),
            );
          },
          separatorBuilder: (BuildContext context, index) {
            return sh10;
          },
          itemCount: terms.length),
      appBar: true,
      actionIcon: Icon(
        Icons.arrow_back_ios_outlined,
        size: 25,
        color: foreground,
      ),
      action: false,
    );
  }
}
