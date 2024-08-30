import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/icon_images.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/models/box.dart';
import 'package:vibemix/screens/mymusic.dart';

import '../customs/container_custom.dart';
import '../customs/list_of_allsongs.dart';
import '../customs/listtile_custom.dart';
import '../models/hive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String name = "Guest";
  bool _hasPermission = false;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  Box<SongHiveModel>? songsBox;

  @override
  void initState() {
    super.initState();
    getname();
    checkAndRequestPermissions();

  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      backButton: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                    alignment: Alignment.topRight,
                    child: IconImage(
                      height: 125,
                      width: 90,
                    )),
                UserImageAndName(name: name),
                sh25,
                const ContainerForSearch(),
                sh25,
                ListTileCustom(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (ctx) {
                      return const MyMusic();
                    }));
                  },
                  trailing: "See all",
                  tittle: "My Music",
                ),
                if (_hasPermission)
                if (songsBox == null || songsBox!.length == 0)
                  TextCustom(
                    text: "Songs Not found",
                  ),

                if (_hasPermission)
                  ListOfMusic(
                      songsBox: songsBox,
                      count: songsBox!.length > 5 ? 5 : songsBox!.length)
              ],
            ),
          ),
        ),
      ),
      appBar: false,
      action: false,
    );
  }

  checkAndRequestPermissions({bool retry = false}) async {
    _hasPermission = await _audioQuery.checkAndRequest(
      retryRequest: retry,
    );
    if (_hasPermission) {
      getHiveMusic();
      setState(() {});
    } else {
    }
  }

  getHiveMusic() async {
    songsBox = await HiveService.getSongsBox();
    List<SongModel> information = await _audioQuery.querySongs(
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
    for (int i = 0; i < information.length; i++) {

      songsBox!.put(
          information[i].id,
          SongHiveModel(
              id: information[i].id,
              displayNameWOExt: information[i].displayNameWOExt,
              artist: information[i].artist,
              uri: information[i].uri));
    }
    setState(() {

    });
  }

  void getname() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPrefs.getString("name") ?? "Guest";
    });
  }
}

class UserImageAndName extends StatelessWidget {
  const UserImageAndName({
    super.key,
    required this.name,
  });

  final String name;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 30,
              child: Image.asset(
                "assets/images/profile.png",
                fit: BoxFit.cover,
                width: 60,
                height: 60,
              ),
            ),
            sw15,
            Text.rich(
              TextSpan(
                text: "Hi There,\n",
                style: const TextStyle(
                    color: textPink, fontWeight: FontWeight.bold, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(
                    text: name,
                    style: const TextStyle(
                        color: foreground,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 18,
          left: 30,
          child: IconButton(
            onPressed: () {},
            icon: const Icon(Icons.camera_alt_outlined),
            color: foreground,
          ),
        ),
      ],
    );
  }
}
