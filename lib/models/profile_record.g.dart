// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_record.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProfileRecordAdapter extends TypeAdapter<ProfileRecord> {
  @override
  final int typeId = 2;

  @override
  ProfileRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProfileRecord(
      id: fields[0] as String,
      heightCm: fields[1] as double,
      weightKg: fields[2] as double,
      date: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, ProfileRecord obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.heightCm)
      ..writeByte(2)
      ..write(obj.weightKg)
      ..writeByte(3)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
