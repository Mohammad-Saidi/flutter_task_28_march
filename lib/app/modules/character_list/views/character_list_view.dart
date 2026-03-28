import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import '../controllers/character_list_controller.dart';
import '../../../data/models/character_model.dart';
import '../../../routes/app_routes.dart';

class CharacterListView extends GetView<CharacterListController> {
  const CharacterListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Favorites',
            onPressed: () => Get.toNamed(Routes.favorites),
          ),
        ],
      ),
      body: Column(
        children: [
          _SearchBar(controller: controller),
          _FilterChips(controller: controller),
          Expanded(child: _Body(controller: controller)),
        ],
      ),
    );
  }
}

// ─── Search Bar ─────────────────────────────────────────────────────────────

class _SearchBar extends StatefulWidget {
  const _SearchBar({required this.controller});
  final CharacterListController controller;

  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Search characters...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: Obx(
            () => widget.controller.searchQuery.value.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _textController.clear();
                      widget.controller.onSearchChanged('');
                    },
                  )
                : const SizedBox.shrink(),
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
        onChanged: widget.controller.onSearchChanged,
      ),
    );
  }
}

// ─── Filter Chips ────────────────────────────────────────────────────────────

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.controller});
  final CharacterListController controller;

  static const _statuses = ['Alive', 'Dead', 'Unknown'];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: _statuses.map((s) {
            final selected = controller.statusFilter.value.toLowerCase() ==
                s.toLowerCase();
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(s),
                selected: selected,
                onSelected: (_) => controller.applyStatusFilter(s),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ─── Body ────────────────────────────────────────────────────────────────────

class _Body extends StatelessWidget {
  const _Body({required this.controller});
  final CharacterListController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return _ShimmerList();
      }
      if (controller.hasError.value) {
        return _ErrorWidget(
          message: controller.errorMessage.value,
          onRetry: controller.retry,
        );
      }
      if (controller.isOffline.value && controller.characters.isEmpty) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.wifi_off, size: 64, color: Colors.grey),
              SizedBox(height: 16),
              Text('You are offline and no cache is available.',
                  textAlign: TextAlign.center),
            ],
          ),
        );
      }
      if (controller.characters.isEmpty) {
        return const Center(child: Text('No characters found.'));
      }

      return ListView.builder(
        controller: controller.scrollController,
        itemCount: controller.characters.length + 1,
        itemBuilder: (context, index) {
          if (index == controller.characters.length) {
            return Obx(() => controller.isPaginating.value
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : const SizedBox.shrink());
          }
          return _CharacterTile(character: controller.characters[index]);
        },
      );
    });
  }
}

// ─── Character Tile ──────────────────────────────────────────────────────────

class _CharacterTile extends StatelessWidget {
  const _CharacterTile({required this.character});
  final CharacterModel character;

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: CachedNetworkImageProvider(character.imageUrl),
          onBackgroundImageError: (_, __) {},
        ),
        title: Text(character.name,
            style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: _statusColor(character.status),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text('${character.status} — ${character.species}'),
          ],
        ),
        onTap: () => Get.toNamed(Routes.characterDetail, arguments: character),
      ),
    );
  }
}

// ─── Shimmer ─────────────────────────────────────────────────────────────────

class _ShimmerList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (_, __) => Card(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: ListTile(
            leading: const CircleAvatar(radius: 28, backgroundColor: Colors.white),
            title: Container(height: 14, color: Colors.white),
            subtitle: Container(height: 12, color: Colors.white),
          ),
        ),
      ),
    );
  }
}

// ─── Error Widget ─────────────────────────────────────────────────────────────

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}
