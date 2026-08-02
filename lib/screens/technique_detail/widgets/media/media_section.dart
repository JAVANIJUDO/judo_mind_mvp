import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../core/widgets/judo_badge.dart';
import '../../../../core/widgets/judo_card.dart';
import '../../../../models/technique_media_item.dart';
import '../../../../models/technique_model.dart';

import 'technique_media_resolver.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Component: Professional Technique Media Library
/// Reference Technique: Uchi Mata
/// Version: 2.0.0
/// ----------------------------------------------------------------
///
/// Rules:
/// - Raw URLs must never be displayed as titles.
/// - YouTube search-result links must not be presented to users.
/// - Every media item must have a meaningful title and source.
/// - Professional media data is preferred.
/// - Legacy media is resolved through TechniqueMediaResolver.
/// ----------------------------------------------------------------

class MediaSection extends StatelessWidget {
  final TechniqueModel technique;

  const MediaSection({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final items = TechniqueMediaResolver.resolve(
      technique,
    );

    if (items.isEmpty) {
      return _EmptyMediaState(
        techniqueName: technique.englishName,
      );
    }

    final featured = _featuredItem(items);

    final officialItems = _filterByTypes(
      items,
      const {
        TechniqueMediaType.officialImage,
        TechniqueMediaType.officialDemonstration,
      },
      excludeId: featured?.id,
    );

    final trainingItems = _filterByTypes(
      items,
      const {
        TechniqueMediaType.trainingVideo,
      },
      excludeId: featured?.id,
    );

    final competitionItems = _filterByTypes(
      items,
      const {
        TechniqueMediaType.competitionVideo,
        TechniqueMediaType.championExample,
      },
      excludeId: featured?.id,
    );

    final analysisItems = _filterByTypes(
      items,
      const {
        TechniqueMediaType.slowMotion,
        TechniqueMediaType.animation,
        TechniqueMediaType.biomechanics,
        TechniqueMediaType.aiComparison,
      },
      excludeId: featured?.id,
    );

    final topExecutions = _filterByTypes(
      items,
      const {
        TechniqueMediaType.topExecution,
      },
      excludeId: featured?.id,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LibraryHeader(
          techniqueName: technique.englishName,
          mediaCount: items.length,
        ),

        if (featured != null) ...[
          const SizedBox(
            height: JudoSpacing.lg,
          ),

          _FeaturedMediaCard(
            item: featured,
            onTap: () {
              _openMedia(
                context,
                featured,
              );
            },
          ),
        ],

        if (officialItems.isNotEmpty)
          _MediaCollection(
            title: 'Official Demonstrations',
            subtitle:
                'Verified official images and technical demonstrations.',
            icon: Icons.verified_outlined,
            accentColor: JudoColors.primary,
            items: officialItems,
            onItemTap: (item) {
              _openMedia(context, item);
            },
          ),

        if (trainingItems.isNotEmpty)
          _MediaCollection(
            title: 'Training Videos',
            subtitle:
                'Selected learning and practice demonstrations.',
            icon: Icons.sports_martial_arts_outlined,
            accentColor: JudoColors.success,
            items: trainingItems,
            onItemTap: (item) {
              _openMedia(context, item);
            },
          ),

        if (competitionItems.isNotEmpty)
          _MediaCollection(
            title: 'Competition Examples',
            subtitle:
                'Verified executions from competitive situations.',
            icon: Icons.emoji_events_outlined,
            accentColor: JudoColors.danger,
            items: competitionItems,
            onItemTap: (item) {
              _openMedia(context, item);
            },
          ),

        if (topExecutions.isNotEmpty)
          _MediaCollection(
            title:
                'Top ${topExecutions.length} Executions',
            subtitle:
                'Ranked elite executions selected for technical study.',
            icon: Icons.workspace_premium_outlined,
            accentColor: JudoColors.gold,
            items: topExecutions,
            onItemTap: (item) {
              _openMedia(context, item);
            },
          ),

        if (analysisItems.isNotEmpty)
          _MediaCollection(
            title: 'Technical Visual Analysis',
            subtitle:
                'Slow motion, animation, biomechanics and AI comparison.',
            icon: Icons.analytics_outlined,
            accentColor: JudoColors.primary,
            items: analysisItems,
            onItemTap: (item) {
              _openMedia(context, item);
            },
          ),
      ],
    );
  }

