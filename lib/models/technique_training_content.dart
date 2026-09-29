enum TechniqueTrainingDrillKind {
  shadowTraining,
  strengthConditioning,
  resistanceBand,
}

enum TechniqueTrainingContentStatus { unavailable, draft, approved }

class TechniqueShadowTrainingConfigurationTranslation {
  final String languageCode;
  final List<String> phaseSequence;
  final List<String> movementPathCues;
  final List<String> paceModes;

  const TechniqueShadowTrainingConfigurationTranslation({
    required this.languageCode,
    required this.phaseSequence,
    required this.movementPathCues,
    required this.paceModes,
  });

  bool get isComplete =>
      languageCode.trim().isNotEmpty &&
      _hasText(phaseSequence) &&
      _hasText(movementPathCues) &&
      _hasText(paceModes);
}

class TechniqueShadowTrainingConfiguration {
  final List<String> phaseSequence;
  final List<String> movementPathCues;
  final String movementPathReferenceId;
  final bool mirrorGhostPresentationAvailable;
  final String frontPresentationReferenceId;
  final String sidePresentationReferenceId;
  final List<String> paceModes;
  final bool repetitionTrackingAvailable;
  final bool historyRecordingAvailable;
  final List<TechniqueShadowTrainingConfigurationTranslation> translations;

  const TechniqueShadowTrainingConfiguration({
    this.phaseSequence = const [],
    this.movementPathCues = const [],
    this.movementPathReferenceId = '',
    this.mirrorGhostPresentationAvailable = false,
    this.frontPresentationReferenceId = '',
    this.sidePresentationReferenceId = '',
    this.paceModes = const [],
    this.repetitionTrackingAvailable = false,
    this.historyRecordingAvailable = false,
    this.translations = const [],
  });

  bool get isComplete =>
      _hasText(phaseSequence) &&
      _hasText(movementPathCues) &&
      movementPathReferenceId.trim().isNotEmpty &&
      (frontPresentationReferenceId.trim().isNotEmpty ||
          sidePresentationReferenceId.trim().isNotEmpty) &&
      _hasText(paceModes);

  ResolvedTechniqueShadowTrainingConfiguration? resolveForLanguage(
    String languageCode,
  ) {
    if (!isComplete) {
      return null;
    }
    final normalized = languageCode.trim().toLowerCase();
    TechniqueShadowTrainingConfigurationTranslation? translation;
    if (normalized != 'en') {
      for (final candidate in translations) {
        if (candidate.languageCode.trim().toLowerCase() == normalized) {
          translation = candidate;
          break;
        }
      }
      if (translation?.isComplete != true) {
        return null;
      }
    }
    return ResolvedTechniqueShadowTrainingConfiguration(
      phaseSequence: _clean(translation?.phaseSequence ?? phaseSequence),
      movementPathCues: _clean(
        translation?.movementPathCues ?? movementPathCues,
      ),
      movementPathReferenceId: movementPathReferenceId.trim(),
      mirrorGhostPresentationAvailable: mirrorGhostPresentationAvailable,
      frontPresentationReferenceId: frontPresentationReferenceId.trim(),
      sidePresentationReferenceId: sidePresentationReferenceId.trim(),
      paceModes: _clean(translation?.paceModes ?? paceModes),
      repetitionTrackingAvailable: repetitionTrackingAvailable,
      historyRecordingAvailable: historyRecordingAvailable,
    );
  }
}

class ResolvedTechniqueShadowTrainingConfiguration {
  final List<String> phaseSequence;
  final List<String> movementPathCues;
  final String movementPathReferenceId;
  final bool mirrorGhostPresentationAvailable;
  final String frontPresentationReferenceId;
  final String sidePresentationReferenceId;
  final List<String> paceModes;
  final bool repetitionTrackingAvailable;
  final bool historyRecordingAvailable;

  const ResolvedTechniqueShadowTrainingConfiguration({
    required this.phaseSequence,
    required this.movementPathCues,
    required this.movementPathReferenceId,
    required this.mirrorGhostPresentationAvailable,
    required this.frontPresentationReferenceId,
    required this.sidePresentationReferenceId,
    required this.paceModes,
    required this.repetitionTrackingAvailable,
    required this.historyRecordingAvailable,
  });
}

class TechniqueConditioningConfigurationTranslation {
  final String languageCode;
  final String targetMovementPattern;
  final String commonExecutionError;

