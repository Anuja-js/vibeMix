import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/music_widget.dart';
import 'package:vibemix/customs/text_custom.dart';
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
      backgroundColor: textPink,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: textPink,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
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
          if (searchQuery.isNotEmpty && filteredSongs.isNotEmpty)
            Expanded(
              child: ListView.builder(
                itemCount: filteredSongs.length,
                itemBuilder: (context, index) {
                  return MusicWidget(
                    data: filteredSongs[index],
                    backGroundColor: background,
                  );
                },
              ),
            )
          else if (searchQuery.isNotEmpty && filteredSongs.isEmpty)
            Padding(
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height / 5,
                  horizontal: MediaQuery.of(context).size.width / 3),
              child: TextCustom(text: "Song Not Found"),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: allSongs.length,
                itemBuilder: (context, index) {
                  return MusicWidget(
                    data: allSongs[index],
                    backGroundColor: background,
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

// ignore: must_be_immutable
class SearchTextField extends StatelessWidget {
  void Function(dynamic)? onPress;
  SearchTextField({super.key, this.onPress});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onPress,
      scrollPhysics: const NeverScrollableScrollPhysics(),
      decoration: InputDecoration(
        fillColor: textPink,
        filled: true,
        focusColor: foreground,
        suffixIconColor: foreground,
        labelText: 'Search for anything ...',
        floatingLabelStyle: const TextStyle(
            color: foreground, fontSize: 14, fontWeight: FontWeight.bold),
        labelStyle: const TextStyle(
            color: foreground, fontSize: 15, fontWeight: FontWeight.normal),
        suffixIcon: const Icon(
          Icons.search,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: const BorderSide(
            color: foreground,
          ),
          borderRadius: BorderRadius.circular(15.0),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: foreground),
          borderRadius: BorderRadius.circular(15.0),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: UnderlineInputBorder(
          borderSide: const BorderSide(color: foreground),
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
    );
  }
}
