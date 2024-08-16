import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "Terms and Condition", backButton: true, body: const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

    ],), showBottomNav: false, appBar: true);
  }
}