  const TechniqueConditioningConfigurationTranslation({
    required this.languageCode,
    required this.targetMovementPattern,
    required this.commonExecutionError,
  });

  bool get isComplete =>
      languageCode.trim().isNotEmpty &&
      targetMovementPattern.trim().isNotEmpty &&
      commonExecutionError.trim().isNotEmpty;
}

class TechniqueConditioningConfiguration {
  final String targetMovementPattern;
  final String commonExecutionError;
  final List<TechniqueConditioningConfigurationTranslation> translations;

  const TechniqueConditioningConfiguration({
    this.targetMovementPattern = '',
    this.commonExecutionError = '',
    this.translations = const [],
  });

  bool get isComplete =>
      targetMovementPattern.trim().isNotEmpty &&
      commonExecutionError.trim().isNotEmpty;

  ResolvedTechniqueConditioningConfiguration? resolveForLanguage(
    String languageCode,
  ) {
    if (!isComplete) {
      return null;
    }
    final normalized = languageCode.trim().toLowerCase();
    TechniqueConditioningConfigurationTranslation? translation;
    if (normalized != 'en') {
      for (final candidate in translations) {
        if (candidate.languageCode.trim().toLowerCase() == normalized) {
          translation = candidate;
          break;
        }
      }
      if (translation?.isComplete != true) {
        return null;
      }
    }
    return ResolvedTechniqueConditioningConfiguration(
      targetMovementPattern:
          translation?.targetMovementPattern.trim() ??
          targetMovementPattern.trim(),
      commonExecutionError:
          translation?.commonExecutionError.trim() ??
          commonExecutionError.trim(),
    );
  }
}

class ResolvedTechniqueConditioningConfiguration {
  final String targetMovementPattern;
  final String commonExecutionError;

  const ResolvedTechniqueConditioningConfiguration({
    required this.targetMovementPattern,
    required this.commonExecutionError,
  });
}

class TechniqueResistanceBandConfigurationTranslation {
  final String languageCode;
  final String anchorLocation;
  final String anchorHeight;
  final String resistanceDirection;
  final String gripMapping;
  final String entryRotationPath;
  final String supportLegRole;
  final String attackingLegRole;
  final String safeDistanceGuidance;
  final String resistanceLevel;
  final String dangerousErrorWarning;

  const TechniqueResistanceBandConfigurationTranslation({
    required this.languageCode,
    required this.anchorLocation,
    required this.anchorHeight,
    required this.resistanceDirection,
    required this.gripMapping,
    required this.entryRotationPath,
    required this.supportLegRole,
    required this.attackingLegRole,
    required this.safeDistanceGuidance,
    this.resistanceLevel = '',
    required this.dangerousErrorWarning,
  });

  bool isComplete({required bool resistanceLevelRequired}) =>
      languageCode.trim().isNotEmpty &&
      anchorLocation.trim().isNotEmpty &&
      anchorHeight.trim().isNotEmpty &&
      resistanceDirection.trim().isNotEmpty &&
      gripMapping.trim().isNotEmpty &&
      entryRotationPath.trim().isNotEmpty &&
      supportLegRole.trim().isNotEmpty &&
      attackingLegRole.trim().isNotEmpty &&
      safeDistanceGuidance.trim().isNotEmpty &&
      (!resistanceLevelRequired || resistanceLevel.trim().isNotEmpty) &&
      dangerousErrorWarning.trim().isNotEmpty;
}

class TechniqueResistanceBandConfiguration {
  final String anchorLocation;
  final String anchorHeight;
  final String resistanceDirection;
  final String gripMapping;
  final String entryRotationPath;
  final String supportLegRole;
  final String attackingLegRole;
  final String safeDistanceGuidance;
  final String resistanceLevel;
  final String dangerousErrorWarning;
  final List<TechniqueResistanceBandConfigurationTranslation> translations;

  const TechniqueResistanceBandConfiguration({
    this.anchorLocation = '',
    this.anchorHeight = '',
    this.resistanceDirection = '',
    this.gripMapping = '',
    this.entryRotationPath = '',
    this.supportLegRole = '',
    this.attackingLegRole = '',
    this.safeDistanceGuidance = '',
    this.resistanceLevel = '',
    this.dangerousErrorWarning = '',
    this.translations = const [],
  });

