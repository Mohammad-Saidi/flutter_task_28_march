import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../../../data/models/character_model.dart';
import '../../../data/repositories/character_repository.dart';
import '../../../data/providers/api_provider.dart';

class CharacterListController extends GetxController {
  final CharacterRepository repository;

  CharacterListController({required this.repository});

  // ─── State ───────────────────────────────────────────────────────────────
  final RxList<CharacterModel> characters = <CharacterModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isPaginating = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isOffline = false.obs;

  // Search & filter
  final RxString searchQuery = ''.obs;
  final RxString statusFilter = ''.obs; // '', 'Alive', 'Dead', 'Unknown'

  // Pagination
  final RxInt currentPage = 1.obs;
  final RxBool hasNextPage = true.obs;
  bool _isRateLimited = false;

  // Scroll controller for infinite scroll
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchCharacters();

    // Infinite scroll listener
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 200) {
        loadMore();
      }
    });
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  /// Initial load or reload after filter/search change.
  Future<void> fetchCharacters() async {
    isLoading.value = true;
    hasError.value = false;
    errorMessage.value = '';
    isOffline.value = false;
    currentPage.value = 1;
    hasNextPage.value = true;
    characters.clear();

    try {
      final result = await repository.getCharacters(
        page: 1,
        name: searchQuery.value,
        status: statusFilter.value,
      );
      // Apply merge (local overrides) before displaying
      characters.assignAll(result.map(repository.getMergedCharacter));
      hasNextPage.value = result.length == 20;
    } on DioException catch (e) {
      if (e.error is OfflineException ||
          e.type == DioExceptionType.connectionError) {
        isOffline.value = true;
        // characters list already empty — cache fallback already tried in repo
      } else if (e.response?.statusCode == 404) {
        // 404 means no characters found for the query
        hasError.value = false;
        hasNextPage.value = false;
        characters.clear();
      } else if (e.response?.statusCode == 429) {
        hasError.value = true;
        errorMessage.value = 'Too many requests. Please try again later.';
      } else {
        hasError.value = true;
        errorMessage.value = e.message ?? 'Something went wrong';
      }
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// Load next page. Skips if already paginating or no more pages.
  Future<void> loadMore() async {
    if (isPaginating.value || !hasNextPage.value || isLoading.value || _isRateLimited) return;

    isPaginating.value = true;
    final nextPage = currentPage.value + 1;

    try {
      final result = await repository.getCharacters(
        page: nextPage,
        name: searchQuery.value,
        status: statusFilter.value,
      );
      if (result.isEmpty) {
        hasNextPage.value = false;
      } else {
        characters.addAll(result.map(repository.getMergedCharacter));
        currentPage.value = nextPage;
        hasNextPage.value = result.length == 20;
      }
    } on DioException catch (e) {
      if (e.error is OfflineException ||
          e.type == DioExceptionType.connectionError) {
        // Silently stop pagination when offline
        hasNextPage.value = false;
      } else if (e.response?.statusCode == 404) {
        // 404 means we've reached the end of the pages
        hasNextPage.value = false;
      } else if (e.response?.statusCode == 429) {
        if (!_isRateLimited) {
          _isRateLimited = true;
          Get.snackbar(
            'Rate Limit',
            'Too many requests. Please pause and try again later.',
            snackPosition: SnackPosition.BOTTOM,
          );
          Future.delayed(const Duration(seconds: 5), () {
            _isRateLimited = false;
          });
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to load more characters',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } finally {
      isPaginating.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    fetchCharacters();
  }

  void applyStatusFilter(String status) {
    statusFilter.value = status == statusFilter.value ? '' : status;
    fetchCharacters();
  }

  void retry() => fetchCharacters();
}
