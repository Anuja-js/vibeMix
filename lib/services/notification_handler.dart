import 'package:audio_service/audio_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibemix/models/audio_player_model.dart';

import '../models/hive.dart';
import '../utils/notifier.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler, SeekHandler {
  final AudioPlayer audioPlayer = AudioPlayerSingleton().audioPlayer;

  MyAudioHandler() {
    // Initialize the audio handler
    audioPlayer.playbackEventStream.listen(broadcastState);

    audioPlayer.durationStream.listen((duration) {
      broadcastState(audioPlayer.playbackEvent);
    });
    // Listen to the currentIndex stream and update the UI when the song changes
    audioPlayer.currentIndexStream.listen((index) async {
      await Future.delayed(Duration(seconds: 1));
      RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;

      List<MediaItem> playlist = [];
      if (AudioPlayerSingleton().currentSong != null) {
        playlist = [createMediaItem(AudioPlayerSingleton().currentSong!)];
      } else {
        playlist = [];
      }

      if (playlist.isNotEmpty) {
        mediaItem.add(MediaItem(
            id: playlist[0].id,
            title: playlist[0].title,
            artUri: playlist[0].artUri,
            artist: playlist[0].artist
        ));
      } else {
        return;
      }

      // Broadcast player state when the index changes
      broadcastState(audioPlayer.playbackEvent);

    });
  }

  // Create an audio source from a MediaItem
  UriAudioSource createAudioSource(MediaItem item) {
    return AudioSource.uri(Uri.parse(item.id));
  }

  // Broadcast player state, including controls and system actions
  void broadcastState(PlaybackEvent event) {
    playbackState.add(playbackState.value.copyWith(
      controls: [
        MediaControl.skipToPrevious,
        if (audioPlayer.playing) MediaControl.pause else MediaControl.play,
        MediaControl.skipToNext,
      ],
      systemActions: {
        // // MediaAction.seek,
        // MediaAction.seekForward,
        // MediaAction.seekBackward,
      },
      processingState: {
        ProcessingState.idle: AudioProcessingState.idle,
        ProcessingState.loading: AudioProcessingState.loading,
        ProcessingState.buffering: AudioProcessingState.buffering,
        ProcessingState.ready: AudioProcessingState.ready,
        ProcessingState.completed: AudioProcessingState.completed,
      }[audioPlayer.processingState]!,
      playing: audioPlayer.playing,
      updatePosition: audioPlayer.position,
      bufferedPosition: audioPlayer.bufferedPosition,
      speed: audioPlayer.speed,
      queueIndex: audioPlayer.currentIndex,
      // duration: audioPlayer.duration,
    ));
  }

  // Initialize the audio player with songs
  Future<void> initSong({required List<MediaItem> songs}) async {
    final audioSources = songs.map(createAudioSource).toList();
    await audioPlayer.setAudioSource(ConcatenatingAudioSource(children: audioSources));
    queue.add(songs);
  }

  // Play audio
  @override
  Future<void> play() async {
    await audioPlayer.play();
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
  }

  // Pause audio
  @override
  Future<void> pause() async {
    await audioPlayer.pause();
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
  }

  // Seek to a specific position
  @override
  Future<void> seek(Duration position) async {
    await audioPlayer.seek(position);
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
  }

  // Skip to next song
  @override
  Future<void> skipToNext() async {
   AudioPlayerSingleton().skipNextWithoutContext();
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
  }

  // Skip to previous song
  @override
  Future<void> skipToPrevious() async {
 AudioPlayerSingleton().skipPreviousNoContext();
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
  }

  // Stop audio player
  @override
  Future<void> stop() async {
    await audioPlayer.stop();
    playbackState.add(playbackState.value.copyWith(
      processingState: AudioProcessingState.idle,
    ));
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value; // Trigger UI update
  }

  // Skip to a specific item in the queue
  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= queue.value.length) return;
    await audioPlayer.seek(Duration.zero, index: index);
    RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value; // Trigger UI update
  }

  // Create MediaItem with cover image
  MediaItem createMediaItem(SongHiveModel song) {
    return MediaItem(
      id: song.uri!,
      album: "",
      title: song.displayNameWOExt,
      artist: song.artist,
      artUri: Uri.parse(song.uri ?? ''),
      duration: AudioPlayerSingleton().audioPlayer.duration,
    );
  }

  // Update playlist with media items and cover art
  Future<void> setPlaylistWithCovers(List<SongHiveModel> songs) async {
    final mediaItems = songs.map((song) => createMediaItem(song)).toList();
    queue.add(mediaItems);

    final audioSources = mediaItems.map(createAudioSource).toList();
    await audioPlayer.setAudioSource(ConcatenatingAudioSource(children: audioSources));
  }

  // Custom action handler for seek, seekForward, and seekBackward
  @override
  Future<dynamic> customAction(String action, [Map<String, dynamic>? extras]) async {

    if (action == MediaAction.seek.name) {
      // Handle seek action
      final newPosition = audioPlayer.position + Duration(seconds: 10); // Seek forward by 10 seconds
      await seek(newPosition);
    } else if (action == MediaAction.seekBackward.name) {
      // Handle seek backward
      final newPosition = audioPlayer.position - Duration(seconds: 10); // Seek backward by 10 seconds
      await seek(newPosition);
    } else if (action == MediaAction.skipToPrevious.name) {
      // Handle skip to previous
      await skipToPrevious();
    } else if (action == MediaAction.skipToNext.name) {
      // Handle skip to next
      await skipToNext();
    }
    return Future.value(); // Ensure return type matches the expected Future<dynamic>
  }
}
