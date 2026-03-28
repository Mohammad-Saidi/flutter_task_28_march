import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/character_detail_controller.dart';
import '../../../routes/app_routes.dart';

class CharacterDetailView extends GetView<CharacterDetailController> {
  const CharacterDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.character.value.name)),
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                controller.isFavorite.value
                    ? Icons.favorite
                    : Icons.favorite_border,
                color: controller.isFavorite.value ? Colors.red : null,
              ),
              onPressed: controller.toggleFavorite,
              tooltip: controller.isFavorite.value
                  ? 'Remove from favorites'
                  : 'Add to favorites',
            ),
          ),
        ],
      ),
      body: Obx(() {
        final c = controller.character.value;
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Character image
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: c.imageUrl,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.person, size: 80),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    width: 200,
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 80),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Info fields
              _InfoCard(children: [
                _InfoRow(label: 'Status', value: c.status),
                _InfoRow(label: 'Species', value: c.species),
                _InfoRow(
                    label: 'Type',
                    value: c.type.isEmpty ? 'N/A' : c.type),
                _InfoRow(label: 'Gender', value: c.gender),
                _InfoRow(label: 'Origin', value: c.originName),
                _InfoRow(label: 'Location', value: c.locationName),
              ]),

              const SizedBox(height: 24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit Character'),
                      onPressed: () async {
                        await Get.toNamed(
                          Routes.editCharacter,
                          arguments: controller.rawCharacter,
                        );
                        // Refresh after returning from edit screen
                        controller.refreshCharacter();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: Icon(controller.isFavorite.value
                          ? Icons.favorite
                          : Icons.favorite_border),
                      label: Text(controller.isFavorite.value
                          ? 'Remove Favorite'
                          : 'Add Favorite'),
                      onPressed: controller.toggleFavorite,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(children: children),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(label,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Expanded(
            child:
                Text(value.isEmpty ? 'N/A' : value, overflow: TextOverflow.ellipsis),
          ),
        ],
      ),
    );
  }
}
