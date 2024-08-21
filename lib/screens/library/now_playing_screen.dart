import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
class NowPlayingScreen extends StatefulWidget {
  final SongModel song;
  final AudioPlayer audioPlayer;
   NowPlayingScreen({Key? key,required this.song, required this.audioPlayer}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  bool _isPlaying=false;
  Duration _duration=const Duration();
  Duration _position=const Duration();
  @override
  void initState() {
   playSongs();
    super.initState();
  }
  void playSongs(){

 try{
   widget.audioPlayer.setAudioSource(
       AudioSource.uri(Uri.parse(widget.song.uri!) )
   );
   widget.audioPlayer.play();
   _isPlaying=true;
 }
 on Exception{
   print("cannot Parse song");
 }
 widget.audioPlayer.durationStream.listen((d) {
   setState(() {
     _duration=d!;
   });
 });
 widget.audioPlayer.positionStream.listen((p) {
   setState(() {
     _position=p;
   });
 });
  }
// @override
//   void dispose() {
//    widget.audioPlayer.dispose();
//     super.dispose();
//   }
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
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(25),
            ),
          child:  QueryArtworkWidget( id:widget.song.id, type: ArtworkType.AUDIO, nullArtworkWidget: Icon(Icons.music_note,color: foreground,size: 150,), ),

          ),
           SizedBox(
              height: 30,width:MediaQuery.of(context).size.width/1.3,
              child: TextCustom(color: foreground, size: 25, fontWeight: FontWeight.bold, text: "${widget.song.displayNameWOExt}",),),
          sh10,
          TextCustom(color: foreground, size: 15, fontWeight: FontWeight.w300, text: "${widget.song.artist}"=="<unknown>"?"Unknown": "${widget.song.artist}"),
      Container(margin: EdgeInsets.only(top: 40),
        height: 200,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
        color: textPink,
        borderRadius: BorderRadius.circular(25)
      ),
        padding: EdgeInsets.symmetric(horizontal: 15,vertical: 25),
        child: Column(
          children: [
            Row(
              
              children: [
                TextCustom(color: foreground, size: 10, fontWeight: FontWeight.w300, text: "${_position.toString().split(".")[0]}"),

                Expanded(
                  child: Slider(
                    min:const Duration(microseconds: 0).inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),

                    onChanged: (value) {
                      setState(() {
                        changeToSeconds(value.toInt());
                        value=value;
                      });
                    },
                    activeColor: background,
                    inactiveColor: foreground,
                  ),
                ),
                TextCustom(color: foreground, size: 10, fontWeight: FontWeight.w300, text:"${_duration.toString().split(".")[0]}"),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.skip_previous, color: Colors.white,size: 25,),
                  onPressed: () {
                    // Add your skip previous functionality here
                  },
                ),
                IconButton(
                  icon: Icon(_isPlaying?Icons.pause:Icons.play_arrow_outlined, color: Colors.white,size: 25,),
                  onPressed: () {

               setState(() {    if(_isPlaying){
                 widget.audioPlayer.pause();
               }else{
                 widget.audioPlayer.play();
               }
                 _isPlaying=!_isPlaying;
               });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.white,size: 25,),
                  onPressed: () {
                  setState(() {
                    widget.audioPlayer.nextIndex;
                  });
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

                  },
                ),
              ],
            ),
          ],
        ),
      )
      ],

      ),
    ),  appBar: true,action: true,);
  }
  void changeToSeconds(int seconds){
    Duration duration=Duration(seconds: seconds);
    widget.audioPlayer.seek(duration);
  }
}
