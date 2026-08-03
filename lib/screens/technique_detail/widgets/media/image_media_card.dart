import 'package:flutter/material.dart';
import '../../../../core/media/media_label_resolver.dart';
import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_media_item.dart';

class ImageMediaCard extends StatelessWidget {
  final TechniqueMediaItem item;
  final VoidCallback onTap;

  const ImageMediaCard({super.key, required this.item, required this.onTap});

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
              ClipRRect(
                borderRadius: BorderRadius.circular(JudoRadius.md),
                child: SizedBox(
                  width: 110,
                  height: 78,
                  child: Image.asset(
                    item.mediaUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(
                        Icons.sports_martial_arts,
                        color: JudoColors.gold,
                      );
                    },
                  ),
                ),
              ),

              const SizedBox(width: JudoSpacing.md),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
  MediaLabelResolver.title(item),

  maxLines: 1,

  overflow: TextOverflow.ellipsis,

  style: JudoTypography.titleSmall,
),

const SizedBox(
  height: JudoSpacing.xs,
),

Text(
  MediaLabelResolver.category(item),

  style: JudoTypography.bodySmall.copyWith(
    color: JudoColors.primary,
  ),
),

const SizedBox(
  height: JudoSpacing.xs,
),

Row(
  children: [

    if (item.isVerified)
      const Icon(
        Icons.verified,
        size: 15,
        color: JudoColors.gold,
      ),

    if (item.isVerified)
      const SizedBox(
        width: 5,
      ),

    Text(
      item.level,
      style: JudoTypography.labelSmall,
    ),
  ],
),
                  ],
                ),
              ),

              const Icon(
                Icons.zoom_in_rounded,
                color: JudoColors.primary,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
