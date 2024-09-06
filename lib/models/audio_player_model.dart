
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibemix/models/box.dart';
import 'package:vibemix/models/recent.dart';

import 'hive.dart';
class AudioPlayerSingleton {
  // Private constructor
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
      await _audioPlayer.setAudioSource(AudioSource.uri(Uri.parse(song.uri!)));
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

  // Method to seek to a specific position in the currently playing song
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
