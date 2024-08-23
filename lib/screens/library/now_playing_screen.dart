import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../../models/audio_player_model.dart';

class NowPlayingScreen extends StatefulWidget {
  final SongModel song;
  const NowPlayingScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final AudioPlayer _audioPlayer = AudioPlayerSingleton().audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    checkPlayButton();
    super.initState();
  }
  checkPlayButton()async{
    AudioPlayerSingleton().setCurrentSong(widget.song);
   await  AudioPlayerSingleton().playSong(widget.song);
   if (kDebugMode) {
     print("';;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;${_audioPlayer.playing}");
   }
    if(_audioPlayer.playing){
      setState(() {
        _isPlaying=true;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "",
      backButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            sh25,
            QueryArtworkWidget(
              id: widget.song.id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(Icons.music_note, color: foreground, size: 150),
              artworkFit: BoxFit.cover,
              artworkWidth: 250,
              artworkHeight: 210,
              artworkBorder: BorderRadius.circular(15),
            ),
            sh25,
            Text(
              widget.song.displayNameWOExt,
              style: const TextStyle(
                color: foreground,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                overflow: TextOverflow.ellipsis,
              ),
              textAlign: TextAlign.center,
            ),
            sh10,
            TextCustom(
              color: foreground,
              size: 15,
              fontWeight: FontWeight.w300,
              text: "${widget.song.artist}" == "<unknown>" ? "Unknown" : "${widget.song.artist}",
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle_outlined, color: foreground),
                  onPressed: () {
                    // Add your volume down functionality here
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.playlist_add, color: foreground),
                  onPressed: () {
                    // Add your volume up functionality here
                  },
                ),
              ],),
            Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: textPink,
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
              child: Column(
                children: [
                  //update the screen
                  StreamBuilder<Duration>(
                    stream: _audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;

                      return Row(
                        children: [
                          TextCustom(
                            color: foreground,
                            size: 10,
                            fontWeight: FontWeight.w300,
                            text: position.toString().split(".")[0],
                          ),
                          Expanded(
                            child: Slider(
                              min: 0.0,
                              value: position.inSeconds.toDouble(),
                              max: _audioPlayer.duration==null?Duration.zero.inSeconds.toDouble(): _audioPlayer.duration!.inSeconds.toDouble(),
                              onChanged: (value) {
                                changeToSeconds(value.toInt());
                              },
                              activeColor: background,
                              inactiveColor: foreground,
                            ),
                          ),
                          TextCustom(
                            color: foreground,
                            size: 10,
                            fontWeight: FontWeight.w300,
                            text:  _audioPlayer.duration==null?Duration.zero.toString().split(".")[0]: _audioPlayer.duration.toString().split(".")[0],
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous, color: foreground, size: 25),
                        onPressed: () {
                          // Add your skip previous functionality here
                        },
                      ),
                      IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow_outlined, color: foreground, size: 25),
                        onPressed: () {
                          setState(() {
                            if (_isPlaying) {
                              _audioPlayer.pause();
                            } else {
                              _audioPlayer.play();
                            }
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.skip_next, color: foreground, size: 25),
                        onPressed: () {
                          // Add your skip next functionality here
                        },
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_down, color: foreground),
                        onPressed: () {
                          // Add your volume down functionality here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: foreground),
                        onPressed: () {
                          // Add your volume up functionality here
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      appBar: true,
      action: true,
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    _audioPlayer.seek(duration);
  }
}
