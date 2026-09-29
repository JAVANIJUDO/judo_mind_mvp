import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/analysis_provenance.dart';
import 'package:judo_mind/models/single_attempt_analysis_v2a.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/single_attempt_v2a_result_card.dart';

void main() {
  test('parses the versioned V2A scientific boundary', () {
    final result = SingleAttemptAnalysisV2A.fromJson(_payload());

    expect(result.schemaVersion, '2.0.0');
    expect(result.analysisVariant, 'single_attempt_v2a');
    expect(result.metrics, hasLength(4));
    expect(result.metrics.first.provenance, AnalysisProvenance.measured);
    expect(
      result.metrics
          .skip(1)
          .every(
            (metric) => metric.provenance == AnalysisProvenance.modelEstimated,
          ),
      isTrue,
    );
    expect(result.hasExpectedScientificBoundary, isTrue);
  });

  test('fails the boundary on promoted provenance or automatic identity', () {
    final mutations = <void Function(Map<String, dynamic>)>[
      (payload) => payload['schema_version'] = '3.0.0',
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        (metrics[1] as Map<String, dynamic>)['provenance'] = 'reconstructed';
      },
      (payload) {
        final capabilities = payload['capabilities'] as Map<String, dynamic>;
        capabilities['automatic_tori_uke_identity'] = true;
      },
      (payload) {
        final capabilities = payload['capabilities'] as Map<String, dynamic>;
        capabilities['multi_person_evidence_status'] = 'sufficient';
      },
      (payload) {
        final capabilities = payload['capabilities'] as Map<String, dynamic>;
        capabilities['multi_person_interaction_metrics_reportable'] = true;
      },
      (payload) {
        final subject = payload['subject'] as Map<String, dynamic>;
        subject['confirmation_source'] = 'AI-inferred';
      },
      (payload) => payload.remove('attacking_leg'),
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        final withheld = metrics[2] as Map<String, dynamic>;
        withheld['value'] = 120.0;
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        (metrics[0] as Map<String, dynamic>)['unit'] = 'degrees';
      },
      (payload) {
        final suitability =
            payload['camera_suitability'] as Map<String, dynamic>;
        suitability['projected_angle_view_suitable'] = false;
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        (metrics[1] as Map<String, dynamic>)['overlay'] = <dynamic>[];
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        final overlay =
            (metrics[1] as Map<String, dynamic>)['overlay'] as List<dynamic>;
        final trunkLine = overlay.first as Map<String, dynamic>;
        trunkLine['points'] = [
          {'x': 0.5, 'y': 0.6, 'label': null},
        ];
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        final overlay =
            (metrics[1] as Map<String, dynamic>)['overlay'] as List<dynamic>;
        final trunkLine = overlay.first as Map<String, dynamic>;
        final points = trunkLine['points'] as List<dynamic>;
        (points.first as Map<String, dynamic>)['x'] = 1.01;
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        final overlay =
            (metrics[1] as Map<String, dynamic>)['overlay'] as List<dynamic>;
        overlay.add(jsonDecode(jsonEncode(overlay.last)));
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        final overlay =
            (metrics[1] as Map<String, dynamic>)['overlay'] as List<dynamic>;
        (overlay.last as Map<String, dynamic>)['label'] = '   ';
      },
      (payload) {
        final subject = payload['subject'] as Map<String, dynamic>;
        subject['neutral_track_id'] = 'Track Tori';
      },
      (payload) {
        final metrics = payload['metrics'] as List<dynamic>;
        final temporal =
            (metrics[1] as Map<String, dynamic>)['temporal_reference']
                as Map<String, dynamic>;
        temporal['frame'] = {'frame_index': 51, 'timestamp_ms': 2040};
      },
      (payload) {
        final limitations = payload['limitations'] as List<dynamic>;
        limitations.removeLast();
      },
      (payload) => payload['camera_view'] = 'diagonal-ish',
    ];

    for (final mutate in mutations) {
      final payload =
          jsonDecode(jsonEncode(_payload())) as Map<String, dynamic>;
      mutate(payload);
      expect(
        SingleAttemptAnalysisV2A.fromJson(
          payload,
        ).hasExpectedScientificBoundary,
        isFalse,
      );
    }
  });

  testWidgets(
    'renders reportable and withheld metrics without normative claims',
    (tester) async {
      final result = SingleAttemptAnalysisV2A.fromJson(_payload());

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: SingleChildScrollView(
              child: SingleAttemptV2AResultCard(result: result),
            ),
          ),
        ),
      );

      expect(
        find.byKey(const ValueKey('single-attempt-v2a-result')),
        findsOneWidget,
      );
      expect(find.text('Single-Attempt Uchi Mata · Level 1'), findsOneWidget);
      expect(
        find.textContaining('Reviewed execution duration is 2.000 seconds'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Projected trunk inclination is 18.4 degrees'),
        findsOneWidget,
      );
      expect(find.text('Review required'), findsOneWidget);
      expect(find.text('Withheld'), findsOneWidget);
      expect(
        find.textContaining('Multi-person evidence is insufficient'),
        findsOneWidget,
      );
      expect(find.textContaining('not pose accuracy'), findsNothing);
      final timingDetails = find.byKey(
        const ValueKey('metric-scientific-details-UM-TIM-001'),
      );
      await tester.ensureVisible(timingDetails);
      await tester.tap(timingDetails);
      await tester.pumpAndSettle();
      expect(
        find.textContaining('Confidence evidence unavailable'),
        findsWidgets,
      );
      final trunkDetails = find.byKey(
        const ValueKey('metric-scientific-details-UM-ANG-001'),
      );
      await tester.ensureVisible(trunkDetails);
      await tester.tap(trunkDetails);
      await tester.pumpAndSettle();
      expect(find.textContaining('not pose accuracy'), findsWidgets);
      expect(
        find.byKey(const ValueKey('single-attempt-blue-overlay')),
        findsOneWidget,
      );
      expect(find.textContaining('not reconstructed 3D'), findsOneWidget);
      expect(find.textContaining('angle is wrong'), findsNothing);
      expect(find.textContaining('ideal position'), findsNothing);
      expect(find.textContaining('Kuzushi is poor'), findsNothing);
    },
  );
}

