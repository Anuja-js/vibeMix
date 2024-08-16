import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';

// ignore: must_be_immutable
class ScaffoldCustom extends StatelessWidget {
  String tittle;
  bool backButton;
  Widget body;
  bool showBottomNav;
  bool appBar;

   ScaffoldCustom({super.key, required this.tittle, required this.backButton, required this.body, required this.showBottomNav,required this.appBar});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar:appBar? AppBar(backgroundColor: background,centerTitle: true,elevation: 0,
       title: Text(tittle,style: const TextStyle(color: foreground,fontSize: 20,fontWeight: FontWeight.bold),),
       automaticallyImplyLeading: backButton,leading: backButton?IconButton(onPressed: (){}, icon: const Icon(Icons.arrow_back,color: foreground,size: 25,)
         ):null
     ):null,
      body: body,
      backgroundColor: background,
      bottomNavigationBar:showBottomNav? const BottomAppBar(

      ):null,
    );
  }
}
