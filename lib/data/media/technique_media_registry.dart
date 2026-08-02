import '../../models/technique_media_item.dart';
import 'uchi_mata_media_catalog.dart';

/// ----------------------------------------------------------------
/// Judo Mind Super App
/// Media Registry
/// Version: 1.0.0
/// ----------------------------------------------------------------
///
/// Central access point for all technique media catalogs.
///
/// Future:
/// - seoi_nage_media_catalog.dart
/// - o_soto_gari_media_catalog.dart
/// - harai_goshi_media_catalog.dart
///
/// All 67 techniques will be registered here.
abstract final class TechniqueMediaRegistry {
  const TechniqueMediaRegistry._();

  static final Map<String, List<TechniqueMediaItem>>
_catalogs = {

  '001':
      UchiMataMediaCatalog.items,

};


  static List<TechniqueMediaItem> getMedia(
    String techniqueId,
  ) {
    return List.unmodifiable(
      _catalogs[techniqueId] ?? [],
    );
  }


  static bool hasCatalog(
    String techniqueId,
  ) {
    return _catalogs.containsKey(
      techniqueId,
    );
  }
}