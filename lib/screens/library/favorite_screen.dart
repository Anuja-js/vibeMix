import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/models/box.dart';
import '../../customs/global.dart';
import '../../models/audio_player_model.dart';
import '../../models/hive.dart';
import '../../utils/fav_notifier.dart';
import '../../utils/notifier.dart';

class FavoriteScreen extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const FavoriteScreen();

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  Box<SongHiveModel>? favsBox;
  final audio = AudioPlayerSingleton().audioPlayer;
  List<SongHiveModel> favourite = [];
  SongHiveModel? current;

  @override
  void initState() {

    FavNotifier().notifier.addListener(getHiveMusic);
    getHiveMusic();
    super.initState();

  }

  getHiveMusic() async {
    favourite = [];
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    setState(() {});
  }

@override
  void dispose() {
  FavNotifier().notifier.removeListener(getHiveMusic);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Favorites",floating: true,
      backButton: true,
      body: favourite.isNotEmpty
          ? ListView.builder(
              padding: const EdgeInsets.only(
                  bottom: 70, top: 20, left: 18, right: 18),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ScrollPhysics(),
              itemCount: favourite.length,
              itemBuilder: (context, index) {

                return MusicWidget(
                    data: favourite[index],
                    color: foreground,
                    playlistName: "fav",
                    backGroundColor: textPink);
              },
            )
          : Center(
              child: TextCustom(
              text: "No Favorites Added",
              color: foreground,
            )),
      appBar: true,
      action: false,
    );
  }
}
