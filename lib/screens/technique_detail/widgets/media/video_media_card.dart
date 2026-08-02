import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_media_item.dart';

class VideoMediaCard extends StatelessWidget {
  final TechniqueMediaItem item;
  final VoidCallback onTap;

  const VideoMediaCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(JudoRadius.lg),

        child: Ink(
          padding: const EdgeInsets.all(JudoSpacing.md),

          decoration: BoxDecoration(
            color: JudoColors.surface,

            borderRadius: BorderRadius.circular(JudoRadius.lg),

            border: Border.all(
              color: JudoColors.primary.withValues(alpha: 0.25),
            ),
          ),

          child: Row(
            children: [
              _VideoThumbnail(item: item),

              const SizedBox(width: JudoSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      item.title,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: JudoTypography.titleSmall,
                    ),

                    const SizedBox(height: JudoSpacing.xs),

                    Text(
                      item.sourceName,

                      maxLines: 1,

                      overflow: TextOverflow.ellipsis,

                      style: JudoTypography.bodySmall.copyWith(
                        color: JudoColors.primary,
                      ),
                    ),

                    const SizedBox(height: JudoSpacing.xs),

                    Row(
                      children: [
                        if (item.level.trim().isNotEmpty)
                          Text(item.level, style: JudoTypography.labelSmall),

                        if (item.formattedDuration.isNotEmpty) ...[
                          const SizedBox(width: JudoSpacing.sm),

                          Text(
                            item.formattedDuration,

                            style: JudoTypography.labelSmall.copyWith(
                              color: JudoColors.gold,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),

              const Icon(
                Icons.play_circle_outline_rounded,

                color: JudoColors.primary,

                size: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VideoThumbnail extends StatelessWidget {
  final TechniqueMediaItem item;

  const _VideoThumbnail({required this.item});

  @override
  Widget build(BuildContext context) {
    final image = item.thumbnailUrl.trim();

    return ClipRRect(
      borderRadius: BorderRadius.circular(JudoRadius.md),

      child: SizedBox(
        width: 110,

        height: 78,

        child: Stack(
          fit: StackFit.expand,

          children: [
            if (image.isNotEmpty)
              Image.network(
                image,

                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return _fallback();
                },
              )
            else
              _fallback(),

            Container(color: Colors.black.withValues(alpha: 0.25)),

            const Center(
              child: Icon(
                Icons.play_arrow_rounded,

                color: Colors.white,

                size: 38,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _fallback() {
    return Container(
      color: JudoColors.surfaceVariant,

      alignment: Alignment.center,

      child: const Icon(
        Icons.sports_martial_arts_rounded,

        color: JudoColors.gold,

        size: 32,
      ),
    );
  }
}
