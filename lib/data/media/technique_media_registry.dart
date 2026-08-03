import '../../models/technique_media_item.dart';
import 'uchi_mata_media_catalog.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Media Registry
/// Version: 1.1.0
/// ----------------------------------------------------------------
///
/// Central access point for all technique media catalogs.
///
/// Future catalogs:
/// - seoi_nage_media_catalog.dart
/// - o_soto_gari_media_catalog.dart
/// - harai_goshi_media_catalog.dart
///
/// All 67 techniques will eventually be registered here.
abstract final class TechniqueMediaRegistry {
  const TechniqueMediaRegistry._();

  static final Map<String, List<TechniqueMediaItem>> _catalogs = {
    '001': UchiMataMediaCatalog.items,
  };

  /// Returns an immutable list of media belonging to one technique.
  static List<TechniqueMediaItem> getMedia(
    String techniqueId,
  ) {
    return List<TechniqueMediaItem>.unmodifiable(
      _catalogs[techniqueId] ?? const <TechniqueMediaItem>[],
    );
  }

  /// Returns all currently registered technique identifiers.
  static Set<String> get registeredTechniqueIds {
    return Set<String>.unmodifiable(
      _catalogs.keys,
    );
  }

  /// Returns every media catalog as an immutable collection.
  static Iterable<List<TechniqueMediaItem>> get allCatalogs sync* {
    for (final catalog in _catalogs.values) {
      yield List<TechniqueMediaItem>.unmodifiable(
        catalog,
      );
    }
  }

  /// Returns every registered media item in one immutable list.
  static List<TechniqueMediaItem> get allMedia {
    return List<TechniqueMediaItem>.unmodifiable(
      _catalogs.values.expand(
        (catalog) => catalog,
      ),
    );
  }

  /// Returns whether a technique has a registered media catalog.
  static bool hasCatalog(
    String techniqueId,
  ) {
    return _catalogs.containsKey(
      techniqueId,
    );
  }
}