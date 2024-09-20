import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/customs/global.dart';
import 'package:vibemix/models/audio_player_model.dart';
import 'package:vibemix/models/recent.dart';

import '../../models/box.dart';

class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({super.key});

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  Box<RecentModel>? recent;
  List<RecentModel> recentList = [];
  List<RecentModel> lastSession = [];
  List<RecentModel> oneHourAgo = [];
  List<RecentModel> sixHoursAgo = [];
  List<RecentModel> twelveHoursAgo = [];
  List<RecentModel> yesterdayPlayed = [];
  @override
  void initState() {
    getRecentMusic();

    super.initState();
  }

  getRecentMusic() async {
    recent = await HiveService.getRecentData();
    recentList.addAll(recent!.values);
    sortSongs();
    setState(() {});
  }

  void sortSongs() {
    DateTime now = DateTime.now();

    for (var song in recentList) {
      Duration difference = now.difference(song.time);

      if (difference.inMinutes < 10) {
        lastSession.add(song);
      } else if (difference.inHours < 1) {
        oneHourAgo.add(song);
      } else if (difference.inHours < 6) {
        sixHoursAgo.add(song);
      } else if (difference.inHours < 12) {
        twelveHoursAgo.add(song);
      } else if (difference.inHours < 24) {
        yesterdayPlayed.add(song);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      backButton: true,
      floating: true,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 18),
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (lastSession.isNotEmpty)
                RecentCustom(
                  recentList: lastSession,
                  text: 'Last Session',
                ),
              if (oneHourAgo.isNotEmpty)
                RecentCustom(
                  recentList: oneHourAgo,
                  text: 'With in One Hour',
                ),
              if (sixHoursAgo.isNotEmpty)
                RecentCustom(
                  recentList: sixHoursAgo,
                  text: 'With in Six Hour',
                ),
              if (twelveHoursAgo.isNotEmpty)
                RecentCustom(
                  recentList: twelveHoursAgo,
                  text: 'With in 12 Hour',
                ),
              if (yesterdayPlayed.isNotEmpty)
                RecentCustom(
                  recentList: yesterdayPlayed,
                  text: 'Played Yesterday',
                ),
              AudioPlayerSingleton().currentSong == null
                  ? sh10
                  : const SizedBox(
                      height: 110,
                    )
            ],
          ),
        ),
      ),
      appBar: true,
      tittle: "Recently Played",
    );
  }
}

// ignore: must_be_immutable
class RecentCustom extends StatelessWidget {
  String text;
  List<RecentModel> recentList;
  RecentCustom({
    super.key,
    required this.text,
    required this.recentList,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(
          text: text,
          size: 18,
          color: foreground,
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: recentList.length,
            itemBuilder: (ctx, index) {
              return MusicWidget(
                data: recentList[index].song,
                color: foreground,
                backGroundColor: textPink,
                playlistName: 'recent',
              );
            })
      ],
    );
  }
}
