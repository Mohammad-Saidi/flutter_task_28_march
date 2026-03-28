import 'package:hive/hive.dart';

part 'character_override.g.dart';

/// Stores local user edits for a character.
/// All fields are nullable — only set fields override the API data.
/// Hive typeId=1 for the auto-generated adapter.
@HiveType(typeId: 1)
class CharacterOverride extends HiveObject {
  @HiveField(0)
  final String? name;

  @HiveField(1)
  final String? status;

  @HiveField(2)
  final String? species;

  @HiveField(3)
  final String? type;

  @HiveField(4)
  final String? gender;

  @HiveField(5)
  final String? originName;

  @HiveField(6)
  final String? locationName;

  CharacterOverride({
    this.name,
    this.status,
    this.species,
    this.type,
    this.gender,
    this.originName,
    this.locationName,
  });

  CharacterOverride copyWith({
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? originName,
    String? locationName,
  }) {
    return CharacterOverride(
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      originName: originName ?? this.originName,
      locationName: locationName ?? this.locationName,
    );
  }
}
