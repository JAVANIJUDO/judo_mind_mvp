import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/models/technique_training_content.dart';

void main() {
  test('training content defaults to empty and unavailable', () {
    const content = TechniqueTrainingContent.empty();

    expect(content.isEmpty, isTrue);
    for (final kind in TechniqueTrainingDrillKind.values) {
      expect(content.drillsFor(kind), isEmpty);
    }
  });

  test(
    'current Uchi Mata data does not activate future training contracts',
    () {
      expect(uchiMata.trainingContent.isEmpty, isTrue);
    },
  );

  test('draft or incomplete drill cannot become available', () {
    const draft = TechniqueTrainingDrill(
      id: 'synthetic-draft',
      kind: TechniqueTrainingDrillKind.shadowTraining,
      title: 'Synthetic title',
      objective: 'Synthetic objective',
      relatedTechniquePhase: 'synthetic-phase',
      status: TechniqueTrainingContentStatus.draft,
    );

    expect(draft.hasApprovedActivationEvidence, isFalse);
    expect(draft.isAvailableForLanguage('en'), isFalse);
    expect(draft.resolveForLanguage('en'), isNull);
  });

  test('band configuration rejects missing anchor and safety fields', () {
    final drill = _completeSyntheticDrill(
      resistanceBandConfiguration: const TechniqueResistanceBandConfiguration(
        resistanceDirection: 'synthetic-direction',
        gripMapping: 'synthetic-grip',
        entryRotationPath: 'synthetic-path',
        supportLegRole: 'synthetic-support-role',
        attackingLegRole: 'synthetic-attacking-role',
      ),
    );

    expect(drill.hasCompleteKindConfiguration, isFalse);
    expect(drill.hasApprovedActivationEvidence, isFalse);
    expect(drill.resolveForLanguage('en'), isNull);
  });

  test(
    'approved evidence resolves English but fails closed for missing Persian',
    () {
      final drill = _completeSyntheticDrill();

      expect(drill.hasApprovedActivationEvidence, isTrue);
      expect(drill.resolveForLanguage('en')?.title, 'Synthetic title');
      expect(drill.isAvailableForLanguage('fa'), isFalse);
      expect(drill.resolveForLanguage('fa'), isNull);
    },
  );

  test(
    'complete approved Persian translation resolves without English fallback',
    () {
      final drill = _completeSyntheticDrill(
        translations: [
          TechniqueTrainingDrillTranslation(
            languageCode: 'fa',
            title: 'عنوان آزمایشی',
            objective: 'هدف آزمایشی',
            relatedTechniquePhase: 'مرحله آزمایشی',
            equipment: ['تجهیزات آزمایشی'],
            steps: ['مرحله آزمایشی'],
            athleteLevel: 'سطح آزمایشی',
            safetyGuidance: ['راهنمای ایمنی آزمایشی'],
          ),
        ],
        resistanceBandConfiguration: const TechniqueResistanceBandConfiguration(
          anchorLocation: 'synthetic-anchor',
          anchorHeight: 'synthetic-height',
          resistanceDirection: 'synthetic-direction',
          gripMapping: 'synthetic-grip',
          entryRotationPath: 'synthetic-path',
          supportLegRole: 'synthetic-support-role',
          attackingLegRole: 'synthetic-attacking-role',
          safeDistanceGuidance: 'synthetic-safe-distance',
          dangerousErrorWarning: 'synthetic-danger-warning',
          translations: [
            TechniqueResistanceBandConfigurationTranslation(
              languageCode: 'fa',
              anchorLocation: 'مهار آزمایشی',
              anchorHeight: 'ارتفاع آزمایشی',
              resistanceDirection: 'جهت آزمایشی',
              gripMapping: 'گرفتن آزمایشی',
              entryRotationPath: 'مسیر آزمایشی',
              supportLegRole: 'پای اتکای آزمایشی',
              attackingLegRole: 'پای حمله آزمایشی',
              safeDistanceGuidance: 'فاصله ایمن آزمایشی',
              dangerousErrorWarning: 'هشدار آزمایشی',
            ),
          ],
        ),
      );

      final resolved = drill.resolveForLanguage('fa');
      expect(resolved, isNotNull);
      expect(resolved!.title, 'عنوان آزمایشی');
      expect(resolved.steps, ['مرحله آزمایشی']);
      expect(resolved.safetyGuidance, ['راهنمای ایمنی آزمایشی']);
    },
  );
}

TechniqueTrainingDrill _completeSyntheticDrill({
  List<TechniqueTrainingDrillTranslation> translations = const [],
  TechniqueResistanceBandConfiguration resistanceBandConfiguration =
      const TechniqueResistanceBandConfiguration(
        anchorLocation: 'synthetic-anchor',
        anchorHeight: 'synthetic-height',
        resistanceDirection: 'synthetic-direction',
        gripMapping: 'synthetic-grip',
        entryRotationPath: 'synthetic-path',
        supportLegRole: 'synthetic-support-role',
        attackingLegRole: 'synthetic-attacking-role',
        safeDistanceGuidance: 'synthetic-safe-distance',
        dangerousErrorWarning: 'synthetic-danger-warning',
      ),
}) {
  return TechniqueTrainingDrill(
    id: 'synthetic-approved',
    kind: TechniqueTrainingDrillKind.resistanceBand,
    title: 'Synthetic title',
    objective: 'Synthetic objective',
    relatedTechniquePhase: 'synthetic-phase',
    equipment: const ['synthetic-equipment'],
    steps: const ['synthetic-step'],
    prescription: const TechniqueTrainingPrescription(repetitions: 1),
    athleteLevel: 'synthetic-level',
    mediaReferenceId: 'synthetic-media',
    safetyGuidance: const ['synthetic-safety'],
    sourceReference: 'synthetic-source',
    contentProvenance: 'test-only',
    status: TechniqueTrainingContentStatus.approved,
    translations: translations,
    resistanceBandConfiguration: resistanceBandConfiguration,
  );
}
