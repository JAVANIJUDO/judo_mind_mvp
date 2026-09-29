import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/technique_model.dart';
import 'package:judo_mind/models/technique_training_content.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/conditioning_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/resistance_band_training_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/shadow_training_section.dart';

void main() {
  testWidgets('empty production-style contracts render fail-closed state', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const ShadowTrainingSection(technique: _emptyTechnique)),
    );

    expect(
      find.byKey(const ValueKey<String>('training-unavailable-shadowTraining')),
      findsOneWidget,
    );
    expect(find.byType(ShadowTrainingDrillRenderer), findsNothing);
  });

  testWidgets('Persian unavailable state has no silent English fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const ShadowTrainingSection(technique: _emptyTechnique),
        locale: const Locale('fa'),
      ),
    );

    expect(
      find.text('تمرین اختصاصی این تکنیک هنوز در دسترس نیست'),
      findsOneWidget,
    );
    expect(
      find.text('Approved technique-specific training is unavailable'),
      findsNothing,
    );
  });

  testWidgets('complete fixtures use three distinct primary renderers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const SingleChildScrollView(
          child: Column(
            children: [
              ShadowTrainingSection(technique: _fixtureTechnique),
              ConditioningSection(technique: _fixtureTechnique),
              ResistanceBandTrainingSection(technique: _fixtureTechnique),
            ],
          ),
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('shadow-training-primary-renderer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('conditioning-primary-renderer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('resistance-band-primary-renderer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('shadow-movement-path-presentation')),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey<String>(
          'conditioning-movement-prescription-presentation',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('band-anchor-direction-presentation')),
      findsOneWidget,
    );
  });

  testWidgets('Persian fixture resolves without English content fallback', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const SingleChildScrollView(
          child: ShadowTrainingSection(technique: _fixtureTechnique),
        ),
        locale: const Locale('fa'),
      ),
    );

    expect(find.text('عنوان سایه آزمایشی'), findsOneWidget);
    expect(find.text('Synthetic shadow title'), findsNothing);
    expect(find.text('توالی مراحل'), findsOneWidget);
    expect(
      Directionality.of(
        tester.element(
          find.byKey(
            const ValueKey<String>('shadow-training-primary-renderer'),
          ),
        ),
      ),
      TextDirection.rtl,
    );
  });

  test('reusable training widgets contain no Uchi Mata identity check', () {
    const files = [
      'lib/screens/technique_detail/widgets/sections/shadow_training_section.dart',
      'lib/screens/technique_detail/widgets/sections/conditioning_section.dart',
      'lib/screens/technique_detail/widgets/sections/resistance_band_training_section.dart',
      'lib/screens/technique_detail/widgets/sections/training_experience_shared.dart',
    ];

    for (final path in files) {
      final source = File(path).readAsStringSync().toLowerCase();
      expect(source, isNot(contains('uchi mata')), reason: path);
      expect(source, isNot(contains('uchi_mata')), reason: path);
    }
  });
}

