import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/technique_explanation_content.dart';
import 'package:judo_mind/models/technique_model.dart';
import 'package:judo_mind/models/technique_translation.dart';
import 'package:judo_mind/screens/technique_detail/generic_technique_detail_adapter.dart';
import 'package:judo_mind/screens/technique_detail/generic_technique_detail_screen.dart';
import 'package:judo_mind/screens/technique_detail/technique_detail_route_policy.dart';
import 'package:judo_mind/screens/technique_detail/widgets/content/technique_content_widgets.dart';

void main() {
  test('existing TechniqueModel construction remains schema-compatible', () {
    const legacyCompatible = TechniqueModel(
      id: '900',
      englishName: 'Compatibility Fixture',
      japaneseName: '試',
      category: 'Fixture',
      type: 'Fixture',
      beltLevel: 'Unavailable',
      difficulty: 'Unavailable',
      description: 'Fixture description.',
      technicalAnalysis: 'Fixture technical explanation.',
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

    expect(
      legacyCompatible.explanationExtension.state,
      TechniqueExplanationContentState.unavailable,
    );
    expect(legacyCompatible.supportsReviewedSingleAttemptV2A, isFalse);
  });

  test('draft and incomplete optional explanation data fail closed', () {
    final content = GenericTechniqueDetailAdapter.fromTechnique(
      _fixture(
        explanationExtension: const TechniqueExplanationExtension(
          state: TechniqueExplanationContentState.draft,
          gripAndStartingPosition: TechniqueLocalizedText(
            values: {'en': 'Draft grip must not render.'},
          ),
          canonicalCombinationTechniqueIds: ['001'],
          visualExplanation: TechniqueVisualExplanation(
            assetReference: 'assets/draft.png',
            rightsBasis: TechniqueMediaRightsBasis.projectOwned,
            provenanceReference: 'draft',
            licenseOrPermissionReference: 'project-owned',
            accessibleDescription: TechniqueLocalizedText(
              values: {'en': 'Draft visual.'},
            ),
          ),
        ),
      ),
      languageCode: 'en',
    );

    expect(content.gripAndStartingPosition, isEmpty);
    expect(content.canonicalCombinationTechniqueIds, isEmpty);
    expect(content.canDisplayVisual, isFalse);
    expect(content.hasQualifiedConceptualInterpretation, isFalse);
    expect(content.hasQualifiedBiomechanicalInterpretation, isFalse);
    expect(content.evidenceAndReviewStatus, isNull);
  });

  test('extension resolves exact locale and rejects silent fallback', () {
    final technique = _fixture(
      explanationExtension: const TechniqueExplanationExtension(
        state: TechniqueExplanationContentState.readOnlyEducationalReady,
        gripAndStartingPosition: TechniqueLocalizedText(
          values: {'en': 'Reviewed fixture position.'},
        ),
        executionPhases: TechniqueExecutionPhaseContent(
          kuzushi: TechniqueLocalizedText(values: {'en': 'Fixture kuzushi.'}),
          tsukuri: TechniqueLocalizedText(values: {'en': 'Fixture tsukuri.'}),
          kake: TechniqueLocalizedText(values: {'en': 'Fixture kake.'}),
        ),
        canonicalCombinationTechniqueIds: ['001', 'bad', '001'],
      ),
    );

    final english = GenericTechniqueDetailAdapter.fromTechnique(
      technique,
      languageCode: 'en-US',
    );
    final persian = GenericTechniqueDetailAdapter.fromTechnique(
      technique,
      languageCode: 'fa-IR',
    );

    expect(english.gripAndStartingPosition, 'Reviewed fixture position.');
    expect(english.kuzushi, 'Fixture kuzushi.');
    expect(english.canonicalCombinationTechniqueIds, const ['001']);
    expect(persian.gripAndStartingPosition, isEmpty);
    expect(persian.kuzushi, isEmpty);
  });

  test('visual and video rights/provenance contracts fail closed', () {
    const missingPermission = TechniqueVisualExplanation(
      assetReference: 'assets/owned.png',
      rightsBasis: TechniqueMediaRightsBasis.projectOwned,
      provenanceReference: 'JM-ASSET-001',
      accessibleDescription: TechniqueLocalizedText(
        values: {'en': 'Accessible fixture diagram.'},
      ),
    );
    const completeVisual = TechniqueVisualExplanation(
      assetReference: 'assets/owned.png',
      rightsBasis: TechniqueMediaRightsBasis.projectOwned,
      provenanceReference: 'JM-ASSET-001',
      licenseOrPermissionReference: 'project-owned',
      accessibleDescription: TechniqueLocalizedText(
        values: {
          'en': 'Accessible fixture diagram.',
          'fa': 'توضیح دسترس‌پذیر نمودار آزمایشی.',
        },
      ),
    );
    const incompleteVideo = TechniqueVideoExplanation(
      mediaReference: 'assets/fixture.mp4',
      rightsBasis: TechniqueMediaRightsBasis.licensed,
      provenanceReference: 'JM-MEDIA-001',
      licenseOrPermissionReference: 'LIC-001',
    );

    expect(missingPermission.canDisplayFor('en'), isFalse);
    expect(completeVisual.canDisplayFor('en'), isTrue);
    expect(completeVisual.canDisplayFor('fa'), isTrue);
    expect(completeVisual.canDisplayFor('de'), isFalse);
    expect(incompleteVideo.canDisplayFor('en'), isFalse);
  });

  test(
    'statement classifications stay explicit and confidence is not invented',
    () {
      expect(
        TechniqueStatementClassification.values.map((value) => value.wireValue),
        const [
          'CONCEPTUAL',
          'OBSERVED',
          'MEASURED',
          'RECONSTRUCTED',
          'MODEL_ESTIMATED',
          'AI_INFERRED',
        ],
      );
      const measuredWithoutMethod = TechniqueInterpretationStatement(
        classification: TechniqueStatementClassification.measured,
        text: TechniqueLocalizedText(values: {'en': 'Fixture quantity.'}),
        limitations: TechniqueLocalizedText(values: {'en': 'Fixture limit.'}),
      );
      expect(measuredWithoutMethod.isQualifiedForDisplay('en'), isFalse);
    },
  );

  test(
    'Uchi Mata stays specialized and production non-Uchi science is absent',
    () {
      expect(
        TechniqueDetailRoutePolicy.resolve('001').kind,
        TechniqueDetailRouteKind.specializedUchiMata,
      );
      for (final technique in TechniqueFactory.allTechniques.where(
        (item) => item.id != '001',
      )) {
        expect(
          technique.explanationExtension.isReadOnlyEducationalReady,
          isFalse,
        );
        expect(
          technique.explanationExtension
              .hasQualifiedBiomechanicalInterpretationFor('en'),
          isFalse,
        );
      }
      expect(TechniqueFactory.readOnlyEducationalTechniqueIds, isEmpty);
    },
  );

  testWidgets(
    'expandable EN and Persian foundations preserve RTL and no science',
    (tester) async {
      final technique = _fixture(
        explanationExtension: const TechniqueExplanationExtension(
          state: TechniqueExplanationContentState.readOnlyEducationalReady,
          applicationContext: TechniqueLocalizedText(
            values: {'en': 'Fixture context.', 'fa': 'زمینه آزمایشی.'},
          ),
        ),
      );

      await tester.pumpWidget(_app(technique));
      await tester.pumpAndSettle();
      expect(find.text('Overview'), findsOneWidget);
      expect(find.text('Execution phases'), findsOneWidget);
      expect(find.text('Technical explanation'), findsOneWidget);
      expect(
        find.byKey(
          const ValueKey<String>(
            'generic-biomechanical-interpretation-section',
          ),
        ),
        findsNothing,
      );

      await tester.pumpWidget(_app(technique, locale: const Locale('fa')));
      await tester.pumpAndSettle();
      final screen = find.byKey(
        const ValueKey<String>('generic-technique-detail-screen'),
      );
      expect(Directionality.of(tester.element(screen)), TextDirection.rtl);
      expect(find.text('نمای کلی'), findsOneWidget);
      expect(find.text('مراحل اجرا'), findsOneWidget);
      expect(find.text('توضیح فنی'), findsOneWidget);
      expect(find.text('زمینه آزمایشی.'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('future diagram wrapper is zoomable and accessible', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: TechniqueZoomableVisual(
            semanticLabel: 'Accessible original diagram',
            child: SizedBox(width: 200, height: 100),
          ),
        ),
      ),
    );

    expect(find.byType(InteractiveViewer), findsOneWidget);
    expect(
      find.bySemanticsLabel('Accessible original diagram'),
      findsOneWidget,
    );
  });

  test('wording and external-inspiration asset boundaries are governed', () {
    final english = File('lib/l10n/app_en.arb').readAsStringSync();
    final persian = File('lib/l10n/app_fa.arb').readAsStringSync();
    final presentationText = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) => file.path.endsWith('.dart') || file.path.endsWith('.arb'),
        )
        .map((file) => file.readAsStringSync())
        .join('\n');

    expect(
      presentationText.toLowerCase(),
      isNot(contains('breaking the opponent’s center of gravity')),
    );
    expect(presentationText.toLowerCase(), isNot(contains('facebook.com')));
    expect(
      english,
      contains(
        'This diagram is an educational interpretation. Arrows indicate conceptual movement or force directions and do not represent direct force measurement.',
      ),
    );
    expect(
      persian,
      contains(
        'این نمودار یک تفسیر آموزشی است. فلش‌ها جهت‌های مفهومی حرکت یا نیرو را نشان می‌دهند و بیانگر اندازه‌گیری مستقیم نیرو نیستند.',
      ),
    );
  });
}

