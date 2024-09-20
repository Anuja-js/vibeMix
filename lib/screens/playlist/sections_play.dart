import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/models/hive.dart';

import '../../customs/music_widget.dart';
import '../../customs/text_custom.dart';
import '../../customs/global.dart';
import 'edit_playlist.dart';
class SecssionsEach extends StatefulWidget {
  String name;
   SecssionsEach({super.key,required this.name});

  @override
  State<SecssionsEach> createState() => _SecssionsEachState();
}

class _SecssionsEachState extends State<SecssionsEach> {
  Box<SongHiveModel>? playlist;
  List<SongHiveModel> playlistSongs = [];
  @override
  void initState() {
    getHiveMusic();
    super.initState();
  }
  getHiveMusic() async {
    playlist = await Hive.openBox(widget.name);
    playlistSongs.addAll(playlist!.values);
    setState(() {

    });
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
        tittle: widget.name,action:true ,
        actionIcon: IconButton(onPressed: (){
          Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
            return EditPlaylist(
              name:widget.name,
            );
          }));
        }, icon: Icon(Icons.edit,size: 25,color: foreground,),),

        backButton: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18,),
            child:Column(children: [
              if(playlistSongs.length==0 )
                TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Songs Not found"),
              ListView.builder(
                  itemCount: playlistSongs.length,

                  padding: const EdgeInsets.only(bottom: 55),shrinkWrap: true,physics: NeverScrollableScrollPhysics(),

                  itemBuilder: (context,index) {
                    return MusicWidget(data:playlist!.getAt(index)!, backGroundColor: textPink, color: foreground, playlistName: widget.name,);

                  }),

            ],)
          ),
        ),floating: true,
        appBar: true);
  }

}
