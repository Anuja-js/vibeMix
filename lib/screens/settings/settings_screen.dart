import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/screens/onboarding/onboarding_secsion.dart';
import 'package:vibemix/screens/onboarding/splash_screen.dart';
import 'package:vibemix/screens/terms_screen.dart';

import '../../Constants/colors.dart';
import '../../customs/text_custom.dart';
class SettingScreen extends StatefulWidget {
   const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool light = true;

  @override
  Widget build(BuildContext context) {

    return ScaffoldCustom(tittle: "Settings", backButton: false, body: Column(children:  [
      ListTile(
        trailing: const Icon(Icons.edit,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Anuja"),
      ),   ListTile(
        trailing: Switch(
          value: light,
          activeColor: foreground,
          inactiveTrackColor: textPink,
          inactiveThumbColor: foreground,
          activeTrackColor: textPink,
          onChanged: (bool value) {
            setState(() {
              light = value;
            });
          },
        ),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "White Theme"),
      ),   ListTile(
        trailing:ConstrainedBox(

          constraints: const BoxConstraints(
    maxHeight: 30,maxWidth: 60,
    ),child:  Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircleAvatar(radius: 6,backgroundColor: textPink,),sw10,  TextCustom(color: textPink, size: 18, fontWeight: FontWeight.normal, text: "Red"),
            ],
          ),



        ),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Accent Colour"),
      ),   ListTile(
        trailing: const Icon(Icons.arrow_forward_ios_outlined,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Terms and Conditions"),
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            return TermsAndCondition();
          }));
        },
      ),  ListTile(
        trailing: const Icon(Icons.arrow_forward_ios_outlined,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Logout"),
        onTap: (){
        logout(context);
        },
      ),

    ],),     appBar: true);
  }

  logout(BuildContext ctx) async {
    final sharedprfs = await SharedPreferences.getInstance();
    // ignore: use_build_context_synchronously
    showDialog(
        context: ctx,
        builder: (ctx1) {
          return AlertDialog(
            title: const Text("Logout"),
            content: const Text(
                "Do you want to logout......?"),
            actions: [
              TextButton(
                  onPressed: () {

                    Navigator.of(ctx1).pop();
                  },
                  child: const Text("Close")), TextButton(
                  onPressed: () async{
                    await sharedprfs.clear();
                    // ignore: use_build_context_synchronously
                    Navigator.of(ctx).pushReplacement(
                        MaterialPageRoute(builder: (ctx1) =>  OnboardingScreen()), );
                  },
                  child: const Text("Logout")),
            ],
          );
        }
    );

  }
}

