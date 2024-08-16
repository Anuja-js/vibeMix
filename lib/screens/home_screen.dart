import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
        tittle: "",
        backButton: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: Image.asset(
                    "assets/images/logo.png",
                    height: 125,
                    width: 90,
                  ),
                ),
                Stack(
                  children:[ Row(mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(radius: 30,child: Image.asset("assets/images/profile.png",fit: BoxFit.cover,width: 60,height: 60,),),
                      sw15,
                      Text.rich(
                        TextSpan(text: "Hi There,\n",
                          style: TextStyle(color: textPink,fontWeight: FontWeight.bold,fontSize: 20),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'Anuja',
                              style: TextStyle(color:foreground,fontWeight: FontWeight.bold,fontSize: 20),
                            ),
                          ],
                        ),

                      )
                    ],),
                  Positioned(
                      top: 18,left: 30,
                      child: IconButton(onPressed: (){}, icon: Icon(Icons.camera_alt_outlined),color: foreground,))
                  ]
                ),
                sh25,
                Container(
                  height: 50,width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color:Color(0x40e07373),
                      spreadRadius: 4,
                      blurRadius: 3,
                      offset: Offset(1, 3),
                    ),
                    BoxShadow(
                      color:Color(0x40e07373),
                      spreadRadius: 4,
                      blurRadius: 3,
                      offset: Offset(-1, -3),
                    ),
                  ],
                ),
                  child: TextFormField(scrollPhysics: const NeverScrollableScrollPhysics(),
                    decoration: InputDecoration(
                      fillColor: textPink,
                      filled: true,
                      focusColor: foreground,
                      suffixIconColor: background,
                      labelText: 'Search for anything ...',

                      floatingLabelStyle: TextStyle(
                          color: foreground,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      labelStyle: TextStyle(
                          color: background,
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: containerPink),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: containerPink),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
                sh25,
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.bold, text: "Favorites Songs")),
                    TextCustom(color: foreground, size: 12, fontWeight: FontWeight.normal, text: "See all"),sw10,

                    Icon(Icons.arrow_forward_ios,color: foreground,size: 15,)
                  ],
                ),
                SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 10, // Number of items
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: AssetImage('assets/images/logo.png'), // Replace with your image path
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            TextCustom(color: foreground, size: 15, fontWeight: FontWeight.bold, text:  'Flower', align: TextAlign.center,),
                            TextCustom(color: foreground, size: 13, fontWeight: FontWeight.w200, text:  'Post Melon', align: TextAlign.center,)
                          ],
                        ),
                      );
                    },
                  ),
                ),

              ],
            ),
          ),
        ),
        showBottomNav: true,
        appBar: false);
  }
}
