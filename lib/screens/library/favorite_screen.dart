import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/models/box.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';
import '../../global.dart';
import '../../models/audio_player_model.dart';
import '../../models/hive.dart';
import '../../utils/notifier.dart';

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
  List<SongHiveModel> favourite = [];
  SongHiveModel? current;

  @override
  void initState() {
    super.initState();
    getHiveMusic();

  }


  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {


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
          return MusicWidget(data: favourite[index], color: foreground, playlistName: "fav", backGroundColor: textPink);

        },
      ): Center(child: TextCustom(text: "No Favorites Added", color: foreground,)),
      appBar: true,

      action: false,
    );
  }

}
class ListileWidget extends StatefulWidget {
  SongHiveModel data;
  int index;
  void Function()? remove;
  void Function()? playPause;
   ListileWidget({super.key,required this.data, required this.index,this.remove,this.playPause});


  @override
  State<ListileWidget> createState() => _ListileWidgetState();
}

class _ListileWidgetState extends State<ListileWidget> {
  bool  isPlaying=false;
  final audio = AudioPlayerSingleton().audioPlayer;
  @override
  void initState() {
    RefreshNotifier().notifier.addListener(checkIsPlaying);
    checkIsPlaying();
    super.initState();
  }
  @override
  void dispose() {
    RefreshNotifier().notifier.removeListener(checkIsPlaying);
    super.dispose();
  }
  void checkIsPlaying() {
    if (!audio.playing || AudioPlayerSingleton().currentSong == null) {
      isPlaying = false;
    }
    else if (audio.playing && AudioPlayerSingleton().currentSong == widget.data) {
      isPlaying = true;
    } else {
      isPlaying = false;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return   ListTile(
      leading: CircleAvatar(backgroundColor: textPink,radius: 25,
        child: QueryArtworkWidget(
          id: widget.data.id,
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
              widget.data.displayNameWOExt,
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
            onPressed: widget.remove,
            icon:  Icon(
              Icons.close_rounded,
              size: 24,
              color: foreground,
            ),
          ),
          IconButton(
            onPressed: widget.playPause,
            icon: Icon(
              isPlaying ? Icons.pause : Icons.play_circle_outline,
              color: foreground,
              size: 24,
            ),
          ),
        ],
      ),
      subtitle: Text(
       widget.data.artist.toString(),
        style:  TextStyle(
          fontSize: 13,
          color: foreground,
          fontWeight: FontWeight.w200,
        ),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        AudioPlayerSingleton().setCurrentPlaylist("fav");
        Navigator.push(context, MaterialPageRoute(builder: (ctx){
          return  NowPlayingScreen(song: widget.data);
        }));
      },
    );;
  }
}
