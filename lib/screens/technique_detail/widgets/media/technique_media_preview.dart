import 'package:flutter/material.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../models/technique_model.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Component: Technique Media Preview
/// Reference Technique: Uchi Mata
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Displays only the best primary visual on TechniqueDetailScreen.
///
/// The complete image and video library must open through:
/// - Videos dashboard card
/// - Explore Media action
///
/// This prevents duplicated media content on the main screen.
class TechniqueMediaPreview extends StatelessWidget {
  final TechniqueModel technique;
  final VoidCallback onExploreMedia;

  const TechniqueMediaPreview({
    super.key,
    required this.technique,
    required this.onExploreMedia,
  });

  @override
  Widget build(BuildContext context) {
    final imageSource = _primaryImageSource();
    final mediaCount = _calculateMediaCount();

    return Semantics(
      button: true,
      label:
          'Explore official media for ${technique.englishName}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onExploreMedia,
          borderRadius: BorderRadius.circular(
            JudoRadius.lg,
          ),
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: JudoColors.surface,
              borderRadius: BorderRadius.circular(
                JudoRadius.lg,
              ),
              border: Border.all(
                color: JudoColors.primary.withValues(
                  alpha: 0.40,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      _TechniquePreviewImage(
                        imageSource: imageSource,
                      ),

                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Color(0x99000000),
                              Color(0xF2000000),
                            ],
                            stops: [
                              0.25,
                              0.70,
                              1.00,
                            ],
                          ),
                        ),
                      ),

                      PositionedDirectional(
                        top: JudoSpacing.md,
                        start: JudoSpacing.md,
                        end: JudoSpacing.md,
                        child: Wrap(
                          spacing: JudoSpacing.sm,
                          runSpacing: JudoSpacing.sm,
                          children: [
                            const JudoBadge(
                              text: 'Official Media',
                              type: JudoBadgeType.official,
                            ),
                            if (technique.type.trim().isNotEmpty)
                              JudoBadge(
                                text: technique.type,
                                type: JudoBadgeType.success,
                                icon: Icons
                                    .sports_martial_arts_outlined,
                              ),
                          ],
                        ),
                      ),

                      PositionedDirectional(
                        start: JudoSpacing.lg,
                        end: JudoSpacing.lg,
                        bottom: JudoSpacing.lg,
                        child: Row(
                          crossAxisAlignment:
                              CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    technique.englishName,
                                    maxLines: 1,
                                    overflow:
                                        TextOverflow.ellipsis,
                                    style: JudoTypography
                                        .headingMedium
                                        .copyWith(
                                      color:
                                          JudoColors.textPrimary,
                                    ),
                                  ),

                                  const SizedBox(
                                    height: JudoSpacing.xs,
                                  ),

                                  Text(
                                    mediaCount > 0
                                        ? '$mediaCount media items available'
                                        : 'Official media library',
                                    style: JudoTypography.bodySmall
                                        .copyWith(
                                      color:
                                          JudoColors.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(
                              width: JudoSpacing.md,
                            ),

                            Container(
                              width: 42,
                              height: 42,
                              decoration: BoxDecoration(
                                color: JudoColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(
                                      alpha: 0.35,
                                    ),
                                    blurRadius: 12,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.play_arrow_rounded,
                                color: JudoColors.white,
                                size: JudoIconSize.md,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(
                    JudoSpacing.md,
                  ),
                  child: Row(
                    children: [
                      const Icon(
  Icons.video_library_outlined,
  color: JudoColors.primary,
  size: JudoIconSize.sm,
),

                      const SizedBox(
                        width: JudoSpacing.sm,
                      ),

                      Expanded(
                        child: Text(
                          'Explore images, training videos, competition examples and future animations.',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: JudoTypography.bodySmall,
                        ),
                      ),

                      const SizedBox(
                        width: JudoSpacing.sm,
                      ),

                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: JudoColors.textSecondary,
                        size: JudoIconSize.xs,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _primaryImageSource() {
    for (final image in technique.images) {
      if (image.trim().isNotEmpty) {
        return image.trim();
      }
    }

    return null;
  }

  int _calculateMediaCount() {
    var count = 0;

    count += technique.images
        .where((item) => item.trim().isNotEmpty)
        .length;

    count += technique.videos
        .where((item) => item.trim().isNotEmpty)
        .length;

    if (technique.trainingVideo.trim().isNotEmpty) {
      count++;
    }

    if (technique.competitionVideo.trim().isNotEmpty) {
      count++;
    }

    return count;
  }
}

class _TechniquePreviewImage extends StatelessWidget {
  final String? imageSource;

  const _TechniquePreviewImage({
    required this.imageSource,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSource == null) {
      return const _ImageFallback();
    }

    if (_isNetworkImage(imageSource!)) {
      return Image.network(
        imageSource!,
        fit: BoxFit.cover,
        alignment: Alignment.center,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return const _ImageFallback();
        },
      );
    }

    return Image.asset(
      imageSource!,
      fit: BoxFit.cover,
      alignment: Alignment.center,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return const _ImageFallback();
      },
    );
  }

  bool _isNetworkImage(String source) {
    final uri = Uri.tryParse(source);

    return uri != null &&
        (uri.scheme == 'http' ||
            uri.scheme == 'https');
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: JudoColors.surfaceVariant,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.sports_martial_arts_rounded,
            color: JudoColors.gold,
            size: 52,
          ),
          SizedBox(
            height: JudoSpacing.sm,
          ),
          Text(
            'Official technique image',
            style: JudoTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}