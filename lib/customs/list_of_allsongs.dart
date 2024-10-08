import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/global.dart';

import '../models/hive.dart';
import 'music_widget.dart';

class ListOfMusic extends StatelessWidget {
  int? count;
  final Box<SongHiveModel>? songsBox;
  ListOfMusic({super.key, required this.songsBox, this.count});
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: count,
        padding: const EdgeInsets.only(bottom: 55),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return MusicWidget(
            data: songsBox!.getAt(index)!,
            color: foreground,
            backGroundColor: textPink,
            playlistName: 'songs',
          );
        });
  }
}
