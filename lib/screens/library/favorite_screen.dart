import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/models/box.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';
import '../../global.dart';
import '../../models/audio_player_model.dart';
import '../../models/hive.dart';

class FavoriteScreen extends StatefulWidget {
   // ignore: use_key_in_widget_constructors
   const FavoriteScreen(

   ) ;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}


class _FavoriteScreenState extends State<FavoriteScreen> {
  Box<SongHiveModel>? favsBox;
  final audio = AudioPlayerSingleton().audioPlayer;
  List<SongHiveModel> favourite = []; SongHiveModel? current;


  @override
  void initState() {

    current = AudioPlayerSingleton().currentSong;
    audio.playerStateStream.listen((state) {
      current = AudioPlayerSingleton().currentSong;
    });
    getHiveMusic();
    super.initState();
  }

  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {

    bool  isPlaying=audio.playing ;
    return ScaffoldCustom(
      tittle: "Favorites",

      backButton: true,
      body:favourite.isNotEmpty? ListView.builder(
        padding: const EdgeInsets.only(bottom: 55, top: 20,left: 18,right: 18),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: favourite.length,
        itemBuilder: (context, index) {
          return
            ListTile(
            leading: CircleAvatar(backgroundColor: textPink,radius: 25,
              child: QueryArtworkWidget(
                id: favourite[index].id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget:  Icon(
                  Icons.music_note,
                  color: foreground,
                  size: 30,
                ),
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    favourite[index].displayNameWOExt,
                    style:  TextStyle(
                      fontSize: 15,
                      color: foreground,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    favsBox = await HiveService.getFavBox();
                    favsBox!.delete(favourite[index].id);
                    favourite.removeAt(index);
                    setState(() {});
                  },
                  icon:  Icon(
                    Icons.close_rounded,
                    size: 24,
                    color: foreground,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audio.pause();
                    } else {
                      await AudioPlayerSingleton().playSong(favourite[index]);

                    }
                    setState(() {});
                  },
                  icon: Icon(
                    isPlaying ? Icons.pause : Icons.play_circle_outline,
                    color: foreground,
                    size: 24,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              favourite[index].artist.toString(),
              style:  TextStyle(
                fontSize: 13,
                color: foreground,
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
           Navigator.push(context, MaterialPageRoute(builder: (ctx){
             return  NowPlayingScreen(song: favourite[index]);
           }));
            },
          );
        },
      ): Center(child: TextCustom(text: "No Favorites Added", color: foreground,)),
      appBar: true,

      action: false,
    );
  }
}
