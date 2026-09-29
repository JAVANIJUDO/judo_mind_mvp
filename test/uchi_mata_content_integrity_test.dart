import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:judo_mind/core/localization/technique_term_localizer.dart';
import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/quiz_model.dart';
import 'package:judo_mind/models/technique_model.dart';
import 'package:judo_mind/models/technique_visual_learning_model.dart';
import 'package:judo_mind/screens/technique_detail/widgets/competition/competition_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/quiz_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/overview_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/biomechanics_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/combination_counter_flow.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/mistakes_safety_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/sources_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/technical_analysis_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/training_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/tactical/tactical_intelligence_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/technique_dashboard_grid.dart';
import 'package:judo_mind/screens/technique_detail/widgets/visual_learning/uchi_mata_three_layer_painter.dart';

void main() {
  test('approved Uchi Mata dataset keeps ten valid unique quiz questions', () {
    expect(uchiMata.quiz, hasLength(10));
    expect(uchiMata.quiz.map((quiz) => quiz.id).toSet(), hasLength(10));

    for (final quiz in uchiMata.quiz) {
      expect(quiz.question.trim(), isNotEmpty);
      expect(quiz.options, isNotEmpty);
      expect(
        quiz.correctAnswerIndex,
        inInclusiveRange(0, quiz.options.length - 1),
      );
      expect(quiz.explanation.trim(), isNotEmpty);
    }
  });

  test('all ten quiz questions have complete Persian content', () {
    expect(uchiMata.quiz, hasLength(10));
    for (final quiz in uchiMata.quiz) {
      final persian = quiz.getTranslation('fa');
      expect(persian, isNotNull, reason: quiz.id);
      expect(persian!.question.trim(), isNotEmpty, reason: quiz.id);
      expect(persian.options, hasLength(quiz.options.length), reason: quiz.id);
      expect(
        persian.options.every((option) => option.trim().isNotEmpty),
        isTrue,
        reason: quiz.id,
      );
      expect(persian.explanation.trim(), isNotEmpty, reason: quiz.id);
      expect(
        quiz.correctAnswerIndex,
        inInclusiveRange(0, persian.options.length - 1),
      );
    }
  });

  testWidgets('Persian Quiz does not fall back to the English question', (
    tester,
  ) async {
    final persian = uchiMata.quiz.first.getTranslation('fa')!;
    await tester.pumpWidget(
      _testApp(QuizSection(quizzes: uchiMata.quiz), locale: const Locale('fa')),
    );

    expect(find.text(persian.question), findsOneWidget);
    expect(find.text(uchiMata.quiz.first.question), findsNothing);
    for (final option in persian.options) {
      expect(find.text(option), findsOneWidget);
    }
  });

  test(
    'Uchi Mata Persian dynamic content is complete without English fallback',
    () {
      final english = uchiMata.resolveContent('en');
      final persian = uchiMata.resolveContent('fa');
      final persianSource = uchiMata.getTranslation('fa')!;

      expect(english.executionSteps, uchiMata.executionSteps);
      expect(persian.description, persianSource.description);
      expect(persian.executionSteps, persianSource.executionSteps);
      expect(persian.executionSteps, hasLength(uchiMata.executionSteps.length));
      expect(persian.keyPoints, hasLength(uchiMata.keyPoints.length));
      expect(persian.commonMistakes, hasLength(uchiMata.commonMistakes.length));
      expect(persian.safetyTips, hasLength(uchiMata.safetyTips.length));
      expect(persian.combinations, hasLength(uchiMata.combinations.length));
      expect(persian.counters, hasLength(uchiMata.counters.length));
      for (final englishItem in <String>[
        ...uchiMata.executionSteps,
        ...uchiMata.keyPoints,
        ...uchiMata.commonMistakes,
        ...uchiMata.safetyTips,
        ...uchiMata.combinations,
        ...uchiMata.counters,
      ]) {
        expect(<String>[
          ...persian.executionSteps,
          ...persian.keyPoints,
          ...persian.commonMistakes,
          ...persian.safetyTips,
          ...persian.combinations,
          ...persian.counters,
        ], isNot(contains(englishItem)));
      }
      expect(
        () => english.executionSteps.add('invented'),
        throwsUnsupportedError,
      );
    },
  );

  test('reviewed V2A capability is explicit and fail closed by default', () {
    expect(uchiMata.supportsReviewedSingleAttemptV2A, isTrue);
    expect(_fixtureTechnique().supportsReviewedSingleAttemptV2A, isFalse);
    expect(_emptyTechnique().supportsReviewedSingleAttemptV2A, isFalse);
  });

  test('approved Uchi Mata structured counts remain unchanged', () {
    expect(uchiMata.executionSteps, hasLength(5));
    expect(uchiMata.keyPoints, hasLength(5));
    expect(uchiMata.commonMistakes, hasLength(5));
    expect(uchiMata.safetyTips, hasLength(4));
    expect(uchiMata.combinations, hasLength(4));
    expect(uchiMata.counters, hasLength(4));
    expect(uchiMata.quiz, hasLength(10));
  });

  test('catalog separates runtime, production, preview and roadmap counts', () {
    expect(TechniqueFactory.allTechniques, hasLength(5));
    expect(TechniqueFactory.productionTechniques, [uchiMata]);
    expect(TechniqueFactory.previewTechniques, hasLength(4));
    expect(TechniqueFactory.officialRoadmapTechniqueCount, 67);
    expect(
      TechniqueFactory.allTechniques.length,
      TechniqueFactory.productionTechniques.length +
          TechniqueFactory.previewTechniques.length,
    );
  });

  testWidgets('overview renders approved identity and content without filler', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const OverviewSection(technique: uchiMata)),
    );
    final l10n = AppLocalizations.of(
      tester.element(find.byType(OverviewSection)),
    )!;

    expect(find.text(uchiMata.japaneseName), findsOneWidget);
    expect(
      find.text(TechniqueTermLocalizer.taxonomy(l10n, uchiMata.category)),
      findsOneWidget,
    );
    expect(
      find.text(TechniqueTermLocalizer.taxonomy(l10n, uchiMata.type)),
      findsOneWidget,
    );
    expect(
      find.text(TechniqueTermLocalizer.difficulty(l10n, uchiMata.beltLevel)),
      findsOneWidget,
    );
    expect(find.text(uchiMata.description), findsOneWidget);
    expect(find.text(uchiMata.technicalAnalysis), findsNothing);
    for (final keyPoint in uchiMata.keyPoints) {
      expect(find.text(keyPoint), findsNothing);
    }

    expect(find.text('Purpose of Technique'), findsNothing);
    expect(find.text('When To Use'), findsNothing);
    expect(find.text('Common Application'), findsNothing);
  });

  testWidgets('overview uses approved Persian content where it exists', (
    tester,
  ) async {
    final persian = uchiMata.getTranslation('fa')!;
    await tester.pumpWidget(
      _testApp(
        const OverviewSection(technique: uchiMata),
        locale: const Locale('fa'),
      ),
    );

    expect(find.text(persian.description), findsOneWidget);
    expect(find.text('توضیحات'), findsOneWidget);
  });

  testWidgets(
    'technical analysis renders every structured item from selection',
    (tester) async {
      await tester.pumpWidget(
        _testApp(const TechnicalAnalysisSection(technique: uchiMata)),
      );

      final phaseIds = ['kuzushi', 'tsukuri', 'kake'];
      for (var index = 0; index < phaseIds.length; index++) {
        await tester.tap(
          find.byKey(ValueKey<String>('technical-phase-${phaseIds[index]}')),
        );
        await tester.pump();
        expect(find.text(uchiMata.executionSteps[index]), findsOneWidget);
      }
      for (final step in uchiMata.executionSteps.skip(3)) {
        expect(find.text(step), findsOneWidget);
      }
      for (final item in uchiMata.keyPoints) {
        expect(find.text(item), findsOneWidget);
      }
      for (final item in [...uchiMata.commonMistakes, ...uchiMata.safetyTips]) {
        expect(find.text(item), findsNothing);
      }
    },
  );

  testWidgets(
    'Kuzushi Tsukuri and Kake form one selectable progressive artifact',
    (tester) async {
      await tester.pumpWidget(
        _testApp(const TechnicalAnalysisSection(technique: uchiMata)),
      );

      expect(
        find.byKey(const ValueKey<String>('technical-phase-progression')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('technical-phase-kuzushi')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('technical-phase-tsukuri')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('technical-phase-kake')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey<String>('technical-phase-detail-kuzushi')),
        findsOneWidget,
      );
      expect(find.text(uchiMata.executionSteps[0]), findsOneWidget);

      final tsukuriCard = find.byKey(
        const ValueKey<String>('technical-phase-tsukuri'),
      );
      await tester.ensureVisible(tsukuriCard);
      await tester.tap(tsukuriCard);
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('technical-phase-detail-tsukuri')),
        findsOneWidget,
      );
      expect(find.text(uchiMata.executionSteps[1]), findsOneWidget);

      final kakeCard = find.byKey(
        const ValueKey<String>('technical-phase-kake'),
      );
      await tester.ensureVisible(kakeCard);
      await tester.tap(kakeCard);
      await tester.pump();
      expect(
        find.byKey(const ValueKey<String>('technical-phase-detail-kake')),
        findsOneWidget,
      );
      expect(find.text(uchiMata.executionSteps[2]), findsOneWidget);
    },
  );

  testWidgets('biomechanics painter is not reused by Technical Analysis', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const TechnicalAnalysisSection(technique: uchiMata)),
    );
    expect(
      tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .where((paint) => paint.painter is UchiMataThreeLayerPainter),
      isEmpty,
    );

    await tester.pumpWidget(
      _testApp(const BiomechanicsSection(technique: uchiMata)),
    );
    expect(
      tester
          .widgetList<CustomPaint>(find.byType(CustomPaint))
          .where((paint) => paint.painter is UchiMataThreeLayerPainter),
      isNotEmpty,
    );
    expect(
      find.byKey(const ValueKey<String>('biomechanics-educational-limitation')),
      findsOneWidget,
    );
    expect(find.textContaining('not a measurement'), findsOneWidget);
    expect(find.text('Illustrative direction'), findsOneWidget);
    expect(find.text('Force'), findsNothing);
  });

  testWidgets('mistakes and combination/counter flows use distinct renderers', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const TechniqueMistakesSafetySection(technique: uchiMata)),
    );
    expect(
      find.byKey(const ValueKey<String>('mistakes-distinct-renderer')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('safety-distinct-renderer')),
      findsOneWidget,
    );
    for (final item in [...uchiMata.commonMistakes, ...uchiMata.safetyTips]) {
      expect(find.text(item), findsOneWidget);
    }

    await tester.pumpWidget(
      _testApp(const TechniqueCombinationCounterFlow(technique: uchiMata)),
    );
    expect(
      find.byKey(
        const ValueKey<String>('combination-counter-distinct-renderer'),
      ),
      findsOneWidget,
    );
    for (final item in [...uchiMata.combinations, ...uchiMata.counters]) {
      expect(find.text(item), findsOneWidget);
    }
  });

  testWidgets(
    'Persian dynamic technique and biomechanics content stays Persian',
    (tester) async {
      final persian = uchiMata.resolveContent('fa');
      await tester.pumpWidget(
        _testApp(
          const TechniqueCombinationCounterFlow(technique: uchiMata),
          locale: const Locale('fa'),
        ),
      );
      for (final item in [...persian.combinations, ...persian.counters]) {
        expect(find.text(item), findsOneWidget);
      }
      expect(find.text('Blocking the attacking leg'), findsNothing);
      expect(find.text('Moving hips away from attack'), findsNothing);

      await tester.pumpWidget(
        _testApp(
          const BiomechanicsSection(technique: uchiMata),
          locale: const Locale('fa'),
        ),
      );
      expect(find.text('نمایش حرکتی اوچی‌ماتا'), findsOneWidget);
      expect(find.text('حرکت'), findsOneWidget);
      expect(find.text('کنترل'), findsOneWidget);
      expect(find.text('جهت نمایشی'), findsOneWidget);
      expect(find.text('Uchi Mata Biomechanics'), findsNothing);
      expect(find.text('Movement'), findsNothing);
      expect(find.text('Control'), findsNothing);
      expect(find.text('Force'), findsNothing);
    },
  );

  testWidgets('Practice is concise and does not repeat learning content', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const TrainingSection(technique: uchiMata)),
    );

    expect(
      find.byKey(const ValueKey<String>('practice-educational-boundary')),
      findsNothing,
    );
    for (final item in [
      ...uchiMata.executionSteps,
      ...uchiMata.keyPoints,
      ...uchiMata.commonMistakes,
      ...uchiMata.safetyTips,
    ]) {
      expect(find.text(item), findsNothing);
    }
    expect(
      find.byKey(const ValueKey<String>('technique-training-unavailable')),
      findsOneWidget,
    );
    expect(find.byType(Slider), findsNothing);
  });

  testWidgets('missing technical data renders explicit empty states', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TechnicalAnalysisSection(technique: _emptyTechnique())),
    );

    expect(
      find.byKey(const ValueKey<String>('technical-phase-empty')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('technical-key-point-empty')),
      findsOneWidget,
    );
    expect(find.text('Common Mistakes'), findsNothing);
    expect(find.text('Safety Tips'), findsNothing);
  });

  testWidgets('neutral fixture renders distinct variable-length model data', (
    tester,
  ) async {
    final fixture = _fixtureTechnique();

    await tester.pumpWidget(_testApp(OverviewSection(technique: fixture)));
    expect(find.text('Fixture Identity'), findsOneWidget);
    expect(find.text('Fixture Classification'), findsOneWidget);
    expect(find.text('Fixture Overview'), findsOneWidget);
    expect(find.text('Fixture Analysis'), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('overview-key-point-0')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('overview-key-point-1')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('overview-key-point-2')),
      findsNothing,
    );

    await tester.pumpWidget(
      _testApp(TechnicalAnalysisSection(technique: fixture)),
    );
    for (var index = 0; index < 3; index++) {
      final phaseId = const ['kuzushi', 'tsukuri', 'kake'][index];
      await tester.tap(
        find.byKey(ValueKey<String>('technical-phase-$phaseId')),
      );
      await tester.pump();
      expect(find.text(fixture.executionSteps[index]), findsOneWidget);
    }
    expect(find.text(fixture.executionSteps[3]), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('technical-completion-step-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('technical-completion-step-1')),
      findsNothing,
    );
    expect(find.text(fixture.safetyTips.last), findsNothing);

    await tester.pumpWidget(
      _testApp(CompetitionAnalysisSection(technique: fixture)),
    );
    for (final item in [...fixture.combinations, ...fixture.counters]) {
      expect(find.text(item), findsNothing);
    }

    for (final uchiContent in [
      uchiMata.description,
      uchiMata.technicalAnalysis,
      ...uchiMata.executionSteps,
      ...uchiMata.keyPoints,
      ...uchiMata.commonMistakes,
      ...uchiMata.safetyTips,
      ...uchiMata.combinations,
      ...uchiMata.counters,
    ]) {
      expect(find.text(uchiContent), findsNothing);
    }
  });

  testWidgets('neutral fixture quiz and dashboard use the actual count', (
    tester,
  ) async {
    final fixture = _fixtureTechnique();

    await tester.pumpWidget(_testApp(QuizSection(quizzes: fixture.quiz)));
    expect(find.text('Fixture Question One'), findsOneWidget);
    expect(find.text('Question 1/2'), findsOneWidget);

    await tester.pumpWidget(
      _testApp(
        SingleChildScrollView(
          child: TechniqueDashboardGrid(
            quizQuestionCount: fixture.quiz.length,
            onSectionTap: (_) {},
          ),
        ),
      ),
    );
    final moreGroup = find.byKey(const ValueKey<String>('journey-group-more'));
    await tester.ensureVisible(moreGroup);
    await tester.tap(moreGroup);
    await tester.pumpAndSettle();
    final quizCard = find.byKey(
      const ValueKey<String>('dashboard-section-quiz'),
    );
    expect(
      find.descendant(of: quizCard, matching: find.text('2')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: quizCard, matching: find.text('10')),
      findsNothing,
    );
  });

  testWidgets('empty overview fields remain explicit and fail closed', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(OverviewSection(technique: _emptyTechnique())),
    );

    expect(
      find.byKey(const ValueKey<String>('overview-description')),
      findsOneWidget,
    );
    expect(
      find.text(
        'Curated educational content is not available for this field yet.',
      ),
      findsOneWidget,
    );
  });

  test('educational widgets do not embed canonical Uchi Mata prose', () {
    const widgetPaths = <String>[
      'lib/screens/technique_detail/widgets/sections/overview_section.dart',
      'lib/screens/technique_detail/widgets/sections/technical_analysis_section.dart',
      'lib/screens/technique_detail/widgets/content/technique_content_widgets.dart',
      'lib/screens/technique_detail/widgets/tactical/tactical_intelligence_section.dart',
      'lib/screens/technique_detail/widgets/competition/competition_section.dart',
      'lib/screens/technique_detail/widgets/quiz_section.dart',
      'lib/screens/technique_detail/widgets/sections/sources_section.dart',
      'lib/screens/technique_detail/widgets/sections/training_section.dart',
      'lib/screens/technique_detail/widgets/visual_learning/technique_phase_visual_guide.dart',
      'lib/screens/technique_detail/widgets/visual_learning/uchi_mata_three_layer_painter.dart',
    ];
    final canonicalProse = <String>[
      uchiMata.description,
      uchiMata.technicalAnalysis,
      ...uchiMata.executionSteps,
      ...uchiMata.keyPoints,
      ...uchiMata.commonMistakes,
      ...uchiMata.safetyTips,
      ...uchiMata.combinations,
      ...uchiMata.counters,
    ];

    for (final path in widgetPaths) {
      final source = File(path).readAsStringSync();
      for (final prose in canonicalProse) {
        expect(
          source,
          isNot(contains(prose)),
          reason: '$path embeds model prose',
        );
      }
    }
  });

  test('visual painter keeps phase labels caller-supplied', () {
    final source = File(
      'lib/screens/technique_detail/widgets/visual_learning/'
      'uchi_mata_three_layer_painter.dart',
    ).readAsStringSync();

    for (final embeddedLabel in const ['KUZUSHI', 'TSUKURI', 'KAKE']) {
      expect(source, isNot(contains("'$embeddedLabel'")));
    }
    expect(source, contains('phaseLabel'));
  });

  testWidgets('tactical section does not reinterpret or duplicate key points', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const TacticalIntelligenceSection(technique: uchiMata)),
    );

    expect(
      find.byKey(const ValueKey<String>('tactical-content-incomplete')),
      findsOneWidget,
    );
    for (final keyPoint in uchiMata.keyPoints) {
      expect(find.text(keyPoint), findsNothing);
    }
    expect(find.text('Grip Strategy'), findsNothing);
    expect(find.text('Body Position'), findsNothing);
  });

  testWidgets('competition does not reuse combinations and counters', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const CompetitionAnalysisSection(technique: uchiMata)),
    );

    expect(
      find.byKey(const ValueKey<String>('competition-content-incomplete')),
      findsOneWidget,
    );
    for (final item in [...uchiMata.combinations, ...uchiMata.counters]) {
      expect(find.text(item), findsNothing);
    }
    expect(find.textContaining('youtube.com/results'), findsNothing);
    expect(find.textContaining('Watch Competition Example'), findsNothing);
  });

  testWidgets('sources render concrete approved entries and reject searches', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(TechniqueSourcesSection(sources: uchiMata.sources)),
    );

    expect(
      find.byKey(const ValueKey<String>('approved-source-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('approved-source-1')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('approved-source-2')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('general-reference-disclosure')),
      findsOneWidget,
    );
    for (final source in uchiMata.sources) {
      expect(find.text(source.title), findsOneWidget);
      expect(find.text(source.url), findsOneWidget);
    }

    await tester.pumpWidget(
      _testApp(
        const TechniqueSourcesSection(
          sources: [
            TechniqueSource(
              title: 'Search result',
              url: 'https://example.com/results?search_query=uchi+mata',
            ),
            TechniqueSource(title: '', url: 'https://example.com'),
            TechniqueSource(title: 'Missing URL', url: ''),
          ],
        ),
      ),
    );
    expect(
      find.byKey(const ValueKey<String>('approved-sources-empty')),
      findsOneWidget,
    );
    expect(find.text('Search result'), findsNothing);
  });

  testWidgets('quiz renders structured questions and preserves answer state', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(QuizSection(quizzes: uchiMata.quiz)));

    ElevatedButton primaryAction() => tester.widget<ElevatedButton>(
      find.byKey(const ValueKey<String>('quiz-primary-action')),
    );

    expect(find.text(uchiMata.quiz.first.question), findsOneWidget);
    expect(find.text('Question 1/10'), findsOneWidget);
    expect(primaryAction().onPressed, isNull);

    await tester.tap(
      find.byKey(
        ValueKey<String>(
          'quiz-option-${uchiMata.quiz.first.correctAnswerIndex}',
        ),
      ),
    );
    await tester.pump();
    expect(primaryAction().onPressed, isNotNull);

    await tester.tap(find.byKey(const ValueKey<String>('quiz-primary-action')));
    await tester.pump();
    expect(
      find.byKey(const ValueKey<String>('quiz-explanation')),
      findsOneWidget,
    );
    expect(find.text('Your Score: 1'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey<String>('quiz-primary-action')));
    await tester.pump();
    expect(find.text(uchiMata.quiz[1].question), findsOneWidget);
    expect(find.text('Question 2/10'), findsOneWidget);
  });

  testWidgets('empty quiz is explicit rather than disappearing', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const QuizSection(quizzes: [])));
    expect(find.byKey(const ValueKey<String>('quiz-empty')), findsOneWidget);
  });
}

