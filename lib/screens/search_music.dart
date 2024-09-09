import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/text_custom.dart';
import 'package:vibemix/global.dart';
import 'package:vibemix/models/hive.dart';
import 'package:vibemix/models/box.dart';

class SearchMusic extends StatefulWidget {
  const SearchMusic({super.key});
  @override
  State<SearchMusic> createState() => _SearchMusicState();
}
class _SearchMusicState extends State<SearchMusic> {
  String searchQuery = "";
  List<SongHiveModel> allSongs = [];
  List<SongHiveModel> filteredSongs = [];
  List<String> recentSearches = [];

  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: background,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new_outlined,
            color: foreground,
            size: 20,
          ),
        ),
      ),
      body: Column(
        children: [
          SearchTextField(
            onPress: (value) {
              _filterSongs(value);
            },
          ),
          sh10,
          if (searchQuery.isNotEmpty && filteredSongs.isNotEmpty)
            FilteredSongs(filteredSongs: filteredSongs)
          else if (searchQuery.isNotEmpty && filteredSongs.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 5,
                  horizontal: MediaQuery.of(context).size.width / 3),
              child: TextCustom(
                text: "Song Not Found",
                color: foreground,
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: allSongs.length,
                itemBuilder: (context, index) {
                  return MusicWidget(
                    data: allSongs[index],
                    backGroundColor: textPink,
                    color: foreground,
                    playlistName: 'songs',
                  );
                },
              ),
            )
        ],
      ),
    );
  }

  Future<void> fetchSongs() async {
    final Box<SongHiveModel> songsBox = await HiveService.getSongsBox();
    allSongs = songsBox.values.toList();
    setState(() {});
  }

  void _filterSongs(String query) {
    setState(() {
      searchQuery = query;
      if (query.isNotEmpty) {
        // Filter songs based on the search query
        filteredSongs = allSongs
            .where((song) =>
                song.displayNameWOExt
                    .toLowerCase()
                    .contains(query.toLowerCase()) ||
                (song.artist?.toLowerCase().contains(query.toLowerCase()) ??
                    false))
            .toList();

        // Update recent searches
        if (!recentSearches.contains(query)) {
          recentSearches.add(query);
          if (recentSearches.length > 5) {
            recentSearches.removeAt(0);
          }
        }
      } else {
        // Clear the search results if query is empty
        filteredSongs.clear();
      }
    });
  }
}

class FilteredSongs extends StatelessWidget {
  const FilteredSongs({
    super.key,
    required this.filteredSongs,
  });

  final List<SongHiveModel> filteredSongs;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredSongs.length,
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
        ),
        itemBuilder: (context, index) {
          return MusicWidget(
            data: filteredSongs[index],
            backGroundColor: background,
            color: foreground,
            playlistName: 'songs',
          );
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class SearchTextField extends StatelessWidget {
  void Function(dynamic)? onPress;
  SearchTextField({super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onPress,
      style: TextStyle(
          color: foreground, fontSize: 15, fontWeight: FontWeight.normal),
      scrollPhysics: const NeverScrollableScrollPhysics(),
      decoration: InputDecoration(
        fillColor: background,
        filled: true,
        focusColor: background,
        suffixIconColor: foreground,
        labelText: 'Search for anything ...',
        floatingLabelStyle: TextStyle(
            color: foreground, fontSize: 14, fontWeight: FontWeight.bold),
        labelStyle: TextStyle(
            color: foreground, fontSize: 15, fontWeight: FontWeight.normal),
        suffixIcon: const Icon(
          Icons.search,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: foreground,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: foreground),
          borderRadius: BorderRadius.circular(15.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: foreground),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
