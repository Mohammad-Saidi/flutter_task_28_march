import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_task_28_march/app/data/models/character_model.dart';
import 'package:flutter_task_28_march/app/data/models/character_override.dart';
import 'package:flutter_task_28_march/app/data/repositories/character_repository.dart';

// Helper to create a base character for tests
CharacterModel _baseCharacter() => CharacterModel(
      id: 1,
      name: 'Rick Sanchez',
      status: 'Alive',
      species: 'Human',
      type: '',
      gender: 'Male',
      originName: 'Earth (C-137)',
      locationName: 'Citadel of Ricks',
      imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
      url: 'https://rickandmortyapi.com/api/character/1',
    );

void main() {
  group('mergeCharacter()', () {
    test('returns apiData unchanged when localEdit is null', () {
      final api = _baseCharacter();
      final result = mergeCharacter(api, null);

      expect(result.id, equals(api.id));
      expect(result.name, equals(api.name));
      expect(result.status, equals(api.status));
      expect(result.species, equals(api.species));
      expect(result.gender, equals(api.gender));
      expect(result.originName, equals(api.originName));
      expect(result.locationName, equals(api.locationName));
    });

    test('applies all override fields when all are set', () {
      final api = _baseCharacter();
      final override = CharacterOverride(
        name: 'Evil Rick',
        status: 'Dead',
        species: 'Robot',
        type: 'Genetic Experiment',
        gender: 'Unknown',
        originName: 'Dimension C-500A',
        locationName: 'Unknown',
      );

      final result = mergeCharacter(api, override);

      expect(result.name, equals('Evil Rick'));
      expect(result.status, equals('Dead'));
      expect(result.species, equals('Robot'));
      expect(result.type, equals('Genetic Experiment'));
      expect(result.gender, equals('Unknown'));
      expect(result.originName, equals('Dimension C-500A'));
      expect(result.locationName, equals('Unknown'));
    });

    test('applies only non-null override fields, leaving others from API', () {
      final api = _baseCharacter();
      final override = CharacterOverride(
        name: 'Pickle Rick',
        // All other fields null — should fall back to API values
      );

      final result = mergeCharacter(api, override);

      expect(result.name, equals('Pickle Rick')); // overridden
      expect(result.status, equals(api.status)); // from API
      expect(result.species, equals(api.species)); // from API
      expect(result.gender, equals(api.gender)); // from API
      expect(result.originName, equals(api.originName)); // from API
      expect(result.locationName, equals(api.locationName)); // from API
    });

    test('original apiData object is not mutated', () {
      final api = _baseCharacter();
      final override = CharacterOverride(name: 'Mutant Rick');

      mergeCharacter(api, override);

      // The original should remain unchanged
      expect(api.name, equals('Rick Sanchez'));
    });

    test('empty override (all nulls) returns api data unchanged', () {
      final api = _baseCharacter();
      final override = CharacterOverride(); // all null

      final result = mergeCharacter(api, override);

      expect(result.name, equals(api.name));
      expect(result.status, equals(api.status));
    });
  });
}