Widget _testApp(Widget body, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: body,
      ),
    ),
  );
}

TechniqueModel _emptyTechnique() {
  return const TechniqueModel(
    id: 'empty',
    englishName: 'Empty Technique',
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
}

const TechniqueVisualLearningPlan _fixtureVisualLearningPlan =
    TechniqueVisualLearningPlan(
      techniqueId: 'fixture-technique',
      sequences: [
        TechniqueVisualSequence(
          id: 'fixture-technical-visual',
          title: 'Fixture Visual',
          description: 'Fixture visual companion',
          learningType: TechniqueVisualLearningType.technicalExecution,
          rendererType: TechniqueVisualRendererType.uchiMataThreeLayer,
          durationMilliseconds: 1200,
          loop: false,
          layers: [
            TechniqueVisualLayer(
              id: 'fixture-movement',
              title: 'Fixture Movement',
              shortInstruction: 'Fixture movement layer',
              type: TechniqueVisualLayerType.movement,
              color: TechniqueVisualLayerColor.blue,
              mediaType: TechniqueVisualMediaType.customPainter,
            ),
            TechniqueVisualLayer(
              id: 'fixture-control',
              title: 'Fixture Control',
              shortInstruction: 'Fixture control layer',
              type: TechniqueVisualLayerType.control,
              color: TechniqueVisualLayerColor.gold,
              mediaType: TechniqueVisualMediaType.customPainter,
            ),
            TechniqueVisualLayer(
              id: 'fixture-educational',
              title: 'Fixture Educational Layer',
              shortInstruction: 'Fixture educational layer',
              type: TechniqueVisualLayerType.biomechanics,
              color: TechniqueVisualLayerColor.green,
              mediaType: TechniqueVisualMediaType.customPainter,
            ),
          ],
        ),
      ],
    );

TechniqueModel _fixtureTechnique() {
  return const TechniqueModel(
    id: 'fixture-technique',
    englishName: 'Fixture Technique',
    japaneseName: 'Fixture Identity',
    category: 'Fixture Classification',
    type: 'Fixture Type',
    beltLevel: 'Fixture Belt',
    difficulty: 'Fixture Difficulty',
    description: 'Fixture Overview',
    technicalAnalysis: 'Fixture Analysis',
    images: [],
    videos: [],
    trainingVideo: '',
    competitionVideo: '',
    visualLearningPlan: _fixtureVisualLearningPlan,
    executionSteps: [
      'Fixture Step One',
      'Fixture Step Two',
      'Fixture Step Three',
      'Fixture Step Four',
    ],
    keyPoints: ['Fixture Key Point One', 'Fixture Key Point Two'],
    commonMistakes: ['Fixture Mistake'],
    safetyTips: [
      'Fixture Safety One',
      'Fixture Safety Two',
      'Fixture Safety Three',
    ],
    combinations: ['Fixture Combination One', 'Fixture Combination Two'],
    counters: ['Fixture Counter'],
    quiz: [
      QuizModel(
        id: 'fixture-question-1',
        question: 'Fixture Question One',
        options: ['Fixture Option A', 'Fixture Option B'],
        correctAnswerIndex: 0,
        explanation: 'Fixture Explanation One',
      ),
      QuizModel(
        id: 'fixture-question-2',
        question: 'Fixture Question Two',
        options: ['Fixture Option C', 'Fixture Option D'],
        correctAnswerIndex: 1,
        explanation: 'Fixture Explanation Two',
      ),
    ],
    sources: [
      TechniqueSource(
        title: 'Fixture Source',
        url: 'https://example.org/fixture-source',
      ),
    ],
  );
}
