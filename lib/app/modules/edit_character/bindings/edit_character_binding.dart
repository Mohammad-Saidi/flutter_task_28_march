import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../services/local_storage_service.dart';
import '../controllers/edit_character_controller.dart';

class EditCharacterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditCharacterController>(
      () => EditCharacterController(
        repository: CharacterRepository(
          apiProvider: ApiProvider(),
          storage: Get.find<LocalStorageService>(),
        ),
      ),
    );
  }
}
