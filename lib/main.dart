import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/data/models/character_model.dart';
import 'app/data/models/character_override.dart';
import 'app/routes/app_pages.dart';
import 'app/services/local_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─── Hive setup ──────────────────────────────────────────────────────────
  await Hive.initFlutter();

  // Register generated TypeAdapters before opening any boxes
  Hive.registerAdapter(CharacterModelAdapter());     // typeId: 0
  Hive.registerAdapter(CharacterOverrideAdapter()); // typeId: 1

  // ─── Initialize services ─────────────────────────────────────────────────
  // LocalStorageService must be ready before any controller accesses Hive
  await Get.putAsync<LocalStorageService>(
    () => LocalStorageService().init(),
    permanent: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Rick & Morty Explorer',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.green,
        useMaterial3: true,
      ),
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
    );
  }
}
