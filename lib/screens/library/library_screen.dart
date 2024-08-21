import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';
import 'package:vibemix/customs/text_custom.dart';
class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScaffoldCustom(tittle: "Library", backButton: false, body: Column(
      children: [
        ListTile(
          leading: Icon(Icons.music_note_outlined,size: 25,color: foreground,),
          title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Now Playing"),
        ),   ListTile(
          leading: Icon(Icons.playlist_add,size: 25,color: foreground,),
          title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Playlists"),
        ),   ListTile(
          leading: Icon(Icons.favorite_border_outlined,size: 25,color: foreground,),
          title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "Favorites"),
        ),   ListTile(
          leading: Icon(Icons.library_music_sharp,size: 25,color: foreground,),
          title: TextCustom(color: foreground, size: 18, fontWeight: FontWeight.normal, text: "My Music"),
        ),

      ],
    ),  appBar: true);
  }
}