Widget _app(TechniqueModel technique, {Locale locale = const Locale('en')}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: GenericTechniqueDetailScreen(technique: technique),
    );

TechniqueModel _fixture({
  TechniqueExplanationExtension explanationExtension =
      const TechniqueExplanationExtension.empty(),
}) => TechniqueModel(
  id: '900',
  englishName: 'Neutral Fixture Technique',
  japaneseName: '試',
  category: 'Fixture',
  type: 'Fixture',
  beltLevel: 'Unavailable',
  difficulty: 'Unavailable',
  description: 'Fixture educational description.',
  technicalAnalysis: 'Fixture technical explanation.',
  translations: const [
    TechniqueTranslation(
      languageCode: 'fa',
      name: 'تکنیک آزمایشی خنثی',
      description: 'شرح آموزشی آزمایشی.',
      technicalAnalysis: 'توضیح فنی آزمایشی.',
      executionSteps: ['گام آزمایشی.'],
      keyPoints: ['نکته آزمایشی.'],
    ),
  ],
  images: const [],
  videos: const [],
  trainingVideo: '',
  competitionVideo: '',
  executionSteps: const ['Fixture execution step.'],
  keyPoints: const ['Fixture coaching point.'],
  commonMistakes: const [],
  safetyTips: const [],
  combinations: const [],
  counters: const [],
  quiz: const [],
  sources: const [],
  explanationExtension: explanationExtension,
);
