import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/custom_elevated_button.dart';
import 'package:vibemix/nav/navbar.dart';
import 'package:vibemix/screens/playlist/sections_play.dart';
import '../../customs/scaffold_custom.dart';
import '../../customs/text_custom.dart';
import '../../customs/global.dart';
import '../../models/audio_player_model.dart';
import '../../models/hive.dart';
import 'create_playlist.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({super.key});

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<String> playlistNames = [];

  @override
  void initState() {
    loadPlaylists();
    super.initState();
  }

  Future<void> loadPlaylists() async {
    Box<String> playlistsBox = await Hive.openBox<String>('playlists');
    setState(() {
      playlistNames = playlistsBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Playlists",
      onBack: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (ctx) {
          return NavBar(reset: false);
        }));
      },
      action: true,
      onpress: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) {
            return const CreatePlaylist();
          }),
        ).then((_) {
          loadPlaylists();
        });
      },
      actionIcon: Icon(
        Icons.add_circle_outline_outlined,
        size: 25,
        color: foreground,
      ),
      backButton: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              playlistNames.isEmpty
                  ? Center(
                      heightFactor: 20.2,
                      child: TextCustom(
                        text: "No Playlist Available",
                        color: foreground,
                      ))
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: playlistNames.length,
                      itemBuilder: (ctx, index) {
                        return ListTile(
                          onTap: () {
                            AudioPlayerSingleton()
                                .setCurrentPlaylist(playlistNames[index]);
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (ctx) {
                              return SecssionsEach(
                                name: playlistNames[index],
                              );
                            })).then((_) {
                              loadPlaylists();
                            });
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                              constraints: BoxConstraints(
                                maxWidth: MediaQuery.of(context).size.width,
                                maxHeight:
                                    MediaQuery.of(context).size.height / 5,
                              ),
                              context: context,
                              builder: (ctx) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 15, horizontal: 18),
                                  color: foreground,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextCustom(
                                            text:
                                                "Do You Want to Delete ${playlistNames[index]}?",
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
                                      ElevatedCustomButton(
                                        buttonName: "Delete",
                                        onpress: delete,
                                      )
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          title: Text(
                            playlistNames[index],
                            style: TextStyle(color: foreground),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios_outlined,
                            color: foreground,
                            size: 18,
                          ),
                        );
                      })
            ],
          )),
        ),
      ),
      appBar: true,
    );
  }
  void delete() async {
    Box<SongHiveModel> oldPlaylist =
    await Hive.openBox<SongHiveModel>(
        playlistNames[index]);

    Box<String> playlists =
    await Hive.openBox("playlists");
    playlists
        .delete(playlistNames[index]);
    oldPlaylist.deleteFromDisk();
    playlistNames.removeAt(index);
    setState(() {});
    Navigator.of(context).pop();
  }
}
