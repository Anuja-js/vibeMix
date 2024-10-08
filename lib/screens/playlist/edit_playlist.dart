import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/screens/playlist/playlist.dart';

import '../../customs/scaffold_custom.dart';
import '../../customs/global.dart';
import '../../models/box.dart';
import '../../models/hive.dart';

class EditPlaylist extends StatefulWidget {
  String name;
  EditPlaylist({super.key, required this.name});

  @override
  State<EditPlaylist> createState() => _EditPlaylistState();
}

class _EditPlaylistState extends State<EditPlaylist> {
  Box<SongHiveModel>? songsBox;
  List<SongHiveModel> songs = [];
  TextEditingController textctr = TextEditingController();
  @override
  void initState() {
    textctr.text = widget.name;
    getHiveMusic();
    super.initState();
  }
  List<SongHiveModel> selected = [];

  getHiveMusic() async {
    songsBox = await HiveService.getSongsBox();
    songs.addAll(songsBox!.values);
    Box<SongHiveModel> temp = await Hive.openBox(widget.name);
    selected.addAll(temp.values);
    sortMusicList();
    setState(() {});
  }


  void sortMusicList() async{
    List<SongHiveModel> unSelected = [];
    unSelected=songs;
      for(int i=0;i<unSelected.length;i++){
      for(int j=0;j<selected.length;j++){
        if(unSelected[i].id==selected[j].id){
          unSelected.removeAt(i);
        }
      }
      }
   songs=[];
    songs.addAll(selected);
    songs.addAll(unSelected);

    // Update the UI or any dependent state if needed
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
        tittle: "Edit Playlist",
        action: true,
        actionIcon: IconButton(
          onPressed: () async {
            FocusManager.instance.primaryFocus!.unfocus();
            String playlistName = textctr.text;
            if (playlistName.isEmpty) return;
            Box<SongHiveModel> playlistSongsBox =
                await Hive.openBox<SongHiveModel>(playlistName);

            for (int i = 0; i < selected.length; i++) {
              playlistSongsBox.put(selected[i].id.toString(), selected[i]);
            }
            Box<String> playlistsBox = await Hive.openBox<String>('playlists');
            playlistsBox.put(playlistName, playlistName);
            if (widget.name != playlistName) {
              playlistsBox.delete(widget.name);
              Box<SongHiveModel> oldPlaylist =
                  await Hive.openBox<SongHiveModel>(widget.name);
           await   oldPlaylist.deleteFromDisk();
            }
            else{
          await    playlistSongsBox.clear();
              for(int i=0;i<selected.length;i++){
             await   playlistSongsBox.put(selected[i].id.toString(), selected[i]);
              }
            }
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Playlist edited successfully'),duration: Duration(seconds: 1),),
            );
            // ignore: use_build_context_synchronously
            Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (ctx) {
              return const PlaylistScreen();
            }));
          },
          icon: Icon(Icons.check_outlined, size: 25, color: foreground),
        ),
        backButton: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextCustom(
                      color: foreground,
                      size: 18,
                      fontWeight: FontWeight.normal,
                      text: "PlayList Name"),
                  sh25,
                  TextFormField(
                    controller: textctr,
                    scrollPhysics: const NeverScrollableScrollPhysics(),
                    decoration: InputDecoration(
                      fillColor: textPink,
                      filled: true,
                      focusColor: textPink,
                      floatingLabelStyle: TextStyle(
                          color: foreground,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: background,
                        ),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: background),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: background),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 55, top: 25),
                    height: 560,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: textPink,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(15)),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: songs.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: background,
                            child: QueryArtworkWidget(
                              artworkBorder: const BorderRadius.all(
                                Radius.circular(50),
                              ),
                              id: songs[index].id,
                              type: ArtworkType.AUDIO,
                              nullArtworkWidget: Icon(
                                Icons.music_note,
                                color: foreground,
                                size: 30,
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width / 2.5,
                                child: Text(
                                  songs[index].displayNameWOExt,
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: foreground,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.start,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Checkbox(
                                  value: selected.any(
                                      (song) => song.id == songs[index].id),
                                  onChanged: (value) {
                                    if (value == true) {
                                      selected.add(songs[index]);
                                    } else {
                                      selected.removeWhere(
                                          (song) => song.id == songs[index].id);
                                      // sortMusicList();
                                    }
                                    setState(() {});
                                  }),

                            ],
                          ),
                          subtitle: Text(
                            "${songs[index].artist}",
                            style: TextStyle(
                              fontSize: 13,
                              color: foreground,
                              fontWeight: FontWeight.w200,
                            ),
                            textAlign: TextAlign.start,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {},
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        appBar: true);
  }
}
