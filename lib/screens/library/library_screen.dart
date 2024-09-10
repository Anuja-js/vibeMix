import 'package:flutter/material.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/screens/library/favorite_screen.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';
import 'package:vibemix/screens/library/recently_played_screen.dart';
import '../../customs/global.dart';
import '../../models/audio_player_model.dart';
import '../playlist/playlist.dart';
import 'mymusic.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Library",
      backButton: false,
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 15),
        child: Column(
          children: [
            NowPlayingSession(),
            PlaylistSession(),
            FavoritesSession(),
            MymusicSession(),
            RecentlyPlayedSession(),
          ],
        ),
      ),
      appBar: true,
    );
  }
}

class RecentlyPlayedSession extends StatelessWidget {
  const RecentlyPlayedSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) {
            return const RecentlyPlayedScreen();
          }),
        );
      },
      leading: Icon(Icons.access_time_outlined, size: 25, color: foreground),
      title: TextCustom(
        color: foreground,
        size: 18,
        fontWeight: FontWeight.normal,
        text: "Recently Played",
      ),
    );
  }
}

class MymusicSession extends StatelessWidget {
  const MymusicSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) {
            return const MyMusic();
          }),
        );
      },
      leading: Icon(Icons.library_music_sharp, size: 25, color: foreground),
      title: TextCustom(
        color: foreground,
        size: 18,
        fontWeight: FontWeight.normal,
        text: "My Music",
      ),
    );
  }
}

class FavoritesSession extends StatelessWidget {
  const FavoritesSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading:
          Icon(Icons.favorite_border_outlined, size: 25, color: foreground),
      title: TextCustom(
        color: foreground,
        size: 18,
        fontWeight: FontWeight.normal,
        text: "Favorites",
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) {
            return const FavoriteScreen();
          }),
        );
      },
    );
  }
}

class PlaylistSession extends StatelessWidget {
  const PlaylistSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) {
            return const PlaylistScreen();
          }),
        );
      },
      leading: Icon(Icons.playlist_add, size: 25, color: foreground),
      title: TextCustom(
        color: foreground,
        size: 18,
        fontWeight: FontWeight.normal,
        text: "Playlists",
      ),
    );
  }
}

class NowPlayingSession extends StatelessWidget {
  const NowPlayingSession({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final currentSong = AudioPlayerSingleton().currentSong;
        if (currentSong != null && AudioPlayerSingleton().audioPlayer.playing) {
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
      leading: Icon(Icons.music_note_outlined, size: 25, color: foreground),
      title: TextCustom(
        color: foreground,
        size: 18,
        fontWeight: FontWeight.normal,
        text: "Now Playing",
      ),
    );
  }
}
