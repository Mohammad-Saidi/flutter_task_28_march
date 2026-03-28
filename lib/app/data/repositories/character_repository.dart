import 'package:dio/dio.dart';

import '../models/character_model.dart';
import '../models/character_override.dart';
import '../providers/api_provider.dart';
import '../../services/local_storage_service.dart';

/// Merges API character data with optional local overrides.
/// Only set fields in [localEdit] replace the API values.
CharacterModel mergeCharacter(
    CharacterModel apiData, CharacterOverride? localEdit) {
  if (localEdit == null) return apiData;
  return apiData.copyWith(
    name: localEdit.name ?? apiData.name,
    status: localEdit.status ?? apiData.status,
    species: localEdit.species ?? apiData.species,
    type: localEdit.type ?? apiData.type,
    gender: localEdit.gender ?? apiData.gender,
    originName: localEdit.originName ?? apiData.originName,
    locationName: localEdit.locationName ?? apiData.locationName,
  );
}

/// Repository that coordinates API calls with local Hive cache.
/// Falls back to cache when offline.
class CharacterRepository {
  final ApiProvider _apiProvider;
  final LocalStorageService _storage;

  CharacterRepository({
    required ApiProvider apiProvider,
    required LocalStorageService storage,
  })  : _apiProvider = apiProvider,
        _storage = storage;

  /// Fetch characters for [page], applying optional [name] and [status] filters.
  /// Returns raw API data (never stores merged data in the cache).
  /// Falls back to Hive cache on [OfflineException] or any connectivity error.
  Future<List<CharacterModel>> getCharacters({
    int page = 1,
    String? name,
    String? status,
  }) async {
    // When filtering by name or status, skip page cache — results are dynamic.
    final bool shouldCache = (name == null || name.isEmpty) &&
        (status == null || status.isEmpty);

    try {
      final data = await _apiProvider.getCharacters(
        page: page,
        name: name,
        status: status,
      );
      final results = (data['results'] as List<dynamic>)
          .map((e) => CharacterModel.fromJson(e as Map<String, dynamic>))
          .toList();

      if (shouldCache) {
        await _storage.cacheCharacters(page, results);
      }
      return results;
    } on DioException catch (e) {
      if (e.error is OfflineException || e.type == DioExceptionType.connectionError) {
        // Return cached data if available; otherwise rethrow.
        if (shouldCache) {
          final cached = _storage.getCachedCharacters(page);
          if (cached != null) return cached;
        }
        rethrow;
      }
      rethrow;
    }
  }

  /// Apply the merge to a character, overlaying any local override.
  CharacterModel getMergedCharacter(CharacterModel apiCharacter) {
    final override = _storage.getOverride(apiCharacter.id);
    return mergeCharacter(apiCharacter, override);
  }

  // ─── Favorites ───────────────────────────────────────────────────────────

  Future<void> addFavorite(CharacterModel character) =>
      _storage.addFavorite(character);

  Future<void> removeFavorite(int characterId) =>
      _storage.removeFavorite(characterId);

  bool isFavorite(int characterId) => _storage.isFavorite(characterId);

  List<CharacterModel> getFavorites() => _storage.getAllFavorites();

  // ─── Overrides ───────────────────────────────────────────────────────────

  Future<void> saveOverride(int characterId, CharacterOverride override) =>
      _storage.saveOverride(characterId, override);

  Future<void> deleteOverride(int characterId) =>
      _storage.deleteOverride(characterId);

  CharacterOverride? getOverride(int characterId) =>
      _storage.getOverride(characterId);
}
