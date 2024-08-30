import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/icon_images.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/nav/navbar.dart';

import '../../Constants/colors.dart';
import '../../customs/custom_elevated_button.dart';

// ignore: must_be_immutable
class GreetingScreen extends StatefulWidget {
  const GreetingScreen({
    super.key,
  });

  @override
  State<GreetingScreen> createState() => _GreetingScreenState();
}

class _GreetingScreenState extends State<GreetingScreen> {
  String name = "Guest";
  @override
  void initState() {
    getname();

    super.initState();
  }

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
            MiddleWidget(name: name),
            ElevatedCustomButton(
              buttonName: "Finish",
              onpress: () {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (ctx) {
                  return NavBar(
                    reset: true,
                  );
                }), (route) => false);
              },
            ),
          ],
        ),
      ),
      appBar: false,
    );
  }

  void getname() async {
    final sharedprfs = await SharedPreferences.getInstance();
    name = sharedprfs.getString("name") ?? "Guest";
    setState(() {

    });

  }
}

class MiddleWidget extends StatelessWidget {
  const MiddleWidget({
    super.key,
    required this.name,
  });

  final String name;

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
            text: "Welcome"),
        Text.rich(
          TextSpan(
            text: name,
            style: const TextStyle(
                color: foreground, fontWeight: FontWeight.bold, fontSize: 45),
            children: const <TextSpan>[
              TextSpan(
                text: '!\n',
                style: TextStyle(
                    color: textPink, fontWeight: FontWeight.bold, fontSize: 45),
              ),
              TextSpan(
                text: 'Mind tell us a few things?',
                style: TextStyle(
                    color: foreground,
                    fontWeight: FontWeight.normal,
                    fontSize: 15),
              ),
            ],
          ),
        )
      ],
    );
  }
}
