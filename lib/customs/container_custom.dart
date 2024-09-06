import 'package:flutter/material.dart';
import 'package:vibemix/customs/text_custom.dart';
import '../../global.dart';
import '../screens/search_music.dart';
class ContainerForSearch extends StatelessWidget {
  const ContainerForSearch({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: textPink,
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
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
          text: "Search for anything ...",
        ),
        trailing:  Icon(
          Icons.search,
          color: background,
          size: 20,
        ),
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (ctx) {
            return const SearchMusic();
          }));
        },
      ),
    );
  }
}