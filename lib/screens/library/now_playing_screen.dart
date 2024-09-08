import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/network/lyrics_network.dart';

import '../../customs/custom_elevated_button.dart';
import '../../global.dart';
import '../../models/audio_player_model.dart';
import '../../models/box.dart';
import '../../models/hive.dart';
import '../../utils/notifier.dart';
import '../playlist/create_playlist.dart';

class NowPlayingScreen extends StatefulWidget {
  final SongHiveModel song;

  const NowPlayingScreen({
    super.key,
    required this.song,
  });

  @override
  State<NowPlayingScreen> createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  final AudioPlayer audioPlayer = AudioPlayerSingleton().audioPlayer;
  final ScrollController lyricsScrollController = ScrollController();
  bool isLooping = false;
  bool isPlaying = true;
  bool isFavorite = false;
  double currentVolume = 0.0;
  String volumeDisplay = "";
  SongHiveModel? current;
  String lyrics = "";
  List<String> lyricsLines = [];
  int currentLineIndex = 0;
  Timer? timer;

  @override
  void initState() {
    checkPlayButton();
    getHiveMusic();
    fetchCurrentVolume();
    getLyricsData();
    audioPlayer.positionStream.listen(onAudioPositionChanged);
    super.initState();
  }

  @override
  void dispose() {
    lyricsScrollController.dispose();
    timer?.cancel();
    super.dispose();
  }

