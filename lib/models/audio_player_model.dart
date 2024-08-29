
import 'package:hive_flutter/hive_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

import 'hive.dart';


// Singleton class to manage the audio player and song storage
class AudioPlayerSingleton {
  // Private constructor
  AudioPlayerSingleton._privateConstructor();

  // The single instance of AudioPlayerSingleton
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._privateConstructor();

  // The single instance of AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variable to store the currently playing song
  SongHiveModel? _currentSong;
  // final Box<SongModel> _songBox = Hive.box<SongModel>('songs');

  // Factory constructor to return the single instance of AudioPlayerSingleton
  factory AudioPlayerSingleton() {
    return _instance;
  }

  // Method to access the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Method to access the currently playing song
  SongHiveModel? get currentSong => _currentSong;

  // Method to set the currently playing song
  void setCurrentSong(SongHiveModel song) {
    _currentSong = song;
  }

  // Method to play a song
  Future<void> playSong(SongHiveModel song) async {
    try {
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
      _currentSong = song;
      _audioPlayer.play();
    } catch (e) {
      print("Error playing song: $e");
    }
  }

  // Method to pause the currently playing song
  void pause() {
    _audioPlayer.pause();
  }

  // Method to resume the currently playing song
  void resume() {
    _audioPlayer.play();
  }

  // Method to stop the currently playing song
  void stop() {
    _audioPlayer.stop();
  }

  // Method to seek to a specific position in the currently playing song
  void seek(Duration position) {
    _audioPlayer.seek(position);
  }

  // Method to dispose of the AudioPlayer instance
  void dispose() {
    _audioPlayer.dispose();
  }

  // // Method to store songs in Hive
  // void saveSong(SongModel song) {
  //   _songBox.put(song.id, song);
  // }
  //
  // // Method to get all stored songs from Hive
  // List<SongModel> getAllSongs() {
  //   return _songBox.values.toList();
  // }
  //
  // // Method to delete a song from Hive
  // void deleteSong(int id) {
  //   _songBox.delete(id);
  // }
}