  bool get isComplete =>
      anchorLocation.trim().isNotEmpty &&
      anchorHeight.trim().isNotEmpty &&
      resistanceDirection.trim().isNotEmpty &&
      gripMapping.trim().isNotEmpty &&
      entryRotationPath.trim().isNotEmpty &&
      supportLegRole.trim().isNotEmpty &&
      attackingLegRole.trim().isNotEmpty &&
      safeDistanceGuidance.trim().isNotEmpty &&
      dangerousErrorWarning.trim().isNotEmpty;

  ResolvedTechniqueResistanceBandConfiguration? resolveForLanguage(
    String languageCode,
  ) {
    if (!isComplete) {
      return null;
    }
    final normalized = languageCode.trim().toLowerCase();
    TechniqueResistanceBandConfigurationTranslation? translation;
    if (normalized != 'en') {
      for (final candidate in translations) {
        if (candidate.languageCode.trim().toLowerCase() == normalized) {
          translation = candidate;
          break;
        }
      }
      if (translation?.isComplete(
            resistanceLevelRequired: resistanceLevel.trim().isNotEmpty,
          ) !=
          true) {
        return null;
      }
    }
    return ResolvedTechniqueResistanceBandConfiguration(
      anchorLocation:
          translation?.anchorLocation.trim() ?? anchorLocation.trim(),
      anchorHeight: translation?.anchorHeight.trim() ?? anchorHeight.trim(),
      resistanceDirection:
          translation?.resistanceDirection.trim() ?? resistanceDirection.trim(),
      gripMapping: translation?.gripMapping.trim() ?? gripMapping.trim(),
      entryRotationPath:
          translation?.entryRotationPath.trim() ?? entryRotationPath.trim(),
      supportLegRole:
          translation?.supportLegRole.trim() ?? supportLegRole.trim(),
      attackingLegRole:
          translation?.attackingLegRole.trim() ?? attackingLegRole.trim(),
      safeDistanceGuidance:
          translation?.safeDistanceGuidance.trim() ??
          safeDistanceGuidance.trim(),
      resistanceLevel:
          translation?.resistanceLevel.trim() ?? resistanceLevel.trim(),
      dangerousErrorWarning:
          translation?.dangerousErrorWarning.trim() ??
          dangerousErrorWarning.trim(),
    );
  }
}

class ResolvedTechniqueResistanceBandConfiguration {
  final String anchorLocation;
  final String anchorHeight;
  final String resistanceDirection;
  final String gripMapping;
  final String entryRotationPath;
  final String supportLegRole;
  final String attackingLegRole;
  final String safeDistanceGuidance;
  final String resistanceLevel;
  final String dangerousErrorWarning;

  const ResolvedTechniqueResistanceBandConfiguration({
    required this.anchorLocation,
    required this.anchorHeight,
    required this.resistanceDirection,
    required this.gripMapping,
    required this.entryRotationPath,
    required this.supportLegRole,
    required this.attackingLegRole,
    required this.safeDistanceGuidance,
    required this.resistanceLevel,
    required this.dangerousErrorWarning,
  });
}

class TechniqueTrainingPrescription {
  final int? sets;
  final int? repetitions;
  final int? durationSeconds;
  final int? restSeconds;
  final int? sessionsPerWeek;

  const TechniqueTrainingPrescription({
    this.sets,
    this.repetitions,
    this.durationSeconds,
    this.restSeconds,
    this.sessionsPerWeek,
  }) : assert(sets == null || sets > 0),
       assert(repetitions == null || repetitions > 0),
       assert(durationSeconds == null || durationSeconds > 0),
       assert(restSeconds == null || restSeconds >= 0),
       assert(sessionsPerWeek == null || sessionsPerWeek > 0);

  bool get isSpecified =>
      sets != null ||
      repetitions != null ||
      durationSeconds != null ||
      restSeconds != null ||
      sessionsPerWeek != null;
}

class TechniqueTrainingDrillTranslation {
  final String languageCode;
  final String title;
  final String objective;
  final String relatedTechniquePhase;
  final List<String> equipment;
  final List<String> steps;
  final String athleteLevel;
  final List<String> safetyGuidance;

  const TechniqueTrainingDrillTranslation({
    required this.languageCode,
    required this.title,
    required this.objective,
    required this.relatedTechniquePhase,
    required this.equipment,
    required this.steps,
    required this.athleteLevel,
    required this.safetyGuidance,
  });

