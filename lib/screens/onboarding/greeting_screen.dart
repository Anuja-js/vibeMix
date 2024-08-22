import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/nav/navbar.dart';

import '../../Constants/colors.dart';
// ignore: must_be_immutable
class GreetingScreen extends StatelessWidget {
  String name;
   GreetingScreen({Key? key,required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "", backButton: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Image.asset(
                  "assets/images/logo.png",
                  height: 125,
                  width: 90,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                      color: textPink,
                      size: 45,
                      fontWeight: FontWeight.bold,
                      text: "Welcome"),
                 Text.rich(
                   TextSpan(text:name,
                     style: const TextStyle(color: foreground,fontWeight: FontWeight.bold,fontSize: 45),
                     children: const <TextSpan>[
                     TextSpan(
                       text: '!\n',
                       style: TextStyle(color:textPink,fontWeight: FontWeight.bold,fontSize: 45),
                     ),
TextSpan(
                       text: 'Mind tell us a few things?',
                       style: TextStyle(color:foreground,fontWeight: FontWeight.normal,fontSize: 15),
                     ),

                   ],
                   ),

                 )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (ctx) =>  NavBar(
                    )));
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: containerPink,
                    backgroundColor:containerPink ,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Rounded corners
                    ),
                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/2.5, vertical: 15), // Padding
                  ),
                  child: TextCustom(color: background, size: 14, fontWeight: FontWeight.w600, text: "Finish")
              ),
            ],
          ),
        ),
       appBar: false,);
  }
}
