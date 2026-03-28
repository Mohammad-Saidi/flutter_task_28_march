// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_override.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharacterOverrideAdapter extends TypeAdapter<CharacterOverride> {
  @override
  final int typeId = 1;

  @override
  CharacterOverride read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharacterOverride(
      name: fields[0] as String?,
      status: fields[1] as String?,
      species: fields[2] as String?,
      type: fields[3] as String?,
      gender: fields[4] as String?,
      originName: fields[5] as String?,
      locationName: fields[6] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, CharacterOverride obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.species)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.originName)
      ..writeByte(6)
      ..write(obj.locationName);
  }
}
