import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';

class FavoriteScreen extends StatefulWidget {
   // ignore: use_key_in_widget_constructors
   const FavoriteScreen(

   ) ;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "Favorites", backButton: false, body:
    ListView.builder(padding: const EdgeInsets.only(bottom: 55,top: 20),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const ScrollPhysics(),
      itemCount: 20,
      itemBuilder: (context, index) {
        return   ListTile(

          leading:
          Container(
            width: 80,
            height: 80,
            decoration:  const BoxDecoration(image:DecorationImage(image:  AssetImage("assets/images/music.png"))),),
          // // QueryArtworkWidget( id:widget.data.id, type: ArtworkType.AUDIO, nullArtworkWidget: Icon(Icons.music_note,color: foreground,size: 30,), ),
          // IconButton(onPressed: (){}, icon: Icon(Icons.close_rounded,color: foreground,size: 24,)),

          title:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Text(
                  "Name of Song",
                  style: TextStyle(
                    fontSize: 15, color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(onPressed: (){}, icon:  const Icon(Icons.close_rounded,size: 24,color: foreground,)),
              IconButton(onPressed: (){
                // AudioPlayerSingleton().playSong(widget.data);
              }, icon: const Icon(Icons.play_circle_outline,color: foreground,size: 24,)), ],
          ),
          subtitle:const Text(


            "artist",
            style: TextStyle(
              fontSize: 13, color: foreground,
              fontWeight: FontWeight.w200,
            ),
            textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,
          ),
          onTap: (){
            // Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            //   return NowPlayingScreen(
            //     song: widget.data,
            //   );
            // }));
          },
        );
      },
    ),
    appBar: true,);
  }
}
