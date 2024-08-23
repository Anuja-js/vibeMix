import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/screens/favorite_screen.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';

import '../../models/audio_player_model.dart';
import '../mymusic.dart';
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Library",
      backButton: false,
      body: Column(
        children: [
          ListTile(
            onTap: () {
              final currentSong = AudioPlayerSingleton().currentSong;
              if (currentSong != null) {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return NowPlayingScreen(song: currentSong);
                  }),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No song is currently playing')),
                );
              }
            },
            leading: const Icon(Icons.music_note_outlined, size: 25, color: foreground),
            title: TextCustom(
              color: foreground,
              size: 18,
              fontWeight: FontWeight.normal,
              text: "Now Playing",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.playlist_add, size: 25, color: foreground),
            title: TextCustom(
              color: foreground,
              size: 18,
              fontWeight: FontWeight.normal,
              text: "Playlists",
            ),
          ),
          ListTile(
            leading: const Icon(Icons.favorite_border_outlined, size: 25, color: foreground),
            title: TextCustom(
              color: foreground,
              size: 18,
              fontWeight: FontWeight.normal,
              text: "Favorites",
            ),
            onTap: (){
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) {
                  return const FavoriteScreen();
                }),
              );
            },
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) {
                  return const MyMusic();
                }),
              );
            },
            leading: const Icon(Icons.library_music_sharp, size: 25, color: foreground),
            title: TextCustom(
              color: foreground,
              size: 18,
              fontWeight: FontWeight.normal,
              text: "My Music",
            ),
          ),
        ],
      ),
      appBar: true,
    );
  }
}

