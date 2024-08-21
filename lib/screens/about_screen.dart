import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "About", backButton: false, body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 55,vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset("assets/images/logo.png",width: 300,height: 300,),

              Positioned(
                  top: 200,left: 100,
                  child: TextCustom(color: foreground, size: 25, fontWeight: FontWeight.bold, text: "Vibe MIX")),

              Positioned(
                  top: 235,left: 115,
                  child: TextCustom(color: foreground, size: 11, fontWeight: FontWeight.bold, text: "Version 1.00.1")),
            ],
          ),
          TextCustom(color: foreground, size: 11, fontWeight: FontWeight.bold, text: "This is an open-source project and can be found on "),
          sh25,
          TextCustom(color: foreground, size: 35, fontWeight: FontWeight.bold, text: "GITHUB"),
          sh25,
          TextCustom(color: foreground, size: 11, fontWeight: FontWeight.bold, text: "Made with Flutter and Hive"),
          sh25,
      ],),
    ),     appBar: true);
  }
}
