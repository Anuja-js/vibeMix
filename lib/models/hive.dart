
import 'package:hive_flutter/hive_flutter.dart';

part 'hive.g.dart';

// Define the SongModel class
@HiveType(typeId: 0)
class SongHiveModel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String displayNameWOExt;

  @HiveField(2)
  final String? artist;

  @HiveField(3)
  final String? uri;

  SongHiveModel({
    required this.id,
    required this.displayNameWOExt,
    required this.artist,
    required this.uri,
  });
}