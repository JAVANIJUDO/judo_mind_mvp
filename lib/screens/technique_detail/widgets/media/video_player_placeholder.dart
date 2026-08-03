import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_media_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Widget: Video Player Placeholder
/// Module: Technique Media Library
/// Version: 1.0.0
/// ----------------------------------------------------------------

class VideoPlayerPlaceholder extends StatelessWidget {
  final TechniqueMediaItem item;
  final VoidCallback? onPlayPressed;

  const VideoPlayerPlaceholder({
    super.key,
    required this.item,
    this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = item.thumbnailUrl.trim();

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _buildThumbnail(thumbnail),

            Container(
              color: Colors.black.withValues(
                alpha: 0.34,
              ),
            ),

            Positioned(
              top: JudoSpacing.sm,
              left: JudoSpacing.sm,
              child: _SourceBadge(
                sourceName: item.sourceName,
                isVerified: item.isVerified,
              ),
            ),

            Center(
              child: Semantics(
                button: true,
                label: 'Play video',
                child: InkWell(
                  onTap: onPlayPressed,
                  customBorder: const CircleBorder(),
                  child: Ink(
                    width: 78,
                    height: 78,
                    decoration: BoxDecoration(
                      color: JudoColors.primary.withValues(
                        alpha: 0.94,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.35,
                          ),
                          blurRadius: 18,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.play_arrow_rounded,
                      size: 52,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            Positioned(
              left: JudoSpacing.sm,
              right: JudoSpacing.sm,
              bottom: JudoSpacing.sm,
              child: _BottomOverlay(
                item: item,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String thumbnail) {
    if (thumbnail.isEmpty) {
      return _fallback();
    }

    final uri = Uri.tryParse(thumbnail);
    final isRemote =
        uri != null && (uri.scheme == 'http' || uri.scheme == 'https');

    if (isRemote) {
      return Image.network(
        thumbnail,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _fallback();
        },
      );
    }

    return Image.asset(
      thumbnail,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _fallback();
      },
    );
  }

  Widget _fallback() {
    return Container(
      color: JudoColors.surface,
      alignment: Alignment.center,
      child: const Icon(
        Icons.sports_martial_arts_rounded,
        color: JudoColors.gold,
        size: 72,
      ),
    );
  }
}

class _SourceBadge extends StatelessWidget {
  final String sourceName;
  final bool isVerified;

  const _SourceBadge({
    required this.sourceName,
    required this.isVerified,
  });

  @override
  Widget build(BuildContext context) {
    final label = sourceName.trim().isEmpty
        ? 'Judo Mind Media'
        : sourceName.trim();

    return Container(
      constraints: const BoxConstraints(
        maxWidth: 220,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: JudoSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.black.withValues(
          alpha: 0.68,
        ),
        borderRadius: BorderRadius.circular(
          JudoRadius.md,
        ),
        border: Border.all(
          color: isVerified
              ? JudoColors.success.withValues(alpha: 0.55)
              : Colors.white.withValues(alpha: 0.20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isVerified
                ? Icons.verified_rounded
                : Icons.video_library_outlined,
            size: 15,
            color: isVerified
                ? JudoColors.success
                : Colors.white70,
          ),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: JudoTypography.labelSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomOverlay extends StatelessWidget {
  final TechniqueMediaItem item;

  const _BottomOverlay({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final duration = item.formattedDuration;
    final level = item.level.trim();

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: JudoSpacing.sm,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: Colors.black.withValues(
              alpha: 0.72,
            ),
            borderRadius: BorderRadius.circular(
              JudoRadius.md,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.high_quality_rounded,
                size: 15,
                color: Colors.white,
              ),
              const SizedBox(width: 5),
              Text(
                'Ready',
                style: JudoTypography.labelSmall.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        if (level.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: JudoSpacing.sm,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.72,
              ),
              borderRadius: BorderRadius.circular(
                JudoRadius.md,
              ),
            ),
            child: Text(
              level,
              style: JudoTypography.labelSmall.copyWith(
                color: JudoColors.gold,
              ),
            ),
          ),

        if (level.isNotEmpty && duration.isNotEmpty)
          const SizedBox(width: JudoSpacing.sm),

        if (duration.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: JudoSpacing.sm,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withValues(
                alpha: 0.72,
              ),
              borderRadius: BorderRadius.circular(
                JudoRadius.md,
              ),
            ),
            child: Text(
              duration,
              style: JudoTypography.labelSmall.copyWith(
                color: Colors.white,
              ),
            ),
          ),
      ],
    );
  }
}