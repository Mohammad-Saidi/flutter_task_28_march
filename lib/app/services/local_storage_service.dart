import 'package:hive_flutter/hive_flutter.dart';
import 'package:get/get.dart';

import '../data/models/character_model.dart';
import '../data/models/character_override.dart';

/// Service wrapping all Hive box operations.
/// Injected via Get.putAsync() in main.dart.
class LocalStorageService extends GetxService {
  static const String _charactersBox = 'characters';
  static const String _favoritesBox = 'favorites';
  static const String _overridesBox = 'overrides';

  late final Box<dynamic> _characters;
  late final Box<CharacterModel> _favorites;
  late final Box<CharacterOverride> _overrides;

  Future<LocalStorageService> init() async {
    _characters = await Hive.openBox<dynamic>(_charactersBox);
    _favorites = await Hive.openBox<CharacterModel>(_favoritesBox);
    _overrides = await Hive.openBox<CharacterOverride>(_overridesBox);
    return this;
  }

  // ─── Characters cache ────────────────────────────────────────────────────

  /// Cache raw API characters for a given page.
  Future<void> cacheCharacters(int page, List<CharacterModel> characters) async {
    await _characters.put('page_$page', characters);
  }

  /// Retrieve cached characters for a given page. Returns null if not found.
  List<CharacterModel>? getCachedCharacters(int page) {
    final dynamic data = _characters.get('page_$page');
    if (data == null) return null;
    return List<CharacterModel>.from(data as List);
  }

  // ─── Favorites ──────────────────────────────────────────────────────────

  Future<void> addFavorite(CharacterModel character) async {
    await _favorites.put(character.id, character);
  }

  Future<void> removeFavorite(int characterId) async {
    await _favorites.delete(characterId);
  }

  bool isFavorite(int characterId) {
    return _favorites.containsKey(characterId);
  }

  List<CharacterModel> getAllFavorites() {
    return _favorites.values.toList();
  }

  // ─── Overrides ──────────────────────────────────────────────────────────

  Future<void> saveOverride(int characterId, CharacterOverride override) async {
    await _overrides.put(characterId, override);
  }

  Future<void> deleteOverride(int characterId) async {
    await _overrides.delete(characterId);
  }

  CharacterOverride? getOverride(int characterId) {
    return _overrides.get(characterId);
  }
}
