import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:vibemix/customs/scaffold_custom.dart';

import '../Constants/colors.dart';
import '../customs/music_widget.dart';
import '../customs/text_custom.dart';
class MyMusic extends StatefulWidget {
  const MyMusic({Key? key}) : super(key: key);

  @override
  State<MyMusic> createState() => _MyMusicState();
}
final OnAudioQuery _audioQuery = OnAudioQuery();
class _MyMusicState extends State<MyMusic> {
  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "My Music", backButton: true, body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18,vertical: 15),
      child: Column(children: [

        Container(margin: EdgeInsets.symmetric(vertical: 25),
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: textPink,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Color(0x40e07373),
                  spreadRadius: 4,
                  blurRadius: 3,
                  offset: Offset(1, 3),
                ),
                BoxShadow(
                  color: Color(0x40e07373),
                  spreadRadius: 4,
                  blurRadius: 3,
                  offset: Offset(-1, -3),
                ),
              ],
            ),
            child: ListTile(
                title: TextCustom(
                    color: background,
                    size: 14,
                    fontWeight: FontWeight.bold,
                    text: "Search for anything ..."),
                trailing: Icon(
                  Icons.search,
                  color: background,
                  size: 20,
                ),
                onTap:() {


                }
            )

        ),
        FutureBuilder(
          future: _audioQuery.querySongs(
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true,
          ),
          builder: (BuildContext context, AsyncSnapshot<List<SongModel>> snapshot) {
            // Check if there's an error
            if (snapshot.hasError) {
              return Center(
                child: TextCustom(
                  color: foreground,
                  size: 20,
                  fontWeight: FontWeight.bold,
                  text: "Error: ${snapshot.error}",
                ),
              );
            }

            // Display loading indicator while the data is loading
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            // Check if data is available and is not empty
            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: TextCustom(
                  color: foreground,
                  size: 20,
                  fontWeight: FontWeight.bold,
                  text: "No Songs found",
                ),
              );
            }

            // Data present
            if (snapshot.hasData && snapshot.data!.isNotEmpty ){
              // return Container(child: Text(snapshot.data![1].displayNameWOExt.toString(),style: TextStyle(color: foreground),),);
              return  SizedBox(
                width: double.infinity,
              height: 600,
                child: ListView.builder(padding: EdgeInsets.only(bottom: 55),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return MusicWidget(
                      data: snapshot.data![index],
                    );
                  },
                ),
              );
            }
            return SizedBox();
          },
        )
      ],),
    ), appBar: true);
  }
}
