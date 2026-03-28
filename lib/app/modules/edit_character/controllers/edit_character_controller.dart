import 'package:get/get.dart';

import '../../../data/models/character_model.dart';
import '../../../data/models/character_override.dart';
import '../../../data/repositories/character_repository.dart';

class EditCharacterController extends GetxController {
  final CharacterRepository repository;

  EditCharacterController({required this.repository});

  late CharacterModel originalCharacter;

  // Text editing controllers (populated in onInit)
  final nameController = _TextObs('');
  final statusController = _TextObs('');
  final speciesController = _TextObs('');
  final typeController = _TextObs('');
  final genderController = _TextObs('');
  final originController = _TextObs('');
  final locationController = _TextObs('');

  final RxBool isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    originalCharacter = Get.arguments as CharacterModel;
    // Pre-fill with merged data (local overrides if any + API data)
    final merged = repository.getMergedCharacter(originalCharacter);
    nameController.value = merged.name;
    statusController.value = merged.status;
    speciesController.value = merged.species;
    typeController.value = merged.type;
    genderController.value = merged.gender;
    originController.value = merged.originName;
    locationController.value = merged.locationName;
  }

  Future<void> saveEdits() async {
    isSaving.value = true;
    try {
      final override = CharacterOverride(
        name: nameController.value,
        status: statusController.value,
        species: speciesController.value,
        type: typeController.value,
        gender: genderController.value,
        originName: originController.value,
        locationName: locationController.value,
      );
      await repository.saveOverride(originalCharacter.id, override);
      Get.snackbar(
        'Saved',
        'Character edits saved successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> resetToApiData() async {
    await repository.deleteOverride(originalCharacter.id);
    // Restore fields to original API values (no merge)
    nameController.value = originalCharacter.name;
    statusController.value = originalCharacter.status;
    speciesController.value = originalCharacter.species;
    typeController.value = originalCharacter.type;
    genderController.value = originalCharacter.gender;
    originController.value = originalCharacter.originName;
    locationController.value = originalCharacter.locationName;
    Get.snackbar(
      'Reset',
      'Local edits cleared. Showing original API data.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

/// Simple observable string wrapper for two-way binding with TextFormField.
class _TextObs {
  _TextObs(String initial) : value = initial;
  String value;
}
