import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../models/technique_model.dart';
import '../../../../core/providers/favorite_provider.dart';


class HeroSection extends StatelessWidget {
  final TechniqueModel technique;
  final String title;

  const HeroSection({
    super.key,
    required this.technique,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Consumer<FavoriteProvider>(
          builder: (context, favoriteProvider, child) {
            final isFavorite =
                favoriteProvider.isFavorite(technique.id);

            return IconButton(
              splashRadius: 26,
              onPressed: () async {
                await favoriteProvider.toggleFavorite(
                  technique.id,
                );
              },
              icon: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  isFavorite
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_add_outlined,
                  key: ValueKey(isFavorite),
                  color: isFavorite
                      ? const Color(0xFFD4AF37)
                      : Colors.white,
                  size: 30,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}