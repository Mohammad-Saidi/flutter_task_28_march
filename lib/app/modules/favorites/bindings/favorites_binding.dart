import 'package:get/get.dart';

import '../../../data/providers/api_provider.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../services/local_storage_service.dart';
import '../controllers/favorites_controller.dart';

class FavoritesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FavoritesController>(
      () => FavoritesController(
        repository: CharacterRepository(
          apiProvider: ApiProvider(),
          storage: Get.find<LocalStorageService>(),
        ),
      ),
    );
  }
}
