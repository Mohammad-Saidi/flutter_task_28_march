import 'package:get/get.dart';

import '../../../data/models/character_model.dart';
import '../../../data/repositories/character_repository.dart';

class CharacterDetailController extends GetxController {
  final CharacterRepository repository;

  CharacterDetailController({required this.repository});

  // The character passed via navigation arguments (already merged in list)
  late final CharacterModel rawCharacter;
  final Rx<CharacterModel> character = CharacterModel(
    id: 0,
    name: '',
    status: '',
    species: '',
    type: '',
    gender: '',
    originName: '',
    locationName: '',
    imageUrl: '',
    url: '',
  ).obs;

  final RxBool isFavorite = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get the character passed from the list screen
    rawCharacter = Get.arguments as CharacterModel;
    // Apply latest overrides (in case edits happened since list loaded)
    character.value = repository.getMergedCharacter(rawCharacter);
    isFavorite.value = repository.isFavorite(rawCharacter.id);
  }

  /// Re-apply merge in case overrides changed (e.g. after returning from edit)
  void refreshCharacter() {
    character.value = repository.getMergedCharacter(rawCharacter);
    isFavorite.value = repository.isFavorite(rawCharacter.id);
  }

  Future<void> toggleFavorite() async {
    if (isFavorite.value) {
      await repository.removeFavorite(rawCharacter.id);
      Get.snackbar('Favorites', '${character.value.name} removed from favorites',
          snackPosition: SnackPosition.BOTTOM);
    } else {
      // Store the raw character in favorites (not the merged one)
      await repository.addFavorite(rawCharacter);
      Get.snackbar('Favorites', '${character.value.name} added to favorites',
          snackPosition: SnackPosition.BOTTOM);
    }
    isFavorite.value = !isFavorite.value;
  }
}
