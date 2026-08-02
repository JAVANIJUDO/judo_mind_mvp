import '../../../../data/media/technique_media_registry.dart';
import '../../../../models/technique_media_item.dart';
import '../../../../models/technique_model.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Service: Technique Media Resolver
/// Version: 2.0.0
/// ----------------------------------------------------------------
///
/// Media source policy:
///
/// 1. Professional `mediaItems` are the only accepted video source.
/// 2. Legacy image paths may temporarily be converted to image items.
/// 3. Legacy video fields must never generate Media Library items.
/// 4. YouTube search-result links must never enter the UI.
/// 5. All 67 techniques will migrate gradually to controlled catalogs.
abstract final class TechniqueMediaResolver {
  const TechniqueMediaResolver._();

  /// Returns the approved media collection for a technique.
  static List<TechniqueMediaItem> resolve(
    TechniqueModel technique,
  ) {
   final catalogItems =
    TechniqueMediaRegistry.getMedia(
  technique.id,
);

if (catalogItems.isNotEmpty) {
  return List.unmodifiable(
    catalogItems,
  );
}
   
    final professionalItems = technique.mediaItems
        .where(_isApprovedProfessionalItem)
        .toList();

    if (professionalItems.isNotEmpty) {
      professionalItems.sort(_compareItems);

      return List.unmodifiable(
        professionalItems,
      );
    }

    // Temporary compatibility:
    // Only legacy images may enter the Media Library.
    // Legacy videos are intentionally ignored.
    return _resolveLegacyImages(
      technique,
    );
  }

  /// Returns the preferred visual item.
  static TechniqueMediaItem? primary(
    TechniqueModel technique,
  ) {
    final items = resolve(technique);

    if (items.isEmpty) {
      return null;
    }

    for (final item in items) {
      if (item.isFeatured && item.isImage) {
        return item;
      }
    }

    for (final item in items) {
      if (item.isVerified && item.isImage) {
        return item;
      }
    }

    for (final item in items) {
      if (item.isImage) {
        return item;
      }
    }

    for (final item in items) {
      if (item.isFeatured) {
        return item;
      }
    }

    return items.first;
  }

  /// Returns approved media items of one specific type.
  static List<TechniqueMediaItem> byType(
    TechniqueModel technique,
    TechniqueMediaType type,
  ) {
    final items = resolve(technique)
        .where(
          (item) => item.type == type,
        )
        .toList();

    items.sort(_compareItems);

    return List.unmodifiable(items);
  }

  /// Returns the total approved media count.
  static int count(
    TechniqueModel technique,
  ) {
    return resolve(technique).length;
  }

  /// Professional items must contain a usable direct resource.
  ///
  /// YouTube search pages and other search-result destinations
  /// are rejected before they reach the Media Library.
  static bool _isApprovedProfessionalItem(
    TechniqueMediaItem item,
  ) {
    if (!item.hasValidMedia) {
      return false;
    }

    return !_isRejectedSearchUrl(
      item.mediaUrl,
    );
  }

  /// Converts only legacy technique images.
  ///
  /// Legacy videos, trainingVideo and competitionVideo are
  /// deliberately excluded from this resolver.
  static List<TechniqueMediaItem> _resolveLegacyImages(
    TechniqueModel technique,
  ) {
    final items = <TechniqueMediaItem>[];

    for (
      var index = 0;
      index < technique.images.length;
      index++
    ) {
      final imageSource =
          technique.images[index].trim();

      if (imageSource.isEmpty) {
        continue;
      }

      items.add(
        TechniqueMediaItem(
          id: '${technique.id}-legacy-image-$index',
          title: index == 0
              ? 'Official Technique Image'
              : 'Technical Reference Image ${index + 1}',
          description:
              'Approved visual reference for studying ${technique.englishName}.',
          type: TechniqueMediaType.officialImage,
          sourceType:
              TechniqueMediaSourceType.judoMind,
          sourceName: 'Judo Mind Media Library',
          mediaUrl: imageSource,
          thumbnailUrl: imageSource,
          languageCode: 'en',
          level: technique.difficulty,
          isVerified: true,
          isFeatured: index == 0,
          sortOrder: index,
          tags: [
            technique.englishName,
            technique.category,
            technique.type,
            'technique image',
          ],
        ),
      );
    }

    items.sort(_compareItems);

    return List.unmodifiable(items);
  }

  static bool _isRejectedSearchUrl(
    String rawUrl,
  ) {
    final value = rawUrl.trim();

    if (value.isEmpty) {
      return true;
    }

    final uri = Uri.tryParse(value);

    if (uri == null) {
      return true;
    }

    final host = uri.host.toLowerCase();
    final path = uri.path.toLowerCase();

    final isYouTube =
        host.contains('youtube.com') ||
        host.contains('youtu.be');

    if (isYouTube &&
        (path.contains('/results') ||
            uri.queryParameters.containsKey(
              'search_query',
            ))) {
      return true;
    }

    return false;
  }

  static int _compareItems(
    TechniqueMediaItem first,
    TechniqueMediaItem second,
  ) {
    if (first.isFeatured != second.isFeatured) {
      return first.isFeatured ? -1 : 1;
    }

    if (first.isVerified != second.isVerified) {
      return first.isVerified ? -1 : 1;
    }

    return first.sortOrder.compareTo(
      second.sortOrder,
    );
  }
}