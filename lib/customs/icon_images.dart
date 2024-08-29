import 'package:flutter/material.dart';
class IconImage extends StatelessWidget {
  double height;
  double width;
   IconImage({
    super.key,required this .width,required this.height
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      "assets/images/logo.png",
      height: height,
      width: width,
    );
  }
}