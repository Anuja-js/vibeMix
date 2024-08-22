import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';

class AudioPlayerSingleton {
  // Private constructor
  AudioPlayerSingleton._privateConstructor();

  // The single instance of AudioPlayerSingleton
  static final AudioPlayerSingleton _instance = AudioPlayerSingleton._privateConstructor();

  // The single instance of AudioPlayer
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Variable to store the currently playing song
  SongModel? _currentSong;

  // Factory constructor to return the single instance of AudioPlayerSingleton
  factory AudioPlayerSingleton() {
    return _instance;
  }

  // Method to access the AudioPlayer instance
  AudioPlayer get audioPlayer => _audioPlayer;

  // Method to access the currently playing song
  SongModel? get currentSong => _currentSong;

  // Method to set the currently playing song
  void setCurrentSong(SongModel song) {
    _currentSong = song;
  }

  // Method to play a song
  Future<void> playSong(SongModel song) async {
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
}
