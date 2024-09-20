import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../../customs/global.dart';


// ignore: must_be_immutable
class PrivacyPolicy extends StatelessWidget {
  PrivacyPolicy({super.key});
  List<Map> privacyPolicy = [
    {
      "head": "1. Introduction",
      "sub":
      '''This Privacy Policy explains how Vibe Mix ("App") handles your personal information and data. By using the App, you agree to the collection and use of information in accordance with this policy.''',
    },
    {
      "head": "2. Data Collection",
      "sub":
      '''Vibe Mix does not collect or store any personal data. The App operates offline and does not transmit any information to external servers or third parties.''',
    },
    {
      "head": "3. Permissions",
      "sub":
      '''To function properly, the App requires access to your device's storage to play music files stored locally. Vibe Mix does not access any other sensitive information on your device without your permission.''',
    },
    {
      "head": "4. Security",
      "sub":
      '''We are committed to protecting your privacy. Since the App does not collect any personal information, there are no concerns regarding data breaches or unauthorized access to personal data.''',
    },
    {
      "head": "5. Changes to This Policy",
      "sub":
      '''We may update our Privacy Policy from time to time. Any changes will be communicated through updates to the App. Continued use of Vibe Mix constitutes your acknowledgment and agreement to any revisions.''',
    },
    {
      "head": "6. Third-Party Services",
      "sub":
      '''Vibe Mix does not integrate with third-party services that track or collect your information. Your music and usage data remain entirely on your device.''',
    },

  ];

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Privacy Policy",
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
                text: privacyPolicy[index]["head"]!.toString()),
            subtitle: TextCustom(
                color: foreground,
                size: 13,
                fontWeight: FontWeight.w300,
                text: privacyPolicy[index]["sub"]!.toString()),
          );
        },
        separatorBuilder: (BuildContext context, index) {
          return sh10;
        },
        itemCount: privacyPolicy.length,
      ),
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
