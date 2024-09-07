import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/playlist/playlist.dart';
import 'package:vibemix/screens/library/favorite_screen.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';
import 'package:vibemix/screens/recently_played_screen.dart';

import '../../global.dart';
import '../../models/audio_player_model.dart';
import 'mymusic.dart';
class LibraryScreen extends StatelessWidget {
   LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Library",
      backButton: false,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 15),
        child: Column(
          children: [
            ListTile(
              onTap: () {
                final currentSong = AudioPlayerSingleton().currentSong;
                if (currentSong != null&& AudioPlayerSingleton().audioPlayer.playing) {
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
              leading:  Icon(Icons.music_note_outlined, size: 25, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Now Playing",
              ),
            ),
            ListTile(
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const PlaylistScreen();
                  }),
                );
              },
              leading:  Icon(Icons.playlist_add, size: 25, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Playlists",
              ),
            ),
            ListTile(

              leading:  Icon(Icons.favorite_border_outlined, size: 25, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Favorites",
              ),
              onTap: (){
                AudioPlayerSingleton().setCurrentPlaylist("fav");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const FavoriteScreen();
                  }),
                );
              },
            ),
            ListTile(
              onTap: () {
                AudioPlayerSingleton().setCurrentPlaylist("songs");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const MyMusic();
                  }),
                );
              },
              leading:  Icon(Icons.library_music_sharp, size: 25, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "My Music",
              ),
            ),  ListTile(
              onTap: () {
                AudioPlayerSingleton().setCurrentPlaylist("recent");
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (ctx) {
                    return const RecentlyPlayedScreen();
                  }),
                );
              },
              leading:  Icon(Icons.access_time_outlined, size: 25, color: foreground),
              title: TextCustom(
                color: foreground,
                size: 18,
                fontWeight: FontWeight.normal,
                text: "Recently Played",
              ),
            ),

          ],
        ),
      ),
      appBar: true,
    );
  }
}