  TechniqueMediaItem? _featuredItem(
    List<TechniqueMediaItem> items,
  ) {
    for (final item in items) {
      if (item.isFeatured) {
        return item;
      }
    }

    for (final item in items) {
      if (item.isVerified) {
        return item;
      }
    }

    return items.isEmpty ? null : items.first;
  }

  List<TechniqueMediaItem> _filterByTypes(
    List<TechniqueMediaItem> items,
    Set<TechniqueMediaType> types, {
    String? excludeId,
  }) {
    final result = items
        .where(
          (item) =>
              item.id != excludeId &&
              types.contains(item.type),
        )
        .toList();

    result.sort(
      (first, second) =>
          first.sortOrder.compareTo(
        second.sortOrder,
      ),
    );

    return result;
  }

  Future<void> _openMedia(
    BuildContext context,
    TechniqueMediaItem item,
  ) async {
    if (item.isImage) {
      await showDialog<void>(
        context: context,
        builder: (dialogContext) {
          return _TechniqueImageDialog(
            item: item,
          );
        },
      );

      return;
    }

    final rawUrl = item.mediaUrl.trim();
    final uri = Uri.tryParse(rawUrl);

    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'https' &&
            uri.scheme != 'http')) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'This media link is not valid.',
      );

      return;
    }

    if (_isYouTubeSearchUrl(uri)) {
      if (!context.mounted) {
        return;
      }

      _showMessage(
        context,
        'This item still uses a YouTube search link and must be replaced with one approved video.',
      );

      return;
    }

    final opened = await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    );

    if (!opened && context.mounted) {
      _showMessage(
        context,
        'The selected media could not be opened.',
      );
    }
  }

  bool _isYouTubeSearchUrl(Uri uri) {
    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    final isYouTube =
        host.contains('youtube.com') ||
        host.contains('youtu.be');

    return isYouTube &&
        (path.contains('/results') ||
            uri.queryParameters.containsKey(
              'search_query',
            ));
  }

  void _showMessage(
    BuildContext context,
    String message,
  ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }
}

class _LibraryHeader extends StatelessWidget {
  final String techniqueName;
  final int mediaCount;

