import '../../models/technique_media_item.dart';
import '../media/technique_media_registry.dart';
import 'media_repository.dart';

class LocalMediaRepository implements MediaRepository {
  const LocalMediaRepository();

  @override
  Future<List<TechniqueMediaItem>> getMediaForTechnique(
    String techniqueId,
  ) async {
    return TechniqueMediaRegistry.getMedia(
      techniqueId,
    );
  }

  @override
  Future<TechniqueMediaItem?> getMediaById(
    String mediaId,
  ) async {
    for (final catalog in _allCatalogs()) {
      for (final item in catalog) {
        if (item.id == mediaId) {
          return item;
        }
      }
    }

    return null;
  }

  @override
  Future<List<TechniqueMediaItem>> getVerifiedMedia(
    String techniqueId,
  ) async {
    final items = TechniqueMediaRegistry.getMedia(
      techniqueId,
    );

    return items
        .where(
          (item) => item.isVerified,
        )
        .toList(growable: false);
  }

  @override
  Future<List<TechniqueMediaItem>> getFeaturedMedia(
    String techniqueId,
  ) async {
    final items = TechniqueMediaRegistry.getMedia(
      techniqueId,
    );

    return items
        .where(
          (item) => item.isFeatured,
        )
        .toList(growable: false);
  }

  @override
  Future<List<TechniqueMediaItem>> getMediaByTypes(
    String techniqueId,
    Set<TechniqueMediaType> types,
  ) async {
    final items = TechniqueMediaRegistry.getMedia(
      techniqueId,
    );

    return items
        .where(
          (item) => types.contains(
            item.type,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<List<TechniqueMediaItem>> searchMedia(
    String query,
  ) async {
    final keyword = query.trim().toLowerCase();

    if (keyword.isEmpty) {
      return [];
    }

    final results = <TechniqueMediaItem>[];

    for (final catalog in _allCatalogs()) {
      for (final item in catalog) {
        final searchable = [
          item.title,
          item.sourceName,
          item.level,
        ].join(' ').toLowerCase();

        if (searchable.contains(keyword)) {
          results.add(item);
        }
      }
    }

    return results;
  }

  @override
Future<void> clearCache() async {
  // Local repository has no cache yet.
}

Iterable<List<TechniqueMediaItem>> _allCatalogs() sync* {
  yield* TechniqueMediaRegistry.allCatalogs;
}
}