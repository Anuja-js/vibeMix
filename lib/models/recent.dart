import 'package:hive/hive.dart';
import 'package:vibemix/models/hive.dart'; // Make sure this is your SongHiveModel
part 'recent.g.dart';

@HiveType(typeId: 1) // Assign a unique typeId
class RecentModel extends HiveObject {
  @HiveField(0)
  final SongHiveModel song;

  @HiveField(1)
  final DateTime time;

  RecentModel({required this.song, required this.time});
}
