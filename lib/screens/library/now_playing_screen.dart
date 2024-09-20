import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/nav/navbar.dart';
import 'package:vibemix/network/lyrics_network.dart';
import 'package:vibemix/utils/fav_notifier.dart';
import '../../customs/custom_elevated_button.dart';
import '../../customs/global.dart';
import '../../models/audio_player_model.dart';
import '../../models/box.dart';
import '../../models/hive.dart';
import '../../utils/notifier.dart';
import '../playlist/create_playlist.dart';

class NowPlayingScreen extends StatefulWidget {
   SongHiveModel song;

   NowPlayingScreen({
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
  List<SongHiveModel> favourite = [];
  Box<SongHiveModel>? favsBox;
  List<String> playlistNames = [];
  @override
  void initState() {
    if(audioPlayer.playing)
      {
        isPlaying=true;
      }else{
      isPlaying=false;
    }

    getHiveMusic();
    fetchCurrentVolume();
    getLyricsData();
    audioPlayer.positionStream.listen(onAudioPositionChanged);
    audioPlayer.loopModeStream.listen((event){
      if(event.name=="one"){
        isLooping=true;
      }else{
        isLooping=false;
      }
      if(mounted) {
        setState(() {

      });
      }
    });
    audioPlayer.currentIndexStream.listen((index)  {

     refresh();
    });
    super.initState();
  }

  @override
  void dispose() {
    lyricsScrollController.dispose();
    audioPlayer.currentIndexStream.listen((index){
      refresh();
    }).cancel();
    timer?.cancel();
    // audioPlayer.currentIndexStream.listen(onPlayerStateChanged).cancel();
    super.dispose();
  }

void refresh(){
   // await Future.delayed(Duration(seconds: 1));
    final playlistSong=AudioPlayerSingleton().playlistList[audioPlayer.currentIndex!];
    SongHiveModel currentSong=SongHiveModel(id: playlistSong.id, displayNameWOExt: playlistSong.displayNameWOExt, artist: playlistSong.artist, uri: playlistSong.uri);
    AudioPlayerSingleton().setCurrentSong(
      currentSong
    );
    widget.song=AudioPlayerSingleton().currentSong!;
    getLyricsData();
  if(mounted) {
    setState(() {

    });
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
            ArtworkImage(widget: widget),
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
                  onPressed:  () async {
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
                                          if(playlistBox.containsKey(widget.song.id)){
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Song already exist'),duration: const Duration(seconds: 1),),
                                            );
                                            Navigator.pop(context);
                                          }
                                          else{
                                            playlistBox.put(
                                                widget.song.id,
                                                widget.song);
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Song add to ${playlistNames[index]}'),duration: const Duration(seconds: 1),),
                                            );
                                            Navigator.pop(context);
                                          }


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
                                ],
                              ),
                              sh10,
                             ElevatedCustomButton(
                                buttonName: "Create Playlist",
                                onpress: () {
                                  Navigator.pop(context);
                                  Navigator.push(context,
                                      MaterialPageRoute(
                                          builder: (ctx) {
                                            return const CreatePlaylist();
                                          }));
                                },
                              )
                            ],
                          ),
                        );
                      },
                    );
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
                    stream: audioPlayer.positionStream,
                    builder: (context, snapshot) {
                      final position = snapshot.data ?? Duration.zero;
                   // print("${audioPlayer.duration},$position");
                      // final position = snapshot.data ?? Duration.zero;
                      final maxDuration = audioPlayer.duration ?? Duration.zero;

                      // Use a tolerance check for slight differences between position and duration
                      if (maxDuration != Duration.zero &&
                          position.inSeconds >= maxDuration.inSeconds - 1) {
                        print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
                        // Execute your function here when the audio completes
                        // AudioPlayerSingleton().skipNext(context); // Example function
                      }

                      return Row(
                        children: [
                          TextCustom(
                            color: foreground,
                            size: 10,
                            fontWeight: FontWeight.w300,
                            text: position.toString().split(".")[0],
                          ),
                          Expanded(
                            child:
                            Slider(
                              min: 0.0,
                              value: audioPlayer.duration == null
                                  ? 0.0
                                  : position.inSeconds.toDouble(),
                              max: audioPlayer.duration?.inSeconds.toDouble() ??
                                  0.0,
                              onChanged: (value) {
                                changeToSeconds(value.toInt());

                                print("lllllllllllllllllllllllllllllllllllllll");
                                // Duration duration =
                                //     Duration(seconds: value.toInt());
                                // print("oooooooooooooooooooooooooooooooooooooooo${duration.inSeconds.toDouble()}");
                                // print("oooooooooooooooooooooooooooooooooooooooo${audioPlayer.duration!.inSeconds.toDouble()}");
                                // if (duration.inSeconds.toDouble() ==
                                //     audioPlayer.duration!.inSeconds
                                //         .toDouble()) {
                                //   print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${duration.inSeconds.toDouble()}");
                                // print("eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee${audioPlayer.duration!.inSeconds.toDouble()}");
                                //
                                // AudioPlayerSingleton().skipNext(context);
                                // }
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
                        onPressed: playPause,
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
        onPressed: favIcon,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_border_outlined,
          color: foreground,
          size: 24,
        ),
      ),
    );
  }

  void playPause() {
    setState(() {
      if (isPlaying) {
        audioPlayer.pause();
      } else {
        audioPlayer.play();
      }
      isPlaying = !isPlaying;
      RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
    });
  }

  void favIcon() async {

    favsBox = await HiveService.getFavBox();
    if (isFavorite) {
      favsBox!.delete(widget.song.id);
      favourite.removeWhere((song) => song.id == widget.song.id);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Song removed from favorites'),duration: Duration(seconds: 1),),
      );
    } else {
      favsBox!.put(widget.song.id, widget.song);
      favourite.add(widget.song);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Song added to favorites'),duration: Duration(seconds: 1),),
      );
    }
    setState(() {
      isFavorite = !isFavorite;
    });
    FavNotifier().notifier.value=!FavNotifier().notifier.value;
  }

  void getLyricsData() async {
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
    if(position==audioPlayer.duration&& mounted){
      print("wrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
      return  NowPlayingScreen(song: AudioPlayerSingleton().currentSong!);
      }));
    }
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

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    audioPlayer.seek(duration);
  }
}

