



import 'package:hive/hive.dart';
import 'package:vibemix/models/hive.dart';

class HiveService {
  static Box<SongHiveModel>? _songsBox;
  static Box<SongHiveModel>? _favBox;

  // Singleton pattern to ensure the box is only opened once
  static Future<Box<SongHiveModel>> getSongsBox() async {
    if (_songsBox == null || !_songsBox!.isOpen) {
      _songsBox = await Hive.openBox<SongHiveModel>('songs');
    }
    return _songsBox!;
  }
  static Future<Box<SongHiveModel>> getFavBox() async {
    if (_favBox == null || !_favBox!.isOpen) {
      _favBox = await Hive.openBox<SongHiveModel>('fav');
    }
    return _favBox!;
  }
}
