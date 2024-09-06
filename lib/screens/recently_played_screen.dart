import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/global.dart';
import 'package:vibemix/models/recent.dart';

import '../models/box.dart';
class RecentlyPlayedScreen extends StatefulWidget {
  const RecentlyPlayedScreen({Key? key}) : super(key: key);

  @override
  State<RecentlyPlayedScreen> createState() => _RecentlyPlayedScreenState();
}

class _RecentlyPlayedScreenState extends State<RecentlyPlayedScreen> {
  Box<RecentModel>? recent;
  List<RecentModel> recentList=[];
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
    setState(() {

    });
  }
  void sortSongs() {
    DateTime now = DateTime.now();

    for (var song in recentList) {
      Duration difference = now.difference(song.time);

      if (difference.inMinutes < 5) {
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
    return ScaffoldCustom(backButton: true, body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 18),
      child: SingleChildScrollView(
        child: Column(
          children: [
         if (lastSession.isNotEmpty) RecentCustom(recentList: lastSession, text: 'Last Session',),
            if (oneHourAgo.isNotEmpty)   RecentCustom(recentList: oneHourAgo, text: 'One Hour Ago',),
            if (sixHoursAgo.isNotEmpty)  RecentCustom(recentList: sixHoursAgo, text: 'Six Hour Ago',),
            if (twelveHoursAgo.isNotEmpty) RecentCustom(recentList: twelveHoursAgo, text: '12 Hour Ago',),
            if (yesterdayPlayed.isNotEmpty)  RecentCustom(recentList: yesterdayPlayed, text: 'Played Yesterday',),
          ],
        ),
      ),
    ), appBar: true,tittle: "Recently Played",);
  }
}

class RecentCustom extends StatelessWidget {
  String text;
   List<RecentModel> recentList;
   RecentCustom({
    super.key,required this.text,
    required this.recentList,
  });


  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextCustom(text: text,size: 18, color: foreground,),
        ListView.builder(
            shrinkWrap: true,
            itemCount: recentList.length,
            itemBuilder: (ctx,index){
          return MusicWidget(data: recentList[index].song, color: foreground, backGroundColor: textPink,);
        })
      ],
    );
  }
}