  bool get isComplete =>
      languageCode.trim().isNotEmpty &&
      title.trim().isNotEmpty &&
      objective.trim().isNotEmpty &&
      relatedTechniquePhase.trim().isNotEmpty &&
      _hasText(equipment) &&
      steps.any((item) => item.trim().isNotEmpty) &&
      athleteLevel.trim().isNotEmpty &&
      safetyGuidance.any((item) => item.trim().isNotEmpty);
}

class TechniqueTrainingDrill {
  final String id;
  final TechniqueTrainingDrillKind kind;
  final String title;
  final String objective;
  final String relatedTechniquePhase;
  final List<String> equipment;
  final List<String> steps;
  final TechniqueTrainingPrescription? prescription;
  final String athleteLevel;
  final String mediaReferenceId;
  final List<String> safetyGuidance;
  final String sourceReference;
  final String contentProvenance;
  final TechniqueTrainingContentStatus status;
  final List<TechniqueTrainingDrillTranslation> translations;
  final TechniqueShadowTrainingConfiguration? shadowConfiguration;
  final TechniqueConditioningConfiguration? conditioningConfiguration;
  final TechniqueResistanceBandConfiguration? resistanceBandConfiguration;

  const TechniqueTrainingDrill({
    required this.id,
    required this.kind,
    required this.title,
    required this.objective,
    required this.relatedTechniquePhase,
    this.equipment = const [],
    this.steps = const [],
    this.prescription,
    this.athleteLevel = '',
    this.mediaReferenceId = '',
    this.safetyGuidance = const [],
    this.sourceReference = '',
    this.contentProvenance = '',
    this.status = TechniqueTrainingContentStatus.unavailable,
    this.translations = const [],
    this.shadowConfiguration,
    this.conditioningConfiguration,
    this.resistanceBandConfiguration,
  });

  bool get hasApprovedActivationEvidence =>
      status == TechniqueTrainingContentStatus.approved &&
      id.trim().isNotEmpty &&
      title.trim().isNotEmpty &&
      objective.trim().isNotEmpty &&
      relatedTechniquePhase.trim().isNotEmpty &&
      steps.any((item) => item.trim().isNotEmpty) &&
      prescription?.isSpecified == true &&
      athleteLevel.trim().isNotEmpty &&
      mediaReferenceId.trim().isNotEmpty &&
      safetyGuidance.any((item) => item.trim().isNotEmpty) &&
      sourceReference.trim().isNotEmpty &&
      contentProvenance.trim().isNotEmpty &&
      hasCompleteKindConfiguration;

  bool get hasCompleteKindConfiguration => switch (kind) {
    TechniqueTrainingDrillKind.shadowTraining =>
      shadowConfiguration?.isComplete == true &&
          conditioningConfiguration == null &&
          resistanceBandConfiguration == null,
    TechniqueTrainingDrillKind.strengthConditioning =>
      shadowConfiguration == null &&
          conditioningConfiguration?.isComplete == true &&
          resistanceBandConfiguration == null,
    TechniqueTrainingDrillKind.resistanceBand =>
      shadowConfiguration == null &&
          conditioningConfiguration == null &&
          resistanceBandConfiguration?.isComplete == true,
  };

  TechniqueTrainingDrillTranslation? translationFor(String languageCode) {
    final normalized = languageCode.trim().toLowerCase();
    for (final translation in translations) {
      if (translation.languageCode.trim().toLowerCase() == normalized) {
        return translation;
      }
    }
    return null;
  }

  bool isAvailableForLanguage(String languageCode) {
    if (!hasApprovedActivationEvidence) {
      return false;
    }
    if (languageCode.trim().toLowerCase() == 'en') {
      return _configurationAvailableForLanguage('en');
    }
    return translationFor(languageCode)?.isComplete == true &&
        _configurationAvailableForLanguage(languageCode);
  }

  bool _configurationAvailableForLanguage(String languageCode) =>
      switch (kind) {
        TechniqueTrainingDrillKind.shadowTraining =>
          shadowConfiguration?.resolveForLanguage(languageCode) != null,
        TechniqueTrainingDrillKind.strengthConditioning =>
          conditioningConfiguration?.resolveForLanguage(languageCode) != null,
        TechniqueTrainingDrillKind.resistanceBand =>
          resistanceBandConfiguration?.resolveForLanguage(languageCode) != null,
      };

