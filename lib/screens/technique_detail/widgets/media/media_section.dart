import '../media_card_factory.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/judo_design_tokens.dart';
import '../../../../core/theme/judo_typography.dart';
import '../../../../models/technique_media_item.dart';
import '../../../../models/technique_model.dart';

import 'technique_media_resolver.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Component: Technique Media Library
/// Design System: JMDS
/// Version: 3.0.0
/// ----------------------------------------------------------------
///
/// Final media-library rules:
///
/// - Every media item appears only once.
/// - There is no duplicated Featured card.
/// - Raw URLs are never displayed.
/// - Hosting platforms are not presented as product identity.
/// - Search-result URLs are rejected.
/// - Images, training, competition and analysis are grouped.
/// - Professional `mediaItems` are the main media source.
/// - Legacy video fields are ignored by the resolver.
class MediaSection extends StatelessWidget {
  final TechniqueModel technique;

  const MediaSection({
    super.key,
    required this.technique,
  });

  @override
  Widget build(BuildContext context) {
    final allItems = TechniqueMediaResolver.resolve(
      technique,
    );

    if (allItems.isEmpty) {
      return _EmptyMediaLibrary(
        techniqueName: technique.englishName,
      );
    }

    final officialItems = _itemsByTypes(
      allItems,
      const {
        TechniqueMediaType.officialImage,
        TechniqueMediaType.officialDemonstration,
      },
    );

    final trainingItems = _itemsByTypes(
      allItems,
      const {
        TechniqueMediaType.trainingVideo,
      },
    );

    final competitionItems = _itemsByTypes(
      allItems,
      const {
        TechniqueMediaType.competitionVideo,
        TechniqueMediaType.championExample,
      },
    );

    final topExecutionItems = _itemsByTypes(
      allItems,
      const {
        TechniqueMediaType.topExecution,
      },
    );

    final analysisItems = _itemsByTypes(
      allItems,
      const {
        TechniqueMediaType.slowMotion,
        TechniqueMediaType.animation,
        TechniqueMediaType.biomechanics,
        TechniqueMediaType.aiComparison,
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MediaLibraryIntro(
          techniqueName: technique.englishName,
        ),

        if (officialItems.isNotEmpty) ...[
          const SizedBox(
            height: JudoSpacing.xl,
          ),
          _MediaGroup(
            title: 'Official Media',
            subtitle:
                'Approved visual and technical references.',
            icon: Icons.verified_outlined,
            accentColor: JudoColors.primary,
            items: officialItems,
            onItemTap: (item) {
              _openMedia(
                context,
                item,
              );
            },
          ),
        ],

        if (trainingItems.isNotEmpty) ...[
          const SizedBox(
            height: JudoSpacing.xxl,
          ),
          _MediaGroup(
            title: 'Training',
            subtitle:
                'Selected demonstrations and practice material.',
            icon: Icons.sports_martial_arts_outlined,
            accentColor: JudoColors.success,
            items: trainingItems,
            onItemTap: (item) {
              _openMedia(
                context,
                item,
              );
            },
          ),
        ],

        if (competitionItems.isNotEmpty) ...[
          const SizedBox(
            height: JudoSpacing.xxl,
          ),
          _MediaGroup(
            title: 'Competition',
            subtitle:
                'Verified executions from competitive situations.',
            icon: Icons.emoji_events_outlined,
            accentColor: JudoColors.danger,
            items: competitionItems,
            onItemTap: (item) {
              _openMedia(
                context,
                item,
              );
            },
          ),
        ],

        if (topExecutionItems.isNotEmpty) ...[
          const SizedBox(
            height: JudoSpacing.xxl,
          ),
          _MediaGroup(
            title: 'Top Executions',
            subtitle:
                'Elite examples selected for technical study.',
            icon: Icons.workspace_premium_outlined,
            accentColor: JudoColors.gold,
            items: topExecutionItems,
            showRanking: true,
            onItemTap: (item) {
              _openMedia(
                context,
                item,
              );
            },
          ),
        ],

        if (analysisItems.isNotEmpty) ...[
          const SizedBox(
            height: JudoSpacing.xxl,
          ),
          _MediaGroup(
            title: 'Visual Analysis',
            subtitle:
                'Slow motion, biomechanics, animation and AI comparison.',
            icon: Icons.analytics_outlined,
            accentColor: JudoColors.primary,
            items: analysisItems,
            onItemTap: (item) {
              _openMedia(
                context,
                item,
              );
            },
          ),
        ],
      ],
    );
  }

