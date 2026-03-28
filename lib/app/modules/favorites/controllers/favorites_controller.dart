import 'package:get/get.dart';

import '../../../data/models/character_model.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../routes/app_routes.dart';

class FavoritesController extends GetxController {
  final CharacterRepository repository;

  FavoritesController({required this.repository});

  final RxList<CharacterModel> favorites = <CharacterModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  void loadFavorites() {
    // Apply merges to favorites before displaying
    final raw = repository.getFavorites();
    favorites.assignAll(raw.map(repository.getMergedCharacter));
  }

  Future<dynamic> navigateToDetail(CharacterModel character) {
    return Get.toNamed(Routes.characterDetail, arguments: character)
        ?? Future.value();
  }
}
