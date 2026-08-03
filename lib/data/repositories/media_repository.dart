import '../../models/technique_media_item.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Repository Contract: Technique Media
/// Module: Media Library
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// This contract separates the UI layer from the source of media data.
///
/// Future implementations may load media from:
/// - Local Dart catalogs
/// - Local database
/// - Remote API
/// - Cloud storage
/// - Offline cache
/// ----------------------------------------------------------------

abstract class MediaRepository {
  /// Returns every available media item for one technique.
  Future<List<TechniqueMediaItem>> getMediaForTechnique(
    String techniqueId,
  );

  /// Returns one media item by its unique identifier.
  Future<TechniqueMediaItem?> getMediaById(
    String mediaId,
  );

  /// Returns verified media belonging to one technique.
  Future<List<TechniqueMediaItem>> getVerifiedMedia(
    String techniqueId,
  );

  /// Returns featured media belonging to one technique.
  Future<List<TechniqueMediaItem>> getFeaturedMedia(
    String techniqueId,
  );

  /// Returns media matching one or more media types.
  Future<List<TechniqueMediaItem>> getMediaByTypes(
    String techniqueId,
    Set<TechniqueMediaType> types,
  );

  /// Searches media titles, descriptions, sources and tags.
  Future<List<TechniqueMediaItem>> searchMedia(
    String query,
  );

  /// Clears any repository-level cached data.
  Future<void> clearCache();
}