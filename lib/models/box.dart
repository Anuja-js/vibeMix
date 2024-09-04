



import 'package:hive/hive.dart';
import 'package:vibemix/models/hive.dart';
import 'package:vibemix/models/recent.dart';

class HiveService {
  static Box<SongHiveModel>? songsBox;
  static Box<SongHiveModel>? favBox;
  static Box<RecentModel>? recentBox;

  // Singleton pattern to ensure the box is only opened once
  static Future<Box<SongHiveModel>> getSongsBox() async {
    if (songsBox == null || !songsBox!.isOpen) {
      songsBox = await Hive.openBox<SongHiveModel>('songs');
    }
    return songsBox!;
  }
  static Future<Box<SongHiveModel>> getFavBox() async {
    if (favBox == null || !favBox!.isOpen) {
      favBox = await Hive.openBox<SongHiveModel>('fav');
    }
    return favBox!;
  }
  static Future<Box<RecentModel>>  getRecentData()async{
    if (recentBox == null || !recentBox!.isOpen) {
      recentBox = await Hive.openBox<RecentModel>('recent');
    }
    return recentBox!;
  }
}
