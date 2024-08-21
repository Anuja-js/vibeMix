import 'package:flutter/material.dart';
import 'package:vibemix/Constants/colors.dart';
import 'package:vibemix/customs/scaffold_custom.dart';

class SearchMusic extends StatefulWidget {
  const SearchMusic({Key? key}) : super(key: key);

  @override
  State<SearchMusic> createState() => _SearchMusicState();
}

class _SearchMusicState extends State<SearchMusic> {
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
            icon: Icon(
              Icons.arrow_back_ios_new_outlined,
              color: background,
              size: 20,
            )),
      ),
      body: Column(
        children: [
          TextFormField(
            scrollPhysics: const NeverScrollableScrollPhysics(),
            decoration: InputDecoration(
              fillColor: textPink,
              filled: true,
              focusColor: foreground,
              suffixIconColor: background,
              labelText: 'Search for anything ...',
              floatingLabelStyle: const TextStyle(
                  color: foreground, fontSize: 14, fontWeight: FontWeight.bold),
              labelStyle: const TextStyle(
                  color: background,
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
              suffixIcon: const Icon(
                Icons.search,
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: background,
                ),
                borderRadius: BorderRadius.circular(15.0),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: background),
                borderRadius: BorderRadius.circular(15.0),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.never,
              border: UnderlineInputBorder(
                borderSide: BorderSide(color: background),
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
