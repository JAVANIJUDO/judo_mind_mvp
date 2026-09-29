import '../../models/technique_model.dart';
import 'canonical_technique_identity_registry.dart';

import 'uchi_mata.dart';
import 'seoi_nage.dart';
import 'harai_goshi.dart';
import 'o_soto_gari.dart';
import 'tomoe_nage.dart';

enum TechniqueCatalogAvailability { production, readOnlyEducational, preview }

class TechniqueFactory {
  /// The product-approved featured/reference technique exposed to platform
  /// entry surfaces. Feature widgets must consume this source rather than
  /// branching on a technique name or ID.
  static const TechniqueModel featuredReferenceTechnique = uchiMata;

  static const List<TechniqueModel> allTechniques = [
    uchiMata,

    seoiNage,

    haraiGoshi,

    oSotoGari,

    tomoeNage,
  ];

  /// The approved long-term technique roadmap. This is not the number of
  /// runtime records or production-ready technique experiences.
  static int get officialRoadmapTechniqueCount =>
      CanonicalTechniqueIdentityRegistry.records.length;

  /// Only Uchi Mata currently satisfies the product's Gold reference gate.
  /// Other bundled records remain visible only as non-interactive previews.
  static const Set<String> productionTechniqueIds = {'001'};

  /// Non-Uchi catalog records may enter the generic read-only detail route
  /// only after their readiness row passes every product/content gate.
  ///
  /// JM-S1.1-B intentionally leaves this set empty: building a route is not
  /// evidence that any current preview record is ready to be unlocked.
  static const Set<String> readOnlyEducationalTechniqueIds = <String>{};

  static TechniqueCatalogAvailability availabilityOf(TechniqueModel technique) {
    if (productionTechniqueIds.contains(technique.id)) {
      return TechniqueCatalogAvailability.production;
    }
    if (readOnlyEducationalTechniqueIds.contains(technique.id)) {
      return TechniqueCatalogAvailability.readOnlyEducational;
    }
    return TechniqueCatalogAvailability.preview;
  }

  static List<TechniqueModel> get productionTechniques => allTechniques
      .where(
        (technique) =>
            availabilityOf(technique) ==
            TechniqueCatalogAvailability.production,
      )
      .toList(growable: false);

  static List<TechniqueModel> get previewTechniques => allTechniques
      .where(
        (technique) =>
            availabilityOf(technique) == TechniqueCatalogAvailability.preview,
      )
      .toList(growable: false);

  static List<TechniqueModel> get readOnlyEducationalTechniques => allTechniques
      .where(
        (technique) =>
            availabilityOf(technique) ==
            TechniqueCatalogAvailability.readOnlyEducational,
      )
      .toList(growable: false);

  static List<TechniqueModel> get navigableTechniques => allTechniques
      .where(
        (technique) =>
            availabilityOf(technique) != TechniqueCatalogAvailability.preview,
      )
      .toList(growable: false);
}
