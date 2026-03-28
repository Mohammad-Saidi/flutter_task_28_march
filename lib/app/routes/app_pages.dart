import 'package:get/get.dart';

import '../modules/character_list/bindings/character_list_binding.dart';
import '../modules/character_list/views/character_list_view.dart';
import '../modules/character_detail/bindings/character_detail_binding.dart';
import '../modules/character_detail/views/character_detail_view.dart';
import '../modules/favorites/bindings/favorites_binding.dart';
import '../modules/favorites/views/favorites_view.dart';
import '../modules/edit_character/bindings/edit_character_binding.dart';
import '../modules/edit_character/views/edit_character_view.dart';
import 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.characterList;

  static final routes = [
    GetPage(
      name: Routes.characterList,
      page: () => const CharacterListView(),
      binding: CharacterListBinding(),
    ),
    GetPage(
      name: Routes.characterDetail,
      page: () => const CharacterDetailView(),
      binding: CharacterDetailBinding(),
    ),
    GetPage(
      name: Routes.favorites,
      page: () => const FavoritesView(),
      binding: FavoritesBinding(),
    ),
    GetPage(
      name: Routes.editCharacter,
      page: () => const EditCharacterView(),
      binding: EditCharacterBinding(),
    ),
  ];
}
