import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';

import '../models/audio_player_model.dart';
class MusicWidget extends StatefulWidget {
 final SongModel data;

    const MusicWidget({super.key, required this.data,}) ;

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
     leading:  QueryArtworkWidget( id:widget.data.id, type: ArtworkType.AUDIO, nullArtworkWidget: const Icon(Icons.music_note,color: foreground,size: 30,), ),


      title:  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width/2.5,
   child: Text(
   widget.data.displayNameWOExt,
     style: const TextStyle(
           fontSize: 15, color: foreground,
           fontWeight: FontWeight.bold,
     ),
     textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,
   ),
 ),
          IconButton(onPressed: (){}, icon: const Icon(Icons.favorite_border_outlined,color: foreground,size: 24,)),

          IconButton(onPressed: (){
            AudioPlayerSingleton().setCurrentSong(widget.data);
            AudioPlayerSingleton().playSong(widget.data);

          }, icon: const Icon(Icons.play_circle_outline,color: foreground,size: 24,)),
        ],
      ),
        subtitle:Text(


      "${ widget.data.artist}",
      style: const TextStyle(
        fontSize: 13, color: foreground,
        fontWeight: FontWeight.w200,
      ),
      textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,
    ),

      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
         return NowPlayingScreen(
           song: widget.data,
         );
        }));
      },
    );
  }
}
