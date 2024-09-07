
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/models/box.dart';
import 'package:vibemix/models/recent.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';

import 'hive.dart';
class AudioPlayerSingleton {
  List<SongHiveModel> playlistList=[];
  int currentIndex=0;
  AudioPlayerSingleton._privateConstructor();

  // The single instance of AudioPlayerSingleton
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._privateConstructor();

  // The single instance of AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variable to store the currently playing song
  SongHiveModel? _currentSong;
  factory AudioPlayerSingleton() {
    return _instance;
  }
ConcatenatingAudioSource currentPlaylist=ConcatenatingAudioSource(children: [

]);

  // Method to access the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Method to access the currently playing song
  SongHiveModel? get currentSong => _currentSong;

  // Method to set the currently playing song
  void setCurrentSong(SongHiveModel song) {

    _currentSong = song;
  }

  Future<void> playSong(SongHiveModel song) async {
    try {
      currentIndex=playlistList.indexWhere((element)=>element==song);

      await _audioPlayer.setAudioSource(currentPlaylist, initialIndex: currentIndex, initialPosition: Duration.zero);
    print("0000000000000000000000000000000000000000000000000000000${currentIndex}");
      _currentSong = song;
      _audioPlayer.play();
      saveToRecent(song);
    } catch (e) {
      print("Error playing song: $e");
    }

  }

  void pause() {
    _audioPlayer.pause();
  }
  void resume() {
    _audioPlayer.play();
  }
  void stop() {
    _audioPlayer.stop();
  }
  void setCurrentPlaylist(String playlistName)async{
    if(playlistName=="recent"){
      currentPlaylist.clear();
      playlistList.clear();
      final shared = await SharedPreferences.getInstance();
      shared.setString('currentPlaylist', playlistName);
      Box<RecentModel> playlist = await HiveService.getRecentData();
      for (int i = 0; i < playlist.length; i++) {
        playlistList.add(playlist.getAt(i)!.song);
      }
      for (int i = 0; i < playlistList.length; i++) {
        currentPlaylist.add(AudioSource.uri(Uri.parse(playlistList[i].uri!)));
      }
    }
  else  {
      currentPlaylist.clear();
      playlistList.clear();
      final shared = await SharedPreferences.getInstance();
      shared.setString('currentPlaylist', playlistName);
      Box<SongHiveModel> playlist = await Hive.openBox(playlistName);
      playlistList.addAll(playlist.values);
      for (int i = 0; i < playlistList.length; i++) {
        currentPlaylist.add(AudioSource.uri(Uri.parse(playlistList[i].uri!)));
      }
    }
  }
  void skipNext(context) async {

    try {
    if(_audioPlayer.hasNext){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
        return NowPlayingScreen(song:playlistList[currentIndex+1]);
      }));

    }else{
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PlayList reached the Limit')),
      );
     }
     } catch (e) {
      print('Error skipping to next track: $e');
    }
  }
  void skipPrevious(context) async {

    try {
      if(_audioPlayer.hasPrevious){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
          return NowPlayingScreen(song:playlistList[currentIndex-1]);
        }));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('PlayList reached the Limit')),
        );
      }
    } catch (e) {
      print('Error skipping to next track: $e');
    }
  }


  void seek(Duration position) {
    _audioPlayer.seek(position);
  }
void saveToRecent(SongHiveModel song)async{
    Box<RecentModel> recent=await  HiveService.getRecentData();
    int index = recent.values.toList().indexWhere((e) => e.song.id == song.id);
    if (index != -1) {
      await recent.deleteAt(index);
    }
    recent.put(DateTime.now().toString(), RecentModel(time:  DateTime.now(), song: song));

}
  // Method to dispose of the AudioPlayer instance
  void dispose() {
    _audioPlayer.dispose();
  }
}
