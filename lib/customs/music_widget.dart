import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/screens/library/favorite_screen.dart';import '../../global.dart';
import 'package:vibemix/customs/custom_elevated_button.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/playlist/create_playlist.dart';
import 'package:vibemix/screens/library/now_playing_screen.dart';

import '../models/audio_player_model.dart';
import '../models/box.dart';
import '../models/hive.dart';
import '../utils/notifier.dart';

class MusicWidget extends StatefulWidget {
  final SongHiveModel data;
  String playlistName;
  Color color;
  Color backGroundColor;

  MusicWidget(
      {super.key,
      required this.data,
      required this.color ,required this.playlistName,
      required this.backGroundColor});

  @override
  State<MusicWidget> createState() => _MusicWidgetState();
}

class _MusicWidgetState extends State<MusicWidget> {
  final audio = AudioPlayerSingleton().audioPlayer;
  SongHiveModel? current;
  bool isFavorite = false;
  List<SongHiveModel> favourite = [];
  Box<SongHiveModel>? favsBox;
  bool isPlaying = false;


  @override
  void initState() {
    super.initState();
    current = AudioPlayerSingleton().currentSong;
    audio.playerStateStream.listen((state) {
      current = AudioPlayerSingleton().currentSong;
    });
    RefreshNotifier().notifier.addListener(checkIsPlaying);
    getHiveMusic();
    checkIsPlaying();
  }

  @override
  void dispose() {
    RefreshNotifier().notifier.removeListener(checkIsPlaying);
    super.dispose();
  }

  void checkIsPlaying() {
    if (!audio.playing || AudioPlayerSingleton().currentSong == null) {
      isPlaying = false;
    }
    else if (audio.playing && AudioPlayerSingleton().currentSong == widget.data) {
      isPlaying = true;
    } else {
      isPlaying = false;
    }
    setState(() {});
  }


  List<String> playlistNames = [];
  @override
  Widget build(BuildContext context) {

    return ListTile(
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: widget.backGroundColor,
        child: QueryArtworkWidget(
          artworkBorder: const BorderRadius.all(
            Radius.circular(50),
          ),
          id: widget.data.id,
          type: ArtworkType.AUDIO,
          nullArtworkWidget: Icon(
            Icons.music_note,
            color: widget.color,
            size: 30,
          ),
        ),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width / 2.5,
                child: Text(
                  widget.data.displayNameWOExt,
                  style: TextStyle(
                    fontSize: 15,
                    color: foreground,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.start,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                onPressed: () async {
     await           AudioPlayerSingleton().setCurrentPlaylist(widget.playlistName);
                  if(audio.playing){
                     AudioPlayerSingleton().pause();
                    if(AudioPlayerSingleton().currentSong!=widget.data){
                   await   AudioPlayerSingleton().playSong(widget.data);
                    }
                  }else{
                    await AudioPlayerSingleton().playSong(widget.data);
                  }
                  current = widget.data;
                  RefreshNotifier().notifier.value = !RefreshNotifier().notifier.value;
                  setState(() {

                  });
                },
                icon: Icon(
                  isPlaying ? Icons.pause : Icons.play_circle_outline,
                  color: foreground,
                  size: 24,
                ),
              ),
              IconButton(
                onPressed: () {
                  showMenu(
                    context: context,surfaceTintColor: textPink,color: textPink,
                    position: const RelativeRect.fromLTRB(
                        80, 350, 80, 10), // Position of the menu
                    items: [
                      PopupMenuItem(
                        value: 'favorite',
                        onTap: () {
                          if (isFavorite) {
                            favsBox!.delete(widget.data.id);
                            favourite
                                .removeWhere((song) => song.id == widget.data.id);
                            setState(() {
                              isFavorite=!isFavorite;

                            });

                          } else {
                            favsBox!.put(widget.data.id, widget.data);
                            favourite.add(widget.data);
                            setState(() {
                              isFavorite=!isFavorite;
                            });

                          }
                          if(widget.playlistName=="fav") {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx){
                            return FavoriteScreen();
                          }));
                          }

                        },
                        child: ListTile(
                          leading: Icon(
                            isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border_outlined,
                            color: iconFav,
                          ),
                          title: isFavorite
                              ? TextCustom(
                            text: 'Remove From Favorite',
                            color: background,
                          )
                              : TextCustom(
                            text: 'Add to Favorite',
                            color: background,
                          ),
                        ),
                      ),
                      PopupMenuItem(
                        onTap: () async {
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
                                            icon:  Icon(
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
                                                      widget.data.id,
                                                      widget.data);
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
                                                        icon:  Icon(
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
                                    )
                                        : Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                          sh50,
                                            TextCustom(
                                              text:
                                              "No PlayList Available Create One",
                                              color: background,
                                            ),
                                            sh10,
                                            ElevatedCustomButton(buttonName: "Create Playlist",onpress: (){
                                              Navigator.push(context, MaterialPageRoute(builder: (ctx){
                                                return const CreatePlaylist();
                                              }));
                                            },)
                                          ],
                                        ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        value: 'playlist',
                        child: const ListTile(
                          leading: Icon(Icons.playlist_add),
                          title: Text('Add to Playlist'),
                        ),
                      ),
                    ],
                  );
                },
                icon:  Icon(
                  Icons.more_vert_outlined,
                  color: foreground,
                  size: 24,
                ),
              ),

            ],
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 2.5,
            child: Text(
              "${widget.data.artist}",
              style:  TextStyle(
                fontSize: 13,
                color: foreground,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      onTap: ()async {
if(audio.playing){
  audio.stop();

}
await AudioPlayerSingleton().setCurrentPlaylist(widget.playlistName);

Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {

          return NowPlayingScreen(
            song: widget.data,
          );
        })).then((value) async{
          getHiveMusic();
          setState(() {
            current=AudioPlayerSingleton().currentSong;
          });
        });
      },
    );
  }

  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    isFavorite = favourite.any((song) => song.id == widget.data.id);
    setState(() {});
  }
}
