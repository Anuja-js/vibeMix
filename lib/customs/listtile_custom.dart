import 'package:flutter/material.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../Constants/colors.dart';
import '../screens/library/mymusic.dart';

class ListTileCustom extends StatelessWidget {
void Function()? onTap;
String? trailing;
String? tittle;
   ListTileCustom({
    super.key,this.onTap,this.trailing,this.tittle
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap:onTap,
      title: TextCustom(
        size: 18,
        fontWeight: FontWeight.bold,
        text:tittle??"",

      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextCustom(
            size: 12,
            text:trailing??"",
          ),
          sw10,
          const Icon(
            Icons.arrow_forward_ios,
            color: foreground,
            size: 15,
          ),
        ],
      ),
    );
  }
}