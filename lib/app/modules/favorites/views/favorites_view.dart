import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../controllers/favorites_controller.dart';
import '../../../data/models/character_model.dart';

class FavoritesView extends GetView<FavoritesController> {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: Obx(() {
        // Refresh whenever view is shown (handles removal side-effects)
        if (controller.favorites.isEmpty) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.favorite_border, size: 80, color: Colors.grey),
                SizedBox(height: 16),
                Text(
                  'No favorites yet.\nTap ❤ on a character to add them.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.favorites.length,
          itemBuilder: (context, index) {
            final character = controller.favorites[index];
            return _FavoriteTile(
              character: character,
              onTap: () async {
                await controller.navigateToDetail(character);
                // Refresh on return (user may have un-favorited from detail)
                controller.loadFavorites();
              },
            );
          },
        );
      }),
    );
  }
}

class _FavoriteTile extends StatelessWidget {
  const _FavoriteTile({required this.character, required this.onTap});
  final CharacterModel character;
  final VoidCallback onTap;

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
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
