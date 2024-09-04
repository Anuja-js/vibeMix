// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RecentModelAdapter extends TypeAdapter<RecentModel> {
  @override
  final int typeId = 1;

  @override
  RecentModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecentModel(
      song: fields[0] as SongHiveModel,
      time: fields[1] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, RecentModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.song)
      ..writeByte(1)
      ..write(obj.time);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecentModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
