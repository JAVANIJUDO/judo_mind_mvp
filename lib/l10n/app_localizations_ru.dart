// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get unavailableLabel => 'Unavailable';

  @override
  String get moreTechniqueSections => 'More technique sections';

  @override
  String get scientificDetailsTitle => 'Scientific details';

  @override
  String get provenanceMeasured => 'Measured';

  @override
  String get provenanceReconstructed => 'Reconstructed';

  @override
  String get provenanceModelEstimated => 'Model-estimated';

  @override
  String get provenanceAiInferred => 'AI-inferred';

  @override
  String get provenanceUnknown => 'Unknown';

  @override
  String get insufficientEvidenceLabel => 'Insufficient evidence';

  @override
  String get leftSide => 'Left Side';

  @override
  String get rightSide => 'Right Side';

  @override
  String get toriRole => 'Tori';

  @override
  String get ukeRole => 'Uke';

  @override
  String get unassignedRole => 'Unassigned';

  @override
  String reviewedGateSummary(
    String trackId,
    int detectionIndex,
    String role,
    String supportSide,
    String attackingSide,
    int startMs,
    int endMs,
  ) {
    return '$trackId; detection $detectionIndex; $role; $supportSide support leg; $attackingSide attacking leg; $startMs–$endMs ms';
  }

  @override
  String get allCategories => 'All';

  @override
  String get allLevels => 'All levels';

  @override
  String get techniqueSearchHint => 'Search techniques';

  @override
  String get noTechniquesFound => 'No techniques found';

  @override
  String officialTechniquesCount(int count) {
    return '$count official Judo techniques';
  }

  @override
  String get ijfTechniqueDatabase => 'IJF technique database';

  @override
  String get filtersTitle => 'Filters';

  @override
  String get eliteLevel => 'Elite';

  @override
  String get sutemiWaza => 'Sutemi-waza';

  @override
  String get neWaza => 'Ne-waza';

  @override
  String get tachiWaza => 'Tachi-waza';

  @override
  String get analyzeVideoDescription =>
      'Choose one training or competition video for an experimental 2D pose-visibility check. Identity, phases and biomechanics are not included.';

  @override
  String get addTechniqueVideo => 'Add technique video';

  @override
  String get videoVisibilityGuidance =>
      'Use a clear video where both judoka remain visible.';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get recordVideo => 'Record video';

  @override
  String get selectedVideo => 'Selected video';

  @override
  String get captureFullBodiesGuidance =>
      'Keep the full bodies of Tori and Uke visible.';

  @override
  String get captureStableLightGuidance =>
      'Keep the camera stable and use sufficient light.';

  @override
  String get captureNoCrossingGuidance =>
      'Avoid people crossing in front of the camera.';

  @override
  String get captureViewGuidance =>
      'Side or 45-degree views provide clearer joint visibility.';

  @override
  String get captureDurationGuidance =>
      'The maximum video duration is 3 minutes.';

  @override
  String get cameraAngleLabel => 'Camera angle';

  @override
  String get cameraSideView => 'Side view';

  @override
  String get cameraFrontView => 'Front view';

  @override
  String get cameraRearView => 'Rear view';

  @override
  String get cameraFortyFiveView => '45-degree view';

  @override
  String get analysisNoticeTitle =>
      'I understand this is video-based analysis.';

  @override
  String get analysisNoticeDescription =>
      'This step reports experimental 2D pose visibility only. It does not identify Tori or Uke, detect phases, reconstruct 3D, or measure force and torque.';

  @override
  String get videoSelectionFailed => 'The video could not be selected.';

  @override
  String get analysisFailedUnexpectedly =>
      'The pose analysis stopped safely. Try again.';

  @override
  String videoSizeMegabytes(String size) {
    return '$size MB';
  }

  @override
  String get sourceInternationalJudoFederation =>
      'International Judo Federation';

  @override
  String get sourceKodokanJudoInstitute => 'Kodokan Judo Institute';

  @override
  String get sourceEuropeanJudoUnion => 'European Judo Union';

  @override
  String get techniqueSectionUnavailable =>
      'This technique section is not available yet.';

  @override
  String get techniqueTrainingUnavailable =>
      'The Uchi Mata training pathway is not available yet.';

  @override
  String get techniqueMasteryUnavailable =>
      'Uchi Mata progress and mastery tracking are not available yet.';

  @override
  String get techniqueChampionsUnavailable =>
      'Verified Uchi Mata champion references are not available yet.';

  @override
  String get techniqueSensiBotUnavailable =>
      'Sensi Bot coaching for Uchi Mata is not available yet.';

  @override
  String get techniqueMediaItemUnavailable =>
      'An approved media source has not been added for this item yet.';

  @override
  String get techniqueMediaOpenFailed =>
      'The selected media could not be opened.';

  @override
  String get techniqueCompetitionVideoUnavailable =>
      'An approved direct competition video is not available yet.';

  @override
  String get techniqueCompetitionVideoOpenFailed =>
      'The competition video could not be opened.';

  @override
  String get submitAnswer => 'Submit Answer';

  @override
  String get overview => 'Overview';

  @override
  String get techniqueApplicationContext => 'Application context';

  @override
  String get techniqueGripAndStartingPosition => 'Grip and starting position';

  @override
  String get techniqueExecutionPhases => 'Execution phases';

  @override
  String get techniqueFollowThrough => 'Makikomi or follow-through';

  @override
  String get techniqueVariations => 'Variations';

  @override
  String get techniqueVisualExplanation => 'Visual explanation';

  @override
  String get techniqueVideoExplanation => 'Video explanation';

  @override
  String get techniqueTechnicalExplanation => 'Technical explanation';

  @override
  String get techniqueConceptualMechanicalInterpretation =>
      'Conceptual mechanical interpretation';

  @override
  String get techniqueBiomechanicalInterpretation =>
      'Biomechanical interpretation';

  @override
  String get techniqueMeasuredBiomechanicalResult =>
      'Measured biomechanical result';

  @override
  String get techniqueEvidenceReviewStatus => 'Evidence and review status';

  @override
  String get techniqueStatementClassification => 'Statement classification';

  @override
  String get techniqueContentSource => 'Content source';

  @override
  String get techniqueSourceType => 'Source type';

  @override
  String get techniqueProvenanceLicense => 'Provenance / licence';

  @override
  String get techniqueTechnicalReviewStatus => 'Technical-review status';

  @override
  String get techniqueScientificReviewStatus => 'Scientific-review status';

  @override
  String get techniqueReviewerRole => 'Reviewer role';

  @override
  String get techniqueLastReviewDate => 'Last review date';

  @override
  String get techniqueReviewNotReviewed => 'Not reviewed';

  @override
  String get techniqueReviewRequired => 'Review required';

  @override
  String get techniqueReviewRecorded => 'Review recorded';

  @override
  String get techniqueConceptualDiagramDisclaimer =>
      'This diagram is an educational interpretation. Arrows indicate conceptual movement or force directions and do not represent direct force measurement.';

  @override
  String get biomechanics => 'Biomechanics';

  @override
  String get techniqueType => 'Technique Type';

  @override
  String get beltLevel => 'Belt Level';

  @override
  String get approvedContentUnavailable =>
      'Curated educational content is not available for this field yet.';

  @override
  String get classicalPhases => 'Classical Phases';

  @override
  String get kuzushi => 'Kuzushi';

  @override
  String get tsukuri => 'Tsukuri';

  @override
  String get kake => 'Kake';

  @override
  String get additionalExecutionSteps => 'Additional Execution Steps';

  @override
  String get noAdditionalExecutionSteps =>
      'No additional approved execution steps are available.';

  @override
  String get approvedKeyPoints => 'Approved Key Points';

  @override
  String get tacticalContentIncomplete =>
      'Dedicated tactical scenarios and competition-context guidance do not yet have an approved source. The key points below are educational technique content, not tactical intelligence.';

  @override
  String get competitionContentIncomplete =>
      'Dedicated competition analysis does not yet have an approved source. The combinations and counters below are the currently approved educational content.';

  @override
  String get watchCompetitionExample => 'Watch Competition Example';

  @override
  String get officialSources => 'Official Sources';

  @override
  String get officialLabel => 'Official';

  @override
  String get verifiedLabel => 'Verified';

  @override
  String get noApprovedSources =>
      'No concrete approved references have been added for this technique.';

  @override
  String get mistakesAndSafety => 'Mistakes & Safety';

  @override
  String get safetyGuidance => 'Safety Guidance';

  @override
  String get noCommonMistakes =>
      'No approved common mistakes have been recorded yet.';

  @override
  String get noSafetyGuidance =>
      'No approved safety guidance has been added yet.';

  @override
  String get noCombinations => 'No approved combinations have been added yet.';

  @override
  String get noCounters => 'No approved counters have been added yet.';

  @override
  String get techniqueQuiz => 'Technique Quiz';

  @override
  String get quizUnavailable =>
      'No approved quiz questions are available for this technique.';

  @override
  String get visualBiomechanics => 'Visual Biomechanics';

  @override
  String get visualBiomechanicsDescription =>
      'Use the educational layers to inspect the repository\'s approved movement visualization.';

  @override
  String get visualBiomechanicsUnavailable =>
      'An approved visual biomechanics sequence is not available for this technique.';

  @override
  String get educationalVisualizationLimitation =>
      'Educational visualization only. It is not measured or reconstructed 3D biomechanics and does not report real force, torque, power or center of mass.';

  @override
  String get blueLayer => 'Blue Layer';

  @override
  String get blueLayerDescription => 'Footwork, entry and body movement';

  @override
  String get goldLayer => 'Gold Layer';

  @override
  String get goldLayerDescription =>
      'Grip, pulling action and kinetic-chain control';

  @override
  String get greenLayer => 'Green Layer';

  @override
  String get greenLayerDescription =>
      'Illustrative direction, balance and body-position concepts';

  @override
  String get visualPhaseGuidanceDescription =>
      'Each classical phase is paired with an educational vector companion, while its instruction comes directly from the technique\'s structured content.';

  @override
  String get animationDisabledStaticFallback =>
      'Animation is disabled. Select a phase to inspect its static visual companion.';

  @override
  String get educationalPracticeTitle => 'Educational Practice Guidance';

  @override
  String get educationalPracticeDescription =>
      'Review the approved execution steps, key points, common mistakes and safety guidance before supervised practice.';

  @override
  String get educationalPracticeLimitation =>
      'Educational guidance only. Timers, repetition programmes, conditioning plans and personalized coaching are not available.';

  @override
  String get shadowTrainingTitle => 'Shadow Training';

  @override
  String get strengthConditioningTitle => 'Strength & Conditioning';

  @override
  String get resistanceBandTrainingTitle => 'Resistance-Band Training';

  @override
  String get trainingExperienceUnavailable =>
      'Approved technique-specific training is unavailable';

  @override
  String get trainingExperienceUnavailableDescription =>
      'This experience remains unavailable until its localized content, visual or media evidence, prescription, safety guidance and sources are reviewed and approved.';

  @override
  String get trainingObjectiveLabel => 'Objective';

  @override
  String get trainingRelatedPhaseLabel => 'Related phase';

  @override
  String get trainingEquipmentLabel => 'Equipment';

  @override
  String get trainingAthleteLevelLabel => 'Athlete level';

  @override
  String get trainingPrescriptionLabel => 'Approved prescription';

  @override
  String get trainingRestLabel => 'Rest';

  @override
  String get trainingMediaLabel => 'Approved media reference';

  @override
  String get trainingSafetyLabel => 'Safety guidance';

  @override
  String get trainingSourceLabel => 'Source';

  @override
  String get trainingProvenanceLabel => 'Content provenance';

  @override
  String get shadowPhaseSequenceLabel => 'Phase sequence';

  @override
  String get shadowMovementPathLabel => 'Movement and entry path';

  @override
  String get shadowMirrorGhostLabel => 'Mirror / Ghost presentation';

  @override
  String get shadowFrontSideLabel => 'Front / side presentation';

  @override
  String get shadowPaceLabel => 'Approved pace modes';

  @override
  String get shadowRepetitionTrackingLabel => 'Repetition tracking';

  @override
  String get shadowHistoryBoundaryLabel => 'History recording';

  @override
  String get conditioningMovementPatternLabel => 'Target movement pattern';

  @override
  String get conditioningCommonErrorLabel => 'Common execution error';

  @override
  String get bandAnchorLabel => 'Anchor location and height';

  @override
  String get bandDirectionLabel => 'Resistance / force direction';

  @override
  String get bandGripMappingLabel => 'Sleeve / lapel grip mapping';

  @override
  String get bandRotationPathLabel => 'Entry / rotation path';

  @override
  String get bandLegRolesLabel => 'Support-leg / attacking-leg roles';

  @override
  String get bandSafeDistanceLabel => 'Safe distance guidance';

  @override
  String get bandResistanceLevelLabel => 'Approved resistance level';

  @override
  String get bandDangerWarningLabel => 'Dangerous-error warning';

  @override
  String get trainingCapabilityEnabled =>
      'Available in reviewed educational content';

  @override
  String get trainingCapabilityDisabled => 'Not approved or unavailable';

  @override
  String trainingSetsValue(int count) {
    return '$count sets';
  }

  @override
  String trainingRepetitionsValue(int count) {
    return '$count repetitions';
  }

  @override
  String trainingDurationValue(int seconds) {
    return '$seconds seconds';
  }

  @override
  String trainingRestValue(int seconds) {
    return '$seconds seconds';
  }

  @override
  String trainingSessionsValue(int count) {
    return '$count sessions per week';
  }

  @override
  String get appName => 'Judo Mind';

  @override
  String get settings => 'Settings';

  @override
  String get settingsLanguageSectionTitle => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Choose the current app language. The selection applies immediately and is stored locally on this device.';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguagePersian => 'Persian (فارسی)';

  @override
  String get settingsLocalDataTitle => 'Local data & privacy';

  @override
  String get settingsLocalDataDescription =>
      'This local/demo foundation stores supported Athlete Profile and explicitly saved V2A History data only on this device. Cloud or federation synchronization is not available.';

  @override
  String settingsStoredHistoryCount(int count) {
    return 'Local validation history records: $count';
  }

  @override
  String get settingsHistoryUnavailable =>
      'Local validation history is unavailable or invalid. Existing data was not overwritten.';

  @override
  String get settingsHistoryEmpty =>
      'No local validation history records are stored.';

  @override
  String get settingsClearHistoryAction => 'Clear validation history';

  @override
  String get settingsClearHistoryConfirmTitle =>
      'Clear local validation history?';

  @override
  String get settingsClearHistoryConfirmDescription =>
      'This clears only saved Local Validation History records. Athlete Profile, language and other local preferences are preserved.';

  @override
  String get settingsHistoryCleared => 'Local validation history was cleared.';

  @override
  String get settingsHistoryClearFailed =>
      'Local validation history could not be cleared. Other local data was not changed.';

  @override
  String get settingsScientificBoundaryTitle =>
      'Scientific & capability transparency';

  @override
  String settingsV2aSupportedBoundary(String metricIds) {
    return 'Single-Attempt V2A validation is currently limited to the engineering metrics $metricIds. These metrics are not scientifically approved for definitive technique assessment.';
  }

  @override
  String get settingsReviewRequiredBoundary =>
      'A result requiring review remains pending until it is confirmed by a qualified human reviewer.';

  @override
  String get settingsMultiPersonBoundary =>
      'Multi-person evidence remains insufficient.';

  @override
  String get settingsInteractionBoundary =>
      'Interaction metrics remain non-reportable.';

  @override
  String get settingsUnavailableModulesBoundary =>
      'Unavailable modules remain unavailable and do not receive placeholder capabilities.';

  @override
  String get settingsApplicationInfoTitle => 'Application information';

  @override
  String get settingsApplicationNameLabel => 'Application';

  @override
  String get settingsApplicationStatusLabel => 'Current status';

  @override
  String get settingsApplicationStatusLocalDemo => 'Local/demo foundation';

  @override
  String get settingsAvailableLanguagesLabel => 'Available languages';

  @override
  String get settingsAvailableLanguagesValue => 'English and Persian';

  @override
  String get settingsStorageBoundaryLabel => 'Storage & privacy';

  @override
  String get settingsStorageBoundaryValue =>
      'Supported Profile and History data stay on this device; no cloud or federation synchronization is claimed.';

  @override
  String get cancel => 'Cancel';

  @override
  String get filter => 'Filter';

  @override
  String get loading => 'Loading...';

  @override
  String get startTraining => 'Start Training';

  @override
  String get techniques => 'Techniques';

  @override
  String get techniqueDetails => 'Technique Details';

  @override
  String get japaneseName => 'Japanese Name';

  @override
  String get classification => 'Classification';

  @override
  String get description => 'Description';

  @override
  String get technicalAnalysis => 'Technical Analysis';

  @override
  String get keyPoints => 'Key Points';

  @override
  String get commonMistakes => 'Common Mistakes';

  @override
  String get safetyTips => 'Safety Tips';

  @override
  String get executionSteps => 'Execution Steps';

  @override
  String get combinations => 'Combinations';

  @override
  String get counters => 'Counters';

  @override
  String get difficulty => 'Difficulty';

  @override
  String get beginner => 'Beginner';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get belt => 'Belt';

  @override
  String get category => 'Category';

  @override
  String get source => 'Source';

  @override
  String get officialMedia => 'Official Media';

  @override
  String get videoLibrary => 'Video Library';

  @override
  String get trainingVideo => 'Training Video';

  @override
  String get competitionAnalysis => 'Competition Analysis';

  @override
  String get quiz => 'Quiz';

  @override
  String get nextQuestion => 'Next Question';

  @override
  String get question => 'Question';

  @override
  String get yourScore => 'Your Score';

  @override
  String get quizCompleted => 'Quiz Completed';

  @override
  String get retakeQuiz => 'Retake Quiz';

  @override
  String get nageWaza => 'Nage-waza';

  @override
  String get katameWaza => 'Katame-waza';

  @override
  String get teWaza => 'Te-waza';

  @override
  String get koshiWaza => 'Koshi-waza';

  @override
  String get ashiWaza => 'Ashi-waza';

  @override
  String get maSutemiWaza => 'Ma-sutemi-waza';

  @override
  String get yokoSutemiWaza => 'Yoko-sutemi-waza';

  @override
  String get osaekomiWaza => 'Osaekomi-waza';

  @override
  String get shimeWaza => 'Shime-waza';

  @override
  String get kansetsuWaza => 'Kansetsu-waza';

  @override
  String get champions => 'Champions';

  @override
  String get ijfProfile => 'IJF Profile';

  @override
  String get competitionUsage => 'Competition Usage';

  @override
  String get tacticalIntelligence => 'Tactical Intelligence';

  @override
  String get gripStrategy => 'Grip Strategy';

  @override
  String get bodyPosition => 'Body Position';

  @override
  String get tacticalNotes => 'Tactical Notes';

  @override
  String get championsUsingTechnique => 'Champions Using This Technique';

  @override
  String get favorite => 'Favorite';

  @override
  String get training => 'Training';

  @override
  String get techniqueMastery => 'Technique Mastery';

  @override
  String get learningProgress => 'Learning Progress';

  @override
  String get theory => 'Theory';

  @override
  String get technique => 'Technique';

  @override
  String get competition => 'Competition';

  @override
  String get sensiBotRecommendation => 'Sensi Bot Recommendation';

  @override
  String get singleCameraPoseSummaryTitle => 'Single-Camera Pose Summary';

  @override
  String get experimentalPoseBaseline => 'experimental pose baseline';

  @override
  String get measuredVideoMetadataLabel => 'Video metadata · measured';

  @override
  String get modelEstimatedPoseCoverageLabel =>
      'Pose coverage · model-estimated';

  @override
  String get analyzedFramesLabel => 'Analyzed frames';

  @override
  String get atLeastOnePoseLabel => 'At least one pose detected';

  @override
  String get twoPosesLabel => 'Two poses detected';

  @override
  String get scientificConfidenceUnavailable =>
      'Scientific confidence is not available in this diagnostic slice. Coverage is not biomechanics confidence.';

  @override
  String get scientificLimitationsTitle => 'Scientific limitations';

  @override
  String get poseIdentityNotAvailable =>
      'Pose order is frame-local and does not establish persistent Tori or Uke identity.';

  @override
  String get phaseDetectionNotAvailable =>
      'Kuzushi, Tsukuri and Kake are not detected in this version.';

  @override
  String get singleCamera2dOnly =>
      'This single-camera result is not measured or reconstructed 3D.';

  @override
  String get forceTorqueNotAvailable =>
      'No real force, torque or laboratory-grade biomechanics is reported.';

  @override
  String get experimentalPoseLimitation =>
      'Pose coverage comes from an experimental model and is not a scientific confidence score.';

  @override
  String get runPoseAnalysis => 'Run 2D Pose Check';

  @override
  String get poseAnalysisRunning => 'Checking Pose Visibility...';

  @override
  String get singleAttemptV2ATitle => 'Single-Attempt Uchi Mata · Level 1';

  @override
  String get singleAttemptHumanReviewed =>
      'Tori, support leg, attacking leg and event boundaries · human-reviewed';

  @override
  String get singleAttemptProjected2d =>
      'Projected single-camera 2D — not reconstructed 3D';

  @override
  String get metricStatusReportable => 'Reportable';

  @override
  String get metricStatusReviewRequired => 'Review required';

  @override
  String get metricStatusWithheld => 'Withheld';

  @override
  String get metricConfidenceLabel => 'Model landmark visibility';

  @override
  String get metricConfidenceUnavailableLabel =>
      'Confidence evidence unavailable';

  @override
  String get blueOverlayTitle => 'Blue geometry layer';

  @override
  String get singleAttemptMultiPersonInsufficient =>
      'Multi-person evidence is insufficient. Interaction metrics remain unavailable and are not inferred.';

  @override
  String get reviewedWorkflowTitle => 'Manual reviewed Single-Attempt analysis';

  @override
  String get reviewedWorkflowDescription =>
      'Development reviewer workflow. Enter source-frame evidence and human-confirmed selections; nothing below is detected automatically.';

  @override
  String get reviewedEventSchema => 'Event schema';

  @override
  String get reviewedAttemptStartFrame => 'Attempt start frame';

  @override
  String get reviewedAttemptStartTimestamp => 'Attempt start timestamp (ms)';

  @override
  String get reviewedAttemptEndFrame => 'Attempt end frame';

  @override
  String get reviewedAttemptEndTimestamp => 'Attempt end timestamp (ms)';

  @override
  String get reviewedAngleFrame => 'Reviewed angle frame';

  @override
  String get reviewedAngleTimestamp => 'Reviewed angle timestamp (ms)';

  @override
  String get reviewedNeutralTrack =>
      'Human-confirmed neutral track (for example, Track A)';

  @override
  String get reviewedDetectionIndex => 'Frame-local detection index';

  @override
  String get reviewedSupportLeg => 'Human-confirmed support leg';

  @override
  String get reviewedAttackingLeg => 'Human-confirmed attacking leg';

  @override
  String get reviewedAngleEventLabel => 'Reviewed angle event label';

  @override
  String get reviewedProjectedViewSuitable => 'Projected-angle view suitable?';

  @override
  String get reviewedLowRoll => 'Low camera roll confirmed?';

  @override
  String get reviewedYes => 'Reviewed: yes';

  @override
  String get reviewedNo => 'Reviewed: no';

  @override
  String get reviewedInputRequired =>
      'Complete every required human-review field.';

  @override
  String get reviewedNonNegativeInteger => 'Enter a non-negative whole number.';

  @override
  String get reviewedNeutralTrackInvalid =>
      'Use a role-neutral label such as Track A; Tori/Uke are not track identities.';

  @override
  String get reviewedInputSequenceInvalid =>
      'The reviewed boundaries are inconsistent. End must follow start and the angle frame must be inside the attempt.';

  @override
  String get reviewedHumanGateNotice =>
      'The selected track is confirmed as Tori only for this reviewed event. Identity, phase and leg selection are not automatic.';

  @override
  String get runReviewedAnalysis => 'Run reviewed four-metric analysis';

  @override
  String get reviewedAnalysisRunning => 'Running selected-frame analysis...';

  @override
  String get reviewedAnalysisFailed =>
      'The reviewed Single-Attempt analysis failed safely.';

  @override
  String get saveAttemptLocally => 'Save locally';

  @override
  String get savingAttemptLocally => 'Saving locally...';

  @override
  String get attemptSavedOnDevice => 'Saved on this device';

  @override
  String get attemptAlreadySaved => 'Already saved';

  @override
  String get attemptSaveFailed => 'Could not save locally';

  @override
  String get localAttemptStorageDisclosure =>
      'Stores only this versioned engineering validation summary on this device. Video, file paths, overlays, scores and profile data are not stored.';

  @override
  String get athleteProfileTitle => 'Athlete Profile';

  @override
  String get localProfileDisclosureTitle => 'Local self-reported profile';

  @override
  String get localProfileDisclosure =>
      'This optional profile is stored only on this device and is self-reported. It is not a verified athlete identity, official rank or cloud account.';

  @override
  String get selfReportedProfileTitle => 'Optional profile details';

  @override
  String get selfReportedProfileDescription =>
      'All fields are optional, local and self-reported.';

  @override
  String get profileDisplayName => 'Display name';

  @override
  String get profileBeltRank => 'Belt rank';

  @override
  String get profileClub => 'Club';

  @override
  String get profileCountry => 'Country';

  @override
  String get profileBiography => 'Short biography';

  @override
  String profileFieldTooLong(int maxLength) {
    return 'Use no more than $maxLength characters.';
  }

  @override
  String get saveLocalProfile => 'Save local profile';

  @override
  String get localProfileSaved => 'Local profile saved on this device.';

  @override
  String get localProfileSaveFailed => 'Local profile was not saved.';

  @override
  String get localProfileStorageError =>
      'The local profile payload is unavailable or invalid. Existing data was not overwritten.';

  @override
  String get localAnalysisHistoryTitle => 'Local validation history';

  @override
  String get localAnalysisHistoryDisclosure =>
      'Only explicitly saved, versioned V2A engineering summaries are listed. Original status, provenance and limitations are preserved; no performance or mastery score is calculated.';

  @override
  String get localHistoryStorageError =>
      'The local history payload is unavailable or invalid. Existing data was not overwritten.';

  @override
  String get localHistoryEmptyTitle => 'No saved local validation results';

  @override
  String get localHistoryEmptyDescription =>
      'A reviewed V2A result appears here only after you explicitly save it on this device.';

  @override
  String get profileUnavailableFeaturesTitle =>
      'Progress and mastery unavailable';

  @override
  String get profileUnavailableFeaturesDescription =>
      'Official ranking, achievements, mastery, performance scoring, trends and cloud synchronization are not available in this local demo slice.';

  @override
  String savedLocalAnalysesCount(int count) {
    return 'Saved local validation results: $count';
  }

  @override
  String metricStatusCount(String status, int count) {
    return '$status: $count';
  }

  @override
  String savedLocallyAt(String date) {
    return 'Saved locally: $date';
  }

  @override
  String get analysisIdentifier => 'Analysis ID';

  @override
  String get analysisModeLabel => 'Analysis mode';

  @override
  String get multiPersonEvidenceLabel => 'Multi-person evidence';

  @override
  String get interactionMetricsLabel => 'Interaction metrics';

  @override
  String get availableLabel => 'Available';

  @override
  String get notAvailableLabel => 'Unavailable';

  @override
  String get notReportableLabel => 'Non-reportable';

  @override
  String get unknownLabel => 'Unknown';

  @override
  String get metricValueLabel => 'Value';

  @override
  String get metricStatusLabel => 'Status';

  @override
  String get metricProvenanceLabel => 'Provenance';

  @override
  String get metricMethodVersionLabel => 'Method version';

  @override
  String get metricConfidenceAvailabilityLabel => 'Confidence evidence';

  @override
  String get metricLimitationLabel => 'Limitation';

  @override
  String get metricWithheldReasonLabel => 'Withheld reason';

  @override
  String get localStorageUnavailableTitle => 'Local storage unavailable';

  @override
  String get retryLabel => 'Retry';

  @override
  String get learningDashboardTitle => 'Technique journeys';

  @override
  String get learningDashboardDescription =>
      'Learn, train, analyze, review local validation history and connect with a coach when product and privacy gates are complete.';

  @override
  String get journeyLearnTitle => 'Learn';

  @override
  String get journeyLearnDescription =>
      'Understand the technique through curated educational content and distinct learning artifacts.';

  @override
  String get journeyTrainTitle => 'Train';

  @override
  String get journeyTrainDescription =>
      'Use only available technique-specific practice and training experiences.';

  @override
  String get journeyAnalyzeTitle => 'Analyze';

  @override
  String get journeyAnalyzeDescription =>
      'Run bounded video analysis and review evidence-guided explanations.';

  @override
  String get journeyTrackProgressTitle => 'Track Progress';

  @override
  String get journeyTrackProgressDescription =>
      'Review local validation history without inventing scores or mastery.';

  @override
  String get journeyConnectCoachTitle => 'Connect with Coach';

  @override
  String get journeyConnectCoachDescription =>
      'Coach communication remains unavailable until its product and privacy gates are complete.';

  @override
  String get learnLabel => 'Learn';

  @override
  String get visualLabel => 'Visual';

  @override
  String get aiLabel => 'AI';

  @override
  String get singleAttemptAnalysisTitle => 'Single-Attempt Analysis';

  @override
  String get groundedSenseiTitle => 'Grounded Sensei';

  @override
  String get coachConnectionTitle => 'Coach connection';

  @override
  String get coachConnectionUnavailable =>
      'Coach communication is not available yet. No message or review request has been sent.';

  @override
  String get mistakeReviewPointLabel => 'Review point';

  @override
  String get safetyGuidanceItemLabel => 'Curated educational safety guidance';

  @override
  String get flowFromTechniqueLabel => 'Available options related to';

  @override
  String get continueLearningTitle => 'Continue your technique journey';

  @override
  String get continueLearningDescription =>
      'Use curated educational content, analyze one bounded attempt and review local validation history.';

  @override
  String get reviewedAnalysisBadge => 'Human-checked inputs';

  @override
  String analyzeTechnique(String techniqueName) {
    return 'Analyze $techniqueName';
  }

  @override
  String get addToFavorites => 'Add to favorites';

  @override
  String get removeFromFavorites => 'Remove from favorites';

  @override
  String get groundedSenseiDisclosure =>
      'Deterministic local explanation of the bounded V2A result produced from human-checked inputs. It is not open generative AI and adds no new measurement, inference or performance rating.';

  @override
  String get groundedSenseiBindingLabel => 'Bounded source binding';

  @override
  String groundedSenseiBindingValue(
    String analysisId,
    String schemaVersion,
    String trackId,
  ) {
    return 'Analysis $analysisId · schema $schemaVersion · $trackId';
  }

  @override
  String get groundedSenseiFindingLabel => 'Finding';

  @override
  String get groundedSenseiEvidenceLabel => 'Evidence';

  @override
  String get groundedSenseiWhyLabel => 'Why it matters';

  @override
  String get groundedSenseiOverlayLabel => 'BLUE overlay reference';

  @override
  String get groundedSenseiNextActionLabel => 'Next action';

  @override
  String get groundedSenseiSafetyLabel => 'Curated educational safety guidance';

  @override
  String get groundedSenseiLimitationsLabel => 'Binding scientific limitations';

  @override
  String get groundedSenseiLocalVersionLabel => 'Local explanation version';

  @override
  String get groundedSenseiMetricDuration => 'Selected-window elapsed time';

  @override
  String get groundedSenseiMetricTrunk => 'Projected trunk inclination';

  @override
  String get groundedSenseiMetricSupportKnee =>
      'Projected support-leg knee angle';

  @override
  String get groundedSenseiMetricAttackingKnee =>
      'Projected attacking-leg knee angle';

  @override
  String get groundedSenseiWhyDuration =>
      'Describes elapsed time only within one attempt selected and confirmed by the human reviewer; Judo Mind does not automatically detect attempts or technique phases.';

  @override
  String get groundedSenseiWhyTrunk =>
      'Describes image-plane trunk geometry at the human-selected frame; camera perspective affects interpretation.';

  @override
  String get groundedSenseiWhySupportKnee =>
      'Describes image-plane support-knee geometry at the human-selected frame; it is not joint load or injury-risk evidence.';

  @override
  String get groundedSenseiWhyAttackingKnee =>
      'Describes image-plane attacking-knee geometry at the human-selected frame; it is not three-dimensional motion evidence.';

  @override
  String groundedSenseiEvidenceValue(String value, String unit, String status) {
    return '$value $unit · original status: $status';
  }

  @override
  String get groundedSenseiEvidenceWithheld =>
      'The bounded result withheld this value. No replacement estimate is generated.';

  @override
  String get groundedSenseiSecondsUnit => 'seconds';

  @override
  String get groundedSenseiDegreesUnit => 'degrees';

  @override
  String get groundedSenseiOverlayAvailable =>
      'Available in the original BLUE result geometry.';

  @override
  String get groundedSenseiOverlayUnavailable =>
      'Unavailable in the bounded result; no geometry is fabricated.';

  @override
  String get groundedSenseiNoApprovedDrill =>
      'No metric-to-drill mapping has been approved. A drill recommendation is unavailable.';

  @override
  String get groundedSenseiSafetyUnavailable =>
      'Approved safety guidance is unavailable in the selected language.';

  @override
  String get groundedSenseiConfidenceAvailable =>
      'Original V2A keypoint-confidence evidence is preserved; no new confidence score is created.';

  @override
  String get groundedSenseiConfidenceUnavailable =>
      'Confidence evidence is unavailable for this metric; no confidence score is created.';

  @override
  String get groundedSenseiProvenanceMeasured => 'measured';

  @override
  String get groundedSenseiProvenanceModelEstimated => 'model-estimated';

  @override
  String get groundedSenseiLimitationHumanRole =>
      'The Tori role comes only from human review; it was not inferred.';

  @override
  String get groundedSenseiLimitationSupportLeg =>
      'The support leg comes only from human review; it was not inferred.';

  @override
  String get groundedSenseiLimitationPhase =>
      'Technique phases are not automatically detected.';

  @override
  String get groundedSenseiLimitationProjected =>
      'Angle findings are projected single-camera 2D, not reconstructed 3D.';

  @override
  String get groundedSenseiLimitationPerspective =>
      'Camera perspective can change projected angle interpretation.';

  @override
  String get groundedSenseiLimitationKinetics =>
      'Force, torque, power, moment, load and OpenSim outputs are unavailable.';

  @override
  String get groundedSenseiLimitationDescriptive =>
      'The explanation is descriptive only and does not classify performance or mastery.';

  @override
  String groundedSenseiLimitationOther(String code) {
    return 'The validated result retains limitation: $code';
  }

  @override
  String get groundedSenseiMultiPersonBoundary =>
      'Multi-person evidence remains insufficient. Interaction findings are unavailable and are not inferred.';

  @override
  String get groundedSenseiUnavailable =>
      'Grounded Sensei is unavailable because the human-checked input binding or bounded contract could not be verified. The original bounded result remains available.';

  @override
  String get homeHeroTitle => 'Your Judo journey starts here';

  @override
  String get homeHeroDescription =>
      'Learn curated educational technique content, analyze one bounded attempt with human-checked inputs and revisit local validation results.';

  @override
  String get exploreTechniques => 'Explore Techniques';

  @override
  String get homeJourneysTitle => 'What do you want to do?';

  @override
  String get homeJourneysDescription =>
      'Choose one of Judo Mind\'s five athlete journeys. Unfinished journeys remain visible and honestly unavailable.';

  @override
  String get homeJourneyLearnDescription =>
      'Explore the available 67-technique catalog, beginning with the Uchi Mata Gold Reference.';

  @override
  String get homeJourneyTrainUnavailable =>
      'Technique-specific training is visible but unavailable until its content, prescription and safety evidence complete review.';

  @override
  String get homeJourneyAnalyzeDescription =>
      'Open the bounded Single-Attempt Uchi Mata V1/V2A engineering workflow with human-checked inputs.';

  @override
  String get homeJourneyTrackProgressDescription =>
      'Open local validation history containing versioned engineering summaries without creating a progress score.';

  @override
  String get homeJourneyCoachUnavailable =>
      'Coach communication is visible but unavailable until product, privacy and federation gates are complete.';

  @override
  String get continueSectionTitle => 'Continue';

  @override
  String get continueUchiMata => 'Continue learning Uchi Mata';

  @override
  String get reviewLocalAnalysisHistory => 'Review local validation history';

  @override
  String get exploreAllCapabilities => 'Explore all capabilities';

  @override
  String get moduleDirectoryTitle => 'Platform overview';

  @override
  String get moduleStatusAvailable => 'Available';

  @override
  String get moduleStatusFoundationPartial => 'Foundation / partial';

  @override
  String get moduleStatusUnavailableDeferred => 'Unavailable / deferred';

  @override
  String get moduleNoApprovedDestination =>
      'No available destination is ready yet.';

  @override
  String get moduleSensiBetDeferredReason =>
      'Deferred pending legal, age, ethical and federation-brand review.';

  @override
  String get surfaceAthleteApp => 'Athlete App';

  @override
  String get surfaceCoachWorkspace => 'Coach Workspace';

  @override
  String get surfaceClubFederationConsole => 'Club / Federation Console';

  @override
  String get surfaceJudoIntelligenceCore => 'Judo Intelligence Core';

  @override
  String get moduleHomeTitle => 'Home';

  @override
  String get moduleTechniquesTitle => 'Techniques — 67 Techniques';

  @override
  String get moduleSensiBotTitle => 'Sensi Bot';

  @override
  String get moduleSensiBetTitle => 'Sensi Bet';

  @override
  String get moduleMonitoringTitle => 'Monitoring / Progress & Mastery';

  @override
  String get moduleAudioCastTitle => 'AudioCast';

  @override
  String get moduleAthleteProfileTitle => 'Athlete Profile';

  @override
  String get moduleTrainingCenterTitle => 'Training Center';

  @override
  String get moduleChampionsHubTitle => 'Champions Hub';

  @override
  String get moduleCompetitionsTitle => 'Competitions & Challenges';

  @override
  String get moduleNewsTitle => 'News';

  @override
  String get moduleStoreSubscriptionsTitle => 'Store & Subscriptions';

  @override
  String get moduleClubAdministrationTitle => 'Club Administration';

  @override
  String get moduleCoachForumTitle => 'Coach Forum';

  @override
  String get moduleOnlineCoursesTitle => 'Online Courses';

  @override
  String get moduleCountryJudoHistoryTitle => 'Country Judo History';

  @override
  String get moduleAppManagementSettingsTitle => 'App Management & Settings';

  @override
  String get moduleTrainingProgramValidatorTitle =>
      'Training Program Validator';

  @override
  String get viewLatestAnalysis => 'View latest analysis';

  @override
  String exploreReferenceTechnique(String techniqueName) {
    return 'Explore $techniqueName';
  }

  @override
  String get homeAnalyzeUchiMataTitle => 'Analyze Uchi Mata';

  @override
  String get moduleDirectorySurfaceTitle => 'Explore by platform';

  @override
  String get moduleDirectoryAllSurfaces => 'All surfaces';

  @override
  String get moduleAvailableDestinationsTitle => 'Available now';

  @override
  String get moduleNoAvailableDestinationForSurface =>
      'No available destination is ready on this surface yet.';

  @override
  String get moduleCurrentDestination => 'Current destination';

  @override
  String get moduleUnavailableDeferredTitle => 'Coming later';

  @override
  String moduleUnavailableDeferredSummary(int count) {
    return '$count official modules are coming later';
  }

  @override
  String get progressOverviewTitle => 'Scientific progress evidence';

  @override
  String get progressOverviewDisclosure =>
      'This local foundation summarizes only saved, versioned V2A evidence. It does not calculate mastery, performance, ranking or improvement.';

  @override
  String get progressNoEvidenceTitle => 'No saved progress evidence';

  @override
  String get progressNoEvidenceDescription =>
      'Save a supported reviewed Uchi Mata V2A result before an evidence summary can be shown.';

  @override
  String get progressInvalidEvidenceTitle => 'Progress evidence withheld';

  @override
  String get progressInvalidEvidenceDescription =>
      'Stored evidence is missing, malformed or outside the approved V2A boundary. Counts and comparisons are withheld.';

  @override
  String get progressIncompatibleEvidenceTitle =>
      'Incompatible metric versions';

  @override
  String get progressIncompatibleEvidenceDescription =>
      'Stored metric versions are not compatible. Judo Mind will not compare or combine them.';

  @override
  String get progressSavedAttempts => 'Saved attempts';

  @override
  String get progressCompletedRecords => 'Completed records';

  @override
  String get progressLatestSaved => 'Latest saved analysis';

  @override
  String get progressMetricEvidenceTitle => 'Metric evidence status';

  @override
  String get progressTechniqueVersionTitle =>
      'Technique and method-version context';

  @override
  String get progressTechniqueLabel => 'Technique';

  @override
  String get progressNoVersionComparison =>
      'Versions are displayed as evidence context only; metric values are not compared and no trend is inferred.';

  @override
  String get progressScientificBoundariesTitle => 'Scientific boundaries';

  @override
  String get progressReviewRequiredBoundary =>
      'UM-ANG-001 remains pending human review and is never upgraded automatically.';

  @override
  String get progressMultiPersonBoundary =>
      'Multi-person evidence remains insufficient.';

  @override
  String get progressInteractionBoundary =>
      'Interaction metrics remain non-reportable.';

  @override
  String get progressMasteryUnavailableTitle => 'Mastery is unavailable';

  @override
  String get progressMasteryUnavailableDescription =>
      'A scientifically validated mastery, score, ranking, readiness or proficiency system has not been implemented.';

  @override
  String get progressOpenHistory => 'Open local validation history';

  @override
  String get progressTimelineTitle => 'Saved evidence timeline';

  @override
  String get uchiMata => 'Uchi Mata';

  @override
  String techniqueCatalogAvailabilitySummary(
    int availableCount,
    int roadmapCount,
  ) {
    return '$availableCount technique available now · $roadmapCount-technique roadmap';
  }

  @override
  String techniqueCatalogPreviewSummary(int count) {
    return '$count incomplete previews are visible but unavailable';
  }

  @override
  String get techniquePreviewUnavailable =>
      'Preview only · full experience unavailable';

  @override
  String get visualLayerMovement => 'Movement';

  @override
  String get visualLayerControl => 'Control';

  @override
  String get visualLayerIllustrativeDirection => 'Illustrative direction';

  @override
  String get uchiMataBiomechanicsVisualizationTitle =>
      'Uchi Mata movement visualization';

  @override
  String get uchiMataBiomechanicsVisualizationDescription =>
      'Explore posture, illustrative direction, balance and body-position concepts throughout the throw.';

  @override
  String get educationalVisualizationNotMeasurement =>
      'Educational visualization — not a measurement';

  @override
  String get sourceGeneralReferenceDisclosure =>
      'These are organization homepages and general references, not technique-specific direct evidence.';

  @override
  String get clubAdministrationTitle => 'Club administration';

  @override
  String get clubLocalFoundationNotice =>
      'Information in this section is currently stored only on this device. Cloud sync, multi-user access and official verification are not available.';

  @override
  String get clubEmptyTitle => 'No local club yet';

  @override
  String get clubEmptyDescription =>
      'Create one local club to organize the current local athlete, a training group, sessions and attendance on this device.';

  @override
  String get clubCreateAction => 'Register club';

  @override
  String get clubEditAction => 'Edit club';

  @override
  String get clubNameLabel => 'Club name';

  @override
  String get clubDescriptionLabel => 'Optional description';

  @override
  String get clubSaveAction => 'Save club';

  @override
  String get clubSaveFailed => 'The local club could not be saved.';

  @override
  String get clubStorageInvalidTitle => 'Club records are unavailable';

  @override
  String get clubStorageInvalidDescription =>
      'Stored club data is malformed or incompatible. It was not treated as valid or overwritten.';

  @override
  String get clubDashboardTitle => 'Local overview';

  @override
  String clubMembersCount(String count) {
    return 'Athletes: $count';
  }

  @override
  String clubGroupsCount(String count) {
    return 'Groups: $count';
  }

  @override
  String clubSessionsCount(String count) {
    return 'Sessions: $count';
  }

  @override
  String clubAttendanceCount(String count) {
    return 'Attendance records: $count';
  }

  @override
  String get clubRosterTitle => 'Club athletes';

  @override
  String get clubRosterEmpty => 'No athlete is linked to this local club.';

  @override
  String get clubLinkCurrentAthlete => 'Add current profile to club';

  @override
  String get clubCurrentAthleteFallback => 'Current local athlete';

  @override
  String get clubCurrentAthleteLinked =>
      'Linked to the current Athlete Profile';

  @override
  String get clubMembershipNumberLabel => 'Optional membership number';

  @override
  String get clubAthleteLinkLimitation =>
      'This foundation can link only the current local Athlete Profile. Additional athletes and verified identities are not available.';

  @override
  String get clubGroupsTitle => 'Training groups';

  @override
  String get clubGroupEmpty => 'No training group has been created.';

  @override
  String get clubGroupCreateAction => 'Add group';

  @override
  String get clubGroupNameLabel => 'Group name';

  @override
  String get clubGroupDescriptionLabel => 'Optional group description';

  @override
  String get clubGroupAssignCurrentAthlete =>
      'Add current athlete to this group';

  @override
  String clubGroupMemberCount(String count) {
    return 'Assigned members: $count';
  }

  @override
  String get clubSessionsTitle => 'Training sessions';

  @override
  String get clubSessionEmpty => 'No training session has been created.';

  @override
  String get clubSessionCreateAction => 'Add session';

  @override
  String get clubSessionGroupLabel => 'Training group';

  @override
  String get clubSessionScheduledLabel => 'Scheduled';

  @override
  String get clubSessionDurationLabel => 'Optional duration in minutes';

  @override
  String clubSessionDurationValue(String count) {
    return '$count minutes';
  }

  @override
  String get clubAttendanceTitle => 'Attendance';

  @override
  String get clubAttendancePresent => 'Present';

  @override
  String get clubAttendanceAbsent => 'Absent';

  @override
  String get clubAttendanceExcused => 'Excused';

  @override
  String get clubAttendanceNotRecorded => 'Not recorded';

  @override
  String get clubOperationFailed => 'The local change could not be saved.';

  @override
  String get clubRequiredField => 'This field is required.';

  @override
  String get clubInvalidDuration => 'Enter a whole number from 1 to 1440.';

  @override
  String get clubCreateGroupFirst =>
      'Create a training group before adding a session.';

  @override
  String get clubSavedFeedback => 'Club changes were saved on this device.';

  @override
  String get clubAthleteLinkedFeedback =>
      'The current profile was added to the club.';

  @override
  String get clubGroupSavedFeedback => 'Training group was saved.';

  @override
  String get clubSessionSavedFeedback => 'Session plan was saved.';

  @override
  String get clubAttendanceSavedFeedback => 'Attendance was saved.';

  @override
  String get clubSessionEditAction => 'Edit session plan';

  @override
  String get clubSessionTypeLabel => 'Session type';

  @override
  String get clubSessionTypeRequired => 'Select a session type.';

  @override
  String get clubSessionTitleLabel => 'Optional session title';

  @override
  String get clubSessionObjectiveLabel => 'Optional objective';

  @override
  String get clubSessionTypeJudoTechnical => 'Judo technical';

  @override
  String get clubSessionTypeRandori => 'Randori';

  @override
  String get clubSessionTypeTactical => 'Tactical';

  @override
  String get clubSessionTypePhysicalPreparation => 'Physical preparation';

  @override
  String get clubSessionTypeRecovery => 'Recovery';

  @override
  String get clubSessionTypeAssessment => 'Assessment';

  @override
  String get clubSessionTypeMixed => 'Mixed';

  @override
  String get clubSessionTypeOther => 'Other';

  @override
  String get clubSessionTypeUnspecifiedLegacy => 'Type not specified';

  @override
  String get clubLegacySessionTypeNotice =>
      'This migrated session has no recorded type. Select a type before saving changes.';

  @override
  String get clubSessionItemsTitle => 'Planned session items';

  @override
  String get clubSessionItemsEmpty => 'No plan items were added.';

  @override
  String get clubSessionItemsOptional =>
      'Plan items are optional and coach-authored. They do not confirm that an athlete completed them.';

  @override
  String get clubSessionAddItemAction => 'Add plan item';

  @override
  String get clubSessionEditItemAction => 'Edit item';

  @override
  String get clubSessionRemoveItemAction => 'Remove item';

  @override
  String get clubSessionMoveItemUp => 'Move item up';

  @override
  String get clubSessionMoveItemDown => 'Move item down';

  @override
  String get clubSessionItemTypeLabel => 'Activity category';

  @override
  String get clubSessionCustomTitleLabel => 'Coach-authored item title';

  @override
  String get clubSessionCoachAuthoredDisclosure =>
      'Coach-authored item — not an approved exercise-library prescription.';

  @override
  String get clubSessionItemWarmUp => 'Warm-up';

  @override
  String get clubSessionItemUkemi => 'Ukemi';

  @override
  String get clubSessionItemTechnicalInstruction => 'Technical instruction';

  @override
  String get clubSessionItemUchikomi => 'Uchikomi';

  @override
  String get clubSessionItemNagekomi => 'Nagekomi';

  @override
  String get clubSessionItemGripFighting => 'Grip fighting / kumi-kata';

  @override
  String get clubSessionItemTachiWaza => 'Tachi-waza';

  @override
  String get clubSessionItemNeWaza => 'Ne-waza';

  @override
  String get clubSessionItemRandori => 'Randori';

  @override
  String get clubSessionItemTacticalPractice => 'Tactical practice';

  @override
  String get clubSessionItemCoolDown => 'Cool-down';

  @override
  String get clubSessionItemPhysicalConditioningCustom =>
      'Physical-conditioning custom item';

  @override
  String get clubSessionItemCustomCoachAuthored => 'Custom coach-authored item';

  @override
  String get clubSessionDosageModeLabel => 'Dosage format';

  @override
  String get clubSessionDosageDuration => 'Duration';

  @override
  String get clubSessionDosageRepetitions => 'Repetitions';

  @override
  String get clubSessionDosageSetsRepetitions => 'Sets × repetitions';

  @override
  String get clubSessionDosageRoundsDuration => 'Rounds × duration';

  @override
  String get clubSessionDosageDistance => 'Distance';

  @override
  String get clubSessionDosageDescriptive => 'Descriptive / custom';

  @override
  String get clubSessionDurationMinutesField => 'Duration in minutes';

  @override
  String get clubSessionRepetitionsField => 'Repetitions';

  @override
  String get clubSessionSetsField => 'Sets';

  @override
  String get clubSessionRoundsField => 'Rounds';

  @override
  String get clubSessionRoundDurationField => 'Minutes per round';

  @override
  String get clubSessionDistanceMetersField => 'Distance in metres';

  @override
  String get clubSessionDosageDescriptionField =>
      'Coach-entered dosage description';

  @override
  String get clubSessionRestSecondsField => 'Optional rest in seconds';

  @override
  String get clubSessionCoachNotesField => 'Optional coach notes';

  @override
  String get clubSessionSaveItemAction => 'Save item';

  @override
  String get clubSessionPositiveNumberError => 'Enter a positive number.';

  @override
  String get clubSessionNonNegativeNumberError =>
      'Enter zero or a positive whole number.';

  @override
  String get clubSessionMeaningfulTextError =>
      'Enter meaningful coach-authored text.';

  @override
  String clubSessionDosageDurationValue(String value) {
    return '$value min';
  }

  @override
  String clubSessionDosageRepetitionsValue(String value) {
    return '$value repetitions';
  }

  @override
  String clubSessionDosageSetsValue(String sets, String repetitions) {
    return '$sets × $repetitions';
  }

  @override
  String clubSessionDosageRoundsValue(String rounds, String duration) {
    return '$rounds rounds × $duration min';
  }

  @override
  String clubSessionDosageDistanceValue(String value) {
    return '$value m';
  }

  @override
  String clubSessionRestValue(String value) {
    return 'Rest: $value sec';
  }

  @override
  String get clubSessionAddNextItemAction => 'Add next section';

  @override
  String get clubSessionDuplicateItemAction => 'Duplicate section';

  @override
  String get clubSessionSavePlanAction => 'Save session plan';

  @override
  String get clubSessionItemIncomplete => 'Incomplete dosage';

  @override
  String get clubSessionPlanItemValidationError =>
      'Complete the required fields in this section before saving.';

  @override
  String get clubSessionLiveSummaryTitle => 'Live plan summary';

  @override
  String clubSessionSummarySections(String count) {
    return 'Planned sections: $count';
  }

  @override
  String clubSessionSummaryScheduledDuration(String value) {
    return 'Scheduled duration: $value min';
  }

  @override
  String get clubSessionSummaryTimeUnavailable =>
      'Scheduled duration: not entered';

  @override
  String clubSessionSummaryCalculableTime(String value) {
    return 'Calculable planned activity time: $value min';
  }

  @override
  String clubSessionSummaryCalculablePartial(String value) {
    return 'Calculable planned activity time: $value min (partial)';
  }

  @override
  String get clubSessionSummaryCalculableUnavailable =>
      'Calculable planned activity time: unavailable';

  @override
  String get clubSessionUnsavedChangesTitle => 'Unsaved changes';

  @override
  String get clubSessionUnsavedChangesDescription =>
      'Discard the unsaved session plan changes?';

  @override
  String get clubSessionDiscardChangesAction => 'Discard changes';

  @override
  String get clubSessionContinueEditingAction => 'Continue editing';

  @override
  String get exerciseLibraryTitle => 'Exercise Library';

  @override
  String get exerciseLibraryOpenAction => 'Open Exercise Library';

  @override
  String get exerciseLibraryDescription =>
      'Build a reusable local library for Club session planning.';

  @override
  String get exerciseLibraryStorageFailure =>
      'The local exercise library could not be read safely.';

  @override
  String get exerciseLibraryEmptyTitle => 'No local exercises yet';

  @override
  String get exerciseApprovedLibraryEmptyDisclosure =>
      'The approved repository is empty. No exercise is shown as approved without review evidence.';

  @override
  String get exerciseFilteredEmpty => 'No exercises match these filters.';

  @override
  String get exerciseSearchLabel => 'Search exercises';

  @override
  String get exerciseCategoryFilterLabel => 'Activity category';

  @override
  String get exerciseSourceFilterLabel => 'Source';

  @override
  String get exerciseReviewFilterLabel => 'Review status';

  @override
  String get filterAll => 'All';

  @override
  String get exerciseCreateAction => 'Create coach exercise';

  @override
  String get exerciseEditAction => 'Edit';

  @override
  String get exerciseArchiveAction => 'Archive';

  @override
  String get exerciseUnarchiveAction => 'Restore';

  @override
  String get exerciseArchived => 'Archived';

  @override
  String get exerciseApprovedBadge => 'Approved repository';

  @override
  String get exerciseCoachAuthoredBadge => 'Coach-authored';

  @override
  String get exerciseCoachAuthoredDisclosure =>
      'Coach-authored — not scientifically reviewed';

  @override
  String get exerciseSavedFeedback => 'Exercise saved locally.';

  @override
  String get exerciseNameEn => 'English name';

  @override
  String get exerciseNameFa => 'Persian name';

  @override
  String get exerciseDescriptionEn => 'English description (optional)';

  @override
  String get exerciseDescriptionFa => 'Persian description (optional)';

  @override
  String get exerciseModalityLabel => 'Exercise modality';

  @override
  String get exerciseSupportedDosageModes => 'Coach-entered dosage modes';

  @override
  String get exerciseReviewApproved => 'Approved';

  @override
  String get exerciseReviewRequired => 'Review required';

  @override
  String get exerciseReviewNotScientific => 'Not scientifically reviewed';

  @override
  String get exerciseModalityFreeWeight => 'Free weight';

  @override
  String get exerciseModalityMachine => 'Machine';

  @override
  String get exerciseModalityBodyweight => 'Bodyweight';

  @override
  String get exerciseModalityConditioning => 'Physical conditioning';

  @override
  String get exerciseModalityBand => 'Resistance band';

  @override
  String get exerciseModalityShadow => 'Shadow training';

  @override
  String get exerciseModalityMobility => 'Mobility / recovery';

  @override
  String get exerciseModalityJudoDrill => 'Judo-specific drill';

  @override
  String get exerciseModalityOther => 'Other';

  @override
  String get exerciseSaveAction => 'Save exercise';

  @override
  String get exerciseChooseFromLibraryAction => 'Choose from Exercise Library';

  @override
  String get exerciseWriteManuallyAction => 'Write manually';

  @override
  String get exerciseLibrarySelectionTitle => 'Choose an exercise';

  @override
  String get exerciseLibrarySelectionEmpty =>
      'No active exercise is available. Create a coach-authored entry in the Exercise Library first.';

  @override
  String exerciseLinkedReference(String revision) {
    return 'Linked library snapshot · revision $revision';
  }

  @override
  String get exerciseImportCsvAction => 'Import CSV';

  @override
  String get exerciseMoreFilters => 'More filters';

  @override
  String get exerciseRecentTitle => 'Recently selected';

  @override
  String get exerciseFavoritesTitle => 'Favorites';

  @override
  String get exerciseResultsTitle => 'Results';

  @override
  String exerciseFavoritesFilter(String count) {
    return 'Favorites ($count)';
  }

  @override
  String exerciseRecentFilter(String count) {
    return 'Recent ($count)';
  }

  @override
  String get exerciseFavoritesEmpty =>
      'No exercises have been added to favorites yet.';

  @override
  String get exerciseRecentEmpty =>
      'No exercise has been selected recently yet.';

  @override
  String get exerciseTranslationUnavailable =>
      'Translation unavailable in the selected language';

  @override
  String get exerciseAddFavorite => 'Add to favorites';

  @override
  String get exerciseRemoveFavorite => 'Remove from favorites';

  @override
  String get exerciseImportPreviewTitle => 'Review CSV import';

  @override
  String exerciseImportTotal(String count) {
    return 'Rows: $count';
  }

  @override
  String exerciseImportValid(String count) {
    return 'Valid: $count';
  }

  @override
  String exerciseImportInvalid(String count) {
    return 'Invalid: $count';
  }

  @override
  String exerciseImportDuplicates(String count) {
    return 'Duplicates: $count';
  }

  @override
  String exerciseImportFileError(String code) {
    return 'File error: $code';
  }

  @override
  String exerciseImportRowError(String row, String errors) {
    return 'Row $row: $errors';
  }

  @override
  String get exerciseImportConfirmAction => 'Import valid rows';

  @override
  String exerciseImportSaved(String count) {
    return 'Imported $count exercises locally.';
  }

  @override
  String get exerciseImportIssueEmptyFile => 'The file is empty';

  @override
  String get exerciseImportIssueInvalidUtf8 => 'The file is not valid UTF-8';

  @override
  String get exerciseImportIssueMalformedCsv => 'Malformed CSV row or quoting';

  @override
  String get exerciseImportIssueHeader =>
      'The canonical header is missing or changed';

  @override
  String get exerciseImportIssueSchema => 'Unsupported schema version';

  @override
  String get exerciseImportIssueMissingId => 'Exercise ID is required';

  @override
  String get exerciseImportIssueDuplicateFile =>
      'Exercise ID is duplicated in this file';

  @override
  String get exerciseImportIssueDuplicateStored =>
      'Exercise ID already exists locally';

  @override
  String get exerciseImportIssueLocale => 'Authoring language must be en or fa';

  @override
  String get exerciseImportIssueName =>
      'The authoring-language name is required';

  @override
  String get exerciseImportIssueCategory => 'Unsupported activity category';

  @override
  String get exerciseImportIssueModality => 'Unsupported exercise modality';

  @override
  String get exerciseImportIssueDosage => 'Unsupported or missing dosage mode';

  @override
  String get exerciseImportIssueUrl =>
      'Source URL must be a direct HTTP(S) page';

  @override
  String get exerciseImportIssueMediaLicense =>
      'Unsupported media-license declaration';

  @override
  String get exerciseImportIssueMediaDeclaration =>
      'Media requires an owned-or-licensed declaration';

  @override
  String get exerciseImportIssueRecord =>
      'Record violates the Exercise Library contract';

  @override
  String get scientificTransparencyTitle => 'Scientific status';

  @override
  String get scientificTransparencyStatusIconLabel =>
      'Scientific status information';

  @override
  String get scientificTransparencyHumanReviewPending => 'Human review pending';

  @override
  String get scientificTransparencyNoApproval =>
      'No scientific approval has been issued';

  @override
  String get scientificTransparencyVideoValidationOnly =>
      'Video analysis: validation only';

  @override
  String get scientificTransparencySensitiveLocked =>
      'Sensitive capabilities: locked';

  @override
  String get scientificTransparencyNotReviewed => 'Not scientifically reviewed';

  @override
  String get scientificTransparencyViewDetails =>
      'View sources and limitations';

  @override
  String get scientificTransparencyDetailsTitle => 'Sources and limitations';

  @override
  String get scientificTransparencyCurrentStatusSection =>
      'Current scientific status';

  @override
  String get scientificTransparencyCandidateCoverageSection =>
      'Candidate source coverage';

  @override
  String get scientificTransparencyHumanReviewSection => 'Human-review status';

  @override
  String get scientificTransparencyVideoLimitationsSection =>
      'Video-analysis limitations';

  @override
  String get scientificTransparencySafetyBoundarySection => 'Safety boundary';

  @override
  String get scientificTransparencyDoesNotDoSection =>
      'What this feature does not do';

  @override
  String get scientificTransparencyHumanReviewLabel => 'Human review';

  @override
  String get scientificTransparencyApprovalLabel => 'Scientific approval';

  @override
  String get scientificTransparencyCandidateSource => 'Candidate source';

  @override
  String get scientificTransparencyReviewPending => 'Review pending';

  @override
  String get scientificTransparencyNotApprovedForClaim =>
      'Not yet approved for a Judo Mind claim';

  @override
  String get scientificTransparencyHumanReviewDescription =>
      'All five candidate sources are awaiting qualified human review. No source review is complete.';

  @override
  String get scientificTransparencyMissingDataLocked =>
      'The governed display data is missing or invalid. This information remains locked and not scientifically reviewed.';

  @override
  String get scientificTransparencyCapabilityPanelTitle => 'Capability status';

  @override
  String get scientificTransparencyStatusNotReviewed =>
      'Not scientifically reviewed';

  @override
  String get scientificTransparencyStatusHumanReviewPending =>
      'Human review pending';

  @override
  String get scientificTransparencyStatusReviewRequired => 'Review required';

  @override
  String get scientificTransparencyStatusValidationOnly => 'Validation only';

  @override
  String get scientificTransparencyStatusLocked => 'Locked';

  @override
  String get scientificTransparencyStatusFullTextRequired =>
      'Full text required';

  @override
  String get scientificTransparencyStatusMethodBlocked => 'Method blocked';

  @override
  String get scientificTransparencyStatusSourceMappingRequired =>
      'Source mapping required';

  @override
  String get scientificTransparencyStatusNotApplicable => 'Not applicable';

  @override
  String get scientificTransparencySourceTypeConsensus => 'Consensus statement';

  @override
  String get scientificTransparencySourceTypeSystematicReview =>
      'Systematic review';

  @override
  String get scientificTransparencySourceTypeMetaAnalysis => 'Meta-analysis';

  @override
  String get scientificTransparencySourceTypeSystematicReviewMetaAnalysis =>
      'Systematic review and meta-analysis';

  @override
  String get scientificTransparencyAccessPublicFullText =>
      'Public full text identified';

  @override
  String get scientificTransparencyAccessValidatedRepository =>
      'Validated repository copy';

  @override
  String get scientificTransparencyAccessAcceptedManuscript =>
      'Validated accepted manuscript';

  @override
  String get scientificTransparencyAccessPublisherVersion =>
      'Validated publisher version';

  @override
  String get scientificTransparencyCapabilityPoseSummary =>
      'Single-camera pose summary';

  @override
  String get scientificTransparencyCapabilityReviewedAttempt =>
      'Human-reviewed single attempt';

  @override
  String get scientificTransparencyCapabilityProjectedMetrics =>
      'Projected 2D metrics';

  @override
  String get scientificTransparencyCapabilityProjectedHipAngle =>
      'Projected attacking-leg hip angle';

  @override
  String get scientificTransparencyCapabilityAutomaticIdentity =>
      'Automatic athlete identity';

  @override
  String get scientificTransparencyCapabilityAutomaticPhases =>
      'Automatic Kuzushi / Tsukuri / Kake phases';

  @override
  String get scientificTransparencyCapabilityThreeDimensional =>
      '3D reconstruction';

  @override
  String get scientificTransparencyCapabilityForceKinetics =>
      'Force and kinetics from ordinary video';

  @override
  String get scientificTransparencyCapabilityTrainingPrescription =>
      'Training prescription activation';

  @override
  String get scientificTransparencyUnknownCapability =>
      'Unmapped sensitive capability';

  @override
  String get scientificTransparencyLimitationEngineering =>
      'Pose estimation provides engineering observations only.';

  @override
  String get scientificTransparencyLimitationNoForce =>
      'It does not directly measure force or kinetics.';

  @override
  String get scientificTransparencyLimitationNoThreeDimensional =>
      'It is not validated as definitive 3D biomechanical analysis.';

  @override
  String get scientificTransparencyLimitationNoDiagnosis =>
      'It does not diagnose technical errors or injury.';

  @override
  String get scientificTransparencyLimitationNoInjuryPrediction =>
      'It does not predict injury.';

  @override
  String get scientificTransparencyLimitationNoReferee =>
      'It does not make referee decisions.';

  @override
  String get scientificTransparencyLimitationAssociation =>
      'A statistical association must not be presented as causation.';

  @override
  String get scientificTransparencyLimitationRisk =>
      'A risk indicator must not be presented as a certain prediction.';

  @override
  String get scientificTransparencyLimitationMissingEvidence =>
      'Missing evidence or approval keeps sensitive features locked.';

  @override
  String get scientificTransparencySafetyBoundaryDescription =>
      'This information is educational and read-only. It does not replace a qualified coach, clinician, sports-medicine professional or referee.';

  @override
  String get scientificTransparencyDoesNotDoDescription =>
      'This feature does not score performance, diagnose injury, prescribe training, predict outcomes, make referee decisions or enable locked scientific and AI capabilities.';

  @override
  String get guidedReviewTitle => 'Guided human review';

  @override
  String get guidedReviewDescription =>
      'Choose and visually confirm exact decoded start/end frames and one review frame. Detection indices remain internal.';

  @override
  String get guidedAttemptStart => 'Attempt start';

  @override
  String get guidedAttemptEnd => 'Attempt end';

  @override
  String get guidedAttemptStartFrame => 'Attempt start frame';

  @override
  String get guidedAttemptEndFrame => 'Attempt end frame';

  @override
  String get guidedPreviousFrame => 'Step one frame backward';

  @override
  String get guidedNextFrame => 'Step one frame forward';

  @override
  String get guidedConfirmAttemptBoundaries =>
      'I confirm these frames bound the intended attempt';

  @override
  String get guidedSingleAttemptCaptureGuidance =>
      'For best results, upload one technique attempt. If the video contains several attempts, select only one continuous attempt for each analysis.';

  @override
  String guidedConfirmSingleAttempt(String techniqueName) {
    return 'I confirm this selected interval contains one continuous $techniqueName attempt only.';
  }

  @override
  String get guidedBoundaryVisualReview =>
      'Inspect the start and end frames in the video preview before confirming.';

  @override
  String get guidedSourceTiming => 'Source timing';

  @override
  String get guidedSourceRealTime => 'Real-time video';

  @override
  String get guidedSourceTimingUnknown => 'Timing unknown';

  @override
  String get guidedSourceTimingRequired =>
      'Select a supported source timing state. Known time-scale entry is not available in this bounded UI yet.';

  @override
  String get guidedLoadFrames => 'Load decoded frames';

  @override
  String guidedTimingEvidence(String mode, String provenance) {
    return 'Timing mode: $mode · $provenance';
  }

  @override
  String get guidedReviewMoment => 'User-selected review moment';

  @override
  String get guidedPrepareReview => 'Prepare review';

  @override
  String get guidedPreparing => 'Preparing selected moment...';

  @override
  String get guidedEditAttemptBoundaries => 'Edit attempt boundaries';

  @override
  String get guidedSelectTori => 'Select the athlete performing Uchi Mata';

  @override
  String get guidedToriBoundary =>
      'The athlete selection is confirmed by you. Judo Mind has not automatically identified the athlete.';

  @override
  String get guidedFrameCandidateEvidenceBoundary =>
      'These are frame-local model-returned pose candidates. They are not a people count, identity, role, or temporal tracking evidence.';

  @override
  String get guidedCandidateEvidenceReady =>
      'Two selectable frame candidates are available for your human selection.';

  @override
  String guidedCandidateEvidenceInsufficient(
    int detectedCount,
    int selectableCount,
  ) {
    return 'Insufficient candidate evidence for human role confirmation. From $detectedCount model-returned pose candidate(s), only $selectableCount usable frame candidate is available at this review moment. This does not mean only one person is present. Two independent frame candidates are required to continue.';
  }

  @override
  String guidedNoSelectableCandidateEvidence(int detectedCount) {
    return 'The model returned $detectedCount pose candidate(s) in this frame, but none contain selectable pose evidence. Analysis remains blocked.';
  }

  @override
  String guidedCandidatePoseEvidence(int availableCount, int requiredCount) {
    return 'Required 2D landmarks available: $availableCount/$requiredCount (model-estimated).';
  }

  @override
  String guidedCandidateVisibilityAvailable(
    int availableCount,
    int requiredCount,
  ) {
    return 'Model landmark visibility available: $availableCount/$requiredCount. This is not pose accuracy.';
  }

  @override
  String guidedCandidateVisibilityPartial(
    int availableCount,
    int requiredCount,
  ) {
    return 'Model landmark visibility is partial: $availableCount/$requiredCount. This is not pose accuracy.';
  }

  @override
  String get guidedCandidateVisibilityUnavailable =>
      'Model landmark visibility is unavailable; no accuracy or confidence is inferred.';

  @override
  String guidedCandidate(int number) {
    return 'Frame candidate $number';
  }

  @override
  String get guidedConfirmTori =>
      'I confirm this selected frame candidate is Tori for this attempt';

  @override
  String get guidedNotSure => 'Not sure';

  @override
  String get guidedNotSureAthlete =>
      'I cannot reliably distinguish the athlete in this frame';

  @override
  String get guidedReviewBoundaryError =>
      'Choose an end after the start and keep the review moment inside the attempt.';

  @override
  String get guidedReviewUncertainWithheld =>
      'Review withheld: make every required human selection and continue only when you are sure.';

  @override
  String get guidedReviewBackendError =>
      'The guided review failed safely. Retry preparation if appropriate.';
}
