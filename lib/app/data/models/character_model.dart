import 'package:hive/hive.dart';

part 'character_model.g.dart';

/// Model representing a Rick and Morty character.
/// Hive typeId=0 for the auto-generated adapter.
@HiveType(typeId: 0)
class CharacterModel extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String status;

  @HiveField(3)
  final String species;

  @HiveField(4)
  final String type;

  @HiveField(5)
  final String gender;

  @HiveField(6)
  final String originName;

  @HiveField(7)
  final String locationName;

  @HiveField(8)
  final String imageUrl;

  @HiveField(9)
  final String url;

  CharacterModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.originName,
    required this.locationName,
    required this.imageUrl,
    required this.url,
  });

  factory CharacterModel.fromJson(Map<String, dynamic> json) {
    return CharacterModel(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      status: json['status'] as String? ?? 'unknown',
      species: json['species'] as String? ?? '',
      // Empty type from API should be displayed as "N/A"
      type: (json['type'] as String?)?.isEmpty ?? true
          ? ''
          : json['type'] as String,
      gender: json['gender'] as String? ?? 'unknown',
      originName: (json['origin'] as Map<String, dynamic>?)?['name'] as String? ?? 'unknown',
      locationName: (json['location'] as Map<String, dynamic>?)?['name'] as String? ?? 'unknown',
      imageUrl: json['image'] as String? ?? '',
      url: json['url'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'status': status,
      'species': species,
      'type': type,
      'gender': gender,
      'origin': {'name': originName},
      'location': {'name': locationName},
      'image': imageUrl,
      'url': url,
    };
  }

  CharacterModel copyWith({
    int? id,
    String? name,
    String? status,
    String? species,
    String? type,
    String? gender,
    String? originName,
    String? locationName,
    String? imageUrl,
    String? url,
  }) {
    return CharacterModel(
      id: id ?? this.id,
      name: name ?? this.name,
      status: status ?? this.status,
      species: species ?? this.species,
      type: type ?? this.type,
      gender: gender ?? this.gender,
      originName: originName ?? this.originName,
      locationName: locationName ?? this.locationName,
      imageUrl: imageUrl ?? this.imageUrl,
      url: url ?? this.url,
    );
  }

  @override
  String toString() => 'CharacterModel(id: $id, name: $name)';
}
