import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:judo_mind/core/ai/analysis/single_attempt_v2a_service.dart';
import 'package:judo_mind/core/ai/analysis/grounded_sensei_service.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/core/providers/local_athlete_profile_provider.dart';
import 'package:judo_mind/data/repositories/local_athlete_profile_repository.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_athlete_profile_storage.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/models/grounded_sensei.dart';
import 'package:judo_mind/models/single_attempt_analysis_v2a.dart';
import 'package:judo_mind/models/single_attempt_v2a_request.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/single_attempt_v2a_review_panel.dart';
import 'package:judo_mind/screens/profile/athlete_profile_screen.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  testWidgets('withholds submission until every reviewed field is supplied', (
    tester,
  ) async {
    final service = _CapturingService();
    await _pumpPanel(tester, service);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pump();

    expect(service.calls, 0);
    expect(find.byKey(const ValueKey('reviewed-v2a-error')), findsOneWidget);
  });

  testWidgets('submits an exact human-reviewed request to the typed service', (
    tester,
  ) async {
    final service = _CapturingService();
    await _pumpPanel(tester, service);
    await _completeReviewedForm(tester);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pumpAndSettle();

    expect(service.calls, 1);
    final request = service.request!;
    expect(request.videoPath, 'D:/authorized/uchi-mata.mp4');
    expect(request.videoId, 'local-authorized-video');
    expect(request.cameraView, 'side');
    expect(request.neutralTrackId, 'Track A');
    expect(request.selectedDetectionIndex, 0);
    expect(request.supportLeg, ReviewedSupportLeg.left);
    expect(request.attackingLeg, ReviewedAttackingLeg.right);
    expect(request.eventSchemaId, 'human-single-attempt-boundaries-v1');
    expect(request.isValid, isTrue);
    expect(
      find.byKey(const ValueKey('single-attempt-v2a-result')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('reviewed-v2a-error')), findsNothing);
    expect(find.text('Fixture reviewed result limitation.'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('save-v2a-attempt-locally')),
      findsNothing,
      reason: 'A result outside the strict scientific boundary is not savable.',
    );
  });

  testWidgets('valid result is saved only after the explicit local-save tap', (
    tester,
  ) async {
    final storage = _MemoryStorage();
    final service = _CapturingService(returnsValidResult: true);
    await _pumpPanel(tester, service, historyStorage: storage);
    await _completeReviewedForm(tester);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pumpAndSettle();

    expect(storage.writeCount, 0, reason: 'Analysis must not auto-save.');
    expect(
      find.byKey(const ValueKey('grounded-sensei-explanation')),
      findsOneWidget,
    );
    final saveButton = find.byKey(const ValueKey('save-v2a-attempt-locally'));
    expect(saveButton, findsOneWidget);
    expect(
      find.byKey(const ValueKey('local-attempt-storage-disclosure')),
      findsOneWidget,
    );

    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(storage.writeCount, 1);
    expect(find.text('Saved on this device'), findsOneWidget);
  });

  testWidgets('local storage failure is visible and leaves retry available', (
    tester,
  ) async {
    final storage = _MemoryStorage(writeSucceeds: false);
    final service = _CapturingService(returnsValidResult: true);
    await _pumpPanel(tester, service, historyStorage: storage);
    await _completeReviewedForm(tester);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const ValueKey('save-v2a-attempt-locally'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Could not save locally'), findsOneWidget);
    final button = tester.widget<OutlinedButton>(saveButton);
    expect(button.onPressed, isNotNull);
  });

  testWidgets('duplicate analysis reports the explicit already-saved state', (
    tester,
  ) async {
    final storage = _MemoryStorage();
    final repository = LocalAttemptHistoryRepository(storage: storage);
    await repository.save(validSingleAttemptV2AResult());
    final writesBeforePanel = storage.writeCount;
    final service = _CapturingService(returnsValidResult: true);
    await _pumpPanel(tester, service, historyStorage: storage);
    await _completeReviewedForm(tester);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pumpAndSettle();

    final saveButton = find.byKey(const ValueKey('save-v2a-attempt-locally'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(find.text('Already saved'), findsOneWidget);
    expect(storage.writeCount, writesBeforePanel);
  });

  testWidgets('explicit V2A save appears in app-scoped Profile History', (
    tester,
  ) async {
    final storage = _MemoryStorage();
    final historyProvider = LocalAttemptHistoryProvider(
      repository: LocalAttemptHistoryRepository(storage: storage),
    );
    final service = _CapturingService(returnsValidResult: true);
    await _pumpPanel(tester, service, historyProvider: historyProvider);
    await _completeReviewedForm(tester);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pumpAndSettle();
    final saveButton = find.byKey(const ValueKey('save-v2a-attempt-locally'));
    await tester.ensureVisible(saveButton);
    await tester.tap(saveButton);
    await tester.pumpAndSettle();

    expect(storage.writeCount, 1);
    expect(historyProvider.records, hasLength(1));

    final profileProvider = LocalAthleteProfileProvider(
      repository: LocalAthleteProfileRepository(
        storage: _MemoryProfileStorage(),
      ),
    );
    await profileProvider.initialize();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: historyProvider),
          ChangeNotifierProvider.value(value: profileProvider),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AthleteProfileScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('local-analysis-history-list')),
      400,
      scrollable: find.byType(Scrollable).first,
    );

    expect(
      find.byKey(const ValueKey('local-analysis-history-list')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('history-record-analysis-v2a-history-fixture')),
      findsOneWidget,
    );
  });

  testWidgets('Sensei failure leaves the scientific result and BLUE overlay', (
    tester,
  ) async {
    final service = _CapturingService(returnsValidResult: true);
    await _pumpPanel(
      tester,
      service,
      groundedSenseiService: const _FailingGroundedSenseiService(),
    );
    await _completeReviewedForm(tester);

    final runButton = find.byKey(const ValueKey('run-reviewed-v2a'));
    await tester.ensureVisible(runButton);
    await tester.tap(runButton);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('single-attempt-v2a-result')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('single-attempt-blue-overlay')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grounded-sensei-unavailable')),
      findsOneWidget,
    );
  });
}

