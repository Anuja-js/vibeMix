import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/playlist/sections_play.dart';
import '../Constants/colors.dart';
import '../customs/scaffold_custom.dart';
import '../customs/text_custom.dart';
import 'create_playlist.dart';

class PlaylistScreen extends StatefulWidget {
  const PlaylistScreen({Key? key}) : super(key: key);

  @override
  State<PlaylistScreen> createState() => _PlaylistScreenState();
}

class _PlaylistScreenState extends State<PlaylistScreen> {
  List<String> playlistNames = [];

  @override
  void initState() {loadPlaylists();
    super.initState();

  }

  Future<void> loadPlaylists() async {
    // Open the Hive box that contains playlist names
    Box<String> playlistsBox = await Hive.openBox<String>('playlists');
    setState(() {
      playlistNames = playlistsBox.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(
      tittle: "Playlists",
      action: true,
      onpress: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (ctx) {
            return const CreatePlaylist();
          }),
        ).then((_) {
          loadPlaylists();
        });
      },
      actionIcon: Icon(
        Icons.add_circle_outline_outlined,
        size: 25,
        color: foreground,
      ),
      backButton: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: SingleChildScrollView(
            child: Column(mainAxisAlignment: MainAxisAlignment.start,
              children: [
                playlistNames.length==0?Text("No Playlist Available"):
                ListView.builder(
                    shrinkWrap: true,physics: NeverScrollableScrollPhysics(),
                    itemCount: playlistNames.length,
                    itemBuilder: (ctx,index){
                  return ListTile(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                        return SecssionsEach(name: playlistNames[index],);
                      }));
                    },
                    title:Text( playlistNames[index],style: TextStyle(color: foreground),),
                    trailing:  Icon(Icons.arrow_forward_ios_outlined,color: foreground,size: 18,),
                  );
                })
              ],
            )
          ),
        ),
      ),
      appBar: true,
    );
  }
}
