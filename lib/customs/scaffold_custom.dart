import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';

// ignore: must_be_immutable
class ScaffoldCustom extends StatelessWidget {
  String tittle;
  bool backButton;
  Widget body;
  bool showBottomNav;
  bool appBar;
  bool? action;
  Color?color;

  ScaffoldCustom(
      {super.key,
      required this.tittle,
      required this.backButton,
      required this.body,
      required this.showBottomNav,
      required this.appBar,this.action,this.color});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar
          ? AppBar(
              backgroundColor: background,
              centerTitle: true,
              elevation: 0,
              title: Text(
                tittle,
                style: const TextStyle(
                    color: foreground,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
          actions: action==true?[
          IconButton(onPressed: (){}, icon: Icon(Icons.favorite_border_outlined,size: 25,color: iconFav,)),sw15      
      ]:null,
              automaticallyImplyLeading: backButton,
              leading: backButton
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.arrow_back,
                        color: foreground,
                        size: 25,
                      ))
                  : null)
          : null,
      body: body,
      backgroundColor: background,
      bottomNavigationBar: showBottomNav ? const BottomAppBar() : null,
    );
  }
}