  ResolvedTechniqueTrainingDrill? resolveForLanguage(String languageCode) {
    if (!isAvailableForLanguage(languageCode)) {
      return null;
    }
    final normalized = languageCode.trim().toLowerCase();
    final translation = normalized == 'en' ? null : translationFor(normalized);
    return ResolvedTechniqueTrainingDrill(
      id: id,
      kind: kind,
      title: translation?.title.trim() ?? title.trim(),
      objective: translation?.objective.trim() ?? objective.trim(),
      relatedTechniquePhase:
          translation?.relatedTechniquePhase.trim() ??
          relatedTechniquePhase.trim(),
      equipment: _clean(translation?.equipment ?? equipment),
      steps: _clean(translation?.steps ?? steps),
      prescription: prescription!,
      athleteLevel: translation?.athleteLevel.trim() ?? athleteLevel.trim(),
      mediaReferenceId: mediaReferenceId.trim(),
      safetyGuidance: _clean(translation?.safetyGuidance ?? safetyGuidance),
      sourceReference: sourceReference.trim(),
      contentProvenance: contentProvenance.trim(),
      shadowConfiguration: shadowConfiguration?.resolveForLanguage(normalized),
      conditioningConfiguration: conditioningConfiguration?.resolveForLanguage(
        normalized,
      ),
      resistanceBandConfiguration: resistanceBandConfiguration
          ?.resolveForLanguage(normalized),
    );
  }

  static List<String> _clean(List<String> values) => List.unmodifiable(
    values.map((item) => item.trim()).where((item) => item.isNotEmpty),
  );
}

class ResolvedTechniqueTrainingDrill {
  final String id;
  final TechniqueTrainingDrillKind kind;
  final String title;
  final String objective;
  final String relatedTechniquePhase;
  final List<String> equipment;
  final List<String> steps;
  final TechniqueTrainingPrescription prescription;
  final String athleteLevel;
  final String mediaReferenceId;
  final List<String> safetyGuidance;
  final String sourceReference;
  final String contentProvenance;
  final ResolvedTechniqueShadowTrainingConfiguration? shadowConfiguration;
  final ResolvedTechniqueConditioningConfiguration? conditioningConfiguration;
  final ResolvedTechniqueResistanceBandConfiguration?
  resistanceBandConfiguration;

  const ResolvedTechniqueTrainingDrill({
    required this.id,
    required this.kind,
    required this.title,
    required this.objective,
    required this.relatedTechniquePhase,
    required this.equipment,
    required this.steps,
    required this.prescription,
    required this.athleteLevel,
    required this.mediaReferenceId,
    required this.safetyGuidance,
    required this.sourceReference,
    required this.contentProvenance,
    this.shadowConfiguration,
    this.conditioningConfiguration,
    this.resistanceBandConfiguration,
  });
}

class TechniqueTrainingContent {
  final List<TechniqueTrainingDrill> shadowTraining;
  final List<TechniqueTrainingDrill> strengthConditioning;
  final List<TechniqueTrainingDrill> resistanceBand;

  const TechniqueTrainingContent({
    this.shadowTraining = const [],
    this.strengthConditioning = const [],
    this.resistanceBand = const [],
  });

  const TechniqueTrainingContent.empty()
    : shadowTraining = const [],
      strengthConditioning = const [],
      resistanceBand = const [];

  bool get isEmpty =>
      shadowTraining.isEmpty &&
      strengthConditioning.isEmpty &&
      resistanceBand.isEmpty;

  List<TechniqueTrainingDrill> drillsFor(TechniqueTrainingDrillKind kind) {
    return switch (kind) {
      TechniqueTrainingDrillKind.shadowTraining => shadowTraining,
      TechniqueTrainingDrillKind.strengthConditioning => strengthConditioning,
      TechniqueTrainingDrillKind.resistanceBand => resistanceBand,
    };
  }

  List<ResolvedTechniqueTrainingDrill> availableDrillsFor(
    TechniqueTrainingDrillKind kind,
    String languageCode,
  ) => List<ResolvedTechniqueTrainingDrill>.unmodifiable(
    drillsFor(kind)
        .map((drill) => drill.resolveForLanguage(languageCode))
        .whereType<ResolvedTechniqueTrainingDrill>(),
  );

  bool hasAvailableDrillsFor(
    TechniqueTrainingDrillKind kind,
    String languageCode,
  ) => availableDrillsFor(kind, languageCode).isNotEmpty;
}

bool _hasText(List<String> values) =>
    values.any((item) => item.trim().isNotEmpty);

List<String> _clean(List<String> values) => List<String>.unmodifiable(
  values.map((item) => item.trim()).where((item) => item.isNotEmpty),
);
