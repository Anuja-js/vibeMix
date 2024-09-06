import 'package:http/http.dart' as http;
import 'dart:convert';

import '../global.dart';

class LyricsNetwork {
  Future<String> getLyrics(String artist, String name) async {
    artist = artist.split('/').first.trim().replaceAll(' ', '-');
    name = name.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '-');

    final url = Uri.parse("$apiLyric$artist/$name");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final lyrics = jsonDecode(response.body);
        return lyrics['lyrics'] ?? "Lyrics not available";
      } else {
        print('Request failed with status: ${response.statusCode}.');
        return "No Lyrics Found";
      }
    } catch (e) {
      print('Error fetching lyrics: $e');
      return "No Lyrics Found";
    }
  }
}
