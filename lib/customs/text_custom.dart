import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
// ignore: must_be_immutable
class TextCustom extends StatelessWidget {
  Color color;
  double size;
  FontWeight fontWeight;
  String text;
  TextAlign? align;
   TextCustom({Key? key,this.color=foreground, this.size=15, this.fontWeight=FontWeight.normal,required this.text,this.align,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,

      ),
      textAlign:align ,

    );
  }
}
