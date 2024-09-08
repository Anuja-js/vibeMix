import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/models/recent.dart';

import '../screens/library/now_playing_screen.dart';
import '../utils/notifier.dart';
import 'box.dart';
import 'hive.dart';

class AudioPlayerSingleton {
  List<SongHiveModel> playlistList = [];
  int currentIndex = 0;

  // Private constructor for Singleton pattern
  AudioPlayerSingleton._privateConstructor();

  // Single instance of AudioPlayerSingleton
  static final AudioPlayerSingleton _instance =
      AudioPlayerSingleton._privateConstructor();

  // AudioPlayer instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Currently playing song
  SongHiveModel? _currentSong;

  // Single instance access
  factory AudioPlayerSingleton() {
    return _instance;
  }

  // ConcatenatingAudioSource to handle the playlist
  ConcatenatingAudioSource currentPlaylist =
      ConcatenatingAudioSource(children: []);

  // Method to get the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Method to get the currently playing song
  SongHiveModel? get currentSong => _currentSong;

  // Method to set the currently playing song
  void setCurrentSong(SongHiveModel song) {
    _currentSong = song;
  }

  // Play a specific song
  Future<void> playSong(SongHiveModel song) async {
    try {
      // Check if the current song is the same as the song to be played
      if (_currentSong == song) {
        // Resume if the song is already playing or paused
        if (_audioPlayer.playing) {
          // _audioPlayer.pause();
        } else {
          AudioPlayerSingleton().resume();
        }
      } else {
        // If the song is different, set it as the new source and play
        currentIndex = playlistList.indexWhere((element) => element == song);
        await _audioPlayer.setAudioSource(
          currentPlaylist,
          initialIndex: currentIndex,
          initialPosition: Duration.zero,
        );
        _currentSong = song;
        await _audioPlayer.play();
        saveToRecent(song);
        RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
      }
    } catch (e) {
      print("Error playing song: $e");
    }
  }


  // Pause the currently playing song
  void pause() {
    _audioPlayer.pause();
  }

  // Resume playback
  void resume() {
    _audioPlayer.play();
  }

  // Stop playback
  void stop() {
    _audioPlayer.stop();
  }

  // Set the current playlist based on the name
  Future<void> setCurrentPlaylist(String playlistName) async {
    try {
      playlistList.clear();
      currentPlaylist.clear();
      final shared = await SharedPreferences.getInstance();
      shared.setString('currentPlaylist', playlistName);

      if (playlistName == "recent") {
        // Fetch recent songs
        Box<RecentModel> playlist = await HiveService.getRecentData();
        for (int i = 0; i < playlist.length; i++) {
          playlistList.add(playlist.getAt(i)!.song);
        }
      } else {
        // Fetch songs from a named playlist
        Box<SongHiveModel> playlist = await Hive.openBox(playlistName);
        playlistList.addAll(playlist.values);
      }

      // Add all songs to the ConcatenatingAudioSource
      for (int i = 0; i < playlistList.length; i++) {
        currentPlaylist.add(AudioSource.uri(Uri.parse(playlistList[i].uri!)));
      }
    } catch (e) {
      print("Error setting playlist: $e");
    }
    if (_audioPlayer.playing &&
        playlistList.contains(AudioPlayerSingleton().currentSong)) {
      // currentIndex=playlistList.indexWhere((element)=>element==AudioPlayerSingleton().currentSong);
    }
  }

  // Skip to the next song
  void skipNext(BuildContext context) async {
    try {
      if (_audioPlayer.hasNext) {
        _audioPlayer.seekToNext();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
          return NowPlayingScreen(song: playlistList[currentIndex + 1]);
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist reached the end')),
        );
      }
    } catch (e) {
      print('Error skipping to next track: $e');
    }
  }

  // Skip to the previous song
  void skipPrevious(BuildContext context) async {
    try {
      if (_audioPlayer.hasPrevious) {
        _audioPlayer.seekToPrevious();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) {
          return NowPlayingScreen(song: playlistList[currentIndex - 1]);
        }));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Reached the beginning of the playlist')),
        );
      }
    } catch (e) {
      print('Error skipping to previous track: $e');
    }
  }

  // Seek to a specific position in the current track
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  // Save the currently played song to the recent list
  Future<void> saveToRecent(SongHiveModel song) async {
    Box<RecentModel> recent = await HiveService.getRecentData();
    int index = recent.values.toList().indexWhere((e) => e.song.id == song.id);
    if (index != -1) {
      await recent.deleteAt(index);
    }
    recent.put(DateTime.now().toString(),
        RecentModel(time: DateTime.now(), song: song));
  }

  // Dispose of the AudioPlayer instance
  void dispose() {
    _audioPlayer.dispose();
  }
}