Future<void> _pumpPanel(
  WidgetTester tester,
  SingleAttemptV2AService service, {
  LocalAttemptHistoryStorage? historyStorage,
  LocalAttemptHistoryProvider? historyProvider,
  GroundedSenseiService? groundedSenseiService,
}) async {
  await tester.binding.setSurfaceSize(const Size(900, 1600));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ChangeNotifierProvider<LocalAttemptHistoryProvider>.value(
      value:
          historyProvider ??
          LocalAttemptHistoryProvider(
            repository: LocalAttemptHistoryRepository(
              storage: historyStorage ?? _MemoryStorage(),
            ),
          ),
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SingleAttemptV2AReviewPanel(
              videoPath: 'D:/authorized/uchi-mata.mp4',
              videoId: 'local-authorized-video',
              cameraView: 'side',
              technique: uchiMata,
              service: service,
              groundedSenseiService: groundedSenseiService,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _FailingGroundedSenseiService implements GroundedSenseiService {
  const _FailingGroundedSenseiService();

  @override
  Future<GroundedSenseiExplanation> explain(GroundedSenseiRequest request) {
    throw const GroundedSenseiException('test_failure');
  }
}

Future<void> _completeReviewedForm(WidgetTester tester) async {
  for (final entry in <ValueKey<String>, String>{
    const ValueKey('reviewed-attempt-start-frame'): '25',
    const ValueKey('reviewed-attempt-start-timestamp'): '1000',
    const ValueKey('reviewed-attempt-end-frame'): '75',
    const ValueKey('reviewed-attempt-end-timestamp'): '3000',
    const ValueKey('reviewed-angle-frame'): '50',
    const ValueKey('reviewed-angle-timestamp'): '2000',
    const ValueKey('reviewed-neutral-track'): 'Track A',
    const ValueKey('reviewed-detection-index'): '0',
    const ValueKey('reviewed-angle-event-label'): 'reviewed-angle-observation',
  }.entries) {
    await tester.enterText(find.byKey(entry.key), entry.value);
  }

  await _choose<ReviewedSupportLeg>(
    tester,
    const ValueKey('reviewed-support-leg'),
    ReviewedSupportLeg.left,
  );
  await _choose<ReviewedAttackingLeg>(
    tester,
    const ValueKey('reviewed-attacking-leg'),
    ReviewedAttackingLeg.right,
  );
  await _choose<bool>(tester, const ValueKey('reviewed-view-suitable'), true);
  await _choose<bool>(tester, const ValueKey('reviewed-low-roll'), true);
}

Future<void> _choose<T>(
  WidgetTester tester,
  ValueKey<String> key,
  T value,
) async {
  final field = find.byKey(key);
  expect(field, findsOneWidget);

  await tester.ensureVisible(field);
  await tester.tap(field);
  await tester.pumpAndSettle();

  final typedOption = find.byWidgetPredicate(
    (widget) => widget is DropdownMenuItem<T> && widget.value == value,
    description: 'DropdownMenuItem<$T> with value $value',
  );
  expect(typedOption, findsWidgets);

  final visibleOption = find
      .descendant(of: typedOption, matching: find.byType(Text))
      .hitTestable();
  expect(visibleOption, findsOneWidget);
  await tester.tap(visibleOption);
  await tester.pumpAndSettle();
}

class _CapturingService implements SingleAttemptV2AService {
  _CapturingService({this.returnsValidResult = false});

  final bool returnsValidResult;
  int calls = 0;
  SingleAttemptV2ARequest? request;

  @override
  Future<SingleAttemptAnalysisV2A> analyzeReviewedVideo(
    SingleAttemptV2ARequest request,
  ) async {
    calls += 1;
    this.request = request;
    if (returnsValidResult) {
      return validSingleAttemptV2AResultForRequest(request);
    }
    return SingleAttemptAnalysisV2A(
      schemaVersion: '2.0.0',
      analysisVariant: 'single_attempt_v2a',
      analysisId: 'review-panel-test-result',
      status: 'completed',
      analysisMode: 'single_camera_2d_single_attempt',
      scientificLevel: 'level_1',
      techniqueId: 'uchi-mata',
      videoId: request.videoId,
      cameraView: request.cameraView,
      attempt: AttemptBoundarySummary(
        start: FrameReferenceSummary(
          frameIndex: request.attemptStart.frameIndex,
          timestampMs: request.attemptStart.timestampMs,
        ),
        end: FrameReferenceSummary(
          frameIndex: request.attemptEnd.frameIndex,
          timestampMs: request.attemptEnd.timestampMs,
        ),
        eventSchemaId: request.eventSchemaId,
        selectionSource: 'human-selected',
      ),
      subject: HumanSubjectSelectionSummary(
        neutralTrackId: request.neutralTrackId,
        selectedDetectionIndex: request.selectedDetectionIndex,
        role: 'Tori',
        confirmationSource: 'human-confirmed',
      ),
      supportLeg: HumanSupportLegSelectionSummary(
        side: request.supportLeg.name,
        confirmationSource: 'human-confirmed',
      ),
      attackingLeg: HumanAttackingLegSelectionSummary(
        side: request.attackingLeg.name,
        confirmationSource: 'human-confirmed',
      ),
      angleFrame: AnalysisFrameSummary(
        frame: FrameReferenceSummary(
          frameIndex: request.angleFrame.frameIndex,
          timestampMs: request.angleFrame.timestampMs,
        ),
        selectionSource: 'human-selected',
        eventLabel: request.angleEventLabel,
      ),
      cameraSuitability: CameraSuitabilitySummary(
        projectedAngleViewSuitable: request.projectedAngleViewSuitable,
        lowRollConfirmed: request.lowRollConfirmed,
        reviewSource: 'human-reviewed',
      ),
      metrics: const [],
      capabilities: const SingleAttemptCapabilitiesSummary(
        humanConfirmedTori: true,
        humanConfirmedSupportLeg: true,
        automaticToriUkeIdentity: false,
        automaticPhaseDetection: false,
        threeDimensionalReconstruction: false,
        forceTorquePower: false,
        normativeCoaching: false,
        multiPersonEvidenceStatus: 'insufficient',
        multiPersonInteractionMetricsReportable: false,
      ),
      limitations: const [
        SingleAttemptLimitation(
          code: 'descriptive_only',
          message: 'Fixture reviewed result limitation.',
          affectsInterpretation: true,
        ),
      ],
    );
  }
}

class _MemoryStorage implements LocalAttemptHistoryStorage {
  _MemoryStorage({this.writeSucceeds = true});

  String? payload;
  final bool writeSucceeds;
  int writeCount = 0;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    writeCount += 1;
    if (writeSucceeds) {
      payload = value;
    }
    return writeSucceeds;
  }
}

class _MemoryProfileStorage implements LocalAthleteProfileStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}
