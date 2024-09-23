import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/models/recent.dart';
import 'package:vibemix/services/notification_handler.dart';

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

  Future<void> playSong(SongHiveModel song) async {
    try {
      currentIndex = playlistList.indexWhere((element) => element == song);

      await _audioPlayer.setAudioSource(currentPlaylist,
          initialIndex: currentIndex, initialPosition: Duration.zero);
      _currentSong = song;
      _audioPlayer.play();
      // MyAudioHandler().setPlaylistWithCovers(playlistList);
      saveToRecent(song);
      RefreshNotifier().notifier.value =
      !RefreshNotifier().notifier.value;
    } catch (e) {
      if (kDebugMode) {
        print("Error playing song: $e");
      }
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
      if (kDebugMode) {
        print("Error setting playlist: $e");
      }
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
       if (_audioPlayer.loopMode.name=="one"){
         _audioPlayer.setLoopMode(LoopMode.off);
         _audioPlayer.seekToNext();
         _audioPlayer.setLoopMode(LoopMode.one);
       }else{
         _audioPlayer.seekToNext();
       }


          AudioPlayerSingleton().setCurrentSong(playlistList[currentIndex+1]);
       saveToRecent(AudioPlayerSingleton().currentSong!);
          if(currentIndex<playlistList.length){
            currentIndex++;
          }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Playlist reached the end')),
        );
      }
    // ignore: empty_catches
    } catch (e) {

    }
  }
  // Skip to the next song
  void skipNextWithoutContext() async {
    try {
      if (_audioPlayer.hasNext) {
        if (_audioPlayer.loopMode.name=="one"){
          _audioPlayer.setLoopMode(LoopMode.off);
          _audioPlayer.seekToNext();
          _audioPlayer.setLoopMode(LoopMode.one);
        }else{
          _audioPlayer.seekToNext();
        }


        AudioPlayerSingleton().setCurrentSong(playlistList[currentIndex+1]);
        saveToRecent(AudioPlayerSingleton().currentSong!);
        if(currentIndex<playlistList.length){
          currentIndex++;
        }
      }

    } catch (e) {
      if (kDebugMode) {
        print('Error skipping to next track: $e');
      }
    }
  }
  // Skip to the previous song
  void skipPrevious(BuildContext context) async {
    try {
      if (_audioPlayer.hasPrevious) {
        if (_audioPlayer.loopMode.name=="one"){
          _audioPlayer.setLoopMode(LoopMode.off);
          _audioPlayer.seekToPrevious();
          _audioPlayer.setLoopMode(LoopMode.one);
        }else{
          _audioPlayer.seekToPrevious();
        }

        AudioPlayerSingleton().setCurrentSong(playlistList[currentIndex-1]);
        saveToRecent(AudioPlayerSingleton().currentSong!);
        if(currentIndex>=0){
          currentIndex--;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Reached the beginning of the playlist')),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error skipping to previous track: $e');
      }
    }
  }
  void skipPreviousNoContext() async {
    try {
      if (_audioPlayer.hasPrevious) {
        if (_audioPlayer.loopMode.name=="one"){
          _audioPlayer.setLoopMode(LoopMode.off);
          _audioPlayer.seekToPrevious();
          _audioPlayer.setLoopMode(LoopMode.one);
        }else{
          _audioPlayer.seekToPrevious();
        }
        AudioPlayerSingleton().setCurrentSong(playlistList[currentIndex-1]);
        saveToRecent(AudioPlayerSingleton().currentSong!);
        if(currentIndex>=0){
          currentIndex--;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error skipping to previous track: $e');
      }
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