  const _LibraryHeader({
    required this.techniqueName,
    required this.mediaCount,
  });

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      borderColor: JudoColors.primary.withValues(
        alpha: 0.35,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: JudoColors.primary.withValues(
                alpha: 0.14,
              ),
              borderRadius: BorderRadius.circular(
                JudoRadius.sm,
              ),
            ),
            child: const Icon(
              Icons.video_library_outlined,
              color: JudoColors.primary,
              size: JudoIconSize.md,
            ),
          ),

          const SizedBox(
            width: JudoSpacing.md,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  '$techniqueName Media Library',
                  style:
                      JudoTypography.headingSmall,
                ),

                const SizedBox(
                  height: JudoSpacing.xs,
                ),

                Text(
                  '$mediaCount selected media items',
                  style: JudoTypography.bodySmall,
                ),

                const SizedBox(
                  height: JudoSpacing.sm,
                ),

                Text(
                  'Only selected and categorized media should appear here. General search pages are rejected.',
                  style: JudoTypography.bodySmall
                      .copyWith(
                    color:
                        JudoColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedMediaCard extends StatelessWidget {
  final TechniqueMediaItem item;
  final VoidCallback onTap;

  const _FeaturedMediaCard({
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final previewSource =
        _previewSource(item);

    return Semantics(
      button: true,
      label: item.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            JudoRadius.lg,
          ),
          child: Ink(
            decoration: BoxDecoration(
              color: JudoColors.surface,
              borderRadius: BorderRadius.circular(
                JudoRadius.lg,
              ),
              border: Border.all(
                color: JudoColors.gold.withValues(
                  alpha: 0.45,
                ),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(
                JudoRadius.lg,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        _MediaPreviewImage(
                          source: previewSource,
                        ),

                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin:
                                  Alignment.topCenter,
                              end:
                                  Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Color(0x66000000),
                                Color(0xF2000000),
                              ],
                              stops: [
                                0.25,
                                0.65,
                                1,
                              ],
                            ),
                          ),
                        ),

                        PositionedDirectional(
                          top: JudoSpacing.md,
                          start: JudoSpacing.md,
                          child: Wrap(
                            spacing: JudoSpacing.sm,
                            children: [
                              const JudoBadge(
                                text: 'Featured',
                                type:
                                    JudoBadgeType.premium,
                              ),

                              if (item.isVerified)
                                const JudoBadge(
                                  text: 'Verified',
                                  type:
                                      JudoBadgeType.verified,
                                ),
                            ],
                          ),
                        ),

                        Positioned.fill(
                          child: Center(
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: JudoColors.primary,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black
                                        .withValues(
                                      alpha: 0.40,
                                    ),
                                    blurRadius: 14,
                                    offset:
                                        const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Icon(
                                item.isImage
                                    ? Icons
                                        .zoom_in_rounded
                                    : Icons
                                        .play_arrow_rounded,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                          ),
                        ),

                        PositionedDirectional(
                          start: JudoSpacing.lg,
                          end: JudoSpacing.lg,
                          bottom: JudoSpacing.lg,
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                maxLines: 2,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: JudoTypography
                                    .headingSmall
                                    .copyWith(
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(
                                height: JudoSpacing.xs,
                              ),

                              Text(
                                _sourceLine(item),
                                maxLines: 1,
                                overflow:
                                    TextOverflow.ellipsis,
                                style: JudoTypography
                                    .bodySmall
                                    .copyWith(
                                  color: JudoColors
                                      .textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MediaCollection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<TechniqueMediaItem> items;
  final ValueChanged<TechniqueMediaItem>
      onItemTap;

  const _MediaCollection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: JudoSpacing.xxl,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: accentColor.withValues(
                    alpha: 0.13,
                  ),
                  borderRadius:
                      BorderRadius.circular(
                    JudoRadius.sm,
                  ),
                ),
                child: Icon(
                  icon,
                  color: accentColor,
                  size: JudoIconSize.sm,
                ),
              ),

              const SizedBox(
                width: JudoSpacing.md,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: JudoTypography
                          .titleLarge
                          .copyWith(
                        color: accentColor,
                      ),
                    ),

                    const SizedBox(
                      height: JudoSpacing.xs,
                    ),

                    Text(
                      subtitle,
                      style:
                          JudoTypography.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(
            height: JudoSpacing.md,
          ),

          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(
                bottom: JudoSpacing.sm,
              ),
              child: _MediaItemCard(
                item: item,
                accentColor: accentColor,
                onTap: () {
                  onItemTap(item);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MediaItemCard extends StatelessWidget {
  final TechniqueMediaItem item;
  final Color accentColor;
  final VoidCallback onTap;

  const _MediaItemCard({
    required this.item,
    required this.accentColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final previewSource =
        _previewSource(item);

    return Semantics(
      button: true,
      label: item.title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(
            JudoRadius.lg,
          ),
          child: Ink(
            decoration: BoxDecoration(
              color: JudoColors.surface,
              borderRadius: BorderRadius.circular(
                JudoRadius.lg,
              ),
              border: Border.all(
                color: accentColor.withValues(
                  alpha: 0.28,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(
                JudoSpacing.sm,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(
                      JudoRadius.sm,
                    ),
                    child: SizedBox(
                      width: 112,
                      height: 76,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          _MediaPreviewImage(
                            source: previewSource,
                          ),

                          Container(
                            color: Colors.black
                                .withValues(
                              alpha: 0.16,
                            ),
                          ),

                          Center(
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration:
                                  BoxDecoration(
                                color: accentColor
                                    .withValues(
                                  alpha: 0.90,
                                ),
                                shape:
                                    BoxShape.circle,
                              ),
                              child: Icon(
                                item.isImage
                                    ? Icons
                                        .image_outlined
                                    : Icons
                                        .play_arrow_rounded,
                                color: Colors.white,
                                size: 19,
                              ),
                            ),
                          ),

                          if (item.formattedDuration
                              .isNotEmpty)
                            PositionedDirectional(
                              end: 5,
                              bottom: 5,
                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration:
                                    BoxDecoration(
                                  color:
                                      Colors.black87,
                                  borderRadius:
                                      BorderRadius
                                          .circular(5),
                                ),
                                child: Text(
                                  item
                                      .formattedDuration,
                                  style:
                                      JudoTypography
                                          .labelSmall
                                          .copyWith(
                                    color:
                                        Colors.white,
                                    fontSize: 9,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(
                    width: JudoSpacing.md,
                  ),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          maxLines: 2,
                          overflow:
                              TextOverflow.ellipsis,
                          style: JudoTypography
                              .titleSmall,
                        ),

                        const SizedBox(
                          height: JudoSpacing.xs,
                        ),

                        Text(
                          item.sourceName,
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: JudoTypography
                              .bodySmall
                              .copyWith(
                            color: accentColor,
                          ),
                        ),

                        const SizedBox(
                          height: JudoSpacing.xs,
                        ),

                        Wrap(
                          spacing: 6,
                          runSpacing: 5,
                          children: [
                            _CompactLabel(
                              text:
                                  item.mediaTypeLabel,
                              color: accentColor,
                            ),

                            if (item.isVerified)
                              const _CompactLabel(
                                text: 'Verified',
                                color:
                                    JudoColors.success,
                              ),

                            if (item.isPremium)
                              const _CompactLabel(
                                text: 'Premium',
                                color:
                                    JudoColors.gold,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    width: JudoSpacing.xs,
                  ),

                  const Icon(
                    Icons
                        .arrow_forward_ios_rounded,
                    color:
                        JudoColors.textSecondary,
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _CompactLabel({
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 7,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.11,
        ),
        borderRadius: BorderRadius.circular(
          JudoRadius.sm,
        ),
      ),
      child: Text(
        text,
        style: JudoTypography.labelSmall.copyWith(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _TechniqueImageDialog extends StatelessWidget {
  final TechniqueMediaItem item;

  const _TechniqueImageDialog({
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: JudoColors.background,
      insetPadding: const EdgeInsets.all(
        JudoSpacing.md,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AspectRatio(
              aspectRatio: 4 / 3,
              child: _MediaPreviewImage(
                source: item.mediaUrl,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(
                JudoSpacing.md,
              ),
              child: Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: JudoTypography
                              .titleLarge,
                        ),

                        const SizedBox(
                          height: JudoSpacing.xs,
                        ),

                        Text(
                          item.sourceName,
                          style:
                              JudoTypography.bodySmall,
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MediaPreviewImage extends StatelessWidget {
  final String? source;

  const _MediaPreviewImage({
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    final value = source?.trim() ?? '';

    if (value.isEmpty) {
      return const _MediaFallback();
    }

    final uri = Uri.tryParse(value);
    final isNetwork =
        uri != null &&
        (uri.scheme == 'http' ||
            uri.scheme == 'https');

    if (isNetwork) {
      return Image.network(
        value,
        fit: BoxFit.cover,
        errorBuilder: (
          context,
          error,
          stackTrace,
        ) {
          return const _MediaFallback();
        },
      );
    }

    return Image.asset(
      value,
      fit: BoxFit.cover,
      errorBuilder: (
        context,
        error,
        stackTrace,
      ) {
        return const _MediaFallback();
      },
    );
  }
}

class _MediaFallback extends StatelessWidget {
  const _MediaFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: JudoColors.surfaceVariant,
      alignment: Alignment.center,
      child: const Icon(
        Icons.sports_martial_arts_rounded,
        color: JudoColors.gold,
        size: 36,
      ),
    );
  }
}

class _EmptyMediaState extends StatelessWidget {
  final String techniqueName;

  const _EmptyMediaState({
    required this.techniqueName,
  });

  @override
  Widget build(BuildContext context) {
    return JudoCard(
      child: Column(
        children: [
          const Icon(
            Icons.video_library_outlined,
            color: JudoColors.textSecondary,
            size: 44,
          ),

          const SizedBox(
            height: JudoSpacing.md,
          ),

          Text(
            '$techniqueName media library',
            textAlign: TextAlign.center,
            style: JudoTypography.titleLarge,
          ),

          const SizedBox(
            height: JudoSpacing.xs,
          ),

          Text(
            'Verified media has not been added yet.',
            textAlign: TextAlign.center,
            style: JudoTypography.bodySmall,
          ),
        ],
      ),
    );
  }
}

String? _previewSource(
  TechniqueMediaItem item,
) {
  if (item.thumbnailUrl.trim().isNotEmpty) {
    return item.thumbnailUrl;
  }

  if (item.isImage &&
      item.mediaUrl.trim().isNotEmpty) {
    return item.mediaUrl;
  }

  return null;
}

String _sourceLine(
  TechniqueMediaItem item,
) {
  final parts = <String>[
    item.sourceName,
    item.mediaTypeLabel,
  ];

  if (item.formattedDuration.isNotEmpty) {
    parts.add(item.formattedDuration);
  }

  return parts.join(' • ');
}