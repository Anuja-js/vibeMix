import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/models/box.dart';

import '../models/hive.dart';

class FavoriteScreen extends StatefulWidget {
   // ignore: use_key_in_widget_constructors
   const FavoriteScreen(

   ) ;

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}


class _FavoriteScreenState extends State<FavoriteScreen> {
  Box<SongHiveModel>? favsBox;
  List<SongHiveModel> favourite = [];

  @override
  void initState() {
    getHiveMusic();
    super.initState();
  }

  getHiveMusic() async {
    favsBox = await HiveService.getFavBox();
    favourite.addAll(favsBox!.values);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Favorites",
      backButton: false,
      body: ListView.builder(
        padding: const EdgeInsets.only(bottom: 55, top: 20),
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: const ScrollPhysics(),
        itemCount: favourite.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: QueryArtworkWidget(
              id: favourite[index].id,
              type: ArtworkType.AUDIO,
              nullArtworkWidget: const Icon(
                Icons.music_note,
                color: foreground,
                size: 30,
              ),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    favourite[index].displayNameWOExt,
                    style: const TextStyle(
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
                    favsBox = await HiveService.getFavBox();
                    favsBox!.delete(favourite[index].id);
                    favourite.removeAt(index);
                    setState(() {});
                  },
                  icon: const Icon(
                    Icons.close_rounded,
                    size: 24,
                    color: foreground,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // AudioPlayerSingleton().playSong(widget.data);
                  },
                  icon: const Icon(
                    Icons.play_circle_outline,
                    color: foreground,
                    size: 24,
                  ),
                ),
              ],
            ),
            subtitle: Text(
              favourite[index].artist.toString(),
              style: const TextStyle(
                fontSize: 13,
                color: foreground,
                fontWeight: FontWeight.w200,
              ),
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
            ),
            onTap: () {
              // Implement navigation to NowPlayingScreen if needed
            },
          );
        },
      ),
      appBar: true,
      actionIcon: const Icon(
        Icons.favorite_border_outlined,
        size: 25,
        color: iconFav,
      ),
      action: true,
    );
  }
}
