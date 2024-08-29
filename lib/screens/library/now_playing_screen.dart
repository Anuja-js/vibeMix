import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';

import '../../models/audio_player_model.dart';
import '../../models/box.dart';
import '../../models/hive.dart';

class NowPlayingScreen extends StatefulWidget {
  final SongHiveModel song;
  const NowPlayingScreen({Key? key, required this.song}) : super(key: key);

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final AudioPlayer _audioPlayer = AudioPlayerSingleton().audioPlayer;
  bool _isPlaying = false;
  bool isFavorite = false;
  double _currentVolume = 1.0; // Initial volume
  String _volumeDisplay = "Volume: 100%"; // Initial volume display

  @override
  void initState() {
    super.initState();
    checkPlayButton();
    getHiveMusic();
  }

  List<SongHiveModel> favourite = [];
  Box<SongHiveModel>? favsBox;

  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    isFavorite = favourite.any((song) => song.id == widget.song.id);
    print(isFavorite);
    setState(() {});
  }

  checkPlayButton() async {
    await _audioPlayer.setUrl(widget.song.uri.toString());
    await _audioPlayer.play();
    if (kDebugMode) {
      print("Audio is playing: ${_audioPlayer.playing}");
    }
    setState(() {
      _isPlaying = _audioPlayer.playing;
    });
  }

  void _volumeUp() {
    if (_currentVolume < 1.0) {
      _currentVolume += 0.1;
      _audioPlayer.setVolume(_currentVolume);
      _updateVolumeDisplay();
    }
  }

  void _volumeDown() {
    if (_currentVolume > 0.0) {
      _currentVolume -= 0.1;
      _audioPlayer.setVolume(_currentVolume);
      _updateVolumeDisplay();
    }
  }

  void _updateVolumeDisplay() {
    setState(() {
      _volumeDisplay = "Volume: ${(_currentVolume * 100).toInt()}%";
    });
  }

  void _skipNext() {
    _audioPlayer.seekToNext();
  }

  void _skipPrevious() {
    _audioPlayer.seekToPrevious();
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
              text: widget.song.artist == "<unknown>" ? "Unknown" : widget.song.artist!,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.shuffle_outlined, color: foreground),
                  onPressed: () {
                    // Add shuffle functionality
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.playlist_add, color: foreground),
                  onPressed: () {
                    // Add to playlist functionality
                  },
                ),
              ],
            ),
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
                              max: _audioPlayer.duration?.inSeconds.toDouble() ?? 0.0,
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
                            text: _audioPlayer.duration?.toString().split(".")[0] ?? '00:00',
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
                        onPressed: _skipPrevious,
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
                        onPressed: _skipNext,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.volume_down, color: foreground),
                        onPressed: _volumeDown,
                      ),
                      TextCustom(
                        color: foreground,
                        size: 15,
                        fontWeight: FontWeight.w400,
                        text: _volumeDisplay, // Volume display text
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up, color: foreground),
                        onPressed: _volumeUp,
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
      actionIcon: IconButton(
        onPressed: () async {
          favsBox = await HiveService.getFavBox();
          if (isFavorite) {
            favsBox!.delete(widget.song.id);
            favourite.removeWhere((song) => song.id == widget.song.id);
          } else {
            favsBox!.put(widget.song.id, widget.song);
            favourite.add(widget.song);
          }
          setState(() {
            isFavorite = !isFavorite;
          });
        },
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          color: foreground,
          size: 24,
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    _audioPlayer.seek(duration);
  }
}
