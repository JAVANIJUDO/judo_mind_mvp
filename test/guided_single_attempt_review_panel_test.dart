import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/ai/analysis/guided_single_attempt_v2a_service.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/guided_single_attempt_review.dart';
import 'package:judo_mind/models/single_attempt_v2a_request.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/guided_single_attempt_review_panel.dart';
import 'package:provider/provider.dart';

import 'support/single_attempt_v2a_fixture.dart';

const _pixel =
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mNk+A8AAQUBAScY42YAAAAASUVORK5CYII=';
const _candidateTokenA = 'candidate-token-A-opaque-safe-length';
const _candidateTokenB = 'candidate-token-B-opaque-safe-length';

void main() {
  test('guided role assignment is explicit and human-only', () {
    const assignment = GuidedHumanRoleAssignment(
      candidateToken: _candidateTokenB,
    );

    expect(assignment.toJson(), {
      'role': 'TORI',
      'source': 'HUMAN_CONFIRMATION',
      'candidate_token': _candidateTokenB,
    });
    expect(assignment.toJson(), isNot(contains('identity')));
  });

  test('guided session parses ready frame-candidate evidence', () {
    final session = GuidedReviewSession.fromJson(_guidedSessionJson());

    expect(session.detectedPoseCount, 2);
    expect(session.selectableCandidateCount, 2);
    expect(session.hasReadyCandidateEvidence, isTrue);
    expect(session.candidates, hasLength(2));
    expect(
      session.candidates.every(
        (candidate) => candidate.trackMetadata.isExplicitlyUnavailable,
      ),
      isTrue,
    );
  });

  test(
    'guided session rejects fabricated frame-candidate tracking evidence',
    () {
      final json = _guidedSessionJson();
      final candidates = json['candidates']! as List<Map<String, dynamic>>;
      final track = candidates.first['track_metadata']! as Map<String, dynamic>;
      track['neutral_track_id'] = 'Track A';

      expect(
        () => GuidedReviewSession.fromJson(json),
        throwsA(isA<FormatException>()),
      );
    },
  );

  test('guided session rejects candidate-set count or status tampering', () {
    final countMismatch = _guidedSessionJson();
    countMismatch['selectable_candidate_count'] = 1;
    expect(
      () => GuidedReviewSession.fromJson(countMismatch),
      throwsA(isA<FormatException>()),
    );

    final statusMismatch = _guidedSessionJson();
    statusMismatch['candidate_selection_status'] =
        'insufficient_candidate_evidence';
    expect(
      () => GuidedReviewSession.fromJson(statusMismatch),
      throwsA(isA<FormatException>()),
    );
  });

  testWidgets(
    'primary guided UX exposes visual times but no engineering fields',
    (tester) async {
      await _pump(tester, _Service());

      expect(
        find.byKey(const ValueKey('guided-attempt-start')),
        findsOneWidget,
      );
      expect(find.byKey(const ValueKey('guided-attempt-end')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('guided-review-moment')),
        findsOneWidget,
      );
      expect(find.byType(TextFormField), findsNothing);
      expect(find.textContaining('frame index'), findsNothing);
      expect(find.textContaining('detection index'), findsNothing);
      expect(find.byTooltip('Step one frame backward'), findsWidgets);
      expect(find.byTooltip('Step one frame forward'), findsWidgets);
    },
  );

  testWidgets('one-frame change requires boundary reconfirmation', (
    tester,
  ) async {
    await _pump(tester, _Service());
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-attempt-boundaries')),
          )
          .value,
      isTrue,
    );
    await tester.tap(find.byTooltip('Step one frame forward').first);
    await tester.pump();
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-attempt-boundaries')),
          )
          .value,
      isFalse,
    );
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-single-attempt-scope')),
          )
          .value,
      isFalse,
    );
    await tester.tap(find.byTooltip('Step one frame backward').first);
    await tester.pump();
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-attempt-boundaries')),
          )
          .value,
      isFalse,
      reason: 'Returning to an old frame must not restore confirmation.',
    );
    expect(
      tester
          .widget<ElevatedButton>(
            find.byKey(const ValueKey('prepare-guided-review')),
          )
          .onPressed,
      isNull,
    );
  });

  testWidgets('unknown source timing remains explicit', (tester) async {
    await _pump(tester, _Service(), sourceTiming: SourceTimingState.unknown);
    expect(find.text('Timing unknown'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('guided-timing-evidence')),
      findsOneWidget,
    );
  });

  testWidgets('single-attempt confirmation is mandatory', (tester) async {
    await _pump(tester, _Service(), confirmSingleAttempt: false);
    expect(
      tester
          .widget<ElevatedButton>(
            find.byKey(const ValueKey('prepare-guided-review')),
          )
          .onPressed,
      isNull,
    );
    expect(
      find.textContaining('one continuous Uchi Mata attempt only'),
      findsOneWidget,
    );
  });

  testWidgets('removing boundary confirmation also removes attempt scope', (
    tester,
  ) async {
    await _pump(tester, _Service());
    await tester.tap(find.byKey(const ValueKey('confirm-attempt-boundaries')));
    await tester.pump();

    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-attempt-boundaries')),
          )
          .value,
      isFalse,
    );
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-single-attempt-scope')),
          )
          .value,
      isFalse,
    );

    await tester.tap(find.byKey(const ValueKey('confirm-attempt-boundaries')));
    await tester.pump();
    expect(
      tester
          .widget<CheckboxListTile>(
            find.byKey(const ValueKey('confirm-single-attempt-scope')),
          )
          .value,
      isFalse,
      reason: 'Reconfirming boundaries must not restore attempt scope.',
    );
  });

  testWidgets(
    'prepare shows frame-local candidates without claiming identity',
    (tester) async {
      final service = _Service();
      await _pump(tester, service);
      await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
      await tester.pumpAndSettle();

      expect(service.prepareCalls, 1);
      expect(find.byKey(const ValueKey('guided-candidate-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('guided-candidate-1')), findsOneWidget);
      expect(find.text('Frame candidate 1'), findsOneWidget);
      expect(find.text('Frame candidate 2'), findsOneWidget);
      expect(
        find.textContaining('has not automatically identified'),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('guided-candidate-evidence-boundary')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('guided-ready-candidate-evidence')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('guided-insufficient-candidate-evidence')),
        findsNothing,
      );
      expect(find.byIcon(Icons.check_circle), findsNothing);
      final confirmationFinder = find.byKey(
        const ValueKey('guided-confirm-tori'),
      );
      var confirmation = tester.widget<CheckboxListTile>(confirmationFinder);
      expect(confirmation.value, isFalse);
      expect(confirmation.onChanged, isNull);
      expect(
        find.text(
          'I confirm this selected frame candidate is Tori for this attempt',
        ),
        findsOneWidget,
      );
      expect(find.textContaining('visible person'), findsNothing);
      final firstCandidate = find.byKey(const ValueKey('guided-candidate-0'));
      expect(tester.widget<InkWell>(firstCandidate).onTap, isNotNull);
      await tester.ensureVisible(firstCandidate);
      await tester.tap(firstCandidate);
      await tester.pump();
      expect(find.byIcon(Icons.check_circle), findsOneWidget);
      confirmation = tester.widget<CheckboxListTile>(confirmationFinder);
      expect(confirmation.value, isFalse);
      expect(confirmation.onChanged, isNotNull);
      expect(find.textContaining('Track A'), findsNothing);
    },
  );

  testWidgets('candidate token selection is invariant to display order', (
    tester,
  ) async {
    for (final order in [
      [_candidateTokenA, _candidateTokenB],
      [_candidateTokenB, _candidateTokenA],
    ]) {
      final service = _Service(
        sessionOverride: _guidedSessionWithCandidateOrder(order),
      );
      await _pump(tester, service);
      await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check_circle), findsNothing);
      var toriConfirmation = tester.widget<CheckboxListTile>(
        find.byKey(const ValueKey('guided-confirm-tori')),
      );
      expect(toriConfirmation.value, isFalse);
      expect(toriConfirmation.onChanged, isNull);
      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const ValueKey('run-guided-v2a')),
            )
            .onPressed,
        isNull,
      );

      final candidateBIndex = order.indexOf(_candidateTokenB);
      final candidateBFinder = find.byKey(
        ValueKey('guided-candidate-$candidateBIndex'),
      );
      await tester.ensureVisible(candidateBFinder);
      await tester.tap(candidateBFinder);
      await tester.pump();

      toriConfirmation = tester.widget<CheckboxListTile>(
        find.byKey(const ValueKey('guided-confirm-tori')),
      );
      expect(toriConfirmation.value, isFalse);
      expect(toriConfirmation.onChanged, isNotNull);
      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const ValueKey('run-guided-v2a')),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const ValueKey('guided-confirm-tori')));
      await tester.pump();
      await _choose(
        tester,
        const ValueKey('guided-support-leg'),
        ReviewedSupportLeg.left,
      );
      await _choose(
        tester,
        const ValueKey('guided-attacking-leg'),
        ReviewedAttackingLeg.right,
      );
      await _chooseAnswer(tester, const ValueKey('guided-view-suitable'));
      await _chooseAnswer(tester, const ValueKey('guided-low-roll'));

      final runButton = find.byKey(const ValueKey('run-guided-v2a'));
      await tester.ensureVisible(runButton);
      expect(tester.widget<ElevatedButton>(runButton).onPressed, isNotNull);
      await tester.tap(runButton);
      await tester.pumpAndSettle();

      expect(service.analyzeCalls, 1);
      expect(service.lastConfirmation?.candidateToken, _candidateTokenB);
      expect(service.lastConfirmation?.toJson()['role_assignment'], {
        'role': 'TORI',
        'source': 'HUMAN_CONFIRMATION',
        'candidate_token': _candidateTokenB,
      });
      expect(
        service.lastConfirmation?.toJson(),
        isNot(contains('candidate_token')),
      );

      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });

  testWidgets('insufficient frame-candidate evidence visibly blocks analysis', (
    tester,
  ) async {
    final runtimeSession = GuidedReviewSession.fromJson(
      _insufficientGuidedSessionJson(),
    );
    final service = _Service(sessionOverride: runtimeSession);
    const deviceViewport = Size(393, 852);
    await _pump(tester, service, surfaceSize: deviceViewport);
    final prepare = find.byKey(const ValueKey('prepare-guided-review'));
    await tester.ensureVisible(prepare);
    await tester.tap(prepare);
    await tester.pumpAndSettle();

    expect(runtimeSession.detectedPoseCount, 1);
    expect(runtimeSession.selectableCandidateCount, 1);
    expect(
      runtimeSession.candidateSelectionStatus,
      GuidedCandidateSelectionStatus.insufficientCandidateEvidence,
    );
    expect(runtimeSession.hasReadyCandidateEvidence, isFalse);
    final candidate = find.byKey(const ValueKey('guided-candidate-0'));
    final explanation = find.byKey(
      const ValueKey('guided-insufficient-candidate-evidence'),
    );
    expect(explanation, findsOneWidget);
    expect(
      find.textContaining(
        'Insufficient candidate evidence for human role confirmation.',
      ),
      findsOneWidget,
    );
    expect(
      find.textContaining('only 1 usable frame candidate is available'),
      findsOneWidget,
    );
    expect(
      find.textContaining('This does not mean only one person is present.'),
      findsOneWidget,
    );
    expect(
      find.textContaining(
        'Two independent frame candidates are required to continue.',
      ),
      findsOneWidget,
    );
    expect(candidate, findsOneWidget);
    expect(tester.widget<InkWell>(candidate).onTap, isNull);
    await tester.ensureVisible(candidate);
    await tester.pumpAndSettle();
    final explanationRect = tester.getRect(explanation);
    expect(
      explanationRect.top,
      lessThan(deviceViewport.height),
      reason:
          'The fail-closed reason must remain in the device viewport when the candidate evidence is reviewed.',
    );
    expect(explanationRect.bottom, greaterThan(0));
    expect(find.byIcon(Icons.check_circle), findsNothing);
    final confirmation = tester.widget<CheckboxListTile>(
      find.byKey(const ValueKey('guided-confirm-tori')),
    );
    expect(confirmation.value, isFalse);
    expect(confirmation.onChanged, isNull);
    expect(
      tester
          .widget<ElevatedButton>(find.byKey(const ValueKey('run-guided-v2a')))
          .onPressed,
      isNull,
    );
    expect(service.analyzeCalls, 0);
  });

  testWidgets('candidate and explicit Tori confirmation are required', (
    tester,
  ) async {
    final service = _Service();
    await _pump(tester, service);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();
    final runButtonBeforeCandidate = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('run-guided-v2a')),
    );
    expect(
      runButtonBeforeCandidate.onPressed,
      isNull,
      reason:
          'Analysis must be disabled until a candidate and Tori are explicitly confirmed.',
    );
    expect(service.analyzeCalls, 0);
    expect(find.byKey(const ValueKey('guided-review-error')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('guided-candidate-0')));
    await tester.pump();
    final confirmation = tester.widget<CheckboxListTile>(
      find.byKey(const ValueKey('guided-confirm-tori')),
    );
    expect(confirmation.value, isFalse);
    expect(service.analyzeCalls, 0);
  });

  testWidgets(
    'changing candidate invalidates all candidate-dependent human review state',
    (tester) async {
      final service = _Service();
      await _pump(tester, service);

      await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('guided-candidate-0')), findsOneWidget);
      expect(find.byKey(const ValueKey('guided-candidate-1')), findsOneWidget);

      await tester.tap(find.byKey(const ValueKey('guided-candidate-0')));
      await tester.pump();

      await tester.tap(find.byKey(const ValueKey('guided-confirm-tori')));
      await tester.pump();

      await _choose(
        tester,
        const ValueKey('guided-support-leg'),
        ReviewedSupportLeg.left,
      );
      await _choose(
        tester,
        const ValueKey('guided-attacking-leg'),
        ReviewedAttackingLeg.right,
      );
      await _chooseAnswer(tester, const ValueKey('guided-view-suitable'));
      await _chooseAnswer(tester, const ValueKey('guided-low-roll'));

      final eligibleBeforeChange = tester.widget<ElevatedButton>(
        find.byKey(const ValueKey('run-guided-v2a')),
      );
      expect(
        eligibleBeforeChange.onPressed,
        isNotNull,
        reason: 'Completed human review should make analysis eligible.',
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey('guided-candidate-1')),
      );
      await tester.tap(find.byKey(const ValueKey('guided-candidate-1')));
      await tester.pump();

      final toriConfirmation = tester.widget<CheckboxListTile>(
        find.byKey(const ValueKey('guided-confirm-tori')),
      );
      expect(toriConfirmation.value, isFalse);

      final supportLeg = tester
          .widget<DropdownButtonFormField<ReviewedSupportLeg>>(
            find.byKey(const ValueKey('guided-support-leg')),
          );
      expect(supportLeg.initialValue, isNull);

      final attackingLeg = tester
          .widget<DropdownButtonFormField<ReviewedAttackingLeg>>(
            find.byKey(const ValueKey('guided-attacking-leg')),
          );
      expect(attackingLeg.initialValue, isNull);

      final runAfterCandidateChange = tester.widget<ElevatedButton>(
        find.byKey(const ValueKey('run-guided-v2a')),
      );
      expect(
        runAfterCandidateChange.onPressed,
        isNull,
        reason:
            'Changing candidate must invalidate prior human review before analysis.',
      );

      expect(service.analyzeCalls, 0);
    },
  );

  testWidgets(
    'editing attempt boundaries returns to timeline and clears dependent review',
    (tester) async {
      final service = _Service();
      await _pump(tester, service);

      await tester.tap(find.byTooltip('Step one frame forward').first);
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('review-exact-boundaries')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('confirm-attempt-boundaries')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('confirm-single-attempt-scope')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
      await tester.pumpAndSettle();

      await _completeHumanReview(tester);
      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const ValueKey('run-guided-v2a')),
            )
            .onPressed,
        isNotNull,
      );

      await tester.ensureVisible(
        find.byKey(const ValueKey('edit-attempt-boundaries')),
      );
      await tester.tap(find.byKey(const ValueKey('edit-attempt-boundaries')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('guided-attempt-start')),
        findsOneWidget,
      );
      expect(
        tester
            .widget<Slider>(find.byKey(const ValueKey('guided-attempt-start')))
            .value,
        1,
        reason: 'Editing keeps the current exact frame selection.',
      );
      expect(find.byKey(const ValueKey('guided-candidate-0')), findsNothing);
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('confirm-attempt-boundaries')),
            )
            .value,
        isFalse,
      );
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('confirm-single-attempt-scope')),
            )
            .value,
        isFalse,
      );
      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const ValueKey('prepare-guided-review')),
            )
            .onPressed,
        isNull,
      );

      await tester.tap(find.byKey(const ValueKey('review-exact-boundaries')));
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('confirm-attempt-boundaries')),
      );
      await tester.pump();
      await tester.tap(
        find.byKey(const ValueKey('confirm-single-attempt-scope')),
      );
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
      await tester.pumpAndSettle();

      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('guided-confirm-tori')),
            )
            .value,
        isFalse,
      );
      expect(
        tester
            .widget<DropdownButtonFormField<ReviewedSupportLeg>>(
              find.byKey(const ValueKey('guided-support-leg')),
            )
            .initialValue,
        isNull,
      );
      expect(
        tester
            .widget<DropdownButtonFormField<ReviewedAttackingLeg>>(
              find.byKey(const ValueKey('guided-attacking-leg')),
            )
            .initialValue,
        isNull,
      );
      final dynamic viewSuitable = tester.widget(
        find.byKey(const ValueKey('guided-view-suitable')),
      );
      final dynamic lowRoll = tester.widget(
        find.byKey(const ValueKey('guided-low-roll')),
      );
      expect(viewSuitable.initialValue, isNull);
      expect(lowRoll.initialValue, isNull);
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const ValueKey('guided-review-uncertain')),
            )
            .value,
        isFalse,
      );
      expect(
        tester
            .widget<ElevatedButton>(
              find.byKey(const ValueKey('run-guided-v2a')),
            )
            .onPressed,
        isNull,
      );
      expect(service.prepareCalls, 2);
      expect(service.prepareRequests, hasLength(2));
      expect(
        service.prepareRequests[1].timingManifestId,
        service.prepareRequests[0].timingManifestId,
        reason:
            'Editing boundaries must reuse the still-valid server timing manifest.',
      );
      expect(service.analyzeCalls, 0);
    },
  );

  testWidgets('editing attempt boundaries clears result and Sensei output', (
    tester,
  ) async {
    final service = _Service();
    await _pump(tester, service);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();
    await _completeHumanReview(tester);
    await tester.ensureVisible(find.byKey(const ValueKey('run-guided-v2a')));
    await tester.tap(find.byKey(const ValueKey('run-guided-v2a')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('single-attempt-v2a-result')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grounded-sensei-explanation')),
      findsOneWidget,
    );

    await tester.ensureVisible(
      find.byKey(const ValueKey('edit-attempt-boundaries')),
    );
    await tester.tap(find.byKey(const ValueKey('edit-attempt-boundaries')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('single-attempt-v2a-result')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('grounded-sensei-explanation')),
      findsNothing,
    );
    expect(find.byKey(const ValueKey('guided-attempt-start')), findsOneWidget);
  });
  testWidgets('prepare exposes a coherent loading state', (tester) async {
    final completer = Completer<GuidedReviewSession>();
    final service = _Service(prepareCompleter: completer);
    await _pump(tester, service);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pump();

    expect(find.text('Preparing selected moment...'), findsOneWidget);
    completer.complete(_Service.session);
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('guided-candidate-0')), findsOneWidget);
  });

  testWidgets('backend error is visible and prepare remains retryable', (
    tester,
  ) async {
    final service = _Service(prepareError: 'Review session expired.');
    await _pump(tester, service);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();

    expect(find.text('Review session expired.'), findsOneWidget);
    expect(
      tester
          .widget<ElevatedButton>(
            find.byKey(const ValueKey('prepare-guided-review')),
          )
          .onPressed,
      isNotNull,
    );
  });

  testWidgets('Not sure fails closed before service analysis', (tester) async {
    final service = _Service();
    await _pump(tester, service);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('guided-candidate-0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('guided-confirm-tori')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('guided-review-uncertain')));
    await tester.pump();
    final runButtonWhileUncertain = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('run-guided-v2a')),
    );
    expect(
      runButtonWhileUncertain.onPressed,
      isNull,
      reason:
          'Reviewer uncertainty must disable analysis before any service call.',
    );
    expect(service.analyzeCalls, 0);
    expect(find.byKey(const ValueKey('guided-review-error')), findsNothing);
  });

  testWidgets('explicit prepare and confirmation reaches result then Sensei', (
    tester,
  ) async {
    final service = _Service();
    await _pump(tester, service);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('guided-candidate-0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('guided-confirm-tori')));
    await _choose(
      tester,
      const ValueKey('guided-support-leg'),
      ReviewedSupportLeg.left,
    );
    await _choose(
      tester,
      const ValueKey('guided-attacking-leg'),
      ReviewedAttackingLeg.right,
    );
    await _chooseAnswer(tester, const ValueKey('guided-view-suitable'));
    await _chooseAnswer(tester, const ValueKey('guided-low-roll'));

    final eligibleRunButton = tester.widget<ElevatedButton>(
      find.byKey(const ValueKey('run-guided-v2a')),
    );
    expect(
      eligibleRunButton.onPressed,
      isNotNull,
      reason:
          'Analysis should become available only after all required human review inputs are valid.',
    );

    await tester.ensureVisible(find.byKey(const ValueKey('run-guided-v2a')));
    await tester.tap(find.byKey(const ValueKey('run-guided-v2a')));
    await tester.pumpAndSettle();

    expect(service.analyzeCalls, 1);
    expect(
      find.byKey(const ValueKey('single-attempt-v2a-result')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grounded-sensei-explanation')),
      findsOneWidget,
    );
    await tester.ensureVisible(
      find.byKey(const ValueKey('grounded-sensei-expansion')),
    );
    await tester.tap(find.byKey(const ValueKey('grounded-sensei-expansion')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('does not automatically detect attempts'),
      findsOneWidget,
      reason:
          'Expanded Grounded Sensei must disclose that attempt and phase detection are not automatic.',
    );
  });

  testWidgets('Persian guided boundary is localized', (tester) async {
    await _pump(tester, _Service(), locale: const Locale('fa'));
    expect(find.text('بازبینی هدایت‌شده انسانی'), findsOneWidget);
    expect(find.textContaining('شماره تشخیص داخلی می‌ماند'), findsOneWidget);
    expect(find.textContaining('فقط شامل یک اجرای پیوسته'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();
    expect(find.text('ویرایش مرزهای تلاش'), findsOneWidget);
  });

  testWidgets('Persian insufficient candidate evidence is explicit', (
    tester,
  ) async {
    final service = _Service(
      sessionOverride: GuidedReviewSession.fromJson(
        _insufficientGuidedSessionJson(),
      ),
    );
    await _pump(tester, service, locale: const Locale('fa'));
    await tester.tap(find.byKey(const ValueKey('prepare-guided-review')));
    await tester.pumpAndSettle();

    expect(
      find.textContaining('شواهد کاندید برای تأیید انسانی نقش کافی نیست.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('این به معنی حضور فقط یک نفر در تصویر نیست.'),
      findsOneWidget,
    );
    expect(
      find.textContaining('برای ادامه، دو کاندیدای فریم مستقل لازم است.'),
      findsOneWidget,
    );
    expect(
      find.text(
        'تأیید می‌کنم کاندیدای فریم انتخاب‌شده برای این تلاش، توری است',
      ),
      findsOneWidget,
    );
    expect(
      tester
          .widget<InkWell>(find.byKey(const ValueKey('guided-candidate-0')))
          .onTap,
      isNull,
    );
  });
}

Future<void> _choose<T>(WidgetTester tester, Key key, T value) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
  final option = find.byWidgetPredicate(
    (widget) => widget is DropdownMenuItem<T> && widget.value == value,
  );
  await tester.tap(
    find.descendant(of: option, matching: find.byType(Text)).last,
  );
  await tester.pumpAndSettle();
}

Future<void> _chooseAnswer(WidgetTester tester, Key key) async {
  await tester.ensureVisible(find.byKey(key));
  await tester.tap(find.byKey(key));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Reviewed: yes').last);
  await tester.pumpAndSettle();
}

Future<void> _completeHumanReview(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('guided-candidate-0')));
  await tester.pump();
  await tester.tap(find.byKey(const ValueKey('guided-confirm-tori')));
  await tester.pump();
  await _choose(
    tester,
    const ValueKey('guided-support-leg'),
    ReviewedSupportLeg.left,
  );
  await _choose(
    tester,
    const ValueKey('guided-attacking-leg'),
    ReviewedAttackingLeg.right,
  );
  await _chooseAnswer(tester, const ValueKey('guided-view-suitable'));
  await _chooseAnswer(tester, const ValueKey('guided-low-roll'));
}

Future<void> _pump(
  WidgetTester tester,
  GuidedSingleAttemptV2AService service, {
  Locale locale = const Locale('en'),
  SourceTimingState sourceTiming = SourceTimingState.realTime,
  bool confirmSingleAttempt = true,
  Size surfaceSize = const Size(900, 1800),
}) async {
  await tester.binding.setSurfaceSize(surfaceSize);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    ChangeNotifierProvider(
      create: (_) => LocalAttemptHistoryProvider(
        repository: LocalAttemptHistoryRepository(storage: _Storage()),
      ),
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: SingleChildScrollView(
            child: GuidedSingleAttemptReviewPanel(
              videoPath: 'D:/authorized/attempt.mp4',
              videoId: 'local-video',
              cameraView: 'side',
              videoDuration: const Duration(seconds: 4),
              technique: uchiMata,
              service: service,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  final sourceTimingFinder = find.byKey(const ValueKey('guided-source-timing'));
  await tester.ensureVisible(sourceTimingFinder);
  await tester.tap(sourceTimingFinder);
  await tester.pumpAndSettle();
  final sourceOption = find.byWidgetPredicate(
    (widget) =>
        widget is DropdownMenuItem<SourceTimingState> &&
        widget.value == sourceTiming,
  );
  await tester.tap(
    find.descendant(of: sourceOption, matching: find.byType(Text)).last,
  );
  await tester.pumpAndSettle();
  final loadManifest = find.byKey(const ValueKey('load-timing-manifest'));
  await tester.ensureVisible(loadManifest);
  await tester.tap(loadManifest);
  await tester.pumpAndSettle();
  final reviewBoundaries = find.byKey(
    const ValueKey('review-exact-boundaries'),
  );
  await tester.ensureVisible(reviewBoundaries);
  await tester.tap(reviewBoundaries);
  await tester.pumpAndSettle();
  final confirmBoundaries = find.byKey(
    const ValueKey('confirm-attempt-boundaries'),
  );
  await tester.ensureVisible(confirmBoundaries);
  await tester.tap(confirmBoundaries);
  await tester.pumpAndSettle();
  if (confirmSingleAttempt) {
    final confirmAttempt = find.byKey(
      const ValueKey('confirm-single-attempt-scope'),
    );
    await tester.ensureVisible(confirmAttempt);
    await tester.tap(confirmAttempt);
    await tester.pumpAndSettle();
  }
}

class _Service implements GuidedSingleAttemptV2AService {
  _Service({this.prepareCompleter, this.prepareError, this.sessionOverride});

  final Completer<GuidedReviewSession>? prepareCompleter;
  final String? prepareError;
  final GuidedReviewSession? sessionOverride;
  int prepareCalls = 0;
  int analyzeCalls = 0;
  GuidedReviewConfirmation? lastConfirmation;
  final List<GuidedReviewPrepareRequest> prepareRequests = [];

  @override
  Future<GuidedTimingManifest> prepareTimingManifest(
    GuidedTimingManifestRequest request,
  ) async => const GuidedTimingManifest(
    id: 'opaque-timing-manifest-with-safe-length',
    totalDecodedFrames: 101,
    durationMs: 4040,
    frameTimestampsMs: [
      0,
      40,
      80,
      120,
      160,
      200,
      240,
      280,
      320,
      360,
      400,
      440,
      480,
      520,
      560,
      600,
      640,
      680,
      720,
      760,
      800,
      840,
      880,
      920,
      960,
      1000,
      1040,
      1080,
      1120,
      1160,
      1200,
      1240,
      1280,
      1320,
      1360,
      1400,
      1440,
      1480,
      1520,
      1560,
      1600,
      1640,
      1680,
      1720,
      1760,
      1800,
      1840,
      1880,
      1920,
      1960,
      2000,
      2040,
      2080,
      2120,
      2160,
      2200,
      2240,
      2280,
      2320,
      2360,
      2400,
      2440,
      2480,
      2520,
      2560,
      2600,
      2640,
      2680,
      2720,
      2760,
      2800,
      2840,
      2880,
      2920,
      2960,
      3000,
      3040,
      3080,
      3120,
      3160,
      3200,
      3240,
      3280,
      3320,
      3360,
      3400,
      3440,
      3480,
      3520,
      3560,
      3600,
      3640,
      3680,
      3720,
      3760,
      3800,
      3840,
      3880,
      3920,
      3960,
      4000,
    ],
    timingMode: 'CFR',
    timestampProvenance: 'decoder-reported-timestamp',
    sourceTimingState: 'REAL_TIME',
    sourceFps: 25,
  );

  @override
  Future<GuidedBoundaryPreview> previewBoundaries(
    GuidedReviewPrepareRequest request,
  ) async => GuidedBoundaryPreview(
    manifestId: request.timingManifestId,
    startFrame: request.attemptStartFrame,
    endFrame: request.attemptEndFrame,
    reviewFrame: request.reviewFrame,
    startTimestampMs: 0,
    endTimestampMs: 4000,
    startPreviewJpegBase64: _pixel,
    endPreviewJpegBase64: _pixel,
  );

  static const session = GuidedReviewSession(
    sessionId: 'opaque-session-token-with-safe-length',
    expiresInSeconds: 600,
    canonicalStartMs: 0,
    canonicalEndMs: 4000,
    canonicalReviewMomentMs: 2000,
    canonicalStartFrame: 0,
    canonicalEndFrame: 100,
    canonicalReviewFrame: 50,
    timingMode: 'CFR',
    timestampProvenance: 'decoder-reported-timestamp',
    sourceTimingState: 'REAL_TIME',
    singleAttemptConfirmed: true,
    attemptScope: 'SINGLE_ATTEMPT',
    attemptScopeSource: 'HUMAN_CONFIRMED',
    attemptScopeContractVersion: 'single-attempt-human-confirmation-1.0.0',
    detectedPoseCount: 2,
    selectableCandidateCount: 2,
    candidateSelectionStatus:
        GuidedCandidateSelectionStatus.readyForHumanSelection,
    candidates: [
      GuidedReviewCandidate(
        token: 'opaque-candidate-token-with-safe-length',
        previewJpegBase64: _pixel,
        requiredLandmarkCount: 8,
        availableRequiredLandmarkCount: 8,
        modelLandmarkVisibilityStatus:
            GuidedModelLandmarkVisibilityStatus.available,
        modelLandmarkVisibilityCount: 8,
      ),
      GuidedReviewCandidate(
        token: 'second-opaque-candidate-token-safe-length',
        previewJpegBase64: _pixel,
        requiredLandmarkCount: 8,
        availableRequiredLandmarkCount: 8,
        modelLandmarkVisibilityStatus:
            GuidedModelLandmarkVisibilityStatus.available,
        modelLandmarkVisibilityCount: 8,
      ),
    ],
    limitations: ['Frame-local candidate only.'],
  );

  @override
  Future<GuidedReviewSession> prepare(
    GuidedReviewPrepareRequest request,
  ) async {
    prepareCalls += 1;
    prepareRequests.add(request);
    if (prepareError != null) {
      throw GuidedReviewException(prepareError!);
    }
    return prepareCompleter?.future ?? sessionOverride ?? session;
  }

  @override
  Future<GuidedReviewAnalysis> analyze(
    GuidedReviewPrepareRequest preparedRequest,
    GuidedReviewConfirmation confirmation,
  ) async {
    analyzeCalls += 1;
    lastConfirmation = confirmation;
    final request = validSingleAttemptV2ARequest();
    return GuidedReviewAnalysis(
      result: validSingleAttemptV2AResultForRequest(request),
      reviewedRequest: request,
    );
  }
}

class _Storage implements LocalAttemptHistoryStorage {
  String? value;
  @override
  Future<String?> readPayload() async => value;
  @override
  Future<bool> writePayload(String value) async {
    this.value = value;
    return true;
  }
}

Map<String, dynamic> _guidedSessionJson() => {
  'review_session_id': 'opaque-session-token-with-safe-length',
  'expires_in_seconds': 600,
  'canonical_start_ms': 0,
  'canonical_end_ms': 4000,
  'canonical_review_moment_ms': 2000,
  'canonical_start_frame': 0,
  'canonical_end_frame': 100,
  'canonical_review_frame': 50,
  'timing_mode': 'CFR',
  'timestamp_provenance': 'decoder-reported-timestamp',
  'source_timing_state': 'REAL_TIME',
  'single_attempt_confirmed': true,
  'attempt_scope': 'SINGLE_ATTEMPT',
  'attempt_scope_source': 'HUMAN_CONFIRMED',
  'attempt_scope_contract_version': 'single-attempt-human-confirmation-1.0.0',
  'detected_pose_count': 2,
  'selectable_candidate_count': 2,
  'candidate_selection_status': 'ready_for_human_selection',
  'candidates': [
    _guidedCandidateJson('opaque-candidate-token-with-safe-length'),
    _guidedCandidateJson('second-opaque-candidate-token-safe-length'),
  ],
  'limitations': ['Frame-local candidate only.'],
};

Map<String, dynamic> _insufficientGuidedSessionJson() {
  final json = _guidedSessionJson();
  json['detected_pose_count'] = 1;
  json['selectable_candidate_count'] = 1;
  json['candidate_selection_status'] = 'insufficient_candidate_evidence';
  json['candidates'] = [
    _guidedCandidateJson('insufficient-candidate-token-safe-length'),
  ];
  return json;
}

GuidedReviewSession _guidedSessionWithCandidateOrder(List<String> tokens) {
  final json = _guidedSessionJson();
  json['candidates'] = [
    for (final token in tokens) _guidedCandidateJson(token),
  ];
  return GuidedReviewSession.fromJson(json);
}

Map<String, dynamic> _guidedCandidateJson(String token) => {
  'candidate_token': token,
  'preview_jpeg_base64': _pixel,
  'pose_availability': 'available',
  'pose_provenance': 'model-estimated',
  'required_landmark_count': 8,
  'available_required_landmark_count': 8,
  'model_landmark_visibility_status': 'available',
  'model_landmark_visibility_count': 8,
  'track_metadata': {
    'status': 'unavailable',
    'neutral_track_id': null,
    'association_confidence': null,
    'reason': 'frame_local_candidate_only_no_tracking',
  },
};
