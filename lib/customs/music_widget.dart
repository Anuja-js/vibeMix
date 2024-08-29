import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';

import '../models/audio_player_model.dart';
import '../models/box.dart';
import '../models/hive.dart';

class MusicWidget extends StatefulWidget {
  final SongHiveModel data;

  const MusicWidget({super.key, required this.data});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  final audio = AudioPlayerSingleton().audioPlayer;
  SongHiveModel? current;
  bool isFavorite = false;
  List<SongHiveModel> favourite = [];
  Box<SongHiveModel>? favsBox;

  @override
  void initState() {
    super.initState();
    // Set the current song only if the audio is playing
    if (audio.playing) {
      current = AudioPlayerSingleton().currentSong;
    }

    // Listen to the player state changes
    audio.playerStateStream.listen((state) {
      current = AudioPlayerSingleton().currentSong;
    });

    getHiveMusic();
  }

  @override
  Widget build(BuildContext context) {
    bool isPlaying = audio.playing && current?.id == widget.data.id;

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: textPink,
        child: QueryArtworkWidget(
          artworkBorder: const BorderRadius.all(
            Radius.circular(50),
          ),
          id: widget.data.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: const Icon(
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
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Text(
              widget.data.displayNameWOExt,
              style: const TextStyle(
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
              // Toggle favorite status
              favsBox = await HiveService.getFavBox();
              if (isFavorite) {
                favsBox!.delete(widget.data.id);
                favourite.removeWhere((song) => song.id == widget.data.id);
              } else {
                favsBox!.put(widget.data.id, widget.data);
                favourite.add(widget.data);
              }
              setState(() {
                isFavorite = !isFavorite; // Update favorite state
              });
            },
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
              color: foreground,
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () async {
              if (isPlaying) {
                await audio.pause();
                isPlaying=false;
              } else {
                AudioPlayerSingleton().setCurrentSong(widget.data);
                await audio.play();
                isPlaying=true;
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
        "${widget.data.artist}",
        style: const TextStyle(
          fontSize: 13,
          color: foreground,
          fontWeight: FontWeight.w200,
        ),
        textAlign: TextAlign.start,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {
          return NowPlayingScreen(
            song: widget.data,
          );
        }));
      },
    );
  }

  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    isFavorite = favourite.any((song) => song.id == widget.data.id);
    setState(() {});
  }
}
