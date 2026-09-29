import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('fa'),
    Locale('fr'),
    Locale('ja'),
    Locale('ru'),
  ];

  /// No description provided for @unavailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get unavailableLabel;

  /// No description provided for @moreTechniqueSections.
  ///
  /// In en, this message translates to:
  /// **'More technique sections'**
  String get moreTechniqueSections;

  /// No description provided for @scientificDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific details'**
  String get scientificDetailsTitle;

  /// No description provided for @provenanceMeasured.
  ///
  /// In en, this message translates to:
  /// **'Measured'**
  String get provenanceMeasured;

  /// No description provided for @provenanceReconstructed.
  ///
  /// In en, this message translates to:
  /// **'Reconstructed'**
  String get provenanceReconstructed;

  /// No description provided for @provenanceModelEstimated.
  ///
  /// In en, this message translates to:
  /// **'Model-estimated'**
  String get provenanceModelEstimated;

  /// No description provided for @provenanceAiInferred.
  ///
  /// In en, this message translates to:
  /// **'AI-inferred'**
  String get provenanceAiInferred;

  /// No description provided for @provenanceUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get provenanceUnknown;

  /// No description provided for @insufficientEvidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Insufficient evidence'**
  String get insufficientEvidenceLabel;

  /// No description provided for @leftSide.
  ///
  /// In en, this message translates to:
  /// **'Left Side'**
  String get leftSide;

  /// No description provided for @rightSide.
  ///
  /// In en, this message translates to:
  /// **'Right Side'**
  String get rightSide;

  /// No description provided for @toriRole.
  ///
  /// In en, this message translates to:
  /// **'Tori'**
  String get toriRole;

  /// No description provided for @ukeRole.
  ///
  /// In en, this message translates to:
  /// **'Uke'**
  String get ukeRole;

  /// No description provided for @unassignedRole.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassignedRole;

  /// No description provided for @reviewedGateSummary.
  ///
  /// In en, this message translates to:
  /// **'{trackId}; detection {detectionIndex}; {role}; {supportSide} support leg; {attackingSide} attacking leg; {startMs}–{endMs} ms'**
  String reviewedGateSummary(
    String trackId,
    int detectionIndex,
    String role,
    String supportSide,
    String attackingSide,
    int startMs,
    int endMs,
  );

  /// No description provided for @allCategories.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get allCategories;

  /// No description provided for @allLevels.
  ///
  /// In en, this message translates to:
  /// **'All levels'**
  String get allLevels;

  /// No description provided for @techniqueSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search techniques'**
  String get techniqueSearchHint;

  /// No description provided for @noTechniquesFound.
  ///
  /// In en, this message translates to:
  /// **'No techniques found'**
  String get noTechniquesFound;

  /// No description provided for @officialTechniquesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} official Judo techniques'**
  String officialTechniquesCount(int count);

  /// No description provided for @ijfTechniqueDatabase.
  ///
  /// In en, this message translates to:
  /// **'IJF technique database'**
  String get ijfTechniqueDatabase;

  /// No description provided for @filtersTitle.
  ///
  /// In en, this message translates to:
  /// **'Filters'**
  String get filtersTitle;

  /// No description provided for @eliteLevel.
  ///
  /// In en, this message translates to:
  /// **'Elite'**
  String get eliteLevel;

  /// No description provided for @sutemiWaza.
  ///
  /// In en, this message translates to:
  /// **'Sutemi-waza'**
  String get sutemiWaza;

  /// No description provided for @neWaza.
  ///
  /// In en, this message translates to:
  /// **'Ne-waza'**
  String get neWaza;

  /// No description provided for @tachiWaza.
  ///
  /// In en, this message translates to:
  /// **'Tachi-waza'**
  String get tachiWaza;

  /// No description provided for @analyzeVideoDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose one training or competition video for an experimental 2D pose-visibility check. Identity, phases and biomechanics are not included.'**
  String get analyzeVideoDescription;

  /// No description provided for @addTechniqueVideo.
  ///
  /// In en, this message translates to:
  /// **'Add technique video'**
  String get addTechniqueVideo;

  /// No description provided for @videoVisibilityGuidance.
  ///
  /// In en, this message translates to:
  /// **'Use a clear video where both judoka remain visible.'**
  String get videoVisibilityGuidance;

  /// No description provided for @chooseFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from gallery'**
  String get chooseFromGallery;

  /// No description provided for @recordVideo.
  ///
  /// In en, this message translates to:
  /// **'Record video'**
  String get recordVideo;

  /// No description provided for @selectedVideo.
  ///
  /// In en, this message translates to:
  /// **'Selected video'**
  String get selectedVideo;

  /// No description provided for @captureFullBodiesGuidance.
  ///
  /// In en, this message translates to:
  /// **'Keep the full bodies of Tori and Uke visible.'**
  String get captureFullBodiesGuidance;

  /// No description provided for @captureStableLightGuidance.
  ///
  /// In en, this message translates to:
  /// **'Keep the camera stable and use sufficient light.'**
  String get captureStableLightGuidance;

  /// No description provided for @captureNoCrossingGuidance.
  ///
  /// In en, this message translates to:
  /// **'Avoid people crossing in front of the camera.'**
  String get captureNoCrossingGuidance;

  /// No description provided for @captureViewGuidance.
  ///
  /// In en, this message translates to:
  /// **'Side or 45-degree views provide clearer joint visibility.'**
  String get captureViewGuidance;

  /// No description provided for @captureDurationGuidance.
  ///
  /// In en, this message translates to:
  /// **'The maximum video duration is 3 minutes.'**
  String get captureDurationGuidance;

  /// No description provided for @cameraAngleLabel.
  ///
  /// In en, this message translates to:
  /// **'Camera angle'**
  String get cameraAngleLabel;

  /// No description provided for @cameraSideView.
  ///
  /// In en, this message translates to:
  /// **'Side view'**
  String get cameraSideView;

  /// No description provided for @cameraFrontView.
  ///
  /// In en, this message translates to:
  /// **'Front view'**
  String get cameraFrontView;

  /// No description provided for @cameraRearView.
  ///
  /// In en, this message translates to:
  /// **'Rear view'**
  String get cameraRearView;

  /// No description provided for @cameraFortyFiveView.
  ///
  /// In en, this message translates to:
  /// **'45-degree view'**
  String get cameraFortyFiveView;

  /// No description provided for @analysisNoticeTitle.
  ///
  /// In en, this message translates to:
  /// **'I understand this is video-based analysis.'**
  String get analysisNoticeTitle;

  /// No description provided for @analysisNoticeDescription.
  ///
  /// In en, this message translates to:
  /// **'This step reports experimental 2D pose visibility only. It does not identify Tori or Uke, detect phases, reconstruct 3D, or measure force and torque.'**
  String get analysisNoticeDescription;

  /// No description provided for @videoSelectionFailed.
  ///
  /// In en, this message translates to:
  /// **'The video could not be selected.'**
  String get videoSelectionFailed;

  /// No description provided for @analysisFailedUnexpectedly.
  ///
  /// In en, this message translates to:
  /// **'The pose analysis stopped safely. Try again.'**
  String get analysisFailedUnexpectedly;

  /// No description provided for @videoSizeMegabytes.
  ///
  /// In en, this message translates to:
  /// **'{size} MB'**
  String videoSizeMegabytes(String size);

  /// No description provided for @sourceInternationalJudoFederation.
  ///
  /// In en, this message translates to:
  /// **'International Judo Federation'**
  String get sourceInternationalJudoFederation;

  /// No description provided for @sourceKodokanJudoInstitute.
  ///
  /// In en, this message translates to:
  /// **'Kodokan Judo Institute'**
  String get sourceKodokanJudoInstitute;

  /// No description provided for @sourceEuropeanJudoUnion.
  ///
  /// In en, this message translates to:
  /// **'European Judo Union'**
  String get sourceEuropeanJudoUnion;

  /// No description provided for @techniqueSectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'This technique section is not available yet.'**
  String get techniqueSectionUnavailable;

  /// No description provided for @techniqueTrainingUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The Uchi Mata training pathway is not available yet.'**
  String get techniqueTrainingUnavailable;

  /// No description provided for @techniqueMasteryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Uchi Mata progress and mastery tracking are not available yet.'**
  String get techniqueMasteryUnavailable;

  /// No description provided for @techniqueChampionsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Verified Uchi Mata champion references are not available yet.'**
  String get techniqueChampionsUnavailable;

  /// No description provided for @techniqueSensiBotUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Sensi Bot coaching for Uchi Mata is not available yet.'**
  String get techniqueSensiBotUnavailable;

  /// No description provided for @techniqueMediaItemUnavailable.
  ///
  /// In en, this message translates to:
  /// **'An approved media source has not been added for this item yet.'**
  String get techniqueMediaItemUnavailable;

  /// No description provided for @techniqueMediaOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'The selected media could not be opened.'**
  String get techniqueMediaOpenFailed;

  /// No description provided for @techniqueCompetitionVideoUnavailable.
  ///
  /// In en, this message translates to:
  /// **'An approved direct competition video is not available yet.'**
  String get techniqueCompetitionVideoUnavailable;

  /// No description provided for @techniqueCompetitionVideoOpenFailed.
  ///
  /// In en, this message translates to:
  /// **'The competition video could not be opened.'**
  String get techniqueCompetitionVideoOpenFailed;

  /// No description provided for @submitAnswer.
  ///
  /// In en, this message translates to:
  /// **'Submit Answer'**
  String get submitAnswer;

  /// No description provided for @overview.
  ///
  /// In en, this message translates to:
  /// **'Overview'**
  String get overview;

  /// No description provided for @techniqueApplicationContext.
  ///
  /// In en, this message translates to:
  /// **'Application context'**
  String get techniqueApplicationContext;

  /// No description provided for @techniqueGripAndStartingPosition.
  ///
  /// In en, this message translates to:
  /// **'Grip and starting position'**
  String get techniqueGripAndStartingPosition;

  /// No description provided for @techniqueExecutionPhases.
  ///
  /// In en, this message translates to:
  /// **'Execution phases'**
  String get techniqueExecutionPhases;

  /// No description provided for @techniqueFollowThrough.
  ///
  /// In en, this message translates to:
  /// **'Makikomi or follow-through'**
  String get techniqueFollowThrough;

  /// No description provided for @techniqueVariations.
  ///
  /// In en, this message translates to:
  /// **'Variations'**
  String get techniqueVariations;

  /// No description provided for @techniqueVisualExplanation.
  ///
  /// In en, this message translates to:
  /// **'Visual explanation'**
  String get techniqueVisualExplanation;

  /// No description provided for @techniqueVideoExplanation.
  ///
  /// In en, this message translates to:
  /// **'Video explanation'**
  String get techniqueVideoExplanation;

  /// No description provided for @techniqueTechnicalExplanation.
  ///
  /// In en, this message translates to:
  /// **'Technical explanation'**
  String get techniqueTechnicalExplanation;

  /// No description provided for @techniqueConceptualMechanicalInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Conceptual mechanical interpretation'**
  String get techniqueConceptualMechanicalInterpretation;

  /// No description provided for @techniqueBiomechanicalInterpretation.
  ///
  /// In en, this message translates to:
  /// **'Biomechanical interpretation'**
  String get techniqueBiomechanicalInterpretation;

  /// No description provided for @techniqueMeasuredBiomechanicalResult.
  ///
  /// In en, this message translates to:
  /// **'Measured biomechanical result'**
  String get techniqueMeasuredBiomechanicalResult;

  /// No description provided for @techniqueEvidenceReviewStatus.
  ///
  /// In en, this message translates to:
  /// **'Evidence and review status'**
  String get techniqueEvidenceReviewStatus;

  /// No description provided for @techniqueStatementClassification.
  ///
  /// In en, this message translates to:
  /// **'Statement classification'**
  String get techniqueStatementClassification;

  /// No description provided for @techniqueContentSource.
  ///
  /// In en, this message translates to:
  /// **'Content source'**
  String get techniqueContentSource;

  /// No description provided for @techniqueSourceType.
  ///
  /// In en, this message translates to:
  /// **'Source type'**
  String get techniqueSourceType;

  /// No description provided for @techniqueProvenanceLicense.
  ///
  /// In en, this message translates to:
  /// **'Provenance / licence'**
  String get techniqueProvenanceLicense;

  /// No description provided for @techniqueTechnicalReviewStatus.
  ///
  /// In en, this message translates to:
  /// **'Technical-review status'**
  String get techniqueTechnicalReviewStatus;

  /// No description provided for @techniqueScientificReviewStatus.
  ///
  /// In en, this message translates to:
  /// **'Scientific-review status'**
  String get techniqueScientificReviewStatus;

  /// No description provided for @techniqueReviewerRole.
  ///
  /// In en, this message translates to:
  /// **'Reviewer role'**
  String get techniqueReviewerRole;

  /// No description provided for @techniqueLastReviewDate.
  ///
  /// In en, this message translates to:
  /// **'Last review date'**
  String get techniqueLastReviewDate;

  /// No description provided for @techniqueReviewNotReviewed.
  ///
  /// In en, this message translates to:
  /// **'Not reviewed'**
  String get techniqueReviewNotReviewed;

  /// No description provided for @techniqueReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Review required'**
  String get techniqueReviewRequired;

  /// No description provided for @techniqueReviewRecorded.
  ///
  /// In en, this message translates to:
  /// **'Review recorded'**
  String get techniqueReviewRecorded;

  /// No description provided for @techniqueConceptualDiagramDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This diagram is an educational interpretation. Arrows indicate conceptual movement or force directions and do not represent direct force measurement.'**
  String get techniqueConceptualDiagramDisclaimer;

  /// No description provided for @biomechanics.
  ///
  /// In en, this message translates to:
  /// **'Biomechanics'**
  String get biomechanics;

  /// No description provided for @techniqueType.
  ///
  /// In en, this message translates to:
  /// **'Technique Type'**
  String get techniqueType;

  /// No description provided for @beltLevel.
  ///
  /// In en, this message translates to:
  /// **'Belt Level'**
  String get beltLevel;

  /// No description provided for @approvedContentUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Curated educational content is not available for this field yet.'**
  String get approvedContentUnavailable;

  /// No description provided for @classicalPhases.
  ///
  /// In en, this message translates to:
  /// **'Classical Phases'**
  String get classicalPhases;

  /// No description provided for @kuzushi.
  ///
  /// In en, this message translates to:
  /// **'Kuzushi'**
  String get kuzushi;

  /// No description provided for @tsukuri.
  ///
  /// In en, this message translates to:
  /// **'Tsukuri'**
  String get tsukuri;

  /// No description provided for @kake.
  ///
  /// In en, this message translates to:
  /// **'Kake'**
  String get kake;

  /// No description provided for @additionalExecutionSteps.
  ///
  /// In en, this message translates to:
  /// **'Additional Execution Steps'**
  String get additionalExecutionSteps;

  /// No description provided for @noAdditionalExecutionSteps.
  ///
  /// In en, this message translates to:
  /// **'No additional approved execution steps are available.'**
  String get noAdditionalExecutionSteps;

  /// No description provided for @approvedKeyPoints.
  ///
  /// In en, this message translates to:
  /// **'Approved Key Points'**
  String get approvedKeyPoints;

  /// No description provided for @tacticalContentIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Dedicated tactical scenarios and competition-context guidance do not yet have an approved source. The key points below are educational technique content, not tactical intelligence.'**
  String get tacticalContentIncomplete;

  /// No description provided for @competitionContentIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Dedicated competition analysis does not yet have an approved source. The combinations and counters below are the currently approved educational content.'**
  String get competitionContentIncomplete;

  /// No description provided for @watchCompetitionExample.
  ///
  /// In en, this message translates to:
  /// **'Watch Competition Example'**
  String get watchCompetitionExample;

  /// No description provided for @officialSources.
  ///
  /// In en, this message translates to:
  /// **'Official Sources'**
  String get officialSources;

  /// No description provided for @officialLabel.
  ///
  /// In en, this message translates to:
  /// **'Official'**
  String get officialLabel;

  /// No description provided for @verifiedLabel.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verifiedLabel;

  /// No description provided for @noApprovedSources.
  ///
  /// In en, this message translates to:
  /// **'No concrete approved references have been added for this technique.'**
  String get noApprovedSources;

  /// No description provided for @mistakesAndSafety.
  ///
  /// In en, this message translates to:
  /// **'Mistakes & Safety'**
  String get mistakesAndSafety;

  /// No description provided for @safetyGuidance.
  ///
  /// In en, this message translates to:
  /// **'Safety Guidance'**
  String get safetyGuidance;

  /// No description provided for @noCommonMistakes.
  ///
  /// In en, this message translates to:
  /// **'No approved common mistakes have been recorded yet.'**
  String get noCommonMistakes;

  /// No description provided for @noSafetyGuidance.
  ///
  /// In en, this message translates to:
  /// **'No approved safety guidance has been added yet.'**
  String get noSafetyGuidance;

  /// No description provided for @noCombinations.
  ///
  /// In en, this message translates to:
  /// **'No approved combinations have been added yet.'**
  String get noCombinations;

  /// No description provided for @noCounters.
  ///
  /// In en, this message translates to:
  /// **'No approved counters have been added yet.'**
  String get noCounters;

  /// No description provided for @techniqueQuiz.
  ///
  /// In en, this message translates to:
  /// **'Technique Quiz'**
  String get techniqueQuiz;

  /// No description provided for @quizUnavailable.
  ///
  /// In en, this message translates to:
  /// **'No approved quiz questions are available for this technique.'**
  String get quizUnavailable;

  /// No description provided for @visualBiomechanics.
  ///
  /// In en, this message translates to:
  /// **'Visual Biomechanics'**
  String get visualBiomechanics;

  /// No description provided for @visualBiomechanicsDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the educational layers to inspect the repository\'s approved movement visualization.'**
  String get visualBiomechanicsDescription;

  /// No description provided for @visualBiomechanicsUnavailable.
  ///
  /// In en, this message translates to:
  /// **'An approved visual biomechanics sequence is not available for this technique.'**
  String get visualBiomechanicsUnavailable;

  /// No description provided for @educationalVisualizationLimitation.
  ///
  /// In en, this message translates to:
  /// **'Educational visualization only. It is not measured or reconstructed 3D biomechanics and does not report real force, torque, power or center of mass.'**
  String get educationalVisualizationLimitation;

  /// No description provided for @blueLayer.
  ///
  /// In en, this message translates to:
  /// **'Blue Layer'**
  String get blueLayer;

  /// No description provided for @blueLayerDescription.
  ///
  /// In en, this message translates to:
  /// **'Footwork, entry and body movement'**
  String get blueLayerDescription;

  /// No description provided for @goldLayer.
  ///
  /// In en, this message translates to:
  /// **'Gold Layer'**
  String get goldLayer;

  /// No description provided for @goldLayerDescription.
  ///
  /// In en, this message translates to:
  /// **'Grip, pulling action and kinetic-chain control'**
  String get goldLayerDescription;

  /// No description provided for @greenLayer.
  ///
  /// In en, this message translates to:
  /// **'Green Layer'**
  String get greenLayer;

  /// No description provided for @greenLayerDescription.
  ///
  /// In en, this message translates to:
  /// **'Illustrative direction, balance and body-position concepts'**
  String get greenLayerDescription;

  /// No description provided for @visualPhaseGuidanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Each classical phase is paired with an educational vector companion, while its instruction comes directly from the technique\'s structured content.'**
  String get visualPhaseGuidanceDescription;

  /// No description provided for @animationDisabledStaticFallback.
  ///
  /// In en, this message translates to:
  /// **'Animation is disabled. Select a phase to inspect its static visual companion.'**
  String get animationDisabledStaticFallback;

  /// No description provided for @educationalPracticeTitle.
  ///
  /// In en, this message translates to:
  /// **'Educational Practice Guidance'**
  String get educationalPracticeTitle;

  /// No description provided for @educationalPracticeDescription.
  ///
  /// In en, this message translates to:
  /// **'Review the approved execution steps, key points, common mistakes and safety guidance before supervised practice.'**
  String get educationalPracticeDescription;

  /// No description provided for @educationalPracticeLimitation.
  ///
  /// In en, this message translates to:
  /// **'Educational guidance only. Timers, repetition programmes, conditioning plans and personalized coaching are not available.'**
  String get educationalPracticeLimitation;

  /// No description provided for @shadowTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Shadow Training'**
  String get shadowTrainingTitle;

  /// No description provided for @strengthConditioningTitle.
  ///
  /// In en, this message translates to:
  /// **'Strength & Conditioning'**
  String get strengthConditioningTitle;

  /// No description provided for @resistanceBandTrainingTitle.
  ///
  /// In en, this message translates to:
  /// **'Resistance-Band Training'**
  String get resistanceBandTrainingTitle;

  /// No description provided for @trainingExperienceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Approved technique-specific training is unavailable'**
  String get trainingExperienceUnavailable;

  /// No description provided for @trainingExperienceUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'This experience remains unavailable until its localized content, visual or media evidence, prescription, safety guidance and sources are reviewed and approved.'**
  String get trainingExperienceUnavailableDescription;

  /// No description provided for @trainingObjectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Objective'**
  String get trainingObjectiveLabel;

  /// No description provided for @trainingRelatedPhaseLabel.
  ///
  /// In en, this message translates to:
  /// **'Related phase'**
  String get trainingRelatedPhaseLabel;

  /// No description provided for @trainingEquipmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Equipment'**
  String get trainingEquipmentLabel;

  /// No description provided for @trainingAthleteLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Athlete level'**
  String get trainingAthleteLevelLabel;

  /// No description provided for @trainingPrescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved prescription'**
  String get trainingPrescriptionLabel;

  /// No description provided for @trainingRestLabel.
  ///
  /// In en, this message translates to:
  /// **'Rest'**
  String get trainingRestLabel;

  /// No description provided for @trainingMediaLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved media reference'**
  String get trainingMediaLabel;

  /// No description provided for @trainingSafetyLabel.
  ///
  /// In en, this message translates to:
  /// **'Safety guidance'**
  String get trainingSafetyLabel;

  /// No description provided for @trainingSourceLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get trainingSourceLabel;

  /// No description provided for @trainingProvenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Content provenance'**
  String get trainingProvenanceLabel;

  /// No description provided for @shadowPhaseSequenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Phase sequence'**
  String get shadowPhaseSequenceLabel;

  /// No description provided for @shadowMovementPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Movement and entry path'**
  String get shadowMovementPathLabel;

  /// No description provided for @shadowMirrorGhostLabel.
  ///
  /// In en, this message translates to:
  /// **'Mirror / Ghost presentation'**
  String get shadowMirrorGhostLabel;

  /// No description provided for @shadowFrontSideLabel.
  ///
  /// In en, this message translates to:
  /// **'Front / side presentation'**
  String get shadowFrontSideLabel;

  /// No description provided for @shadowPaceLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved pace modes'**
  String get shadowPaceLabel;

  /// No description provided for @shadowRepetitionTrackingLabel.
  ///
  /// In en, this message translates to:
  /// **'Repetition tracking'**
  String get shadowRepetitionTrackingLabel;

  /// No description provided for @shadowHistoryBoundaryLabel.
  ///
  /// In en, this message translates to:
  /// **'History recording'**
  String get shadowHistoryBoundaryLabel;

  /// No description provided for @conditioningMovementPatternLabel.
  ///
  /// In en, this message translates to:
  /// **'Target movement pattern'**
  String get conditioningMovementPatternLabel;

  /// No description provided for @conditioningCommonErrorLabel.
  ///
  /// In en, this message translates to:
  /// **'Common execution error'**
  String get conditioningCommonErrorLabel;

  /// No description provided for @bandAnchorLabel.
  ///
  /// In en, this message translates to:
  /// **'Anchor location and height'**
  String get bandAnchorLabel;

  /// No description provided for @bandDirectionLabel.
  ///
  /// In en, this message translates to:
  /// **'Resistance / force direction'**
  String get bandDirectionLabel;

  /// No description provided for @bandGripMappingLabel.
  ///
  /// In en, this message translates to:
  /// **'Sleeve / lapel grip mapping'**
  String get bandGripMappingLabel;

  /// No description provided for @bandRotationPathLabel.
  ///
  /// In en, this message translates to:
  /// **'Entry / rotation path'**
  String get bandRotationPathLabel;

  /// No description provided for @bandLegRolesLabel.
  ///
  /// In en, this message translates to:
  /// **'Support-leg / attacking-leg roles'**
  String get bandLegRolesLabel;

  /// No description provided for @bandSafeDistanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Safe distance guidance'**
  String get bandSafeDistanceLabel;

  /// No description provided for @bandResistanceLevelLabel.
  ///
  /// In en, this message translates to:
  /// **'Approved resistance level'**
  String get bandResistanceLevelLabel;

  /// No description provided for @bandDangerWarningLabel.
  ///
  /// In en, this message translates to:
  /// **'Dangerous-error warning'**
  String get bandDangerWarningLabel;

  /// No description provided for @trainingCapabilityEnabled.
  ///
  /// In en, this message translates to:
  /// **'Available in reviewed educational content'**
  String get trainingCapabilityEnabled;

  /// No description provided for @trainingCapabilityDisabled.
  ///
  /// In en, this message translates to:
  /// **'Not approved or unavailable'**
  String get trainingCapabilityDisabled;

  /// No description provided for @trainingSetsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} sets'**
  String trainingSetsValue(int count);

  /// No description provided for @trainingRepetitionsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} repetitions'**
  String trainingRepetitionsValue(int count);

  /// No description provided for @trainingDurationValue.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String trainingDurationValue(int seconds);

  /// No description provided for @trainingRestValue.
  ///
  /// In en, this message translates to:
  /// **'{seconds} seconds'**
  String trainingRestValue(int seconds);

  /// No description provided for @trainingSessionsValue.
  ///
  /// In en, this message translates to:
  /// **'{count} sessions per week'**
  String trainingSessionsValue(int count);

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Judo Mind'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @settingsLanguageSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSectionTitle;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose the current app language. The selection applies immediately and is stored locally on this device.'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguagePersian.
  ///
  /// In en, this message translates to:
  /// **'Persian (فارسی)'**
  String get settingsLanguagePersian;

  /// No description provided for @settingsLocalDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Local data & privacy'**
  String get settingsLocalDataTitle;

  /// No description provided for @settingsLocalDataDescription.
  ///
  /// In en, this message translates to:
  /// **'This local/demo foundation stores supported Athlete Profile and explicitly saved V2A History data only on this device. Cloud or federation synchronization is not available.'**
  String get settingsLocalDataDescription;

  /// No description provided for @settingsStoredHistoryCount.
  ///
  /// In en, this message translates to:
  /// **'Local validation history records: {count}'**
  String settingsStoredHistoryCount(int count);

  /// No description provided for @settingsHistoryUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Local validation history is unavailable or invalid. Existing data was not overwritten.'**
  String get settingsHistoryUnavailable;

  /// No description provided for @settingsHistoryEmpty.
  ///
  /// In en, this message translates to:
  /// **'No local validation history records are stored.'**
  String get settingsHistoryEmpty;

  /// No description provided for @settingsClearHistoryAction.
  ///
  /// In en, this message translates to:
  /// **'Clear validation history'**
  String get settingsClearHistoryAction;

  /// No description provided for @settingsClearHistoryConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear local validation history?'**
  String get settingsClearHistoryConfirmTitle;

  /// No description provided for @settingsClearHistoryConfirmDescription.
  ///
  /// In en, this message translates to:
  /// **'This clears only saved Local Validation History records. Athlete Profile, language and other local preferences are preserved.'**
  String get settingsClearHistoryConfirmDescription;

  /// No description provided for @settingsHistoryCleared.
  ///
  /// In en, this message translates to:
  /// **'Local validation history was cleared.'**
  String get settingsHistoryCleared;

  /// No description provided for @settingsHistoryClearFailed.
  ///
  /// In en, this message translates to:
  /// **'Local validation history could not be cleared. Other local data was not changed.'**
  String get settingsHistoryClearFailed;

  /// No description provided for @settingsScientificBoundaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific & capability transparency'**
  String get settingsScientificBoundaryTitle;

  /// No description provided for @settingsV2aSupportedBoundary.
  ///
  /// In en, this message translates to:
  /// **'Single-Attempt V2A validation is currently limited to the engineering metrics {metricIds}. These metrics are not scientifically approved for definitive technique assessment.'**
  String settingsV2aSupportedBoundary(String metricIds);

  /// No description provided for @settingsReviewRequiredBoundary.
  ///
  /// In en, this message translates to:
  /// **'A result requiring review remains pending until it is confirmed by a qualified human reviewer.'**
  String get settingsReviewRequiredBoundary;

  /// No description provided for @settingsMultiPersonBoundary.
  ///
  /// In en, this message translates to:
  /// **'Multi-person evidence remains insufficient.'**
  String get settingsMultiPersonBoundary;

  /// No description provided for @settingsInteractionBoundary.
  ///
  /// In en, this message translates to:
  /// **'Interaction metrics remain non-reportable.'**
  String get settingsInteractionBoundary;

  /// No description provided for @settingsUnavailableModulesBoundary.
  ///
  /// In en, this message translates to:
  /// **'Unavailable modules remain unavailable and do not receive placeholder capabilities.'**
  String get settingsUnavailableModulesBoundary;

  /// No description provided for @settingsApplicationInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'Application information'**
  String get settingsApplicationInfoTitle;

  /// No description provided for @settingsApplicationNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Application'**
  String get settingsApplicationNameLabel;

  /// No description provided for @settingsApplicationStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Current status'**
  String get settingsApplicationStatusLabel;

  /// No description provided for @settingsApplicationStatusLocalDemo.
  ///
  /// In en, this message translates to:
  /// **'Local/demo foundation'**
  String get settingsApplicationStatusLocalDemo;

  /// No description provided for @settingsAvailableLanguagesLabel.
  ///
  /// In en, this message translates to:
  /// **'Available languages'**
  String get settingsAvailableLanguagesLabel;

  /// No description provided for @settingsAvailableLanguagesValue.
  ///
  /// In en, this message translates to:
  /// **'English and Persian'**
  String get settingsAvailableLanguagesValue;

  /// No description provided for @settingsStorageBoundaryLabel.
  ///
  /// In en, this message translates to:
  /// **'Storage & privacy'**
  String get settingsStorageBoundaryLabel;

  /// No description provided for @settingsStorageBoundaryValue.
  ///
  /// In en, this message translates to:
  /// **'Supported Profile and History data stay on this device; no cloud or federation synchronization is claimed.'**
  String get settingsStorageBoundaryValue;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @startTraining.
  ///
  /// In en, this message translates to:
  /// **'Start Training'**
  String get startTraining;

  /// No description provided for @techniques.
  ///
  /// In en, this message translates to:
  /// **'Techniques'**
  String get techniques;

  /// No description provided for @techniqueDetails.
  ///
  /// In en, this message translates to:
  /// **'Technique Details'**
  String get techniqueDetails;

  /// No description provided for @japaneseName.
  ///
  /// In en, this message translates to:
  /// **'Japanese Name'**
  String get japaneseName;

  /// No description provided for @classification.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get classification;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @technicalAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Technical Analysis'**
  String get technicalAnalysis;

  /// No description provided for @keyPoints.
  ///
  /// In en, this message translates to:
  /// **'Key Points'**
  String get keyPoints;

  /// No description provided for @commonMistakes.
  ///
  /// In en, this message translates to:
  /// **'Common Mistakes'**
  String get commonMistakes;

  /// No description provided for @safetyTips.
  ///
  /// In en, this message translates to:
  /// **'Safety Tips'**
  String get safetyTips;

  /// No description provided for @executionSteps.
  ///
  /// In en, this message translates to:
  /// **'Execution Steps'**
  String get executionSteps;

  /// No description provided for @combinations.
  ///
  /// In en, this message translates to:
  /// **'Combinations'**
  String get combinations;

  /// No description provided for @counters.
  ///
  /// In en, this message translates to:
  /// **'Counters'**
  String get counters;

  /// No description provided for @difficulty.
  ///
  /// In en, this message translates to:
  /// **'Difficulty'**
  String get difficulty;

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @belt.
  ///
  /// In en, this message translates to:
  /// **'Belt'**
  String get belt;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @officialMedia.
  ///
  /// In en, this message translates to:
  /// **'Official Media'**
  String get officialMedia;

  /// No description provided for @videoLibrary.
  ///
  /// In en, this message translates to:
  /// **'Video Library'**
  String get videoLibrary;

  /// No description provided for @trainingVideo.
  ///
  /// In en, this message translates to:
  /// **'Training Video'**
  String get trainingVideo;

  /// No description provided for @competitionAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Competition Analysis'**
  String get competitionAnalysis;

  /// No description provided for @quiz.
  ///
  /// In en, this message translates to:
  /// **'Quiz'**
  String get quiz;

  /// No description provided for @nextQuestion.
  ///
  /// In en, this message translates to:
  /// **'Next Question'**
  String get nextQuestion;

  /// No description provided for @question.
  ///
  /// In en, this message translates to:
  /// **'Question'**
  String get question;

  /// No description provided for @yourScore.
  ///
  /// In en, this message translates to:
  /// **'Your Score'**
  String get yourScore;

  /// No description provided for @quizCompleted.
  ///
  /// In en, this message translates to:
  /// **'Quiz Completed'**
  String get quizCompleted;

  /// No description provided for @retakeQuiz.
  ///
  /// In en, this message translates to:
  /// **'Retake Quiz'**
  String get retakeQuiz;

  /// No description provided for @nageWaza.
  ///
  /// In en, this message translates to:
  /// **'Nage-waza'**
  String get nageWaza;

  /// No description provided for @katameWaza.
  ///
  /// In en, this message translates to:
  /// **'Katame-waza'**
  String get katameWaza;

  /// No description provided for @teWaza.
  ///
  /// In en, this message translates to:
  /// **'Te-waza'**
  String get teWaza;

  /// No description provided for @koshiWaza.
  ///
  /// In en, this message translates to:
  /// **'Koshi-waza'**
  String get koshiWaza;

  /// No description provided for @ashiWaza.
  ///
  /// In en, this message translates to:
  /// **'Ashi-waza'**
  String get ashiWaza;

  /// No description provided for @maSutemiWaza.
  ///
  /// In en, this message translates to:
  /// **'Ma-sutemi-waza'**
  String get maSutemiWaza;

  /// No description provided for @yokoSutemiWaza.
  ///
  /// In en, this message translates to:
  /// **'Yoko-sutemi-waza'**
  String get yokoSutemiWaza;

  /// No description provided for @osaekomiWaza.
  ///
  /// In en, this message translates to:
  /// **'Osaekomi-waza'**
  String get osaekomiWaza;

  /// No description provided for @shimeWaza.
  ///
  /// In en, this message translates to:
  /// **'Shime-waza'**
  String get shimeWaza;

  /// No description provided for @kansetsuWaza.
  ///
  /// In en, this message translates to:
  /// **'Kansetsu-waza'**
  String get kansetsuWaza;

  /// No description provided for @champions.
  ///
  /// In en, this message translates to:
  /// **'Champions'**
  String get champions;

  /// No description provided for @ijfProfile.
  ///
  /// In en, this message translates to:
  /// **'IJF Profile'**
  String get ijfProfile;

  /// No description provided for @competitionUsage.
  ///
  /// In en, this message translates to:
  /// **'Competition Usage'**
  String get competitionUsage;

  /// No description provided for @tacticalIntelligence.
  ///
  /// In en, this message translates to:
  /// **'Tactical Intelligence'**
  String get tacticalIntelligence;

  /// No description provided for @gripStrategy.
  ///
  /// In en, this message translates to:
  /// **'Grip Strategy'**
  String get gripStrategy;

  /// No description provided for @bodyPosition.
  ///
  /// In en, this message translates to:
  /// **'Body Position'**
  String get bodyPosition;

  /// No description provided for @tacticalNotes.
  ///
  /// In en, this message translates to:
  /// **'Tactical Notes'**
  String get tacticalNotes;

  /// No description provided for @championsUsingTechnique.
  ///
  /// In en, this message translates to:
  /// **'Champions Using This Technique'**
  String get championsUsingTechnique;

  /// No description provided for @favorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favorite;

  /// No description provided for @training.
  ///
  /// In en, this message translates to:
  /// **'Training'**
  String get training;

  /// No description provided for @techniqueMastery.
  ///
  /// In en, this message translates to:
  /// **'Technique Mastery'**
  String get techniqueMastery;

  /// No description provided for @learningProgress.
  ///
  /// In en, this message translates to:
  /// **'Learning Progress'**
  String get learningProgress;

  /// No description provided for @theory.
  ///
  /// In en, this message translates to:
  /// **'Theory'**
  String get theory;

  /// No description provided for @technique.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get technique;

  /// No description provided for @competition.
  ///
  /// In en, this message translates to:
  /// **'Competition'**
  String get competition;

  /// No description provided for @sensiBotRecommendation.
  ///
  /// In en, this message translates to:
  /// **'Sensi Bot Recommendation'**
  String get sensiBotRecommendation;

  /// No description provided for @singleCameraPoseSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Single-Camera Pose Summary'**
  String get singleCameraPoseSummaryTitle;

  /// No description provided for @experimentalPoseBaseline.
  ///
  /// In en, this message translates to:
  /// **'experimental pose baseline'**
  String get experimentalPoseBaseline;

  /// No description provided for @measuredVideoMetadataLabel.
  ///
  /// In en, this message translates to:
  /// **'Video metadata · measured'**
  String get measuredVideoMetadataLabel;

  /// No description provided for @modelEstimatedPoseCoverageLabel.
  ///
  /// In en, this message translates to:
  /// **'Pose coverage · model-estimated'**
  String get modelEstimatedPoseCoverageLabel;

  /// No description provided for @analyzedFramesLabel.
  ///
  /// In en, this message translates to:
  /// **'Analyzed frames'**
  String get analyzedFramesLabel;

  /// No description provided for @atLeastOnePoseLabel.
  ///
  /// In en, this message translates to:
  /// **'At least one pose detected'**
  String get atLeastOnePoseLabel;

  /// No description provided for @twoPosesLabel.
  ///
  /// In en, this message translates to:
  /// **'Two poses detected'**
  String get twoPosesLabel;

  /// No description provided for @scientificConfidenceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scientific confidence is not available in this diagnostic slice. Coverage is not biomechanics confidence.'**
  String get scientificConfidenceUnavailable;

  /// No description provided for @scientificLimitationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific limitations'**
  String get scientificLimitationsTitle;

  /// No description provided for @poseIdentityNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Pose order is frame-local and does not establish persistent Tori or Uke identity.'**
  String get poseIdentityNotAvailable;

  /// No description provided for @phaseDetectionNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Kuzushi, Tsukuri and Kake are not detected in this version.'**
  String get phaseDetectionNotAvailable;

  /// No description provided for @singleCamera2dOnly.
  ///
  /// In en, this message translates to:
  /// **'This single-camera result is not measured or reconstructed 3D.'**
  String get singleCamera2dOnly;

  /// No description provided for @forceTorqueNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'No real force, torque or laboratory-grade biomechanics is reported.'**
  String get forceTorqueNotAvailable;

  /// No description provided for @experimentalPoseLimitation.
  ///
  /// In en, this message translates to:
  /// **'Pose coverage comes from an experimental model and is not a scientific confidence score.'**
  String get experimentalPoseLimitation;

  /// No description provided for @runPoseAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Run 2D Pose Check'**
  String get runPoseAnalysis;

  /// No description provided for @poseAnalysisRunning.
  ///
  /// In en, this message translates to:
  /// **'Checking Pose Visibility...'**
  String get poseAnalysisRunning;

  /// No description provided for @singleAttemptV2ATitle.
  ///
  /// In en, this message translates to:
  /// **'Single-Attempt Uchi Mata · Level 1'**
  String get singleAttemptV2ATitle;

  /// No description provided for @singleAttemptHumanReviewed.
  ///
  /// In en, this message translates to:
  /// **'Tori, support leg, attacking leg and event boundaries · human-reviewed'**
  String get singleAttemptHumanReviewed;

  /// No description provided for @singleAttemptProjected2d.
  ///
  /// In en, this message translates to:
  /// **'Projected single-camera 2D — not reconstructed 3D'**
  String get singleAttemptProjected2d;

  /// No description provided for @metricStatusReportable.
  ///
  /// In en, this message translates to:
  /// **'Reportable'**
  String get metricStatusReportable;

  /// No description provided for @metricStatusReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Review required'**
  String get metricStatusReviewRequired;

  /// No description provided for @metricStatusWithheld.
  ///
  /// In en, this message translates to:
  /// **'Withheld'**
  String get metricStatusWithheld;

  /// No description provided for @metricConfidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Model landmark visibility'**
  String get metricConfidenceLabel;

  /// No description provided for @metricConfidenceUnavailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence evidence unavailable'**
  String get metricConfidenceUnavailableLabel;

  /// No description provided for @blueOverlayTitle.
  ///
  /// In en, this message translates to:
  /// **'Blue geometry layer'**
  String get blueOverlayTitle;

  /// No description provided for @singleAttemptMultiPersonInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Multi-person evidence is insufficient. Interaction metrics remain unavailable and are not inferred.'**
  String get singleAttemptMultiPersonInsufficient;

  /// No description provided for @reviewedWorkflowTitle.
  ///
  /// In en, this message translates to:
  /// **'Manual reviewed Single-Attempt analysis'**
  String get reviewedWorkflowTitle;

  /// No description provided for @reviewedWorkflowDescription.
  ///
  /// In en, this message translates to:
  /// **'Development reviewer workflow. Enter source-frame evidence and human-confirmed selections; nothing below is detected automatically.'**
  String get reviewedWorkflowDescription;

  /// No description provided for @reviewedEventSchema.
  ///
  /// In en, this message translates to:
  /// **'Event schema'**
  String get reviewedEventSchema;

  /// No description provided for @reviewedAttemptStartFrame.
  ///
  /// In en, this message translates to:
  /// **'Attempt start frame'**
  String get reviewedAttemptStartFrame;

  /// No description provided for @reviewedAttemptStartTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Attempt start timestamp (ms)'**
  String get reviewedAttemptStartTimestamp;

  /// No description provided for @reviewedAttemptEndFrame.
  ///
  /// In en, this message translates to:
  /// **'Attempt end frame'**
  String get reviewedAttemptEndFrame;

  /// No description provided for @reviewedAttemptEndTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Attempt end timestamp (ms)'**
  String get reviewedAttemptEndTimestamp;

  /// No description provided for @reviewedAngleFrame.
  ///
  /// In en, this message translates to:
  /// **'Reviewed angle frame'**
  String get reviewedAngleFrame;

  /// No description provided for @reviewedAngleTimestamp.
  ///
  /// In en, this message translates to:
  /// **'Reviewed angle timestamp (ms)'**
  String get reviewedAngleTimestamp;

  /// No description provided for @reviewedNeutralTrack.
  ///
  /// In en, this message translates to:
  /// **'Human-confirmed neutral track (for example, Track A)'**
  String get reviewedNeutralTrack;

  /// No description provided for @reviewedDetectionIndex.
  ///
  /// In en, this message translates to:
  /// **'Frame-local detection index'**
  String get reviewedDetectionIndex;

  /// No description provided for @reviewedSupportLeg.
  ///
  /// In en, this message translates to:
  /// **'Human-confirmed support leg'**
  String get reviewedSupportLeg;

  /// No description provided for @reviewedAttackingLeg.
  ///
  /// In en, this message translates to:
  /// **'Human-confirmed attacking leg'**
  String get reviewedAttackingLeg;

  /// No description provided for @reviewedAngleEventLabel.
  ///
  /// In en, this message translates to:
  /// **'Reviewed angle event label'**
  String get reviewedAngleEventLabel;

  /// No description provided for @reviewedProjectedViewSuitable.
  ///
  /// In en, this message translates to:
  /// **'Projected-angle view suitable?'**
  String get reviewedProjectedViewSuitable;

  /// No description provided for @reviewedLowRoll.
  ///
  /// In en, this message translates to:
  /// **'Low camera roll confirmed?'**
  String get reviewedLowRoll;

  /// No description provided for @reviewedYes.
  ///
  /// In en, this message translates to:
  /// **'Reviewed: yes'**
  String get reviewedYes;

  /// No description provided for @reviewedNo.
  ///
  /// In en, this message translates to:
  /// **'Reviewed: no'**
  String get reviewedNo;

  /// No description provided for @reviewedInputRequired.
  ///
  /// In en, this message translates to:
  /// **'Complete every required human-review field.'**
  String get reviewedInputRequired;

  /// No description provided for @reviewedNonNegativeInteger.
  ///
  /// In en, this message translates to:
  /// **'Enter a non-negative whole number.'**
  String get reviewedNonNegativeInteger;

  /// No description provided for @reviewedNeutralTrackInvalid.
  ///
  /// In en, this message translates to:
  /// **'Use a role-neutral label such as Track A; Tori/Uke are not track identities.'**
  String get reviewedNeutralTrackInvalid;

  /// No description provided for @reviewedInputSequenceInvalid.
  ///
  /// In en, this message translates to:
  /// **'The reviewed boundaries are inconsistent. End must follow start and the angle frame must be inside the attempt.'**
  String get reviewedInputSequenceInvalid;

  /// No description provided for @reviewedHumanGateNotice.
  ///
  /// In en, this message translates to:
  /// **'The selected track is confirmed as Tori only for this reviewed event. Identity, phase and leg selection are not automatic.'**
  String get reviewedHumanGateNotice;

  /// No description provided for @runReviewedAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Run reviewed four-metric analysis'**
  String get runReviewedAnalysis;

  /// No description provided for @reviewedAnalysisRunning.
  ///
  /// In en, this message translates to:
  /// **'Running selected-frame analysis...'**
  String get reviewedAnalysisRunning;

  /// No description provided for @reviewedAnalysisFailed.
  ///
  /// In en, this message translates to:
  /// **'The reviewed Single-Attempt analysis failed safely.'**
  String get reviewedAnalysisFailed;

  /// No description provided for @saveAttemptLocally.
  ///
  /// In en, this message translates to:
  /// **'Save locally'**
  String get saveAttemptLocally;

  /// No description provided for @savingAttemptLocally.
  ///
  /// In en, this message translates to:
  /// **'Saving locally...'**
  String get savingAttemptLocally;

  /// No description provided for @attemptSavedOnDevice.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device'**
  String get attemptSavedOnDevice;

  /// No description provided for @attemptAlreadySaved.
  ///
  /// In en, this message translates to:
  /// **'Already saved'**
  String get attemptAlreadySaved;

  /// No description provided for @attemptSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save locally'**
  String get attemptSaveFailed;

  /// No description provided for @localAttemptStorageDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Stores only this versioned engineering validation summary on this device. Video, file paths, overlays, scores and profile data are not stored.'**
  String get localAttemptStorageDisclosure;

  /// No description provided for @athleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Athlete Profile'**
  String get athleteProfileTitle;

  /// No description provided for @localProfileDisclosureTitle.
  ///
  /// In en, this message translates to:
  /// **'Local self-reported profile'**
  String get localProfileDisclosureTitle;

  /// No description provided for @localProfileDisclosure.
  ///
  /// In en, this message translates to:
  /// **'This optional profile is stored only on this device and is self-reported. It is not a verified athlete identity, official rank or cloud account.'**
  String get localProfileDisclosure;

  /// No description provided for @selfReportedProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Optional profile details'**
  String get selfReportedProfileTitle;

  /// No description provided for @selfReportedProfileDescription.
  ///
  /// In en, this message translates to:
  /// **'All fields are optional, local and self-reported.'**
  String get selfReportedProfileDescription;

  /// No description provided for @profileDisplayName.
  ///
  /// In en, this message translates to:
  /// **'Display name'**
  String get profileDisplayName;

  /// No description provided for @profileBeltRank.
  ///
  /// In en, this message translates to:
  /// **'Belt rank'**
  String get profileBeltRank;

  /// No description provided for @profileClub.
  ///
  /// In en, this message translates to:
  /// **'Club'**
  String get profileClub;

  /// No description provided for @profileCountry.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get profileCountry;

  /// No description provided for @profileBiography.
  ///
  /// In en, this message translates to:
  /// **'Short biography'**
  String get profileBiography;

  /// No description provided for @profileFieldTooLong.
  ///
  /// In en, this message translates to:
  /// **'Use no more than {maxLength} characters.'**
  String profileFieldTooLong(int maxLength);

  /// No description provided for @saveLocalProfile.
  ///
  /// In en, this message translates to:
  /// **'Save local profile'**
  String get saveLocalProfile;

  /// No description provided for @localProfileSaved.
  ///
  /// In en, this message translates to:
  /// **'Local profile saved on this device.'**
  String get localProfileSaved;

  /// No description provided for @localProfileSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Local profile was not saved.'**
  String get localProfileSaveFailed;

  /// No description provided for @localProfileStorageError.
  ///
  /// In en, this message translates to:
  /// **'The local profile payload is unavailable or invalid. Existing data was not overwritten.'**
  String get localProfileStorageError;

  /// No description provided for @localAnalysisHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Local validation history'**
  String get localAnalysisHistoryTitle;

  /// No description provided for @localAnalysisHistoryDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Only explicitly saved, versioned V2A engineering summaries are listed. Original status, provenance and limitations are preserved; no performance or mastery score is calculated.'**
  String get localAnalysisHistoryDisclosure;

  /// No description provided for @localHistoryStorageError.
  ///
  /// In en, this message translates to:
  /// **'The local history payload is unavailable or invalid. Existing data was not overwritten.'**
  String get localHistoryStorageError;

  /// No description provided for @localHistoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved local validation results'**
  String get localHistoryEmptyTitle;

  /// No description provided for @localHistoryEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'A reviewed V2A result appears here only after you explicitly save it on this device.'**
  String get localHistoryEmptyDescription;

  /// No description provided for @profileUnavailableFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress and mastery unavailable'**
  String get profileUnavailableFeaturesTitle;

  /// No description provided for @profileUnavailableFeaturesDescription.
  ///
  /// In en, this message translates to:
  /// **'Official ranking, achievements, mastery, performance scoring, trends and cloud synchronization are not available in this local demo slice.'**
  String get profileUnavailableFeaturesDescription;

  /// No description provided for @savedLocalAnalysesCount.
  ///
  /// In en, this message translates to:
  /// **'Saved local validation results: {count}'**
  String savedLocalAnalysesCount(int count);

  /// No description provided for @metricStatusCount.
  ///
  /// In en, this message translates to:
  /// **'{status}: {count}'**
  String metricStatusCount(String status, int count);

  /// No description provided for @savedLocallyAt.
  ///
  /// In en, this message translates to:
  /// **'Saved locally: {date}'**
  String savedLocallyAt(String date);

  /// No description provided for @analysisIdentifier.
  ///
  /// In en, this message translates to:
  /// **'Analysis ID'**
  String get analysisIdentifier;

  /// No description provided for @analysisModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Analysis mode'**
  String get analysisModeLabel;

  /// No description provided for @multiPersonEvidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Multi-person evidence'**
  String get multiPersonEvidenceLabel;

  /// No description provided for @interactionMetricsLabel.
  ///
  /// In en, this message translates to:
  /// **'Interaction metrics'**
  String get interactionMetricsLabel;

  /// No description provided for @availableLabel.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get availableLabel;

  /// No description provided for @notAvailableLabel.
  ///
  /// In en, this message translates to:
  /// **'Unavailable'**
  String get notAvailableLabel;

  /// No description provided for @notReportableLabel.
  ///
  /// In en, this message translates to:
  /// **'Non-reportable'**
  String get notReportableLabel;

  /// No description provided for @unknownLabel.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknownLabel;

  /// No description provided for @metricValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Value'**
  String get metricValueLabel;

  /// No description provided for @metricStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get metricStatusLabel;

  /// No description provided for @metricProvenanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Provenance'**
  String get metricProvenanceLabel;

  /// No description provided for @metricMethodVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Method version'**
  String get metricMethodVersionLabel;

  /// No description provided for @metricConfidenceAvailabilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Confidence evidence'**
  String get metricConfidenceAvailabilityLabel;

  /// No description provided for @metricLimitationLabel.
  ///
  /// In en, this message translates to:
  /// **'Limitation'**
  String get metricLimitationLabel;

  /// No description provided for @metricWithheldReasonLabel.
  ///
  /// In en, this message translates to:
  /// **'Withheld reason'**
  String get metricWithheldReasonLabel;

  /// No description provided for @localStorageUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Local storage unavailable'**
  String get localStorageUnavailableTitle;

  /// No description provided for @retryLabel.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retryLabel;

  /// No description provided for @learningDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Technique journeys'**
  String get learningDashboardTitle;

  /// No description provided for @learningDashboardDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn, train, analyze, review local validation history and connect with a coach when product and privacy gates are complete.'**
  String get learningDashboardDescription;

  /// No description provided for @journeyLearnTitle.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get journeyLearnTitle;

  /// No description provided for @journeyLearnDescription.
  ///
  /// In en, this message translates to:
  /// **'Understand the technique through curated educational content and distinct learning artifacts.'**
  String get journeyLearnDescription;

  /// No description provided for @journeyTrainTitle.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get journeyTrainTitle;

  /// No description provided for @journeyTrainDescription.
  ///
  /// In en, this message translates to:
  /// **'Use only available technique-specific practice and training experiences.'**
  String get journeyTrainDescription;

  /// No description provided for @journeyAnalyzeTitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get journeyAnalyzeTitle;

  /// No description provided for @journeyAnalyzeDescription.
  ///
  /// In en, this message translates to:
  /// **'Run bounded video analysis and review evidence-guided explanations.'**
  String get journeyAnalyzeDescription;

  /// No description provided for @journeyTrackProgressTitle.
  ///
  /// In en, this message translates to:
  /// **'Track Progress'**
  String get journeyTrackProgressTitle;

  /// No description provided for @journeyTrackProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'Review local validation history without inventing scores or mastery.'**
  String get journeyTrackProgressDescription;

  /// No description provided for @journeyConnectCoachTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect with Coach'**
  String get journeyConnectCoachTitle;

  /// No description provided for @journeyConnectCoachDescription.
  ///
  /// In en, this message translates to:
  /// **'Coach communication remains unavailable until its product and privacy gates are complete.'**
  String get journeyConnectCoachDescription;

  /// No description provided for @learnLabel.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get learnLabel;

  /// No description provided for @visualLabel.
  ///
  /// In en, this message translates to:
  /// **'Visual'**
  String get visualLabel;

  /// No description provided for @aiLabel.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get aiLabel;

  /// No description provided for @singleAttemptAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Single-Attempt Analysis'**
  String get singleAttemptAnalysisTitle;

  /// No description provided for @groundedSenseiTitle.
  ///
  /// In en, this message translates to:
  /// **'Grounded Sensei'**
  String get groundedSenseiTitle;

  /// No description provided for @coachConnectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach connection'**
  String get coachConnectionTitle;

  /// No description provided for @coachConnectionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Coach communication is not available yet. No message or review request has been sent.'**
  String get coachConnectionUnavailable;

  /// No description provided for @mistakeReviewPointLabel.
  ///
  /// In en, this message translates to:
  /// **'Review point'**
  String get mistakeReviewPointLabel;

  /// No description provided for @safetyGuidanceItemLabel.
  ///
  /// In en, this message translates to:
  /// **'Curated educational safety guidance'**
  String get safetyGuidanceItemLabel;

  /// No description provided for @flowFromTechniqueLabel.
  ///
  /// In en, this message translates to:
  /// **'Available options related to'**
  String get flowFromTechniqueLabel;

  /// No description provided for @continueLearningTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue your technique journey'**
  String get continueLearningTitle;

  /// No description provided for @continueLearningDescription.
  ///
  /// In en, this message translates to:
  /// **'Use curated educational content, analyze one bounded attempt and review local validation history.'**
  String get continueLearningDescription;

  /// No description provided for @reviewedAnalysisBadge.
  ///
  /// In en, this message translates to:
  /// **'Human-checked inputs'**
  String get reviewedAnalysisBadge;

  /// No description provided for @analyzeTechnique.
  ///
  /// In en, this message translates to:
  /// **'Analyze {techniqueName}'**
  String analyzeTechnique(String techniqueName);

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @groundedSenseiDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Deterministic local explanation of the bounded V2A result produced from human-checked inputs. It is not open generative AI and adds no new measurement, inference or performance rating.'**
  String get groundedSenseiDisclosure;

  /// No description provided for @groundedSenseiBindingLabel.
  ///
  /// In en, this message translates to:
  /// **'Bounded source binding'**
  String get groundedSenseiBindingLabel;

  /// No description provided for @groundedSenseiBindingValue.
  ///
  /// In en, this message translates to:
  /// **'Analysis {analysisId} · schema {schemaVersion} · {trackId}'**
  String groundedSenseiBindingValue(
    String analysisId,
    String schemaVersion,
    String trackId,
  );

  /// No description provided for @groundedSenseiFindingLabel.
  ///
  /// In en, this message translates to:
  /// **'Finding'**
  String get groundedSenseiFindingLabel;

  /// No description provided for @groundedSenseiEvidenceLabel.
  ///
  /// In en, this message translates to:
  /// **'Evidence'**
  String get groundedSenseiEvidenceLabel;

  /// No description provided for @groundedSenseiWhyLabel.
  ///
  /// In en, this message translates to:
  /// **'Why it matters'**
  String get groundedSenseiWhyLabel;

  /// No description provided for @groundedSenseiOverlayLabel.
  ///
  /// In en, this message translates to:
  /// **'BLUE overlay reference'**
  String get groundedSenseiOverlayLabel;

  /// No description provided for @groundedSenseiNextActionLabel.
  ///
  /// In en, this message translates to:
  /// **'Next action'**
  String get groundedSenseiNextActionLabel;

  /// No description provided for @groundedSenseiSafetyLabel.
  ///
  /// In en, this message translates to:
  /// **'Curated educational safety guidance'**
  String get groundedSenseiSafetyLabel;

  /// No description provided for @groundedSenseiLimitationsLabel.
  ///
  /// In en, this message translates to:
  /// **'Binding scientific limitations'**
  String get groundedSenseiLimitationsLabel;

  /// No description provided for @groundedSenseiLocalVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Local explanation version'**
  String get groundedSenseiLocalVersionLabel;

  /// No description provided for @groundedSenseiMetricDuration.
  ///
  /// In en, this message translates to:
  /// **'Selected-window elapsed time'**
  String get groundedSenseiMetricDuration;

  /// No description provided for @groundedSenseiMetricTrunk.
  ///
  /// In en, this message translates to:
  /// **'Projected trunk inclination'**
  String get groundedSenseiMetricTrunk;

  /// No description provided for @groundedSenseiMetricSupportKnee.
  ///
  /// In en, this message translates to:
  /// **'Projected support-leg knee angle'**
  String get groundedSenseiMetricSupportKnee;

  /// No description provided for @groundedSenseiMetricAttackingKnee.
  ///
  /// In en, this message translates to:
  /// **'Projected attacking-leg knee angle'**
  String get groundedSenseiMetricAttackingKnee;

  /// No description provided for @groundedSenseiWhyDuration.
  ///
  /// In en, this message translates to:
  /// **'Describes elapsed time only within one attempt selected and confirmed by the human reviewer; Judo Mind does not automatically detect attempts or technique phases.'**
  String get groundedSenseiWhyDuration;

  /// No description provided for @groundedSenseiWhyTrunk.
  ///
  /// In en, this message translates to:
  /// **'Describes image-plane trunk geometry at the human-selected frame; camera perspective affects interpretation.'**
  String get groundedSenseiWhyTrunk;

  /// No description provided for @groundedSenseiWhySupportKnee.
  ///
  /// In en, this message translates to:
  /// **'Describes image-plane support-knee geometry at the human-selected frame; it is not joint load or injury-risk evidence.'**
  String get groundedSenseiWhySupportKnee;

  /// No description provided for @groundedSenseiWhyAttackingKnee.
  ///
  /// In en, this message translates to:
  /// **'Describes image-plane attacking-knee geometry at the human-selected frame; it is not three-dimensional motion evidence.'**
  String get groundedSenseiWhyAttackingKnee;

  /// No description provided for @groundedSenseiEvidenceValue.
  ///
  /// In en, this message translates to:
  /// **'{value} {unit} · original status: {status}'**
  String groundedSenseiEvidenceValue(String value, String unit, String status);

  /// No description provided for @groundedSenseiEvidenceWithheld.
  ///
  /// In en, this message translates to:
  /// **'The bounded result withheld this value. No replacement estimate is generated.'**
  String get groundedSenseiEvidenceWithheld;

  /// No description provided for @groundedSenseiSecondsUnit.
  ///
  /// In en, this message translates to:
  /// **'seconds'**
  String get groundedSenseiSecondsUnit;

  /// No description provided for @groundedSenseiDegreesUnit.
  ///
  /// In en, this message translates to:
  /// **'degrees'**
  String get groundedSenseiDegreesUnit;

  /// No description provided for @groundedSenseiOverlayAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available in the original BLUE result geometry.'**
  String get groundedSenseiOverlayAvailable;

  /// No description provided for @groundedSenseiOverlayUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Unavailable in the bounded result; no geometry is fabricated.'**
  String get groundedSenseiOverlayUnavailable;

  /// No description provided for @groundedSenseiNoApprovedDrill.
  ///
  /// In en, this message translates to:
  /// **'No metric-to-drill mapping has been approved. A drill recommendation is unavailable.'**
  String get groundedSenseiNoApprovedDrill;

  /// No description provided for @groundedSenseiSafetyUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Approved safety guidance is unavailable in the selected language.'**
  String get groundedSenseiSafetyUnavailable;

  /// No description provided for @groundedSenseiConfidenceAvailable.
  ///
  /// In en, this message translates to:
  /// **'Original V2A keypoint-confidence evidence is preserved; no new confidence score is created.'**
  String get groundedSenseiConfidenceAvailable;

  /// No description provided for @groundedSenseiConfidenceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Confidence evidence is unavailable for this metric; no confidence score is created.'**
  String get groundedSenseiConfidenceUnavailable;

  /// No description provided for @groundedSenseiProvenanceMeasured.
  ///
  /// In en, this message translates to:
  /// **'measured'**
  String get groundedSenseiProvenanceMeasured;

  /// No description provided for @groundedSenseiProvenanceModelEstimated.
  ///
  /// In en, this message translates to:
  /// **'model-estimated'**
  String get groundedSenseiProvenanceModelEstimated;

  /// No description provided for @groundedSenseiLimitationHumanRole.
  ///
  /// In en, this message translates to:
  /// **'The Tori role comes only from human review; it was not inferred.'**
  String get groundedSenseiLimitationHumanRole;

  /// No description provided for @groundedSenseiLimitationSupportLeg.
  ///
  /// In en, this message translates to:
  /// **'The support leg comes only from human review; it was not inferred.'**
  String get groundedSenseiLimitationSupportLeg;

  /// No description provided for @groundedSenseiLimitationPhase.
  ///
  /// In en, this message translates to:
  /// **'Technique phases are not automatically detected.'**
  String get groundedSenseiLimitationPhase;

  /// No description provided for @groundedSenseiLimitationProjected.
  ///
  /// In en, this message translates to:
  /// **'Angle findings are projected single-camera 2D, not reconstructed 3D.'**
  String get groundedSenseiLimitationProjected;

  /// No description provided for @groundedSenseiLimitationPerspective.
  ///
  /// In en, this message translates to:
  /// **'Camera perspective can change projected angle interpretation.'**
  String get groundedSenseiLimitationPerspective;

  /// No description provided for @groundedSenseiLimitationKinetics.
  ///
  /// In en, this message translates to:
  /// **'Force, torque, power, moment, load and OpenSim outputs are unavailable.'**
  String get groundedSenseiLimitationKinetics;

  /// No description provided for @groundedSenseiLimitationDescriptive.
  ///
  /// In en, this message translates to:
  /// **'The explanation is descriptive only and does not classify performance or mastery.'**
  String get groundedSenseiLimitationDescriptive;

  /// No description provided for @groundedSenseiLimitationOther.
  ///
  /// In en, this message translates to:
  /// **'The validated result retains limitation: {code}'**
  String groundedSenseiLimitationOther(String code);

  /// No description provided for @groundedSenseiMultiPersonBoundary.
  ///
  /// In en, this message translates to:
  /// **'Multi-person evidence remains insufficient. Interaction findings are unavailable and are not inferred.'**
  String get groundedSenseiMultiPersonBoundary;

  /// No description provided for @groundedSenseiUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Grounded Sensei is unavailable because the human-checked input binding or bounded contract could not be verified. The original bounded result remains available.'**
  String get groundedSenseiUnavailable;

  /// No description provided for @homeHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Your Judo journey starts here'**
  String get homeHeroTitle;

  /// No description provided for @homeHeroDescription.
  ///
  /// In en, this message translates to:
  /// **'Learn curated educational technique content, analyze one bounded attempt with human-checked inputs and revisit local validation results.'**
  String get homeHeroDescription;

  /// No description provided for @exploreTechniques.
  ///
  /// In en, this message translates to:
  /// **'Explore Techniques'**
  String get exploreTechniques;

  /// No description provided for @homeJourneysTitle.
  ///
  /// In en, this message translates to:
  /// **'What do you want to do?'**
  String get homeJourneysTitle;

  /// No description provided for @homeJourneysDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose one of Judo Mind\'s five athlete journeys. Unfinished journeys remain visible and honestly unavailable.'**
  String get homeJourneysDescription;

  /// No description provided for @homeJourneyLearnDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore the available 67-technique catalog, beginning with the Uchi Mata Gold Reference.'**
  String get homeJourneyLearnDescription;

  /// No description provided for @homeJourneyTrainUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Technique-specific training is visible but unavailable until its content, prescription and safety evidence complete review.'**
  String get homeJourneyTrainUnavailable;

  /// No description provided for @homeJourneyAnalyzeDescription.
  ///
  /// In en, this message translates to:
  /// **'Open the bounded Single-Attempt Uchi Mata V1/V2A engineering workflow with human-checked inputs.'**
  String get homeJourneyAnalyzeDescription;

  /// No description provided for @homeJourneyTrackProgressDescription.
  ///
  /// In en, this message translates to:
  /// **'Open local validation history containing versioned engineering summaries without creating a progress score.'**
  String get homeJourneyTrackProgressDescription;

  /// No description provided for @homeJourneyCoachUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Coach communication is visible but unavailable until product, privacy and federation gates are complete.'**
  String get homeJourneyCoachUnavailable;

  /// No description provided for @continueSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueSectionTitle;

  /// No description provided for @continueUchiMata.
  ///
  /// In en, this message translates to:
  /// **'Continue learning Uchi Mata'**
  String get continueUchiMata;

  /// No description provided for @reviewLocalAnalysisHistory.
  ///
  /// In en, this message translates to:
  /// **'Review local validation history'**
  String get reviewLocalAnalysisHistory;

  /// No description provided for @exploreAllCapabilities.
  ///
  /// In en, this message translates to:
  /// **'Explore all capabilities'**
  String get exploreAllCapabilities;

  /// No description provided for @moduleDirectoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Platform overview'**
  String get moduleDirectoryTitle;

  /// No description provided for @moduleStatusAvailable.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get moduleStatusAvailable;

  /// No description provided for @moduleStatusFoundationPartial.
  ///
  /// In en, this message translates to:
  /// **'Foundation / partial'**
  String get moduleStatusFoundationPartial;

  /// No description provided for @moduleStatusUnavailableDeferred.
  ///
  /// In en, this message translates to:
  /// **'Unavailable / deferred'**
  String get moduleStatusUnavailableDeferred;

  /// No description provided for @moduleNoApprovedDestination.
  ///
  /// In en, this message translates to:
  /// **'No available destination is ready yet.'**
  String get moduleNoApprovedDestination;

  /// No description provided for @moduleSensiBetDeferredReason.
  ///
  /// In en, this message translates to:
  /// **'Deferred pending legal, age, ethical and federation-brand review.'**
  String get moduleSensiBetDeferredReason;

  /// No description provided for @surfaceAthleteApp.
  ///
  /// In en, this message translates to:
  /// **'Athlete App'**
  String get surfaceAthleteApp;

  /// No description provided for @surfaceCoachWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Coach Workspace'**
  String get surfaceCoachWorkspace;

  /// No description provided for @surfaceClubFederationConsole.
  ///
  /// In en, this message translates to:
  /// **'Club / Federation Console'**
  String get surfaceClubFederationConsole;

  /// No description provided for @surfaceJudoIntelligenceCore.
  ///
  /// In en, this message translates to:
  /// **'Judo Intelligence Core'**
  String get surfaceJudoIntelligenceCore;

  /// No description provided for @moduleHomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get moduleHomeTitle;

  /// No description provided for @moduleTechniquesTitle.
  ///
  /// In en, this message translates to:
  /// **'Techniques — 67 Techniques'**
  String get moduleTechniquesTitle;

  /// No description provided for @moduleSensiBotTitle.
  ///
  /// In en, this message translates to:
  /// **'Sensi Bot'**
  String get moduleSensiBotTitle;

  /// No description provided for @moduleSensiBetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sensi Bet'**
  String get moduleSensiBetTitle;

  /// No description provided for @moduleMonitoringTitle.
  ///
  /// In en, this message translates to:
  /// **'Monitoring / Progress & Mastery'**
  String get moduleMonitoringTitle;

  /// No description provided for @moduleAudioCastTitle.
  ///
  /// In en, this message translates to:
  /// **'AudioCast'**
  String get moduleAudioCastTitle;

  /// No description provided for @moduleAthleteProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Athlete Profile'**
  String get moduleAthleteProfileTitle;

  /// No description provided for @moduleTrainingCenterTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Center'**
  String get moduleTrainingCenterTitle;

  /// No description provided for @moduleChampionsHubTitle.
  ///
  /// In en, this message translates to:
  /// **'Champions Hub'**
  String get moduleChampionsHubTitle;

  /// No description provided for @moduleCompetitionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Competitions & Challenges'**
  String get moduleCompetitionsTitle;

  /// No description provided for @moduleNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get moduleNewsTitle;

  /// No description provided for @moduleStoreSubscriptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Store & Subscriptions'**
  String get moduleStoreSubscriptionsTitle;

  /// No description provided for @moduleClubAdministrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Club Administration'**
  String get moduleClubAdministrationTitle;

  /// No description provided for @moduleCoachForumTitle.
  ///
  /// In en, this message translates to:
  /// **'Coach Forum'**
  String get moduleCoachForumTitle;

  /// No description provided for @moduleOnlineCoursesTitle.
  ///
  /// In en, this message translates to:
  /// **'Online Courses'**
  String get moduleOnlineCoursesTitle;

  /// No description provided for @moduleCountryJudoHistoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Country Judo History'**
  String get moduleCountryJudoHistoryTitle;

  /// No description provided for @moduleAppManagementSettingsTitle.
  ///
  /// In en, this message translates to:
  /// **'App Management & Settings'**
  String get moduleAppManagementSettingsTitle;

  /// No description provided for @moduleTrainingProgramValidatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Training Program Validator'**
  String get moduleTrainingProgramValidatorTitle;

  /// No description provided for @viewLatestAnalysis.
  ///
  /// In en, this message translates to:
  /// **'View latest analysis'**
  String get viewLatestAnalysis;

  /// No description provided for @exploreReferenceTechnique.
  ///
  /// In en, this message translates to:
  /// **'Explore {techniqueName}'**
  String exploreReferenceTechnique(String techniqueName);

  /// No description provided for @homeAnalyzeUchiMataTitle.
  ///
  /// In en, this message translates to:
  /// **'Analyze Uchi Mata'**
  String get homeAnalyzeUchiMataTitle;

  /// No description provided for @moduleDirectorySurfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Explore by platform'**
  String get moduleDirectorySurfaceTitle;

  /// No description provided for @moduleDirectoryAllSurfaces.
  ///
  /// In en, this message translates to:
  /// **'All surfaces'**
  String get moduleDirectoryAllSurfaces;

  /// No description provided for @moduleAvailableDestinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Available now'**
  String get moduleAvailableDestinationsTitle;

  /// No description provided for @moduleNoAvailableDestinationForSurface.
  ///
  /// In en, this message translates to:
  /// **'No available destination is ready on this surface yet.'**
  String get moduleNoAvailableDestinationForSurface;

  /// No description provided for @moduleCurrentDestination.
  ///
  /// In en, this message translates to:
  /// **'Current destination'**
  String get moduleCurrentDestination;

  /// No description provided for @moduleUnavailableDeferredTitle.
  ///
  /// In en, this message translates to:
  /// **'Coming later'**
  String get moduleUnavailableDeferredTitle;

  /// No description provided for @moduleUnavailableDeferredSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} official modules are coming later'**
  String moduleUnavailableDeferredSummary(int count);

  /// No description provided for @progressOverviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific progress evidence'**
  String get progressOverviewTitle;

  /// No description provided for @progressOverviewDisclosure.
  ///
  /// In en, this message translates to:
  /// **'This local foundation summarizes only saved, versioned V2A evidence. It does not calculate mastery, performance, ranking or improvement.'**
  String get progressOverviewDisclosure;

  /// No description provided for @progressNoEvidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'No saved progress evidence'**
  String get progressNoEvidenceTitle;

  /// No description provided for @progressNoEvidenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Save a supported reviewed Uchi Mata V2A result before an evidence summary can be shown.'**
  String get progressNoEvidenceDescription;

  /// No description provided for @progressInvalidEvidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Progress evidence withheld'**
  String get progressInvalidEvidenceTitle;

  /// No description provided for @progressInvalidEvidenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Stored evidence is missing, malformed or outside the approved V2A boundary. Counts and comparisons are withheld.'**
  String get progressInvalidEvidenceDescription;

  /// No description provided for @progressIncompatibleEvidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Incompatible metric versions'**
  String get progressIncompatibleEvidenceTitle;

  /// No description provided for @progressIncompatibleEvidenceDescription.
  ///
  /// In en, this message translates to:
  /// **'Stored metric versions are not compatible. Judo Mind will not compare or combine them.'**
  String get progressIncompatibleEvidenceDescription;

  /// No description provided for @progressSavedAttempts.
  ///
  /// In en, this message translates to:
  /// **'Saved attempts'**
  String get progressSavedAttempts;

  /// No description provided for @progressCompletedRecords.
  ///
  /// In en, this message translates to:
  /// **'Completed records'**
  String get progressCompletedRecords;

  /// No description provided for @progressLatestSaved.
  ///
  /// In en, this message translates to:
  /// **'Latest saved analysis'**
  String get progressLatestSaved;

  /// No description provided for @progressMetricEvidenceTitle.
  ///
  /// In en, this message translates to:
  /// **'Metric evidence status'**
  String get progressMetricEvidenceTitle;

  /// No description provided for @progressTechniqueVersionTitle.
  ///
  /// In en, this message translates to:
  /// **'Technique and method-version context'**
  String get progressTechniqueVersionTitle;

  /// No description provided for @progressTechniqueLabel.
  ///
  /// In en, this message translates to:
  /// **'Technique'**
  String get progressTechniqueLabel;

  /// No description provided for @progressNoVersionComparison.
  ///
  /// In en, this message translates to:
  /// **'Versions are displayed as evidence context only; metric values are not compared and no trend is inferred.'**
  String get progressNoVersionComparison;

  /// No description provided for @progressScientificBoundariesTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific boundaries'**
  String get progressScientificBoundariesTitle;

  /// No description provided for @progressReviewRequiredBoundary.
  ///
  /// In en, this message translates to:
  /// **'UM-ANG-001 remains pending human review and is never upgraded automatically.'**
  String get progressReviewRequiredBoundary;

  /// No description provided for @progressMultiPersonBoundary.
  ///
  /// In en, this message translates to:
  /// **'Multi-person evidence remains insufficient.'**
  String get progressMultiPersonBoundary;

  /// No description provided for @progressInteractionBoundary.
  ///
  /// In en, this message translates to:
  /// **'Interaction metrics remain non-reportable.'**
  String get progressInteractionBoundary;

  /// No description provided for @progressMasteryUnavailableTitle.
  ///
  /// In en, this message translates to:
  /// **'Mastery is unavailable'**
  String get progressMasteryUnavailableTitle;

  /// No description provided for @progressMasteryUnavailableDescription.
  ///
  /// In en, this message translates to:
  /// **'A scientifically validated mastery, score, ranking, readiness or proficiency system has not been implemented.'**
  String get progressMasteryUnavailableDescription;

  /// No description provided for @progressOpenHistory.
  ///
  /// In en, this message translates to:
  /// **'Open local validation history'**
  String get progressOpenHistory;

  /// No description provided for @progressTimelineTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved evidence timeline'**
  String get progressTimelineTitle;

  /// No description provided for @uchiMata.
  ///
  /// In en, this message translates to:
  /// **'Uchi Mata'**
  String get uchiMata;

  /// No description provided for @techniqueCatalogAvailabilitySummary.
  ///
  /// In en, this message translates to:
  /// **'{availableCount} technique available now · {roadmapCount}-technique roadmap'**
  String techniqueCatalogAvailabilitySummary(
    int availableCount,
    int roadmapCount,
  );

  /// No description provided for @techniqueCatalogPreviewSummary.
  ///
  /// In en, this message translates to:
  /// **'{count} incomplete previews are visible but unavailable'**
  String techniqueCatalogPreviewSummary(int count);

  /// No description provided for @techniquePreviewUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Preview only · full experience unavailable'**
  String get techniquePreviewUnavailable;

  /// No description provided for @visualLayerMovement.
  ///
  /// In en, this message translates to:
  /// **'Movement'**
  String get visualLayerMovement;

  /// No description provided for @visualLayerControl.
  ///
  /// In en, this message translates to:
  /// **'Control'**
  String get visualLayerControl;

  /// No description provided for @visualLayerIllustrativeDirection.
  ///
  /// In en, this message translates to:
  /// **'Illustrative direction'**
  String get visualLayerIllustrativeDirection;

  /// No description provided for @uchiMataBiomechanicsVisualizationTitle.
  ///
  /// In en, this message translates to:
  /// **'Uchi Mata movement visualization'**
  String get uchiMataBiomechanicsVisualizationTitle;

  /// No description provided for @uchiMataBiomechanicsVisualizationDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore posture, illustrative direction, balance and body-position concepts throughout the throw.'**
  String get uchiMataBiomechanicsVisualizationDescription;

  /// No description provided for @educationalVisualizationNotMeasurement.
  ///
  /// In en, this message translates to:
  /// **'Educational visualization — not a measurement'**
  String get educationalVisualizationNotMeasurement;

  /// No description provided for @sourceGeneralReferenceDisclosure.
  ///
  /// In en, this message translates to:
  /// **'These are organization homepages and general references, not technique-specific direct evidence.'**
  String get sourceGeneralReferenceDisclosure;

  /// No description provided for @clubAdministrationTitle.
  ///
  /// In en, this message translates to:
  /// **'Club administration'**
  String get clubAdministrationTitle;

  /// No description provided for @clubLocalFoundationNotice.
  ///
  /// In en, this message translates to:
  /// **'Information in this section is currently stored only on this device. Cloud sync, multi-user access and official verification are not available.'**
  String get clubLocalFoundationNotice;

  /// No description provided for @clubEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No local club yet'**
  String get clubEmptyTitle;

  /// No description provided for @clubEmptyDescription.
  ///
  /// In en, this message translates to:
  /// **'Create one local club to organize the current local athlete, a training group, sessions and attendance on this device.'**
  String get clubEmptyDescription;

  /// No description provided for @clubCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Register club'**
  String get clubCreateAction;

  /// No description provided for @clubEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit club'**
  String get clubEditAction;

  /// No description provided for @clubNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Club name'**
  String get clubNameLabel;

  /// No description provided for @clubDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional description'**
  String get clubDescriptionLabel;

  /// No description provided for @clubSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save club'**
  String get clubSaveAction;

  /// No description provided for @clubSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'The local club could not be saved.'**
  String get clubSaveFailed;

  /// No description provided for @clubStorageInvalidTitle.
  ///
  /// In en, this message translates to:
  /// **'Club records are unavailable'**
  String get clubStorageInvalidTitle;

  /// No description provided for @clubStorageInvalidDescription.
  ///
  /// In en, this message translates to:
  /// **'Stored club data is malformed or incompatible. It was not treated as valid or overwritten.'**
  String get clubStorageInvalidDescription;

  /// No description provided for @clubDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Local overview'**
  String get clubDashboardTitle;

  /// No description provided for @clubMembersCount.
  ///
  /// In en, this message translates to:
  /// **'Athletes: {count}'**
  String clubMembersCount(String count);

  /// No description provided for @clubGroupsCount.
  ///
  /// In en, this message translates to:
  /// **'Groups: {count}'**
  String clubGroupsCount(String count);

  /// No description provided for @clubSessionsCount.
  ///
  /// In en, this message translates to:
  /// **'Sessions: {count}'**
  String clubSessionsCount(String count);

  /// No description provided for @clubAttendanceCount.
  ///
  /// In en, this message translates to:
  /// **'Attendance records: {count}'**
  String clubAttendanceCount(String count);

  /// No description provided for @clubRosterTitle.
  ///
  /// In en, this message translates to:
  /// **'Club athletes'**
  String get clubRosterTitle;

  /// No description provided for @clubRosterEmpty.
  ///
  /// In en, this message translates to:
  /// **'No athlete is linked to this local club.'**
  String get clubRosterEmpty;

  /// No description provided for @clubLinkCurrentAthlete.
  ///
  /// In en, this message translates to:
  /// **'Add current profile to club'**
  String get clubLinkCurrentAthlete;

  /// No description provided for @clubCurrentAthleteFallback.
  ///
  /// In en, this message translates to:
  /// **'Current local athlete'**
  String get clubCurrentAthleteFallback;

  /// No description provided for @clubCurrentAthleteLinked.
  ///
  /// In en, this message translates to:
  /// **'Linked to the current Athlete Profile'**
  String get clubCurrentAthleteLinked;

  /// No description provided for @clubMembershipNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional membership number'**
  String get clubMembershipNumberLabel;

  /// No description provided for @clubAthleteLinkLimitation.
  ///
  /// In en, this message translates to:
  /// **'This foundation can link only the current local Athlete Profile. Additional athletes and verified identities are not available.'**
  String get clubAthleteLinkLimitation;

  /// No description provided for @clubGroupsTitle.
  ///
  /// In en, this message translates to:
  /// **'Training groups'**
  String get clubGroupsTitle;

  /// No description provided for @clubGroupEmpty.
  ///
  /// In en, this message translates to:
  /// **'No training group has been created.'**
  String get clubGroupEmpty;

  /// No description provided for @clubGroupCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get clubGroupCreateAction;

  /// No description provided for @clubGroupNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Group name'**
  String get clubGroupNameLabel;

  /// No description provided for @clubGroupDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional group description'**
  String get clubGroupDescriptionLabel;

  /// No description provided for @clubGroupAssignCurrentAthlete.
  ///
  /// In en, this message translates to:
  /// **'Add current athlete to this group'**
  String get clubGroupAssignCurrentAthlete;

  /// No description provided for @clubGroupMemberCount.
  ///
  /// In en, this message translates to:
  /// **'Assigned members: {count}'**
  String clubGroupMemberCount(String count);

  /// No description provided for @clubSessionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Training sessions'**
  String get clubSessionsTitle;

  /// No description provided for @clubSessionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No training session has been created.'**
  String get clubSessionEmpty;

  /// No description provided for @clubSessionCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Add session'**
  String get clubSessionCreateAction;

  /// No description provided for @clubSessionGroupLabel.
  ///
  /// In en, this message translates to:
  /// **'Training group'**
  String get clubSessionGroupLabel;

  /// No description provided for @clubSessionScheduledLabel.
  ///
  /// In en, this message translates to:
  /// **'Scheduled'**
  String get clubSessionScheduledLabel;

  /// No description provided for @clubSessionDurationLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional duration in minutes'**
  String get clubSessionDurationLabel;

  /// No description provided for @clubSessionDurationValue.
  ///
  /// In en, this message translates to:
  /// **'{count} minutes'**
  String clubSessionDurationValue(String count);

  /// No description provided for @clubAttendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get clubAttendanceTitle;

  /// No description provided for @clubAttendancePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get clubAttendancePresent;

  /// No description provided for @clubAttendanceAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get clubAttendanceAbsent;

  /// No description provided for @clubAttendanceExcused.
  ///
  /// In en, this message translates to:
  /// **'Excused'**
  String get clubAttendanceExcused;

  /// No description provided for @clubAttendanceNotRecorded.
  ///
  /// In en, this message translates to:
  /// **'Not recorded'**
  String get clubAttendanceNotRecorded;

  /// No description provided for @clubOperationFailed.
  ///
  /// In en, this message translates to:
  /// **'The local change could not be saved.'**
  String get clubOperationFailed;

  /// No description provided for @clubRequiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required.'**
  String get clubRequiredField;

  /// No description provided for @clubInvalidDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter a whole number from 1 to 1440.'**
  String get clubInvalidDuration;

  /// No description provided for @clubCreateGroupFirst.
  ///
  /// In en, this message translates to:
  /// **'Create a training group before adding a session.'**
  String get clubCreateGroupFirst;

  /// No description provided for @clubSavedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Club changes were saved on this device.'**
  String get clubSavedFeedback;

  /// No description provided for @clubAthleteLinkedFeedback.
  ///
  /// In en, this message translates to:
  /// **'The current profile was added to the club.'**
  String get clubAthleteLinkedFeedback;

  /// No description provided for @clubGroupSavedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Training group was saved.'**
  String get clubGroupSavedFeedback;

  /// No description provided for @clubSessionSavedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Session plan was saved.'**
  String get clubSessionSavedFeedback;

  /// No description provided for @clubAttendanceSavedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Attendance was saved.'**
  String get clubAttendanceSavedFeedback;

  /// No description provided for @clubSessionEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit session plan'**
  String get clubSessionEditAction;

  /// No description provided for @clubSessionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Session type'**
  String get clubSessionTypeLabel;

  /// No description provided for @clubSessionTypeRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a session type.'**
  String get clubSessionTypeRequired;

  /// No description provided for @clubSessionTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional session title'**
  String get clubSessionTitleLabel;

  /// No description provided for @clubSessionObjectiveLabel.
  ///
  /// In en, this message translates to:
  /// **'Optional objective'**
  String get clubSessionObjectiveLabel;

  /// No description provided for @clubSessionTypeJudoTechnical.
  ///
  /// In en, this message translates to:
  /// **'Judo technical'**
  String get clubSessionTypeJudoTechnical;

  /// No description provided for @clubSessionTypeRandori.
  ///
  /// In en, this message translates to:
  /// **'Randori'**
  String get clubSessionTypeRandori;

  /// No description provided for @clubSessionTypeTactical.
  ///
  /// In en, this message translates to:
  /// **'Tactical'**
  String get clubSessionTypeTactical;

  /// No description provided for @clubSessionTypePhysicalPreparation.
  ///
  /// In en, this message translates to:
  /// **'Physical preparation'**
  String get clubSessionTypePhysicalPreparation;

  /// No description provided for @clubSessionTypeRecovery.
  ///
  /// In en, this message translates to:
  /// **'Recovery'**
  String get clubSessionTypeRecovery;

  /// No description provided for @clubSessionTypeAssessment.
  ///
  /// In en, this message translates to:
  /// **'Assessment'**
  String get clubSessionTypeAssessment;

  /// No description provided for @clubSessionTypeMixed.
  ///
  /// In en, this message translates to:
  /// **'Mixed'**
  String get clubSessionTypeMixed;

  /// No description provided for @clubSessionTypeOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get clubSessionTypeOther;

  /// No description provided for @clubSessionTypeUnspecifiedLegacy.
  ///
  /// In en, this message translates to:
  /// **'Type not specified'**
  String get clubSessionTypeUnspecifiedLegacy;

  /// No description provided for @clubLegacySessionTypeNotice.
  ///
  /// In en, this message translates to:
  /// **'This migrated session has no recorded type. Select a type before saving changes.'**
  String get clubLegacySessionTypeNotice;

  /// No description provided for @clubSessionItemsTitle.
  ///
  /// In en, this message translates to:
  /// **'Planned session items'**
  String get clubSessionItemsTitle;

  /// No description provided for @clubSessionItemsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No plan items were added.'**
  String get clubSessionItemsEmpty;

  /// No description provided for @clubSessionItemsOptional.
  ///
  /// In en, this message translates to:
  /// **'Plan items are optional and coach-authored. They do not confirm that an athlete completed them.'**
  String get clubSessionItemsOptional;

  /// No description provided for @clubSessionAddItemAction.
  ///
  /// In en, this message translates to:
  /// **'Add plan item'**
  String get clubSessionAddItemAction;

  /// No description provided for @clubSessionEditItemAction.
  ///
  /// In en, this message translates to:
  /// **'Edit item'**
  String get clubSessionEditItemAction;

  /// No description provided for @clubSessionRemoveItemAction.
  ///
  /// In en, this message translates to:
  /// **'Remove item'**
  String get clubSessionRemoveItemAction;

  /// No description provided for @clubSessionMoveItemUp.
  ///
  /// In en, this message translates to:
  /// **'Move item up'**
  String get clubSessionMoveItemUp;

  /// No description provided for @clubSessionMoveItemDown.
  ///
  /// In en, this message translates to:
  /// **'Move item down'**
  String get clubSessionMoveItemDown;

  /// No description provided for @clubSessionItemTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity category'**
  String get clubSessionItemTypeLabel;

  /// No description provided for @clubSessionCustomTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Coach-authored item title'**
  String get clubSessionCustomTitleLabel;

  /// No description provided for @clubSessionCoachAuthoredDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Coach-authored item — not an approved exercise-library prescription.'**
  String get clubSessionCoachAuthoredDisclosure;

  /// No description provided for @clubSessionItemWarmUp.
  ///
  /// In en, this message translates to:
  /// **'Warm-up'**
  String get clubSessionItemWarmUp;

  /// No description provided for @clubSessionItemUkemi.
  ///
  /// In en, this message translates to:
  /// **'Ukemi'**
  String get clubSessionItemUkemi;

  /// No description provided for @clubSessionItemTechnicalInstruction.
  ///
  /// In en, this message translates to:
  /// **'Technical instruction'**
  String get clubSessionItemTechnicalInstruction;

  /// No description provided for @clubSessionItemUchikomi.
  ///
  /// In en, this message translates to:
  /// **'Uchikomi'**
  String get clubSessionItemUchikomi;

  /// No description provided for @clubSessionItemNagekomi.
  ///
  /// In en, this message translates to:
  /// **'Nagekomi'**
  String get clubSessionItemNagekomi;

  /// No description provided for @clubSessionItemGripFighting.
  ///
  /// In en, this message translates to:
  /// **'Grip fighting / kumi-kata'**
  String get clubSessionItemGripFighting;

  /// No description provided for @clubSessionItemTachiWaza.
  ///
  /// In en, this message translates to:
  /// **'Tachi-waza'**
  String get clubSessionItemTachiWaza;

  /// No description provided for @clubSessionItemNeWaza.
  ///
  /// In en, this message translates to:
  /// **'Ne-waza'**
  String get clubSessionItemNeWaza;

  /// No description provided for @clubSessionItemRandori.
  ///
  /// In en, this message translates to:
  /// **'Randori'**
  String get clubSessionItemRandori;

  /// No description provided for @clubSessionItemTacticalPractice.
  ///
  /// In en, this message translates to:
  /// **'Tactical practice'**
  String get clubSessionItemTacticalPractice;

  /// No description provided for @clubSessionItemCoolDown.
  ///
  /// In en, this message translates to:
  /// **'Cool-down'**
  String get clubSessionItemCoolDown;

  /// No description provided for @clubSessionItemPhysicalConditioningCustom.
  ///
  /// In en, this message translates to:
  /// **'Physical-conditioning custom item'**
  String get clubSessionItemPhysicalConditioningCustom;

  /// No description provided for @clubSessionItemCustomCoachAuthored.
  ///
  /// In en, this message translates to:
  /// **'Custom coach-authored item'**
  String get clubSessionItemCustomCoachAuthored;

  /// No description provided for @clubSessionDosageModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Dosage format'**
  String get clubSessionDosageModeLabel;

  /// No description provided for @clubSessionDosageDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get clubSessionDosageDuration;

  /// No description provided for @clubSessionDosageRepetitions.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get clubSessionDosageRepetitions;

  /// No description provided for @clubSessionDosageSetsRepetitions.
  ///
  /// In en, this message translates to:
  /// **'Sets × repetitions'**
  String get clubSessionDosageSetsRepetitions;

  /// No description provided for @clubSessionDosageRoundsDuration.
  ///
  /// In en, this message translates to:
  /// **'Rounds × duration'**
  String get clubSessionDosageRoundsDuration;

  /// No description provided for @clubSessionDosageDistance.
  ///
  /// In en, this message translates to:
  /// **'Distance'**
  String get clubSessionDosageDistance;

  /// No description provided for @clubSessionDosageDescriptive.
  ///
  /// In en, this message translates to:
  /// **'Descriptive / custom'**
  String get clubSessionDosageDescriptive;

  /// No description provided for @clubSessionDurationMinutesField.
  ///
  /// In en, this message translates to:
  /// **'Duration in minutes'**
  String get clubSessionDurationMinutesField;

  /// No description provided for @clubSessionRepetitionsField.
  ///
  /// In en, this message translates to:
  /// **'Repetitions'**
  String get clubSessionRepetitionsField;

  /// No description provided for @clubSessionSetsField.
  ///
  /// In en, this message translates to:
  /// **'Sets'**
  String get clubSessionSetsField;

  /// No description provided for @clubSessionRoundsField.
  ///
  /// In en, this message translates to:
  /// **'Rounds'**
  String get clubSessionRoundsField;

  /// No description provided for @clubSessionRoundDurationField.
  ///
  /// In en, this message translates to:
  /// **'Minutes per round'**
  String get clubSessionRoundDurationField;

  /// No description provided for @clubSessionDistanceMetersField.
  ///
  /// In en, this message translates to:
  /// **'Distance in metres'**
  String get clubSessionDistanceMetersField;

  /// No description provided for @clubSessionDosageDescriptionField.
  ///
  /// In en, this message translates to:
  /// **'Coach-entered dosage description'**
  String get clubSessionDosageDescriptionField;

  /// No description provided for @clubSessionRestSecondsField.
  ///
  /// In en, this message translates to:
  /// **'Optional rest in seconds'**
  String get clubSessionRestSecondsField;

  /// No description provided for @clubSessionCoachNotesField.
  ///
  /// In en, this message translates to:
  /// **'Optional coach notes'**
  String get clubSessionCoachNotesField;

  /// No description provided for @clubSessionSaveItemAction.
  ///
  /// In en, this message translates to:
  /// **'Save item'**
  String get clubSessionSaveItemAction;

  /// No description provided for @clubSessionPositiveNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter a positive number.'**
  String get clubSessionPositiveNumberError;

  /// No description provided for @clubSessionNonNegativeNumberError.
  ///
  /// In en, this message translates to:
  /// **'Enter zero or a positive whole number.'**
  String get clubSessionNonNegativeNumberError;

  /// No description provided for @clubSessionMeaningfulTextError.
  ///
  /// In en, this message translates to:
  /// **'Enter meaningful coach-authored text.'**
  String get clubSessionMeaningfulTextError;

  /// No description provided for @clubSessionDosageDurationValue.
  ///
  /// In en, this message translates to:
  /// **'{value} min'**
  String clubSessionDosageDurationValue(String value);

  /// No description provided for @clubSessionDosageRepetitionsValue.
  ///
  /// In en, this message translates to:
  /// **'{value} repetitions'**
  String clubSessionDosageRepetitionsValue(String value);

  /// No description provided for @clubSessionDosageSetsValue.
  ///
  /// In en, this message translates to:
  /// **'{sets} × {repetitions}'**
  String clubSessionDosageSetsValue(String sets, String repetitions);

  /// No description provided for @clubSessionDosageRoundsValue.
  ///
  /// In en, this message translates to:
  /// **'{rounds} rounds × {duration} min'**
  String clubSessionDosageRoundsValue(String rounds, String duration);

  /// No description provided for @clubSessionDosageDistanceValue.
  ///
  /// In en, this message translates to:
  /// **'{value} m'**
  String clubSessionDosageDistanceValue(String value);

  /// No description provided for @clubSessionRestValue.
  ///
  /// In en, this message translates to:
  /// **'Rest: {value} sec'**
  String clubSessionRestValue(String value);

  /// No description provided for @clubSessionAddNextItemAction.
  ///
  /// In en, this message translates to:
  /// **'Add next section'**
  String get clubSessionAddNextItemAction;

  /// No description provided for @clubSessionDuplicateItemAction.
  ///
  /// In en, this message translates to:
  /// **'Duplicate section'**
  String get clubSessionDuplicateItemAction;

  /// No description provided for @clubSessionSavePlanAction.
  ///
  /// In en, this message translates to:
  /// **'Save session plan'**
  String get clubSessionSavePlanAction;

  /// No description provided for @clubSessionItemIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete dosage'**
  String get clubSessionItemIncomplete;

  /// No description provided for @clubSessionPlanItemValidationError.
  ///
  /// In en, this message translates to:
  /// **'Complete the required fields in this section before saving.'**
  String get clubSessionPlanItemValidationError;

  /// No description provided for @clubSessionLiveSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Live plan summary'**
  String get clubSessionLiveSummaryTitle;

  /// No description provided for @clubSessionSummarySections.
  ///
  /// In en, this message translates to:
  /// **'Planned sections: {count}'**
  String clubSessionSummarySections(String count);

  /// No description provided for @clubSessionSummaryScheduledDuration.
  ///
  /// In en, this message translates to:
  /// **'Scheduled duration: {value} min'**
  String clubSessionSummaryScheduledDuration(String value);

  /// No description provided for @clubSessionSummaryTimeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Scheduled duration: not entered'**
  String get clubSessionSummaryTimeUnavailable;

  /// No description provided for @clubSessionSummaryCalculableTime.
  ///
  /// In en, this message translates to:
  /// **'Calculable planned activity time: {value} min'**
  String clubSessionSummaryCalculableTime(String value);

  /// No description provided for @clubSessionSummaryCalculablePartial.
  ///
  /// In en, this message translates to:
  /// **'Calculable planned activity time: {value} min (partial)'**
  String clubSessionSummaryCalculablePartial(String value);

  /// No description provided for @clubSessionSummaryCalculableUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Calculable planned activity time: unavailable'**
  String get clubSessionSummaryCalculableUnavailable;

  /// No description provided for @clubSessionUnsavedChangesTitle.
  ///
  /// In en, this message translates to:
  /// **'Unsaved changes'**
  String get clubSessionUnsavedChangesTitle;

  /// No description provided for @clubSessionUnsavedChangesDescription.
  ///
  /// In en, this message translates to:
  /// **'Discard the unsaved session plan changes?'**
  String get clubSessionUnsavedChangesDescription;

  /// No description provided for @clubSessionDiscardChangesAction.
  ///
  /// In en, this message translates to:
  /// **'Discard changes'**
  String get clubSessionDiscardChangesAction;

  /// No description provided for @clubSessionContinueEditingAction.
  ///
  /// In en, this message translates to:
  /// **'Continue editing'**
  String get clubSessionContinueEditingAction;

  /// No description provided for @exerciseLibraryTitle.
  ///
  /// In en, this message translates to:
  /// **'Exercise Library'**
  String get exerciseLibraryTitle;

  /// No description provided for @exerciseLibraryOpenAction.
  ///
  /// In en, this message translates to:
  /// **'Open Exercise Library'**
  String get exerciseLibraryOpenAction;

  /// No description provided for @exerciseLibraryDescription.
  ///
  /// In en, this message translates to:
  /// **'Build a reusable local library for Club session planning.'**
  String get exerciseLibraryDescription;

  /// No description provided for @exerciseLibraryStorageFailure.
  ///
  /// In en, this message translates to:
  /// **'The local exercise library could not be read safely.'**
  String get exerciseLibraryStorageFailure;

  /// No description provided for @exerciseLibraryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No local exercises yet'**
  String get exerciseLibraryEmptyTitle;

  /// No description provided for @exerciseApprovedLibraryEmptyDisclosure.
  ///
  /// In en, this message translates to:
  /// **'The approved repository is empty. No exercise is shown as approved without review evidence.'**
  String get exerciseApprovedLibraryEmptyDisclosure;

  /// No description provided for @exerciseFilteredEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercises match these filters.'**
  String get exerciseFilteredEmpty;

  /// No description provided for @exerciseSearchLabel.
  ///
  /// In en, this message translates to:
  /// **'Search exercises'**
  String get exerciseSearchLabel;

  /// No description provided for @exerciseCategoryFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Activity category'**
  String get exerciseCategoryFilterLabel;

  /// No description provided for @exerciseSourceFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get exerciseSourceFilterLabel;

  /// No description provided for @exerciseReviewFilterLabel.
  ///
  /// In en, this message translates to:
  /// **'Review status'**
  String get exerciseReviewFilterLabel;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @exerciseCreateAction.
  ///
  /// In en, this message translates to:
  /// **'Create coach exercise'**
  String get exerciseCreateAction;

  /// No description provided for @exerciseEditAction.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get exerciseEditAction;

  /// No description provided for @exerciseArchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get exerciseArchiveAction;

  /// No description provided for @exerciseUnarchiveAction.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get exerciseUnarchiveAction;

  /// No description provided for @exerciseArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get exerciseArchived;

  /// No description provided for @exerciseApprovedBadge.
  ///
  /// In en, this message translates to:
  /// **'Approved repository'**
  String get exerciseApprovedBadge;

  /// No description provided for @exerciseCoachAuthoredBadge.
  ///
  /// In en, this message translates to:
  /// **'Coach-authored'**
  String get exerciseCoachAuthoredBadge;

  /// No description provided for @exerciseCoachAuthoredDisclosure.
  ///
  /// In en, this message translates to:
  /// **'Coach-authored — not scientifically reviewed'**
  String get exerciseCoachAuthoredDisclosure;

  /// No description provided for @exerciseSavedFeedback.
  ///
  /// In en, this message translates to:
  /// **'Exercise saved locally.'**
  String get exerciseSavedFeedback;

  /// No description provided for @exerciseNameEn.
  ///
  /// In en, this message translates to:
  /// **'English name'**
  String get exerciseNameEn;

  /// No description provided for @exerciseNameFa.
  ///
  /// In en, this message translates to:
  /// **'Persian name'**
  String get exerciseNameFa;

  /// No description provided for @exerciseDescriptionEn.
  ///
  /// In en, this message translates to:
  /// **'English description (optional)'**
  String get exerciseDescriptionEn;

  /// No description provided for @exerciseDescriptionFa.
  ///
  /// In en, this message translates to:
  /// **'Persian description (optional)'**
  String get exerciseDescriptionFa;

  /// No description provided for @exerciseModalityLabel.
  ///
  /// In en, this message translates to:
  /// **'Exercise modality'**
  String get exerciseModalityLabel;

  /// No description provided for @exerciseSupportedDosageModes.
  ///
  /// In en, this message translates to:
  /// **'Coach-entered dosage modes'**
  String get exerciseSupportedDosageModes;

  /// No description provided for @exerciseReviewApproved.
  ///
  /// In en, this message translates to:
  /// **'Approved'**
  String get exerciseReviewApproved;

  /// No description provided for @exerciseReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Review required'**
  String get exerciseReviewRequired;

  /// No description provided for @exerciseReviewNotScientific.
  ///
  /// In en, this message translates to:
  /// **'Not scientifically reviewed'**
  String get exerciseReviewNotScientific;

  /// No description provided for @exerciseModalityFreeWeight.
  ///
  /// In en, this message translates to:
  /// **'Free weight'**
  String get exerciseModalityFreeWeight;

  /// No description provided for @exerciseModalityMachine.
  ///
  /// In en, this message translates to:
  /// **'Machine'**
  String get exerciseModalityMachine;

  /// No description provided for @exerciseModalityBodyweight.
  ///
  /// In en, this message translates to:
  /// **'Bodyweight'**
  String get exerciseModalityBodyweight;

  /// No description provided for @exerciseModalityConditioning.
  ///
  /// In en, this message translates to:
  /// **'Physical conditioning'**
  String get exerciseModalityConditioning;

  /// No description provided for @exerciseModalityBand.
  ///
  /// In en, this message translates to:
  /// **'Resistance band'**
  String get exerciseModalityBand;

  /// No description provided for @exerciseModalityShadow.
  ///
  /// In en, this message translates to:
  /// **'Shadow training'**
  String get exerciseModalityShadow;

  /// No description provided for @exerciseModalityMobility.
  ///
  /// In en, this message translates to:
  /// **'Mobility / recovery'**
  String get exerciseModalityMobility;

  /// No description provided for @exerciseModalityJudoDrill.
  ///
  /// In en, this message translates to:
  /// **'Judo-specific drill'**
  String get exerciseModalityJudoDrill;

  /// No description provided for @exerciseModalityOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get exerciseModalityOther;

  /// No description provided for @exerciseSaveAction.
  ///
  /// In en, this message translates to:
  /// **'Save exercise'**
  String get exerciseSaveAction;

  /// No description provided for @exerciseChooseFromLibraryAction.
  ///
  /// In en, this message translates to:
  /// **'Choose from Exercise Library'**
  String get exerciseChooseFromLibraryAction;

  /// No description provided for @exerciseWriteManuallyAction.
  ///
  /// In en, this message translates to:
  /// **'Write manually'**
  String get exerciseWriteManuallyAction;

  /// No description provided for @exerciseLibrarySelectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose an exercise'**
  String get exerciseLibrarySelectionTitle;

  /// No description provided for @exerciseLibrarySelectionEmpty.
  ///
  /// In en, this message translates to:
  /// **'No active exercise is available. Create a coach-authored entry in the Exercise Library first.'**
  String get exerciseLibrarySelectionEmpty;

  /// No description provided for @exerciseLinkedReference.
  ///
  /// In en, this message translates to:
  /// **'Linked library snapshot · revision {revision}'**
  String exerciseLinkedReference(String revision);

  /// No description provided for @exerciseImportCsvAction.
  ///
  /// In en, this message translates to:
  /// **'Import CSV'**
  String get exerciseImportCsvAction;

  /// No description provided for @exerciseMoreFilters.
  ///
  /// In en, this message translates to:
  /// **'More filters'**
  String get exerciseMoreFilters;

  /// No description provided for @exerciseRecentTitle.
  ///
  /// In en, this message translates to:
  /// **'Recently selected'**
  String get exerciseRecentTitle;

  /// No description provided for @exerciseFavoritesTitle.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get exerciseFavoritesTitle;

  /// No description provided for @exerciseResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'Results'**
  String get exerciseResultsTitle;

  /// No description provided for @exerciseFavoritesFilter.
  ///
  /// In en, this message translates to:
  /// **'Favorites ({count})'**
  String exerciseFavoritesFilter(String count);

  /// No description provided for @exerciseRecentFilter.
  ///
  /// In en, this message translates to:
  /// **'Recent ({count})'**
  String exerciseRecentFilter(String count);

  /// No description provided for @exerciseFavoritesEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercises have been added to favorites yet.'**
  String get exerciseFavoritesEmpty;

  /// No description provided for @exerciseRecentEmpty.
  ///
  /// In en, this message translates to:
  /// **'No exercise has been selected recently yet.'**
  String get exerciseRecentEmpty;

  /// No description provided for @exerciseTranslationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Translation unavailable in the selected language'**
  String get exerciseTranslationUnavailable;

  /// No description provided for @exerciseAddFavorite.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get exerciseAddFavorite;

  /// No description provided for @exerciseRemoveFavorite.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get exerciseRemoveFavorite;

  /// No description provided for @exerciseImportPreviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review CSV import'**
  String get exerciseImportPreviewTitle;

  /// No description provided for @exerciseImportTotal.
  ///
  /// In en, this message translates to:
  /// **'Rows: {count}'**
  String exerciseImportTotal(String count);

  /// No description provided for @exerciseImportValid.
  ///
  /// In en, this message translates to:
  /// **'Valid: {count}'**
  String exerciseImportValid(String count);

  /// No description provided for @exerciseImportInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid: {count}'**
  String exerciseImportInvalid(String count);

  /// No description provided for @exerciseImportDuplicates.
  ///
  /// In en, this message translates to:
  /// **'Duplicates: {count}'**
  String exerciseImportDuplicates(String count);

  /// No description provided for @exerciseImportFileError.
  ///
  /// In en, this message translates to:
  /// **'File error: {code}'**
  String exerciseImportFileError(String code);

  /// No description provided for @exerciseImportRowError.
  ///
  /// In en, this message translates to:
  /// **'Row {row}: {errors}'**
  String exerciseImportRowError(String row, String errors);

  /// No description provided for @exerciseImportConfirmAction.
  ///
  /// In en, this message translates to:
  /// **'Import valid rows'**
  String get exerciseImportConfirmAction;

  /// No description provided for @exerciseImportSaved.
  ///
  /// In en, this message translates to:
  /// **'Imported {count} exercises locally.'**
  String exerciseImportSaved(String count);

  /// No description provided for @exerciseImportIssueEmptyFile.
  ///
  /// In en, this message translates to:
  /// **'The file is empty'**
  String get exerciseImportIssueEmptyFile;

  /// No description provided for @exerciseImportIssueInvalidUtf8.
  ///
  /// In en, this message translates to:
  /// **'The file is not valid UTF-8'**
  String get exerciseImportIssueInvalidUtf8;

  /// No description provided for @exerciseImportIssueMalformedCsv.
  ///
  /// In en, this message translates to:
  /// **'Malformed CSV row or quoting'**
  String get exerciseImportIssueMalformedCsv;

  /// No description provided for @exerciseImportIssueHeader.
  ///
  /// In en, this message translates to:
  /// **'The canonical header is missing or changed'**
  String get exerciseImportIssueHeader;

  /// No description provided for @exerciseImportIssueSchema.
  ///
  /// In en, this message translates to:
  /// **'Unsupported schema version'**
  String get exerciseImportIssueSchema;

  /// No description provided for @exerciseImportIssueMissingId.
  ///
  /// In en, this message translates to:
  /// **'Exercise ID is required'**
  String get exerciseImportIssueMissingId;

  /// No description provided for @exerciseImportIssueDuplicateFile.
  ///
  /// In en, this message translates to:
  /// **'Exercise ID is duplicated in this file'**
  String get exerciseImportIssueDuplicateFile;

  /// No description provided for @exerciseImportIssueDuplicateStored.
  ///
  /// In en, this message translates to:
  /// **'Exercise ID already exists locally'**
  String get exerciseImportIssueDuplicateStored;

  /// No description provided for @exerciseImportIssueLocale.
  ///
  /// In en, this message translates to:
  /// **'Authoring language must be en or fa'**
  String get exerciseImportIssueLocale;

  /// No description provided for @exerciseImportIssueName.
  ///
  /// In en, this message translates to:
  /// **'The authoring-language name is required'**
  String get exerciseImportIssueName;

  /// No description provided for @exerciseImportIssueCategory.
  ///
  /// In en, this message translates to:
  /// **'Unsupported activity category'**
  String get exerciseImportIssueCategory;

  /// No description provided for @exerciseImportIssueModality.
  ///
  /// In en, this message translates to:
  /// **'Unsupported exercise modality'**
  String get exerciseImportIssueModality;

  /// No description provided for @exerciseImportIssueDosage.
  ///
  /// In en, this message translates to:
  /// **'Unsupported or missing dosage mode'**
  String get exerciseImportIssueDosage;

  /// No description provided for @exerciseImportIssueUrl.
  ///
  /// In en, this message translates to:
  /// **'Source URL must be a direct HTTP(S) page'**
  String get exerciseImportIssueUrl;

  /// No description provided for @exerciseImportIssueMediaLicense.
  ///
  /// In en, this message translates to:
  /// **'Unsupported media-license declaration'**
  String get exerciseImportIssueMediaLicense;

  /// No description provided for @exerciseImportIssueMediaDeclaration.
  ///
  /// In en, this message translates to:
  /// **'Media requires an owned-or-licensed declaration'**
  String get exerciseImportIssueMediaDeclaration;

  /// No description provided for @exerciseImportIssueRecord.
  ///
  /// In en, this message translates to:
  /// **'Record violates the Exercise Library contract'**
  String get exerciseImportIssueRecord;

  /// No description provided for @scientificTransparencyTitle.
  ///
  /// In en, this message translates to:
  /// **'Scientific status'**
  String get scientificTransparencyTitle;

  /// No description provided for @scientificTransparencyStatusIconLabel.
  ///
  /// In en, this message translates to:
  /// **'Scientific status information'**
  String get scientificTransparencyStatusIconLabel;

  /// No description provided for @scientificTransparencyHumanReviewPending.
  ///
  /// In en, this message translates to:
  /// **'Human review pending'**
  String get scientificTransparencyHumanReviewPending;

  /// No description provided for @scientificTransparencyNoApproval.
  ///
  /// In en, this message translates to:
  /// **'No scientific approval has been issued'**
  String get scientificTransparencyNoApproval;

  /// No description provided for @scientificTransparencyVideoValidationOnly.
  ///
  /// In en, this message translates to:
  /// **'Video analysis: validation only'**
  String get scientificTransparencyVideoValidationOnly;

  /// No description provided for @scientificTransparencySensitiveLocked.
  ///
  /// In en, this message translates to:
  /// **'Sensitive capabilities: locked'**
  String get scientificTransparencySensitiveLocked;

  /// No description provided for @scientificTransparencyNotReviewed.
  ///
  /// In en, this message translates to:
  /// **'Not scientifically reviewed'**
  String get scientificTransparencyNotReviewed;

  /// No description provided for @scientificTransparencyViewDetails.
  ///
  /// In en, this message translates to:
  /// **'View sources and limitations'**
  String get scientificTransparencyViewDetails;

  /// No description provided for @scientificTransparencyDetailsTitle.
  ///
  /// In en, this message translates to:
  /// **'Sources and limitations'**
  String get scientificTransparencyDetailsTitle;

  /// No description provided for @scientificTransparencyCurrentStatusSection.
  ///
  /// In en, this message translates to:
  /// **'Current scientific status'**
  String get scientificTransparencyCurrentStatusSection;

  /// No description provided for @scientificTransparencyCandidateCoverageSection.
  ///
  /// In en, this message translates to:
  /// **'Candidate source coverage'**
  String get scientificTransparencyCandidateCoverageSection;

  /// No description provided for @scientificTransparencyHumanReviewSection.
  ///
  /// In en, this message translates to:
  /// **'Human-review status'**
  String get scientificTransparencyHumanReviewSection;

  /// No description provided for @scientificTransparencyVideoLimitationsSection.
  ///
  /// In en, this message translates to:
  /// **'Video-analysis limitations'**
  String get scientificTransparencyVideoLimitationsSection;

  /// No description provided for @scientificTransparencySafetyBoundarySection.
  ///
  /// In en, this message translates to:
  /// **'Safety boundary'**
  String get scientificTransparencySafetyBoundarySection;

  /// No description provided for @scientificTransparencyDoesNotDoSection.
  ///
  /// In en, this message translates to:
  /// **'What this feature does not do'**
  String get scientificTransparencyDoesNotDoSection;

  /// No description provided for @scientificTransparencyHumanReviewLabel.
  ///
  /// In en, this message translates to:
  /// **'Human review'**
  String get scientificTransparencyHumanReviewLabel;

  /// No description provided for @scientificTransparencyApprovalLabel.
  ///
  /// In en, this message translates to:
  /// **'Scientific approval'**
  String get scientificTransparencyApprovalLabel;

  /// No description provided for @scientificTransparencyCandidateSource.
  ///
  /// In en, this message translates to:
  /// **'Candidate source'**
  String get scientificTransparencyCandidateSource;

  /// No description provided for @scientificTransparencyReviewPending.
  ///
  /// In en, this message translates to:
  /// **'Review pending'**
  String get scientificTransparencyReviewPending;

  /// No description provided for @scientificTransparencyNotApprovedForClaim.
  ///
  /// In en, this message translates to:
  /// **'Not yet approved for a Judo Mind claim'**
  String get scientificTransparencyNotApprovedForClaim;

  /// No description provided for @scientificTransparencyHumanReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'All five candidate sources are awaiting qualified human review. No source review is complete.'**
  String get scientificTransparencyHumanReviewDescription;

  /// No description provided for @scientificTransparencyMissingDataLocked.
  ///
  /// In en, this message translates to:
  /// **'The governed display data is missing or invalid. This information remains locked and not scientifically reviewed.'**
  String get scientificTransparencyMissingDataLocked;

  /// No description provided for @scientificTransparencyCapabilityPanelTitle.
  ///
  /// In en, this message translates to:
  /// **'Capability status'**
  String get scientificTransparencyCapabilityPanelTitle;

  /// No description provided for @scientificTransparencyStatusNotReviewed.
  ///
  /// In en, this message translates to:
  /// **'Not scientifically reviewed'**
  String get scientificTransparencyStatusNotReviewed;

  /// No description provided for @scientificTransparencyStatusHumanReviewPending.
  ///
  /// In en, this message translates to:
  /// **'Human review pending'**
  String get scientificTransparencyStatusHumanReviewPending;

  /// No description provided for @scientificTransparencyStatusReviewRequired.
  ///
  /// In en, this message translates to:
  /// **'Review required'**
  String get scientificTransparencyStatusReviewRequired;

  /// No description provided for @scientificTransparencyStatusValidationOnly.
  ///
  /// In en, this message translates to:
  /// **'Validation only'**
  String get scientificTransparencyStatusValidationOnly;

  /// No description provided for @scientificTransparencyStatusLocked.
  ///
  /// In en, this message translates to:
  /// **'Locked'**
  String get scientificTransparencyStatusLocked;

  /// No description provided for @scientificTransparencyStatusFullTextRequired.
  ///
  /// In en, this message translates to:
  /// **'Full text required'**
  String get scientificTransparencyStatusFullTextRequired;

  /// No description provided for @scientificTransparencyStatusMethodBlocked.
  ///
  /// In en, this message translates to:
  /// **'Method blocked'**
  String get scientificTransparencyStatusMethodBlocked;

  /// No description provided for @scientificTransparencyStatusSourceMappingRequired.
  ///
  /// In en, this message translates to:
  /// **'Source mapping required'**
  String get scientificTransparencyStatusSourceMappingRequired;

  /// No description provided for @scientificTransparencyStatusNotApplicable.
  ///
  /// In en, this message translates to:
  /// **'Not applicable'**
  String get scientificTransparencyStatusNotApplicable;

  /// No description provided for @scientificTransparencySourceTypeConsensus.
  ///
  /// In en, this message translates to:
  /// **'Consensus statement'**
  String get scientificTransparencySourceTypeConsensus;

  /// No description provided for @scientificTransparencySourceTypeSystematicReview.
  ///
  /// In en, this message translates to:
  /// **'Systematic review'**
  String get scientificTransparencySourceTypeSystematicReview;

  /// No description provided for @scientificTransparencySourceTypeMetaAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Meta-analysis'**
  String get scientificTransparencySourceTypeMetaAnalysis;

  /// No description provided for @scientificTransparencySourceTypeSystematicReviewMetaAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Systematic review and meta-analysis'**
  String get scientificTransparencySourceTypeSystematicReviewMetaAnalysis;

  /// No description provided for @scientificTransparencyAccessPublicFullText.
  ///
  /// In en, this message translates to:
  /// **'Public full text identified'**
  String get scientificTransparencyAccessPublicFullText;

  /// No description provided for @scientificTransparencyAccessValidatedRepository.
  ///
  /// In en, this message translates to:
  /// **'Validated repository copy'**
  String get scientificTransparencyAccessValidatedRepository;

  /// No description provided for @scientificTransparencyAccessAcceptedManuscript.
  ///
  /// In en, this message translates to:
  /// **'Validated accepted manuscript'**
  String get scientificTransparencyAccessAcceptedManuscript;

  /// No description provided for @scientificTransparencyAccessPublisherVersion.
  ///
  /// In en, this message translates to:
  /// **'Validated publisher version'**
  String get scientificTransparencyAccessPublisherVersion;

  /// No description provided for @scientificTransparencyCapabilityPoseSummary.
  ///
  /// In en, this message translates to:
  /// **'Single-camera pose summary'**
  String get scientificTransparencyCapabilityPoseSummary;

  /// No description provided for @scientificTransparencyCapabilityReviewedAttempt.
  ///
  /// In en, this message translates to:
  /// **'Human-reviewed single attempt'**
  String get scientificTransparencyCapabilityReviewedAttempt;

  /// No description provided for @scientificTransparencyCapabilityProjectedMetrics.
  ///
  /// In en, this message translates to:
  /// **'Projected 2D metrics'**
  String get scientificTransparencyCapabilityProjectedMetrics;

  /// No description provided for @scientificTransparencyCapabilityProjectedHipAngle.
  ///
  /// In en, this message translates to:
  /// **'Projected attacking-leg hip angle'**
  String get scientificTransparencyCapabilityProjectedHipAngle;

  /// No description provided for @scientificTransparencyCapabilityAutomaticIdentity.
  ///
  /// In en, this message translates to:
  /// **'Automatic athlete identity'**
  String get scientificTransparencyCapabilityAutomaticIdentity;

  /// No description provided for @scientificTransparencyCapabilityAutomaticPhases.
  ///
  /// In en, this message translates to:
  /// **'Automatic Kuzushi / Tsukuri / Kake phases'**
  String get scientificTransparencyCapabilityAutomaticPhases;

  /// No description provided for @scientificTransparencyCapabilityThreeDimensional.
  ///
  /// In en, this message translates to:
  /// **'3D reconstruction'**
  String get scientificTransparencyCapabilityThreeDimensional;

  /// No description provided for @scientificTransparencyCapabilityForceKinetics.
  ///
  /// In en, this message translates to:
  /// **'Force and kinetics from ordinary video'**
  String get scientificTransparencyCapabilityForceKinetics;

  /// No description provided for @scientificTransparencyCapabilityTrainingPrescription.
  ///
  /// In en, this message translates to:
  /// **'Training prescription activation'**
  String get scientificTransparencyCapabilityTrainingPrescription;

  /// No description provided for @scientificTransparencyUnknownCapability.
  ///
  /// In en, this message translates to:
  /// **'Unmapped sensitive capability'**
  String get scientificTransparencyUnknownCapability;

  /// No description provided for @scientificTransparencyLimitationEngineering.
  ///
  /// In en, this message translates to:
  /// **'Pose estimation provides engineering observations only.'**
  String get scientificTransparencyLimitationEngineering;

  /// No description provided for @scientificTransparencyLimitationNoForce.
  ///
  /// In en, this message translates to:
  /// **'It does not directly measure force or kinetics.'**
  String get scientificTransparencyLimitationNoForce;

  /// No description provided for @scientificTransparencyLimitationNoThreeDimensional.
  ///
  /// In en, this message translates to:
  /// **'It is not validated as definitive 3D biomechanical analysis.'**
  String get scientificTransparencyLimitationNoThreeDimensional;

  /// No description provided for @scientificTransparencyLimitationNoDiagnosis.
  ///
  /// In en, this message translates to:
  /// **'It does not diagnose technical errors or injury.'**
  String get scientificTransparencyLimitationNoDiagnosis;

  /// No description provided for @scientificTransparencyLimitationNoInjuryPrediction.
  ///
  /// In en, this message translates to:
  /// **'It does not predict injury.'**
  String get scientificTransparencyLimitationNoInjuryPrediction;

  /// No description provided for @scientificTransparencyLimitationNoReferee.
  ///
  /// In en, this message translates to:
  /// **'It does not make referee decisions.'**
  String get scientificTransparencyLimitationNoReferee;

  /// No description provided for @scientificTransparencyLimitationAssociation.
  ///
  /// In en, this message translates to:
  /// **'A statistical association must not be presented as causation.'**
  String get scientificTransparencyLimitationAssociation;

  /// No description provided for @scientificTransparencyLimitationRisk.
  ///
  /// In en, this message translates to:
  /// **'A risk indicator must not be presented as a certain prediction.'**
  String get scientificTransparencyLimitationRisk;

  /// No description provided for @scientificTransparencyLimitationMissingEvidence.
  ///
  /// In en, this message translates to:
  /// **'Missing evidence or approval keeps sensitive features locked.'**
  String get scientificTransparencyLimitationMissingEvidence;

  /// No description provided for @scientificTransparencySafetyBoundaryDescription.
  ///
  /// In en, this message translates to:
  /// **'This information is educational and read-only. It does not replace a qualified coach, clinician, sports-medicine professional or referee.'**
  String get scientificTransparencySafetyBoundaryDescription;

  /// No description provided for @scientificTransparencyDoesNotDoDescription.
  ///
  /// In en, this message translates to:
  /// **'This feature does not score performance, diagnose injury, prescribe training, predict outcomes, make referee decisions or enable locked scientific and AI capabilities.'**
  String get scientificTransparencyDoesNotDoDescription;

  /// No description provided for @guidedReviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Guided human review'**
  String get guidedReviewTitle;

  /// No description provided for @guidedReviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Choose and visually confirm exact decoded start/end frames and one review frame. Detection indices remain internal.'**
  String get guidedReviewDescription;

  /// No description provided for @guidedAttemptStart.
  ///
  /// In en, this message translates to:
  /// **'Attempt start'**
  String get guidedAttemptStart;

  /// No description provided for @guidedAttemptEnd.
  ///
  /// In en, this message translates to:
  /// **'Attempt end'**
  String get guidedAttemptEnd;

  /// No description provided for @guidedAttemptStartFrame.
  ///
  /// In en, this message translates to:
  /// **'Attempt start frame'**
  String get guidedAttemptStartFrame;

  /// No description provided for @guidedAttemptEndFrame.
  ///
  /// In en, this message translates to:
  /// **'Attempt end frame'**
  String get guidedAttemptEndFrame;

  /// No description provided for @guidedPreviousFrame.
  ///
  /// In en, this message translates to:
  /// **'Step one frame backward'**
  String get guidedPreviousFrame;

  /// No description provided for @guidedNextFrame.
  ///
  /// In en, this message translates to:
  /// **'Step one frame forward'**
  String get guidedNextFrame;

  /// No description provided for @guidedConfirmAttemptBoundaries.
  ///
  /// In en, this message translates to:
  /// **'I confirm these frames bound the intended attempt'**
  String get guidedConfirmAttemptBoundaries;

  /// No description provided for @guidedSingleAttemptCaptureGuidance.
  ///
  /// In en, this message translates to:
  /// **'For best results, upload one technique attempt. If the video contains several attempts, select only one continuous attempt for each analysis.'**
  String get guidedSingleAttemptCaptureGuidance;

  /// No description provided for @guidedConfirmSingleAttempt.
  ///
  /// In en, this message translates to:
  /// **'I confirm this selected interval contains one continuous {techniqueName} attempt only.'**
  String guidedConfirmSingleAttempt(String techniqueName);

  /// No description provided for @guidedBoundaryVisualReview.
  ///
  /// In en, this message translates to:
  /// **'Inspect the start and end frames in the video preview before confirming.'**
  String get guidedBoundaryVisualReview;

  /// No description provided for @guidedSourceTiming.
  ///
  /// In en, this message translates to:
  /// **'Source timing'**
  String get guidedSourceTiming;

  /// No description provided for @guidedSourceRealTime.
  ///
  /// In en, this message translates to:
  /// **'Real-time video'**
  String get guidedSourceRealTime;

  /// No description provided for @guidedSourceTimingUnknown.
  ///
  /// In en, this message translates to:
  /// **'Timing unknown'**
  String get guidedSourceTimingUnknown;

  /// No description provided for @guidedSourceTimingRequired.
  ///
  /// In en, this message translates to:
  /// **'Select a supported source timing state. Known time-scale entry is not available in this bounded UI yet.'**
  String get guidedSourceTimingRequired;

  /// No description provided for @guidedLoadFrames.
  ///
  /// In en, this message translates to:
  /// **'Load decoded frames'**
  String get guidedLoadFrames;

  /// No description provided for @guidedTimingEvidence.
  ///
  /// In en, this message translates to:
  /// **'Timing mode: {mode} · {provenance}'**
  String guidedTimingEvidence(String mode, String provenance);

  /// No description provided for @guidedReviewMoment.
  ///
  /// In en, this message translates to:
  /// **'User-selected review moment'**
  String get guidedReviewMoment;

  /// No description provided for @guidedPrepareReview.
  ///
  /// In en, this message translates to:
  /// **'Prepare review'**
  String get guidedPrepareReview;

  /// No description provided for @guidedPreparing.
  ///
  /// In en, this message translates to:
  /// **'Preparing selected moment...'**
  String get guidedPreparing;

  /// No description provided for @guidedEditAttemptBoundaries.
  ///
  /// In en, this message translates to:
  /// **'Edit attempt boundaries'**
  String get guidedEditAttemptBoundaries;

  /// No description provided for @guidedSelectTori.
  ///
  /// In en, this message translates to:
  /// **'Select the athlete performing Uchi Mata'**
  String get guidedSelectTori;

  /// No description provided for @guidedToriBoundary.
  ///
  /// In en, this message translates to:
  /// **'The athlete selection is confirmed by you. Judo Mind has not automatically identified the athlete.'**
  String get guidedToriBoundary;

  /// No description provided for @guidedFrameCandidateEvidenceBoundary.
  ///
  /// In en, this message translates to:
  /// **'These are frame-local model-returned pose candidates. They are not a people count, identity, role, or temporal tracking evidence.'**
  String get guidedFrameCandidateEvidenceBoundary;

  /// No description provided for @guidedCandidateEvidenceReady.
  ///
  /// In en, this message translates to:
  /// **'Two selectable frame candidates are available for your human selection.'**
  String get guidedCandidateEvidenceReady;

  /// No description provided for @guidedCandidateEvidenceInsufficient.
  ///
  /// In en, this message translates to:
  /// **'Insufficient candidate evidence for human role confirmation. From {detectedCount} model-returned pose candidate(s), only {selectableCount} usable frame candidate is available at this review moment. This does not mean only one person is present. Two independent frame candidates are required to continue.'**
  String guidedCandidateEvidenceInsufficient(
    int detectedCount,
    int selectableCount,
  );

  /// No description provided for @guidedNoSelectableCandidateEvidence.
  ///
  /// In en, this message translates to:
  /// **'The model returned {detectedCount} pose candidate(s) in this frame, but none contain selectable pose evidence. Analysis remains blocked.'**
  String guidedNoSelectableCandidateEvidence(int detectedCount);

  /// No description provided for @guidedCandidatePoseEvidence.
  ///
  /// In en, this message translates to:
  /// **'Required 2D landmarks available: {availableCount}/{requiredCount} (model-estimated).'**
  String guidedCandidatePoseEvidence(int availableCount, int requiredCount);

  /// No description provided for @guidedCandidateVisibilityAvailable.
  ///
  /// In en, this message translates to:
  /// **'Model landmark visibility available: {availableCount}/{requiredCount}. This is not pose accuracy.'**
  String guidedCandidateVisibilityAvailable(
    int availableCount,
    int requiredCount,
  );

  /// No description provided for @guidedCandidateVisibilityPartial.
  ///
  /// In en, this message translates to:
  /// **'Model landmark visibility is partial: {availableCount}/{requiredCount}. This is not pose accuracy.'**
  String guidedCandidateVisibilityPartial(
    int availableCount,
    int requiredCount,
  );

  /// No description provided for @guidedCandidateVisibilityUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Model landmark visibility is unavailable; no accuracy or confidence is inferred.'**
  String get guidedCandidateVisibilityUnavailable;

  /// No description provided for @guidedCandidate.
  ///
  /// In en, this message translates to:
  /// **'Frame candidate {number}'**
  String guidedCandidate(int number);

  /// No description provided for @guidedConfirmTori.
  ///
  /// In en, this message translates to:
  /// **'I confirm this selected frame candidate is Tori for this attempt'**
  String get guidedConfirmTori;

  /// No description provided for @guidedNotSure.
  ///
  /// In en, this message translates to:
  /// **'Not sure'**
  String get guidedNotSure;

  /// No description provided for @guidedNotSureAthlete.
  ///
  /// In en, this message translates to:
  /// **'I cannot reliably distinguish the athlete in this frame'**
  String get guidedNotSureAthlete;

  /// No description provided for @guidedReviewBoundaryError.
  ///
  /// In en, this message translates to:
  /// **'Choose an end after the start and keep the review moment inside the attempt.'**
  String get guidedReviewBoundaryError;

  /// No description provided for @guidedReviewUncertainWithheld.
  ///
  /// In en, this message translates to:
  /// **'Review withheld: make every required human selection and continue only when you are sure.'**
  String get guidedReviewUncertainWithheld;

  /// No description provided for @guidedReviewBackendError.
  ///
  /// In en, this message translates to:
  /// **'The guided review failed safely. Retry preparation if appropriate.'**
  String get guidedReviewBackendError;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'fa',
    'fr',
    'ja',
    'ru',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'ja':
      return AppLocalizationsJa();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