  List<TechniqueMediaItem> _itemsByTypes(
    List<TechniqueMediaItem> items,
    Set<TechniqueMediaType> acceptedTypes,
  ) {
    final result = items
        .where(
          (item) => acceptedTypes.contains(
            item.type,
          ),
        )
        .toList();

    result.sort(
      (first, second) =>
          first.sortOrder.compareTo(
        second.sortOrder,
      ),
    );

    return List.unmodifiable(result);
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

    if (!_isValidHttpUri(uri)) {
      if (context.mounted) {
        _showMessage(
          context,
          'This media item does not have a valid link.',
        );
      }

      return;
    }

    if (_isRejectedSearchUrl(uri!)) {
      if (context.mounted) {
        _showMessage(
          context,
          'This media source has not yet been replaced with an approved direct video.',
        );
      }

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

  bool _isValidHttpUri(
    Uri? uri,
  ) {
    if (uri == null || !uri.hasScheme) {
      return false;
    }

    return uri.scheme == 'https' ||
        uri.scheme == 'http';
  }

  bool _isRejectedSearchUrl(
    Uri uri,
  ) {
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

class _MediaLibraryIntro extends StatelessWidget {
  final String techniqueName;

  const _MediaLibraryIntro({
    required this.techniqueName,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 4,
          height: 42,
          decoration: BoxDecoration(
            color: JudoColors.primary,
            borderRadius: BorderRadius.circular(
              JudoRadius.sm,
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
                '$techniqueName Media',
                style: JudoTypography.headingSmall,
              ),

              const SizedBox(
                height: JudoSpacing.xs,
              ),

              Text(
                'Official images, demonstrations, competition examples and technical analysis.',
                style: JudoTypography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MediaGroup extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<TechniqueMediaItem> items;
  final ValueChanged<TechniqueMediaItem>
      onItemTap;
  final bool showRanking;

  const _MediaGroup({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.items,
    required this.onItemTap,
    this.showRanking = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _MediaGroupHeader(
          title: title,
          subtitle: subtitle,
          icon: icon,
          accentColor: accentColor,
        ),

        const SizedBox(
          height: JudoSpacing.md,
        ),

        ...List.generate(
          items.length,
          (index) {
            final item = items[index];

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == items.length - 1
                    ? 0
                    : JudoSpacing.sm,
              ),
              child: MediaCardFactory.build(
  item: item,
  onTap: () {
    onItemTap(item);
  },
),
            );
          },
        ),
      ],
    );
  }
}

class _MediaGroupHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  const _MediaGroupHeader({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: accentColor,
          size: 22,
        ),

        const SizedBox(
          width: JudoSpacing.sm,
        ),

        Expanded(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                    JudoTypography.titleLarge.copyWith(
                  color: accentColor,
                ),
              ),

              const SizedBox(
                height: JudoSpacing.xs,
              ),

              Text(
                subtitle,
                style: JudoTypography.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}



class _MediaThumbnail extends StatelessWidget {
  final TechniqueMediaItem item;
  final Color accentColor;
  final int? ranking;

  const _MediaThumbnail({
    required this.item,
    required this.accentColor,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    final previewSource = _previewSource(
      item,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(
        JudoRadius.sm,
      ),
      child: SizedBox(
        width: 104,
        height: 72,
        child: Stack(
          fit: StackFit.expand,
          children: [
            _MediaPreviewImage(
              source: previewSource,
            ),

            if (!item.isImage)
              Container(
                color: Colors.black.withValues(
                  alpha: 0.18,
                ),
              ),

            if (!item.isImage)
              Center(
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(
                      alpha: 0.90,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

            if (ranking != null)
              PositionedDirectional(
                top: 5,
                start: 5,
                child: Container(
                  width: 25,
                  height: 25,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.82,
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: JudoColors.gold,
                    ),
                  ),
                  child: Text(
                    '$ranking',
                    style: JudoTypography.labelSmall
                        .copyWith(
                      color: JudoColors.gold,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),

            if (item.formattedDuration.isNotEmpty)
              PositionedDirectional(
                end: 5,
                bottom: 5,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 5,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(
                      alpha: 0.85,
                    ),
                    borderRadius:
                        BorderRadius.circular(5),
                  ),
                  child: Text(
                    item.formattedDuration,
                    style:
                        JudoTypography.labelSmall.copyWith(
                      color: Colors.white,
                      fontSize: 9,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _MediaItemInformation
    extends StatelessWidget {
  final TechniqueMediaItem item;
  final Color accentColor;

  const _MediaItemInformation({
    required this.item,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          item.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: JudoTypography.titleSmall,
        ),

        const SizedBox(
          height: JudoSpacing.xs,
        ),

        Row(
          children: [
            Expanded(
              child: Text(
                item.sourceName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    JudoTypography.bodySmall.copyWith(
                  color: accentColor,
                ),
              ),
            ),

            if (item.isVerified) ...[
              const SizedBox(
                width: JudoSpacing.xs,
              ),
              Icon(
                Icons.verified_rounded,
                color: accentColor,
                size: 15,
              ),
            ],
          ],
        ),

        if (_secondaryInformation(item).isNotEmpty) ...[
          const SizedBox(
            height: JudoSpacing.xs,
          ),
          Text(
            _secondaryInformation(item),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: JudoTypography.labelSmall.copyWith(
              color: JudoColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

class _TechniqueImageDialog
    extends StatelessWidget {
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
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style:
                              JudoTypography.titleLarge,
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
                    tooltip: 'Close',
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.close_rounded,
                      color:
                          JudoColors.textSecondary,
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
        size: 34,
      ),
    );
  }
}

class _EmptyMediaLibrary extends StatelessWidget {
  final String techniqueName;

  const _EmptyMediaLibrary({
    required this.techniqueName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(
        JudoSpacing.xl,
      ),
      decoration: BoxDecoration(
        color: JudoColors.surface,
        borderRadius: BorderRadius.circular(
          JudoRadius.lg,
        ),
        border: Border.all(
          color: JudoColors.primary.withValues(
            alpha: 0.18,
          ),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.video_library_outlined,
            color: JudoColors.textSecondary,
            size: 42,
          ),

          const SizedBox(
            height: JudoSpacing.md,
          ),

          Text(
            '$techniqueName Media Library',
            textAlign: TextAlign.center,
            style: JudoTypography.titleLarge,
          ),

          const SizedBox(
            height: JudoSpacing.xs,
          ),

          Text(
            'Approved media has not been added yet.',
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

String _secondaryInformation(
  TechniqueMediaItem item,
) {
  final parts = <String>[];

  if (item.athleteName?.trim().isNotEmpty ??
      false) {
    parts.add(item.athleteName!.trim());
  }

  if (item.competitionName?.trim().isNotEmpty ??
      false) {
    parts.add(item.competitionName!.trim());
  }

  if (item.competitionYear != null) {
    parts.add('${item.competitionYear}');
  }

  if (parts.isEmpty &&
      item.level.trim().isNotEmpty) {
    parts.add(item.level.trim());
  }

  return parts.join(' • ');
}