import 'dart:math';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';
import 'package:vibemix/screens/navbar.dart';
class MusicWidget extends StatefulWidget {
 final SongModel data;

   MusicWidget({required this.data,}) ;

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  static  AudioPlayer _audioPlayer=AudioPlayer();
  PlaySong(String?uri){
  try {
    _audioPlayer.setAudioSource(

        AudioSource.uri(Uri.parse(uri!))
    );
    _audioPlayer.play();
  }on Exception{
    print("Error Parsing song");
  }
  }
  @override
  Widget build(BuildContext context) {
    return ListTile(

     leading:  QueryArtworkWidget( id:widget.data.id, type: ArtworkType.AUDIO, nullArtworkWidget: Icon(Icons.music_note,color: foreground,size: 30,), ),


      title:  SizedBox(width: MediaQuery.of(context).size.width/2,
   child: Text(
   "${ widget.data.displayNameWOExt}",
     style: TextStyle(
       fontSize: 15, color: foreground,
       fontWeight: FontWeight.bold,
     ),
     textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,
   ),
 ),
        subtitle:Text(


      "${ widget.data.artist}",
      style: TextStyle(
        fontSize: 13, color: foreground,
        fontWeight: FontWeight.w200,
      ),
      textAlign: TextAlign.start,overflow: TextOverflow.ellipsis,
    ),
     trailing:   IconButton(onPressed: (){
       PlaySong(widget.data.uri);
        }, icon: Icon(Icons.play_circle_outline,color: foreground,size: 24,)),
      onTap: (){
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
         return NowPlayingScreen(audioPlayer: _audioPlayer,
           song: widget.data,
         );
        }));
      },
    );
  }
}