Map<String, dynamic> _payload() {
  return {
    'schema_version': '2.0.0',
    'analysis_variant': 'single_attempt_v2a',
    'analysis_id': 'analysis-v2a-1',
    'status': 'completed',
    'analysis_mode': 'single_camera_2d_single_attempt',
    'scientific_level': 'level_1',
    'technique': {'id': 'uchi-mata'},
    'video_id': 'authorized-video-1',
    'camera_view': 'side',
    'attempt': {
      'start': {'frame_index': 25, 'timestamp_ms': 1000},
      'end': {'frame_index': 75, 'timestamp_ms': 3000},
      'event_schema_id': 'human-single-attempt-boundaries-v1',
      'selection_source': 'human-selected',
    },
    'subject': {
      'neutral_track_id': 'Track A',
      'selected_detection_index': 0,
      'role': 'Tori',
      'confirmation_source': 'human-confirmed',
    },
    'support_leg': {'side': 'left', 'confirmation_source': 'human-confirmed'},
    'attacking_leg': {
      'side': 'right',
      'confirmation_source': 'human-confirmed',
    },
    'angle_frame': {
      'frame': {'frame_index': 50, 'timestamp_ms': 2000},
      'selection_source': 'human-selected',
      'event_label': 'reviewed-angle-observation',
    },
    'camera_suitability': {
      'projected_angle_view_suitable': true,
      'low_roll_confirmed': true,
      'review_source': 'human-reviewed',
    },
    'metrics': [
      {
        'metric_id': 'UM-TIM-001',
        'name': 'Reviewed execution duration',
        'status': 'reportable',
        'value': 2.0,
        'unit': 'seconds',
        'provenance': 'measured',
        'temporal_reference': {
          'kind': 'interval',
          'frame': null,
          'start': {'frame_index': 25, 'timestamp_ms': 1000},
          'end': {'frame_index': 75, 'timestamp_ms': 3000},
        },
        'confidence': {
          'available': false,
          'kind': null,
          'value': null,
          'provenance': null,
          'interpretation': 'Human-reviewed boundaries; no model confidence.',
        },
        'method_version': 'reviewed-event-elapsed-time-1.0.0',
        'limitation': 'Depends on the same reviewed event schema.',
        'descriptive_text':
            'Reviewed execution duration is 2.000 seconds between timestamps 1000 ms and 3000 ms.',
        'withheld_reason': null,
        'overlay': <dynamic>[],
      },
      {
        'metric_id': 'UM-ANG-001',
        'name': 'Projected trunk inclination',
        'status': 'review_required',
        'value': 18.4,
        'unit': 'degrees',
        'provenance': 'model-estimated',
        'temporal_reference': {
          'kind': 'instant',
          'frame': {'frame_index': 50, 'timestamp_ms': 2000},
          'start': null,
          'end': null,
        },
        'confidence': {
          'available': true,
          'kind': 'minimum_model_landmark_visibility',
          'value': 0.78,
          'provenance': 'model-estimated',
          'interpretation': 'Minimum model visibility; not pose accuracy.',
        },
        'method_version': 'projected-trunk-inclination-1.0.0',
        'limitation': 'Projected 2D angle; not a true 3D trunk angle.',
        'descriptive_text':
            'Projected trunk inclination is 18.4 degrees at timestamp 2000 ms.',
        'withheld_reason': null,
        'overlay': [
          {
            'kind': 'line',
            'points': [
              {'x': 0.5, 'y': 0.6, 'label': null},
              {'x': 0.6, 'y': 0.3, 'label': null},
            ],
            'label': 'Projected trunk line',
            'color_layer': 'blue',
          },
          {
            'kind': 'angle_label',
            'points': [
              {'x': 0.6, 'y': 0.3, 'label': null},
            ],
            'label': '18.4 degrees projected',
            'color_layer': 'blue',
          },
        ],
      },
      {
        'metric_id': 'UM-ANG-002',
        'name': 'Projected support-leg knee angle',
        'status': 'withheld',
        'value': null,
        'unit': 'degrees',
        'provenance': 'model-estimated',
        'temporal_reference': {
          'kind': 'instant',
          'frame': {'frame_index': 50, 'timestamp_ms': 2000},
          'start': null,
          'end': null,
        },
        'confidence': {
          'available': false,
          'kind': null,
          'value': null,
          'provenance': null,
          'interpretation': 'Metric withheld.',
        },
        'method_version': 'projected-knee-angle-1.0.0',
        'limitation': 'Projected 2D angle; no load or injury-risk claim.',
        'descriptive_text': null,
        'withheld_reason': 'The support-side ankle landmark is missing.',
        'overlay': <dynamic>[],
      },
      {
        'metric_id': 'UM-ANG-003',
        'name': 'Projected attacking-leg knee angle',
        'status': 'reportable',
        'value': 142.0,
        'unit': 'degrees',
        'provenance': 'model-estimated',
        'temporal_reference': {
          'kind': 'instant',
          'frame': {'frame_index': 50, 'timestamp_ms': 2000},
          'start': null,
          'end': null,
        },
        'confidence': {
          'available': true,
          'kind': 'minimum_model_landmark_visibility',
          'value': 0.74,
          'provenance': 'model-estimated',
          'interpretation': 'Minimum model visibility; not pose accuracy.',
        },
        'method_version': 'projected-knee-angle-1.0.0',
        'limitation': 'Projected 2D angle; no load or injury-risk claim.',
        'descriptive_text':
            'Projected attacking-leg knee angle is 142.0 degrees at timestamp 2000 ms.',
        'withheld_reason': null,
        'overlay': [
          {
            'kind': 'polyline',
            'points': [
              {'x': 0.6, 'y': 0.5, 'label': 'right hip'},
              {'x': 0.6, 'y': 0.7, 'label': 'right knee'},
              {'x': 0.6, 'y': 0.9, 'label': 'right ankle'},
            ],
            'label': 'Projected right attacking leg',
            'color_layer': 'blue',
          },
          {
            'kind': 'angle_label',
            'points': [
              {'x': 0.6, 'y': 0.7, 'label': null},
            ],
            'label': '142.0 degrees projected',
            'color_layer': 'blue',
          },
        ],
      },
    ],
    'capabilities': {
      'human_confirmed_tori': true,
      'human_confirmed_support_leg': true,
      'automatic_tori_uke_identity': false,
      'automatic_phase_detection': false,
      'three_dimensional_reconstruction': false,
      'force_torque_power': false,
      'normative_coaching': false,
      'multi_person_evidence_status': 'insufficient',
      'multi_person_interaction_metrics_reportable': false,
    },
    'limitations': [
      {
        'code': 'human_role_confirmation_required',
        'message': 'Tori is selected by a human reviewer.',
        'affects_interpretation': true,
      },
      {
        'code': 'human_support_leg_confirmation_required',
        'message': 'The support leg is selected by a human reviewer.',
        'affects_interpretation': true,
      },
      {
        'code': 'automatic_phase_detection_not_available',
        'message': 'Kuzushi, Tsukuri and Kake are not automatically detected.',
        'affects_interpretation': true,
      },
      {
        'code': 'projected_single_camera_geometry',
        'message': 'Angles are projected single-camera geometry.',
        'affects_interpretation': true,
      },
      {
        'code': 'camera_perspective_affects_angles',
        'message': 'Camera perspective can affect projected angles.',
        'affects_interpretation': true,
      },
      {
        'code': 'kinetics_not_available',
        'message': 'No force, torque, power or load is reported.',
        'affects_interpretation': true,
      },
      {
        'code': 'descriptive_only',
        'message': 'The result is descriptive and not normative coaching.',
        'affects_interpretation': true,
      },
    ],
  };
}
