import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../models/audio_player_model.dart';
import '../screens/library/now_playing_screen.dart';
import '../utils/notifier.dart';
import 'global.dart';
class FloatingMusic extends StatefulWidget {
  const FloatingMusic({
    super.key,
  });

  @override
  State<FloatingMusic> createState() => _FloatingMusicState();
}

class _FloatingMusicState extends State<FloatingMusic> {
  @override
  void initState() {
    AudioPlayerSingleton().audioPlayer.playbackEventStream.listen(broadcastState);
    RefreshNotifier().notifier.addListener(refresh);
    super.initState();
  }
  void refresh(){
    setState(() {
      
    });
  }
  void broadcastState(PlaybackEvent event)
  {
   if(mounted) {
     setState(() {

    });
   }
  }
  @override
  void dispose() {
    AudioPlayerSingleton().audioPlayer.playbackEventStream.listen(broadcastState).cancel();
   RefreshNotifier().notifier.removeListener(refresh);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (ctx){
          return NowPlayingScreen(song: AudioPlayerSingleton().currentSong!);
        }));
      },
      child: Container(padding: EdgeInsets.symmetric(horizontal: 10),
        margin: const EdgeInsets.symmetric(horizontal: 18,vertical: 25),
        width: MediaQuery.of(context).size.width,height: MediaQuery.of(context).size.height/8,
        decoration: BoxDecoration(color: textPink,borderRadius: BorderRadius.circular(18), border: Border.all(
          color: foreground, // Set the border color
          width: 2.0,         // Set the border width
        ),),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,

          children: [
            Container(width: 50,height: 50,
              decoration: BoxDecoration(
                border: Border.all(color: background,width: 1.5),
              ),
              child: QueryArtworkWidget(
                artworkBorder: const BorderRadius.all(
                  Radius.circular(1),
                ),
                id: AudioPlayerSingleton().currentSong!.id,
                type: ArtworkType.AUDIO,
                nullArtworkWidget: Icon(
                  Icons.music_note,
                  color: background,
                  size: 30,
                ),
              ),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width / 2.5,
                  child: Text(
                    AudioPlayerSingleton().currentSong!.displayNameWOExt,
                    style: TextStyle(
                      fontSize: 15,
                      color: background,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.start,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                Row(crossAxisAlignment: CrossAxisAlignment.start,mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    StreamBuilder<Duration>(
                      stream: AudioPlayerSingleton().audioPlayer.positionStream,
                      builder: (context, snapshot) {
                        final position = snapshot.data ?? Duration.zero;

                        return Slider(
                          min: 0.0,
                          value: AudioPlayerSingleton().audioPlayer.duration == null
                              ? 0.0
                              : position.inSeconds.toDouble(),
                          max: AudioPlayerSingleton().audioPlayer.duration?.inSeconds.toDouble() ??
                              0.0,
                          onChanged: (value) {

                            changeToSeconds(value.toInt());
                            Duration duration =
                            Duration(seconds: value.toInt());
                            if (duration.inSeconds.toDouble() ==
                                AudioPlayerSingleton().audioPlayer.duration!.inSeconds
                                    .toDouble()) {
                              AudioPlayerSingleton().skipNext(context);
                            }
                          },
                          activeColor: background,
                          inactiveColor: foreground,
                        );
                      },
                    ),
                  ],
                )
              ],
            ),
            IconButton(
              onPressed: ()  {
                if(AudioPlayerSingleton().audioPlayer.playing){
                  AudioPlayerSingleton().audioPlayer.pause();

                }
                else{
                  AudioPlayerSingleton().audioPlayer.play();
                }
                RefreshNotifier().notifier.value =
                !RefreshNotifier().notifier.value;
              },
              icon: Icon(
                AudioPlayerSingleton().audioPlayer.playing ? Icons.pause : Icons.play_circle_outline,
                color: background,
                size: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    AudioPlayerSingleton().audioPlayer.seek(duration);
  }
}
