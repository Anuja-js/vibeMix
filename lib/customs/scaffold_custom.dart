import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
class ScaffoldCustom extends StatefulWidget {
  String tittle;
  bool backButton;
  Widget body;
  bool showBottomNav;
  bool appBar;

   ScaffoldCustom({required this.tittle, required this.backButton, required this.body, required this.showBottomNav,required this.appBar});

  @override
  State<ScaffoldCustom> createState() => _ScaffoldCustomState();
}

class _ScaffoldCustomState extends State<ScaffoldCustom> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:widget.appBar? AppBar(
       title: Text(widget.tittle,),
       automaticallyImplyLeading: widget.backButton,
     ):null,
      body: widget.body,
      backgroundColor: background,
      bottomNavigationBar:widget.showBottomNav? const BottomAppBar():null,
    );
  }
}
