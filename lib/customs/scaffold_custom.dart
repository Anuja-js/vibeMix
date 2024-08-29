import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';

// ignore: must_be_immutable
class ScaffoldCustom extends StatelessWidget {
  String?tittle;
  bool backButton;
  Widget body;
  Widget? actionIcon;
  bool appBar;
  bool? action;
  Color?color;
  void Function()? onpress;

  ScaffoldCustom(
      {super.key,
       this.tittle,
      required this.backButton,this.onpress,
      required this.body, this.actionIcon,
      required this.appBar,this.action,this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar
          ? AppBar(
              backgroundColor: background,
              centerTitle: true,
              elevation: 0,
              title: appBar==true?Text(
                tittle!,
                style: const TextStyle(
                    color: foreground,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ):Text(""),
          actions: action==true?[
          IconButton(onPressed: onpress, icon: actionIcon!,

          ),sw15
      ]:null,
              automaticallyImplyLeading: backButton,
              leading: backButton
                  ? IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: foreground,
                        size: 25,
                      ))
                  : null)
          : null,
      body: body,
      backgroundColor: background,

    );
  }
}
