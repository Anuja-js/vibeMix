import 'package:flutter/material.dart';
// ignore: must_be_immutable
class TextCustom extends StatelessWidget {
  Color color;
  double size;
  FontWeight fontWeight;
  String text;
  TextAlign? align;
   TextCustom({Key? key,required this.color,required this.size,required this.fontWeight,required this.text,this.align,}) : super(key: key);

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
