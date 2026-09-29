import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/ai/analysis/grounded_sensei_service.dart';
import 'package:judo_mind/data/ai/local_grounded_sensei_service.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/models/grounded_sensei.dart';
import 'package:judo_mind/models/single_attempt_analysis_v2a.dart';
import 'package:judo_mind/models/single_attempt_v2a_request.dart';
import 'package:judo_mind/models/technique_model.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  const service = LocalGroundedSenseiService();

  test(
    'binds exactly to reviewed V2A and preserves four metric semantics',
    () async {
      final reviewedRequest = validSingleAttemptV2ARequest();
      final reviewedResult = validSingleAttemptV2AResultForRequest(
        reviewedRequest,
      );

      final explanation = await service.explain(
        GroundedSenseiRequest(
          technique: uchiMata,
          reviewedRequest: reviewedRequest,
          reviewedResult: reviewedResult,
          locale: 'en',
        ),
      );

      expect(explanation.isDeterministicLocal, isTrue);
      expect(explanation.binding.analysisId, reviewedResult.analysisId);
      expect(explanation.binding.videoId, reviewedRequest.videoId);
      expect(explanation.binding.eventSchemaId, reviewedRequest.eventSchemaId);
      expect(explanation.binding.neutralTrackId, 'Track A');
      expect(explanation.binding.selectedDetectionIndex, 0);
      expect(explanation.binding.cameraView, 'side');
      expect(explanation.binding.supportLeg, 'left');
      expect(explanation.binding.attackingLeg, 'right');
      expect(explanation.binding.projectedAngleViewSuitable, isTrue);
      expect(explanation.binding.lowRollConfirmed, isTrue);
      expect(explanation.binding.humanReviewed, isTrue);
      expect(
        explanation.findings.map((finding) => finding.metricId),
        orderedEquals(['UM-TIM-001', 'UM-ANG-001', 'UM-ANG-002', 'UM-ANG-003']),
      );
      for (var index = 0; index < reviewedResult.metrics.length; index++) {
        final source = reviewedResult.metrics[index];
        final finding = explanation.findings[index];
        expect(finding.value, source.value);
        expect(finding.status, source.status);
        expect(finding.provenance, source.provenance);
        expect(finding.methodVersion, source.methodVersion);
      }
      expect(
        explanation.findings[1].status,
        SingleAttemptMetricStatus.reviewRequired,
      );
      expect(
        explanation.findings[2].status,
        SingleAttemptMetricStatus.withheld,
      );
      expect(explanation.findings[2].value, isNull);
      expect(explanation.hasApprovedDrillMapping, isFalse);
      expect(explanation.multiPersonEvidenceStatus, 'insufficient');
      expect(explanation.multiPersonInteractionMetricsReportable, isFalse);
    },
  );

  test(
    'uses only selected-language approved safety with no silent fallback',
    () async {
      final reviewedRequest = validSingleAttemptV2ARequest();
      final result = validSingleAttemptV2AResultForRequest(reviewedRequest);
      final explanation = await service.explain(
        GroundedSenseiRequest(
          technique: uchiMata,
          reviewedRequest: reviewedRequest,
          reviewedResult: result,
          locale: 'fa',
        ),
      );

      final persianSafety = uchiMata.getTranslation('fa')!.safetyTips;
      expect(explanation.safetyGuidance, orderedEquals(persianSafety));
      expect(
        explanation.safetyGuidance,
        isNot(contains(uchiMata.safetyTips.first)),
      );
    },
  );

  test('rejects mismatched technique and reviewed request bindings', () async {
    final reviewedRequest = validSingleAttemptV2ARequest();
    final result = validSingleAttemptV2AResultForRequest(reviewedRequest);
    final mismatchedRequest = validSingleAttemptV2ARequest(videoId: 'other');

    await expectLater(
      service.explain(
        GroundedSenseiRequest(
          technique: uchiMata,
          reviewedRequest: mismatchedRequest,
          reviewedResult: result,
          locale: 'en',
        ),
      ),
      throwsA(
        isA<GroundedSenseiException>().having(
          (error) => error.code,
          'code',
          'reviewed_binding_mismatch',
        ),
      ),
    );

    await expectLater(
      service.explain(
        GroundedSenseiRequest(
          technique: _techniqueWithId('other-technique'),
          reviewedRequest: reviewedRequest,
          reviewedResult: result,
          locale: 'en',
        ),
      ),
      throwsA(
        isA<GroundedSenseiException>().having(
          (error) => error.code,
          'code',
          'technique_binding_mismatch',
        ),
      ),
    );
  });

  test(
    'rejects missing duplicate and unknown metric IDs before explanation',
    () async {
      final reviewedRequest = validSingleAttemptV2ARequest();
      final result = validSingleAttemptV2AResultForRequest(reviewedRequest);

      await _expectMetricFailure(
        service,
        reviewedRequest,
        _copyResult(result, metrics: result.metrics.take(3).toList()),
        'missing_metric',
      );
      await _expectMetricFailure(
        service,
        reviewedRequest,
        _copyResult(result, metrics: [...result.metrics, result.metrics.first]),
        'duplicate_metric',
      );
      await _expectMetricFailure(
        service,
        reviewedRequest,
        _copyResult(
          result,
          metrics: [
            ...result.metrics.take(3),
            _copyMetric(result.metrics.last, metricId: 'UM-NEW-999'),
          ],
        ),
        'unknown_metric',
      );
    },
  );

  test(
    'local implementation contains no network or open-generative client',
    () {
      final source = File(
        'lib/data/ai/local_grounded_sensei_service.dart',
      ).readAsStringSync();
      for (final forbidden in [
        "dart:io",
        'package:http',
        'dio',
        'Socket',
        'HttpClient',
        'OPENAI_API_KEY',
        'String prompt',
        'prompt:',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: forbidden);
      }
    },
  );
}