class ChoosePlaylist extends StatelessWidget {
  const ChoosePlaylist({
    super.key,
    required this.playlistNames,
    required this.widget,
  });

  final List<String> playlistNames;
  final NowPlayingScreen widget;

  @override
  Widget build(BuildContext context) {
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
              ? ListOfPlaylist(playlistNames: playlistNames, widget: widget)
              : const ListEmptyAddPlaylist(),
        ],
      ),
    );
  }
}

class ListEmptyAddPlaylist extends StatelessWidget {
  const ListEmptyAddPlaylist({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
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
      );
  }
}

class ListOfPlaylist extends StatelessWidget {
  const ListOfPlaylist({
    super.key,
    required this.playlistNames,
    required this.widget,
  });

  final List<String> playlistNames;
  final NowPlayingScreen widget;

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                            playlistNames[index]);
                    playlistBox.put(
                        widget.song.id,
                        widget.song);
                    ScaffoldMessenger.of(context).showSnackBar(
                       SnackBar(content: Text('Song added ${playlistNames[index]}'),duration: Duration(seconds: 1),),
                    );
                    Navigator.pop(context);
                  },
                  child: Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      TextCustom(
                        text:
                            playlistNames[index],
                        color: background,
                        size: 18,
                      ),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons
                                .arrow_forward_ios_outlined,
                            color: background,
                            size: 18,
                          ))
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      );
  }
}

class ArtworkImage extends StatelessWidget {
  const ArtworkImage({
    super.key,
    required this.widget,
  });

  final NowPlayingScreen widget;

  @override
  Widget build(BuildContext context) {
    return QueryArtworkWidget(
      id: widget.song.id,
      type: ArtworkType.AUDIO,
      nullArtworkWidget: Icon(Icons.music_note, color: foreground, size: 150),
      artworkFit: BoxFit.cover,
      artworkWidth: 250,
      artworkHeight: 210,
      artworkBorder: BorderRadius.circular(15),
    );
  }
}
