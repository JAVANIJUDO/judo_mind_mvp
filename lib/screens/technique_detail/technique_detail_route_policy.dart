import '../../data/techniques/canonical_technique_identity_registry.dart';
import '../../data/techniques/technique_factory.dart';
import '../../models/canonical_technique_identity.dart';
import '../../models/technique_model.dart';

enum TechniqueDetailRouteKind { specializedUchiMata, genericReadOnly, locked }

enum TechniqueDetailRouteBlockReason {
  none,
  malformedId,
  unknownId,
  duplicateId,
  identityReviewRequired,
  identityConflict,
  modelUnavailable,
  notReadOnlyEligible,
}

class TechniqueDetailRouteDecision {
  const TechniqueDetailRouteDecision({
    required this.kind,
    required this.blockReason,
    this.technique,
    this.canonicalIdentity,
  });

  final TechniqueDetailRouteKind kind;
  final TechniqueDetailRouteBlockReason blockReason;
  final TechniqueModel? technique;
  final CanonicalTechniqueIdentity? canonicalIdentity;

  bool get isOpenable => kind != TechniqueDetailRouteKind.locked;
}

/// Canonical fail-closed boundary between the catalog and technique detail.
///
/// Route eligibility is explicit. A three-digit-looking ID, a populated model,
/// or a working widget is never sufficient to activate a catalog destination.
abstract final class TechniqueDetailRoutePolicy {
  const TechniqueDetailRoutePolicy._();

  static final RegExp _canonicalIdPattern = RegExp(r'^\d{3}$');

  static TechniqueDetailRouteDecision resolve(
    String requestedId, {
    List<TechniqueModel>? catalog,
    Set<String>? readOnlyEducationalIds,
    List<CanonicalTechniqueIdentity>? identityRegistry,
  }) {
    if (!_canonicalIdPattern.hasMatch(requestedId)) {
      return const TechniqueDetailRouteDecision(
        kind: TechniqueDetailRouteKind.locked,
        blockReason: TechniqueDetailRouteBlockReason.malformedId,
      );
    }

    // Production resolution always traverses the authoritative identity
    // registry. Test/custom catalogs may opt in with an explicit registry.
    final shouldResolveIdentity = catalog == null || identityRegistry != null;
    CanonicalTechniqueIdentity? canonicalIdentity;
    if (shouldResolveIdentity) {
      final identities =
          identityRegistry ?? CanonicalTechniqueIdentityRegistry.records;
      final identityMatches = identities
          .where((identity) => identity.techniqueId == requestedId)
          .toList(growable: false);
      if (identityMatches.isEmpty) {
        return const TechniqueDetailRouteDecision(
          kind: TechniqueDetailRouteKind.locked,
          blockReason: TechniqueDetailRouteBlockReason.unknownId,
        );
      }
      if (identityMatches.length != 1) {
        return const TechniqueDetailRouteDecision(
          kind: TechniqueDetailRouteKind.locked,
          blockReason: TechniqueDetailRouteBlockReason.duplicateId,
        );
      }
      canonicalIdentity = identityMatches.single;
      if (canonicalIdentity.identityVerificationState ==
              TechniqueIdentityVerificationState.identityConflict ||
          canonicalIdentity.classificationVerificationState ==
              TechniqueIdentityVerificationState.identityConflict) {
        return TechniqueDetailRouteDecision(
          kind: TechniqueDetailRouteKind.locked,
          blockReason: TechniqueDetailRouteBlockReason.identityConflict,
          canonicalIdentity: canonicalIdentity,
        );
      }
      if (!canonicalIdentity.hasResolvedIdentity ||
          canonicalIdentity.technicalHumanReviewRequired) {
        return TechniqueDetailRouteDecision(
          kind: TechniqueDetailRouteKind.locked,
          blockReason: TechniqueDetailRouteBlockReason.identityReviewRequired,
          canonicalIdentity: canonicalIdentity,
        );
      }
    }

    final records = catalog ?? TechniqueFactory.allTechniques;
    final matches = records
        .where((technique) => technique.id == requestedId)
        .toList(growable: false);
    if (matches.isEmpty) {
      return TechniqueDetailRouteDecision(
        kind: TechniqueDetailRouteKind.locked,
        blockReason: TechniqueDetailRouteBlockReason.unknownId,
        canonicalIdentity: canonicalIdentity,
      );
    }
    if (matches.length != 1) {
      return TechniqueDetailRouteDecision(
        kind: TechniqueDetailRouteKind.locked,
        blockReason: TechniqueDetailRouteBlockReason.duplicateId,
        canonicalIdentity: canonicalIdentity,
      );
    }

    final technique = matches.single;
    if (canonicalIdentity != null &&
        !canonicalIdentity.canResolveRuntimeModel) {
      return TechniqueDetailRouteDecision(
        kind: TechniqueDetailRouteKind.locked,
        blockReason: TechniqueDetailRouteBlockReason.modelUnavailable,
        technique: technique,
        canonicalIdentity: canonicalIdentity,
      );
    }
    if (requestedId == '001' &&
        TechniqueFactory.productionTechniqueIds.contains(requestedId)) {
      return TechniqueDetailRouteDecision(
        kind: TechniqueDetailRouteKind.specializedUchiMata,
        blockReason: TechniqueDetailRouteBlockReason.none,
        technique: technique,
        canonicalIdentity: canonicalIdentity,
      );
    }

    final eligibleIds =
        readOnlyEducationalIds ??
        TechniqueFactory.readOnlyEducationalTechniqueIds;
    if (requestedId != '001' && eligibleIds.contains(requestedId)) {
      return TechniqueDetailRouteDecision(
        kind: TechniqueDetailRouteKind.genericReadOnly,
        blockReason: TechniqueDetailRouteBlockReason.none,
        technique: technique,
        canonicalIdentity: canonicalIdentity,
      );
    }

    return TechniqueDetailRouteDecision(
      kind: TechniqueDetailRouteKind.locked,
      blockReason: TechniqueDetailRouteBlockReason.notReadOnlyEligible,
      technique: technique,
      canonicalIdentity: canonicalIdentity,
    );
  }
}
