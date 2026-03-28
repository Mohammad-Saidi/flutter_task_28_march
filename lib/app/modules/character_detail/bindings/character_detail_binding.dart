import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../services/local_storage_service.dart';
import '../controllers/character_detail_controller.dart';

class CharacterDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CharacterDetailController>(
      () => CharacterDetailController(
        repository: CharacterRepository(
          apiProvider: ApiProvider(),
          storage: Get.find<LocalStorageService>(),
        ),
      ),
    );
  }
}
