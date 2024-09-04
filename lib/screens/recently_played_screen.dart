import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
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
  @override
  void initState() {
    getRecentMusic();
    super.initState();
  }
  getRecentMusic() async {
    recent = await HiveService.getRecentData();
    recentList.addAll(recent!.values);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(backButton: true, body: Padding(
      padding: const EdgeInsets.symmetric(vertical: 15,horizontal: 18),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextCustom(text: "One Hour Later",size: 18,),
          ListView.builder(
              shrinkWrap: true,
              itemCount: recentList.length,
              itemBuilder: (ctx,index){
            return ListTile(title: TextCustom(text:recentList[index].song.displayNameWOExt) ,);
          })
        ],
      ),
    ), appBar: true,tittle: "Recently Played",);
  }
}
