import 'package:flutter/material.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../Constants/colors.dart';
import '../nav/navbar.dart';
class ElevatedCustomButton extends StatelessWidget {
  String buttonName;
  void Function()?   onpress;
  ElevatedCustomButton({
    super.key,required this.buttonName,this.onpress
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed:onpress,
        style: ElevatedButton.styleFrom(
          foregroundColor: containerPink,
          fixedSize: Size(MediaQuery.of(context).size.width, 55),
          backgroundColor:containerPink ,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0), // Rounded corners
          ),
        ),
        child: TextCustom(color: background, size: 14, fontWeight: FontWeight.w600, text: buttonName)
    );
  }
}