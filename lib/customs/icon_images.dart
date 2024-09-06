import 'package:flutter/material.dart';
import 'package:vibemix/global.dart';
class IconImage extends StatelessWidget {
  double height;
  double width;
   IconImage({
    super.key,required this .width,required this.height
  });

  @override
  Widget build(BuildContext context) {
    return background==Colors.white?Image.asset(
      "assets/images/whiteLogo.png",
      height: height,
      width: width,
    ): Image.asset(
      "assets/images/logo.png",
      height: height,
      width: width,
    );
  }
}