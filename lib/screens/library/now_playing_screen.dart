import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
class NowPlayingScreen extends StatefulWidget {
  const NowPlayingScreen({Key? key}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(

      tittle: "", backButton: true, body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
        Container(height: 250,width:  MediaQuery.of(context).size.width,margin: EdgeInsets.only(left: 25,right: 25,bottom: 50,top: 20),padding: EdgeInsets.all(0),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),image: DecorationImage(image: AssetImage("assets/images/nowPlay.png",))),
          ),
          TextCustom(color: foreground, size: 30, fontWeight: FontWeight.bold, text: "Perfect"),
          sh5,
          TextCustom(color: foreground, size: 15, fontWeight: FontWeight.w300, text: "Ed-sheeran"),
      Container(
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
        color: textPink,
        borderRadius: BorderRadius.circular(25)
      ),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        child: Column(
          children: [
            Slider(
              value: 0.5,
              onChanged: (value) {

              },
              activeColor: background,
              inactiveColor: foreground,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white),
                  onPressed: () {
                    // Add your skip previous functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.pause, color: Colors.white),
                  onPressed: () {
                    // Add your pause/play functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white),
                  onPressed: () {
                    // Add your skip next functionality here
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.volume_down, color: Colors.white),
                  onPressed: () {
                    // Add your volume down functionality here
                  },
                ),
                IconButton(
                  icon: Icon(Icons.volume_up, color: Colors.white),
                  onPressed: () {
                    // Add your volume up functionality here
                  },
                ),
              ],
            ),
          ],
        ),
      )
      ],

      ),
    ), showBottomNav: false, appBar: true,action: true,);
  }
}
