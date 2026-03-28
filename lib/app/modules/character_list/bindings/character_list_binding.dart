import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../services/local_storage_service.dart';
import '../controllers/character_list_controller.dart';

class CharacterListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CharacterListController>(
      () => CharacterListController(
        repository: CharacterRepository(
          apiProvider: ApiProvider(),
          storage: Get.find<LocalStorageService>(),
        ),
      ),
    );
  }
}
