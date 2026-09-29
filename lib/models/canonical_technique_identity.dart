enum TechniqueIdentityVerificationState {
  verifiedExistingProjectRecord,
  verifiedOfficialSource,
  normalizedPendingHumanConfirmation,
  identityConflict,
  unresolved,
}

extension TechniqueIdentityVerificationStateWireValue
    on TechniqueIdentityVerificationState {
  String get wireValue => switch (this) {
    TechniqueIdentityVerificationState.verifiedExistingProjectRecord =>
      'VERIFIED_EXISTING_PROJECT_RECORD',
    TechniqueIdentityVerificationState.verifiedOfficialSource =>
      'VERIFIED_OFFICIAL_SOURCE',
    TechniqueIdentityVerificationState.normalizedPendingHumanConfirmation =>
      'NORMALIZED_PENDING_HUMAN_CONFIRMATION',
    TechniqueIdentityVerificationState.identityConflict => 'IDENTITY_CONFLICT',
    TechniqueIdentityVerificationState.unresolved => 'UNRESOLVED',
  };
}

enum TechniquePersianNameState {
  existingReviewed,
  existingUnreviewed,
  transliterationPendingReview,
  notAvailable,
}

extension TechniquePersianNameStateWireValue on TechniquePersianNameState {
  String get wireValue => switch (this) {
    TechniquePersianNameState.existingReviewed => 'EXISTING_REVIEWED',
    TechniquePersianNameState.existingUnreviewed => 'EXISTING_UNREVIEWED',
    TechniquePersianNameState.transliterationPendingReview =>
      'TRANSLITERATION_PENDING_REVIEW',
    TechniquePersianNameState.notAvailable => 'NOT_AVAILABLE',
  };
}

enum TechniqueRegistryUnlockState { locked }

extension TechniqueRegistryUnlockStateWireValue
    on TechniqueRegistryUnlockState {
  String get wireValue => 'LOCKED';
}

/// Content-free identity projection of the canonical CSV registry.
///
/// Identity, classification, model presence and unlock remain independent.
/// Membership in this registry can never create educational or scientific
/// content, route eligibility, analysis capability or scientific approval.
class CanonicalTechniqueIdentity {
  const CanonicalTechniqueIdentity({
    required this.techniqueId,
    required this.canonicalEnglishName,
    required this.canonicalJapaneseRomanizedName,
    required this.canonicalJapaneseScript,
    required this.persianName,
    required this.persianNameState,
    required this.officialClassification,
    required this.techniqueFamily,
    required this.nageWazaOrKatameWaza,
    required this.subclassification,
    required this.existingModelAvailable,
    required this.identityVerificationState,
    required this.classificationVerificationState,
    required this.normalizationNotes,
    required this.identityConflicts,
    required this.technicalHumanReviewRequired,
    this.unlockState = TechniqueRegistryUnlockState.locked,
  });

  const CanonicalTechniqueIdentity.existing({
    required this.techniqueId,
    required this.canonicalEnglishName,
    required this.canonicalJapaneseRomanizedName,
    required this.canonicalJapaneseScript,
    required this.persianName,
    required this.persianNameState,
    required this.subclassification,
    this.classificationVerificationState =
        TechniqueIdentityVerificationState.verifiedOfficialSource,
    this.normalizationNotes = '',
    this.identityConflicts = '',
    this.technicalHumanReviewRequired = false,
  }) : identityVerificationState =
           TechniqueIdentityVerificationState.verifiedExistingProjectRecord,
       existingModelAvailable = true,
       officialClassification = 'KODOKAN_NAGE_WAZA',
       techniqueFamily = 'THROWING_TECHNIQUE',
       nageWazaOrKatameWaza = 'NAGE_WAZA',
       unlockState = TechniqueRegistryUnlockState.locked;

  const CanonicalTechniqueIdentity.normalized({
    required this.techniqueId,
    required this.canonicalEnglishName,
    required this.canonicalJapaneseRomanizedName,
    required this.canonicalJapaneseScript,
    required this.subclassification,
    this.normalizationNotes =
        'ID-to-name mapping follows the bounded official-source order and requires qualified human confirmation.',
    this.identityConflicts = '',
  }) : persianName = '',
       persianNameState = TechniquePersianNameState.notAvailable,
       identityVerificationState = TechniqueIdentityVerificationState
           .normalizedPendingHumanConfirmation,
       classificationVerificationState =
           TechniqueIdentityVerificationState.verifiedOfficialSource,
       existingModelAvailable = false,
       officialClassification = 'KODOKAN_NAGE_WAZA',
       techniqueFamily = 'THROWING_TECHNIQUE',
       nageWazaOrKatameWaza = 'NAGE_WAZA',
       technicalHumanReviewRequired = true,
       unlockState = TechniqueRegistryUnlockState.locked;

  final String techniqueId;
  final String canonicalEnglishName;
  final String canonicalJapaneseRomanizedName;
  final String canonicalJapaneseScript;
  final String persianName;
  final TechniquePersianNameState persianNameState;
  final String officialClassification;
  final String techniqueFamily;
  final String nageWazaOrKatameWaza;
  final String subclassification;
  final bool existingModelAvailable;
  final TechniqueIdentityVerificationState identityVerificationState;
  final TechniqueIdentityVerificationState classificationVerificationState;
  final String normalizationNotes;
  final String identityConflicts;
  final bool technicalHumanReviewRequired;
  final TechniqueRegistryUnlockState unlockState;

  bool get hasCanonicalId => RegExp(r'^\d{3}$').hasMatch(techniqueId);

  bool get hasResolvedIdentity =>
      identityVerificationState ==
          TechniqueIdentityVerificationState.verifiedExistingProjectRecord ||
      identityVerificationState ==
          TechniqueIdentityVerificationState.verifiedOfficialSource;

  bool get hasResolvedClassification =>
      classificationVerificationState ==
          TechniqueIdentityVerificationState.verifiedExistingProjectRecord ||
      classificationVerificationState ==
          TechniqueIdentityVerificationState.verifiedOfficialSource;

  bool get canResolveRuntimeModel =>
      hasCanonicalId &&
      hasResolvedIdentity &&
      hasResolvedClassification &&
      existingModelAvailable;

  bool get isUnlocked => false;
}
