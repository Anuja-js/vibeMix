import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';
import 'package:vibemix/models/audio_player_model.dart';

class MyAudioHandler extends BaseAudioHandler with QueueHandler,SeekHandler{
//create instance of the AudioPlayer class from just_audio package
  AudioPlayer audioPlayer=AudioPlayerSingleton().audioPlayer;
//function to create an audio source from a MediaItem
  UriAudioSource createAudioSource(MediaItem item){
    return ProgressiveAudioSource(Uri.parse(item.id));
  }

//Listen for changes in the current song index and update media item
  void listenForCurrentSongIndexChanges(){
    audioPlayer.currentIndexStream.listen((index){
      final playlist=queue.value;
      if(index==null ||playlist.isEmpty) return;
      mediaItem.add(playlist[index]);
    });
  }
  void broadcastState(PlaybackEvent event){
    playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.skipToPrevious,
          if(audioPlayer.playing)MediaControl.pause else MediaControl.play,
          MediaControl.skipToNext,
        ],
        systemActions: const{
          MediaAction.seek,
          MediaAction.seekForward,
          MediaAction.seekBackward
        },
        processingState: const{
          ProcessingState.idle:AudioProcessingState.idle,
          ProcessingState.loading:AudioProcessingState.loading,
          ProcessingState.buffering:AudioProcessingState.buffering,
          ProcessingState.ready:AudioProcessingState.ready,
          ProcessingState.completed:AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        playing: audioPlayer.playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: event.currentIndex

    ));
  }
//function to initialize the song and set up the audio player
  Future<void> initSong({required List<MediaItem>songs})async{
//Listen for playback events and broadcast the state
    audioPlayer.playbackEventStream.listen(broadcastState);
  }
}