Future<void> _expectMetricFailure(
  LocalGroundedSenseiService service,
  SingleAttemptV2ARequest reviewedRequest,
  SingleAttemptAnalysisV2A result,
  String code,
) async {
  await expectLater(
    service.explain(
      GroundedSenseiRequest(
        technique: uchiMata,
        reviewedRequest: reviewedRequest,
        reviewedResult: result,
        locale: 'en',
      ),
    ),
    throwsA(
      isA<GroundedSenseiException>().having(
        (error) => error.code,
        'code',
        code,
      ),
    ),
  );
}

SingleAttemptAnalysisV2A _copyResult(
  SingleAttemptAnalysisV2A source, {
  required List<SingleAttemptMetricResult> metrics,
}) {
  return SingleAttemptAnalysisV2A(
    schemaVersion: source.schemaVersion,
    analysisVariant: source.analysisVariant,
    analysisId: source.analysisId,
    status: source.status,
    analysisMode: source.analysisMode,
    scientificLevel: source.scientificLevel,
    techniqueId: source.techniqueId,
    videoId: source.videoId,
    cameraView: source.cameraView,
    attempt: source.attempt,
    subject: source.subject,
    supportLeg: source.supportLeg,
    attackingLeg: source.attackingLeg,
    angleFrame: source.angleFrame,
    cameraSuitability: source.cameraSuitability,
    metrics: metrics,
    capabilities: source.capabilities,
    limitations: source.limitations,
  );
}

SingleAttemptMetricResult _copyMetric(
  SingleAttemptMetricResult source, {
  required String metricId,
}) {
  return SingleAttemptMetricResult(
    metricId: metricId,
    name: source.name,
    status: source.status,
    value: source.value,
    unit: source.unit,
    provenance: source.provenance,
    temporalReference: source.temporalReference,
    confidence: source.confidence,
    methodVersion: source.methodVersion,
    limitation: source.limitation,
    descriptiveText: source.descriptiveText,
    withheldReason: source.withheldReason,
    overlay: source.overlay,
  );
}

TechniqueModel _techniqueWithId(String id) {
  return TechniqueModel(
    id: id,
    englishName: uchiMata.englishName,
    japaneseName: uchiMata.japaneseName,
    category: uchiMata.category,
    type: uchiMata.type,
    beltLevel: uchiMata.beltLevel,
    difficulty: uchiMata.difficulty,
    description: uchiMata.description,
    technicalAnalysis: uchiMata.technicalAnalysis,
    translations: uchiMata.translations,
    images: uchiMata.images,
    videos: uchiMata.videos,
    trainingVideo: uchiMata.trainingVideo,
    competitionVideo: uchiMata.competitionVideo,
    executionSteps: uchiMata.executionSteps,
    keyPoints: uchiMata.keyPoints,
    commonMistakes: uchiMata.commonMistakes,
    safetyTips: uchiMata.safetyTips,
    combinations: uchiMata.combinations,
    counters: uchiMata.counters,
    quiz: uchiMata.quiz,
    sources: uchiMata.sources,
  );
}