Widget _testApp(Widget child, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

const _emptyTechnique = TechniqueModel(
  id: 'empty-fixture',
  englishName: 'Empty Fixture',
  japaneseName: '',
  category: '',
  type: '',
  beltLevel: '',
  difficulty: '',
  description: '',
  technicalAnalysis: '',
  images: [],
  videos: [],
  trainingVideo: '',
  competitionVideo: '',
  executionSteps: [],
  keyPoints: [],
  commonMistakes: [],
  safetyTips: [],
  combinations: [],
  counters: [],
  quiz: [],
  sources: [],
);

const _fixtureTechnique = TechniqueModel(
  id: 'synthetic-training-fixture',
  englishName: 'Synthetic Fixture',
  japaneseName: '',
  category: '',
  type: '',
  beltLevel: '',
  difficulty: '',
  description: '',
  technicalAnalysis: '',
  images: [],
  videos: [],
  trainingVideo: '',
  competitionVideo: '',
  executionSteps: [],
  keyPoints: [],
  commonMistakes: [],
  safetyTips: [],
  combinations: [],
  counters: [],
  quiz: [],
  sources: [],
  trainingContent: TechniqueTrainingContent(
    shadowTraining: [_shadowDrill],
    strengthConditioning: [_conditioningDrill],
    resistanceBand: [_bandDrill],
  ),
);

const _shadowDrill = TechniqueTrainingDrill(
  id: 'synthetic-shadow',
  kind: TechniqueTrainingDrillKind.shadowTraining,
  title: 'Synthetic shadow title',
  objective: 'Synthetic shadow objective',
  relatedTechniquePhase: 'Synthetic phase',
  equipment: ['Synthetic equipment'],
  steps: ['Synthetic step'],
  prescription: TechniqueTrainingPrescription(repetitions: 1, restSeconds: 1),
  athleteLevel: 'Synthetic level',
  mediaReferenceId: 'synthetic-shadow-media',
  safetyGuidance: ['Synthetic safety'],
  sourceReference: 'synthetic-source',
  contentProvenance: 'test-only',
  status: TechniqueTrainingContentStatus.approved,
  translations: [
    TechniqueTrainingDrillTranslation(
      languageCode: 'fa',
      title: 'عنوان سایه آزمایشی',
      objective: 'هدف سایه آزمایشی',
      relatedTechniquePhase: 'مرحله مرتبط آزمایشی',
      equipment: ['تجهیزات آزمایشی'],
      steps: ['گام آزمایشی'],
      athleteLevel: 'سطح آزمایشی',
      safetyGuidance: ['ایمنی آزمایشی'],
    ),
  ],
  shadowConfiguration: TechniqueShadowTrainingConfiguration(
    phaseSequence: ['Phase A'],
    movementPathCues: ['Path A'],
    movementPathReferenceId: 'synthetic-path-reference',
    mirrorGhostPresentationAvailable: true,
    frontPresentationReferenceId: 'synthetic-front-reference',
    paceModes: ['Synthetic pace'],
    repetitionTrackingAvailable: true,
    translations: [
      TechniqueShadowTrainingConfigurationTranslation(
        languageCode: 'fa',
        phaseSequence: ['مرحله آزمایشی'],
        movementPathCues: ['مسیر آزمایشی'],
        paceModes: ['سرعت آزمایشی'],
      ),
    ],
  ),
);

const _conditioningDrill = TechniqueTrainingDrill(
  id: 'synthetic-conditioning',
  kind: TechniqueTrainingDrillKind.strengthConditioning,
  title: 'Synthetic conditioning title',
  objective: 'Synthetic conditioning objective',
  relatedTechniquePhase: 'Synthetic phase',
  equipment: ['Synthetic equipment'],
  steps: ['Synthetic step'],
  prescription: TechniqueTrainingPrescription(sets: 1, restSeconds: 1),
  athleteLevel: 'Synthetic level',
  mediaReferenceId: 'synthetic-conditioning-media',
  safetyGuidance: ['Synthetic safety'],
  sourceReference: 'synthetic-source',
  contentProvenance: 'test-only',
  status: TechniqueTrainingContentStatus.approved,
  conditioningConfiguration: TechniqueConditioningConfiguration(
    targetMovementPattern: 'Synthetic movement pattern',
    commonExecutionError: 'Synthetic execution error',
  ),
);

const _bandDrill = TechniqueTrainingDrill(
  id: 'synthetic-band',
  kind: TechniqueTrainingDrillKind.resistanceBand,
  title: 'Synthetic band title',
  objective: 'Synthetic band objective',
  relatedTechniquePhase: 'Synthetic phase',
  equipment: ['Synthetic equipment'],
  steps: ['Synthetic step'],
  prescription: TechniqueTrainingPrescription(durationSeconds: 1),
  athleteLevel: 'Synthetic level',
  mediaReferenceId: 'synthetic-band-media',
  safetyGuidance: ['Synthetic safety'],
  sourceReference: 'synthetic-source',
  contentProvenance: 'test-only',
  status: TechniqueTrainingContentStatus.approved,
  resistanceBandConfiguration: TechniqueResistanceBandConfiguration(
    anchorLocation: 'Synthetic anchor',
    anchorHeight: 'Synthetic height',
    resistanceDirection: 'Synthetic direction',
    gripMapping: 'Synthetic grip',
    entryRotationPath: 'Synthetic rotation',
    supportLegRole: 'Synthetic support role',
    attackingLegRole: 'Synthetic attacking role',
    safeDistanceGuidance: 'Synthetic distance',
    resistanceLevel: 'Synthetic approved resistance',
    dangerousErrorWarning: 'Synthetic danger warning',
  ),
);
