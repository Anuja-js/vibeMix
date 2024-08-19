import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';

import '../../Constants/colors.dart';
import '../../customs/text_custom.dart';
class SettingScreen extends StatelessWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "Settings", backButton: false, body: Column(children:  [
      ListTile(
        trailing: Icon(Icons.edit,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Anuja"),
      ),   ListTile(
        trailing: Icon(Icons.timelapse_sharp,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "White Theme"),
      ),   ListTile(
        trailing: Icon(Icons.favorite_border_outlined,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Accent Colour"),
      ),   ListTile(
        trailing: Icon(Icons.arrow_forward_ios_outlined,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Terms and Conditions"),
      ),  ListTile(
        trailing: Icon(Icons.arrow_forward_ios_outlined,size: 20,color: foreground,),
        title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Logout"),
      ),

    ],), showBottomNav: true, appBar: true);
  }
}

