import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import '../../customs/container_custom.dart';
import '../../customs/list_of_allsongs.dart';
import '../../customs/text_custom.dart';
import '../../global.dart';
import '../../models/box.dart';
import '../../models/hive.dart';

class MyMusic extends StatefulWidget {
  const MyMusic({super.key});

  @override
  State<MyMusic> createState() => _MyMusicState();
}

class _MyMusicState extends State<MyMusic> {
  Box<SongHiveModel>? songsBox;
  List<SongHiveModel> songs = [];
  @override
  void initState() {
    getHiveMusic();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "My Music",
      backButton: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 25),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const ContainerForSearch(),
              sh10,
              if (songs.isEmpty)
                TextCustom(
                    color: foreground,
                    size: 18,
                    fontWeight: FontWeight.normal,
                    text: "Songs Not found"),
              ListOfMusic(songsBox: songsBox, count: songs.length)
            ],
          ),
        ),
      ),
      appBar: true,
      action: false,
    );
  }

  getHiveMusic() async {
    songsBox = await HiveService.getSongsBox();
    songs.addAll(songsBox!.values);
    setState(() {});
  }
}