  List<SongHiveModel> favourite = [];
  Box<SongHiveModel>? favsBox;
  List<String> playlistNames = [];
  getLyricsData() async {
    lyrics = await LyricsNetwork()
        .getLyrics(widget.song.artist.toString(), widget.song.displayNameWOExt);
    lyricsLines = lyrics.split('\n');
  }

  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    isFavorite = favourite.any((song) => song.id == widget.song.id);
    setState(() {});
  }

  checkPlayButton() async {
    current = AudioPlayerSingleton().currentSong;
    if (current == null) {
      current = widget.song;
      AudioPlayerSingleton().setCurrentSong(widget.song);
     await AudioPlayerSingleton().playSong(widget.song);
    } else if (current!.id != widget.song.id) {
      await AudioPlayerSingleton().playSong(widget.song);
    } else {
      await AudioPlayerSingleton().playSong(widget.song);
    }
    AudioPlayerSingleton().setCurrentSong(widget.song);
  }

  fetchCurrentVolume() {
    currentVolume = audioPlayer.volume.toDouble();
    updateVolumeDisplay();
  }

  void volumeUp() {
    if (currentVolume < 1.0) {
      currentVolume += 0.1;
      audioPlayer.setVolume(currentVolume);
      updateVolumeDisplay();
    }
  }

  void volumeDown() {
    if (currentVolume > 0.1) {
      currentVolume = currentVolume - 0.1;
      audioPlayer.setVolume(currentVolume);
      updateVolumeDisplay();
    }
  }

  void updateVolumeDisplay() {
    setState(() {
      volumeDisplay = "Volume: ${(currentVolume * 100).toInt()}%";
    });
  }

  void onAudioPositionChanged(Duration position) {
    for (int i = 0; i < lyricsLines.length; i++) {
      if (position.inSeconds >= i * 5 && position.inSeconds < (i + 1) * 5) {
        currentLineIndex = i;
        scrollToCurrentLine();
        break;
      }
    }
  }

  void scrollToCurrentLine() {
    if (lyricsScrollController.hasClients) {
      lyricsScrollController.animateTo(
        currentLineIndex * 40.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "",
      backButton: true,
      onBack: () {
        RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
        Navigator.pop(context);
      },
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
              nullArtworkWidget:
                  Icon(Icons.music_note, color: foreground, size: 150),
              artworkFit: BoxFit.cover,
              artworkWidth: 250,
              artworkHeight: 210,
              artworkBorder: BorderRadius.circular(15),
            ),
            sh25,
            Text(
              widget.song.displayNameWOExt,
              style: TextStyle(
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
              text: widget.song.artist == "<unknown>"
                  ? "Unknown"
                  : widget.song.artist!,
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(
                    isLooping ? Icons.repeat_one : Icons.repeat,
                    color: foreground,
                  ),
                  onPressed: () {
                    setState(() {
                      isLooping = !isLooping;
                      audioPlayer.setLoopMode(
                        isLooping ? LoopMode.one : LoopMode.off,
                      );
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.lyrics_outlined, color: foreground),
                  onPressed: () {
                    showModalBottomSheet(
                      constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width,
                        maxHeight: MediaQuery.of(context).size.height / 2,
                      ),
                      context: context,
                      builder: (ctx) {
                        return Container(
                          width: MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 18),
                          color: foreground,
                          child: SingleChildScrollView(
                            controller: lyricsScrollController,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextCustom(
                                  text: "Lyrics",
                                  color: background,
                                  size: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                sh10,
                                TextCustom(
                                  text: lyrics,
                                  color: background,
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
                IconButton(
                    icon: Icon(Icons.playlist_add, color: foreground),
                    onPressed: ()async {
                      Box<String> playlistsBox =
                      await Hive.openBox<String>('playlists');
                      setState(() {
                        playlistNames = playlistsBox.values.toList();
                      });
                      showModalBottomSheet(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width,
                          maxHeight: MediaQuery.of(context).size.height / 2,
                        ),
                        context: context,
                        builder: (ctx) {
                          return Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 18),
                            color: textPink,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextCustom(
                                      text: "Choose PlayList",
                                      color: background,
                                      size: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(
                                          Icons.close_rounded,
                                          color: background,
                                        ))
                                  ],
                                ),
                                playlistNames.isNotEmpty
                                    ? Expanded(
                                  child: ListView.builder(
                                    itemCount: playlistNames.length,
                                    itemBuilder: (ctx, index) {
                                      return Column(
                                        children: [
                                          InkWell(
                                            onTap: () async {
                                              Box<SongHiveModel>
                                              playlistBox =
                                              await Hive.openBox(
                                                  playlistNames[
                                                  index]);
                                              playlistBox.put(
                                                  widget.song.id,
                                                  widget.song);
                                              Navigator.pop(context);
                                            },
                                            child: Row(
                                              mainAxisAlignment:
                                              MainAxisAlignment
                                                  .spaceBetween,
                                              children: [
                                                TextCustom(
                                                  text: playlistNames[
                                                  index],
                                                  color: background,
                                                  size: 18,
                                                ),
                                                IconButton(
                                                    onPressed: () {},
                                                    icon: Icon(
                                                      Icons
                                                          .arrow_forward_ios_outlined,
                                                      color:
                                                      background,
                                                      size: 18,
                                                    ))
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                                    : Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    sh50,
                                    TextCustom(
                                      text:
                                      "No PlayList Available Create One",
                                      color: background,
                                    ),
                                    sh10,
                                    ElevatedCustomButton(
                                      buttonName: "Create Playlist",
                                      onpress: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (ctx) {
                                                  return const CreatePlaylist();
                                                }));
                                      },
                                    )
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },),
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
                    stream: audioPlayer.positionStream,
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
                              value: audioPlayer.duration == null
                                  ? 0.0
                                  : position.inSeconds.toDouble(),
                              max: audioPlayer.duration?.inSeconds.toDouble() ??
                                  0.0,
                              onChanged: (value) {
                                changeToSeconds(value.toInt());
                                Duration duration =
                                    Duration(seconds: value.toInt());
                                if (duration.inSeconds.toDouble() ==
                                    audioPlayer.duration!.inSeconds
                                        .toDouble()) {
                                  AudioPlayerSingleton().skipNext(context);
                                }
                              },

                              activeColor: background,
                              inactiveColor: foreground,
                            ),
                          ),
                          TextCustom(
                            color: foreground,
                            size: 10,
                            fontWeight: FontWeight.w300,
                            text: audioPlayer.duration
                                    ?.toString()
                                    .split(".")[0] ??
                                '00:00',
                          ),
                        ],
                      );
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                        icon: Icon(Icons.skip_previous,
                            color: foreground, size: 25),
                        onPressed: () {
                          AudioPlayerSingleton().skipPrevious(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(
                            isPlaying ? Icons.pause : Icons.play_arrow_outlined,
                            color: foreground,
                            size: 25),
                        onPressed: () {
                          setState(() {
                            if (isPlaying) {
                              audioPlayer.pause();
                            } else {
                              audioPlayer.play();
                            }
                            isPlaying = !isPlaying;
                            RefreshNotifier().notifier.value =
                                !RefreshNotifier().notifier.value;
                          });
                        },
                      ),
                      IconButton(
                        icon:
                            Icon(Icons.skip_next, color: foreground, size: 25),
                        onPressed: () {
                          AudioPlayerSingleton().skipNext(context);
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.volume_down, color: foreground),
                        onPressed: volumeDown,
                      ),
                      TextCustom(
                        color: foreground,
                        size: 15,
                        fontWeight: FontWeight.w400,
                        text: volumeDisplay, // Volume display text
                      ),
                      IconButton(
                        icon: Icon(Icons.volume_up, color: foreground),
                        onPressed: volumeUp,
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
    audioPlayer.seek(duration);
  }
}
