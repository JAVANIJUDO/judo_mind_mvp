import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:judo_mind/core/language/language_provider.dart';
import 'package:judo_mind/core/providers/favorite_provider.dart';
import 'package:judo_mind/data/storage/user_preferences_storage.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/technique_model.dart';
import 'package:judo_mind/screens/technique_detail/widgets/actions/technique_primary_actions.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/analyze_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/competition/competition_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/media/media_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/media/video_detail_screen.dart';
import 'package:judo_mind/screens/technique_detail/widgets/quiz_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/overview_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/technique_section_router.dart';
import 'package:judo_mind/screens/technique_detail/widgets/sections/training_section.dart';
import 'package:judo_mind/screens/technique_detail/widgets/technique_dashboard_grid.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('Uchi Mata dashboard availability is deterministic', () {
    final dashboardSections = TechniqueDashboardSection.values
        .where((section) => section != TechniqueDashboardSection.aiAnalysis)
        .toList(growable: false);
    final unavailableSections = dashboardSections
        .where(
          (section) => !TechniqueSectionRouter.isAvailable(
            section: section,
            technique: uchiMata,
          ),
        )
        .toSet();

    expect(dashboardSections, hasLength(19));
    expect(unavailableSections, <TechniqueDashboardSection>{
      TechniqueDashboardSection.training,
      TechniqueDashboardSection.shadowTraining,
      TechniqueDashboardSection.conditioning,
      TechniqueDashboardSection.resistanceBandTraining,
      TechniqueDashboardSection.mastery,
      TechniqueDashboardSection.champions,
      TechniqueDashboardSection.sensiBot,
      TechniqueDashboardSection.coachConnection,
    });
    expect(uchiMata.hasApprovedEducationalPracticeGuidance, isTrue);
    expect(
      TechniqueSectionRouter.isAvailable(
        section: TechniqueDashboardSection.aiAnalysis,
        technique: uchiMata,
      ),
      isTrue,
    );
    expect(
      TechniqueSectionRouter.isAvailable(
        section: TechniqueDashboardSection.videos,
        technique: uchiMata,
        languageCode: 'fa',
      ),
      isFalse,
      reason: 'Unlocalized media must fail closed in Persian mode.',
    );
  });

  testWidgets(
    'unavailable section routes fail closed with localized feedback',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          const _RouterHarness(section: TechniqueDashboardSection.mastery),
          locale: const Locale('fa'),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('open-section')));
      await tester.pump();

      expect(
        find.byKey(
          const ValueKey<String>('technique-section-unavailable-mastery'),
        ),
        findsOneWidget,
      );
      expect(find.byType(TrainingSection), findsNothing);
    },
  );

  testWidgets('dashboard visibly marks and routes unavailable actions', (
    tester,
  ) async {
    TechniqueDashboardSection? tappedSection;

    await tester.pumpWidget(
      _testApp(
        TechniqueDashboardGrid(
          quizQuestionCount: uchiMata.quiz.length,
          isSectionAvailable: (section) {
            return TechniqueSectionRouter.isAvailable(
              section: section,
              technique: uchiMata,
            );
          },
          onSectionTap: (section) => tappedSection = section,
        ),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('journey-group-coming-later')),
    );
    await tester.pumpAndSettle();
    final trainingCard = find.byKey(
      const ValueKey<String>('dashboard-section-training'),
    );
    await tester.ensureVisible(trainingCard);
    expect(
      find.descendant(of: trainingCard, matching: find.text('Unavailable')),
      findsOneWidget,
    );

    await tester.tap(trainingCard);
    expect(tappedSection, TechniqueDashboardSection.training);
  });

  testWidgets('technique hub keeps one Analyze and compact future actions', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        SingleChildScrollView(
          child: Column(
            children: [
              TechniquePrimaryActions(technique: uchiMata, onAiAnalysis: () {}),
              TechniqueDashboardGrid(
                quizQuestionCount: uchiMata.quiz.length,
                isSectionAvailable: (section) =>
                    TechniqueSectionRouter.isAvailable(
                      section: section,
                      technique: uchiMata,
                    ),
                onSectionTap: (_) {},
              ),
            ],
          ),
        ),
      ),
    );

    for (final title in [
      'Learn',
      'Analyze',
      'Track Progress',
      'Coming later',
    ]) {
      expect(find.text(title), findsWidgets);
    }
    expect(
      find.byKey(const ValueKey<String>('technique-analyze-action')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('dashboard-section-aiAnalysis')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('dashboard-section-sensiBot')),
      findsNothing,
    );
    await tester.tap(
      find.byKey(const ValueKey<String>('journey-group-progress')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey<String>('dashboard-section-analysisHistory')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('journey-group-train')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('journey-group-coach')),
      findsNothing,
    );
    final comingLater = find.byKey(
      const ValueKey<String>('journey-group-coming-later'),
    );
    await tester.ensureVisible(comingLater);
    await tester.tap(comingLater);
    await tester.pumpAndSettle();
    expect(find.text('Train'), findsOneWidget);
    expect(find.text('Connect with Coach'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('dashboard-section-training')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey<String>('dashboard-section-coachConnection')),
      findsOneWidget,
    );
  });

  testWidgets('five journeys render in Persian without English headings', (
    tester,
  ) async {
    final persian = await AppLocalizations.delegate.load(const Locale('fa'));
    await tester.pumpWidget(
      _testApp(
        SingleChildScrollView(
          child: Column(
            children: [
              TechniquePrimaryActions(technique: uchiMata, onAiAnalysis: () {}),
              TechniqueDashboardGrid(
                quizQuestionCount: uchiMata.quiz.length,
                onSectionTap: (_) {},
              ),
            ],
          ),
        ),
        locale: const Locale('fa'),
      ),
    );

    final comingLater = find.byKey(
      const ValueKey<String>('journey-group-coming-later'),
    );
    await tester.ensureVisible(comingLater);
    await tester.tap(comingLater);
    await tester.pumpAndSettle();

    for (final title in [
      persian.journeyLearnTitle,
      persian.journeyTrainTitle,
      persian.journeyAnalyzeTitle,
      persian.journeyTrackProgressTitle,
      persian.journeyConnectCoachTitle,
    ]) {
      expect(find.text(title), findsWidgets);
    }
    expect(find.text('Connect with Coach'), findsNothing);
  });

  testWidgets('generic Practice fails closed without an approved drill', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const _RouterHarness(section: TechniqueDashboardSection.training),
      ),
    );

    await tester.tap(find.byKey(const ValueKey<String>('open-section')));
    await tester.pump();
    expect(
      find.byKey(
        const ValueKey<String>('technique-section-unavailable-training'),
      ),
      findsOneWidget,
    );
    expect(find.byType(TrainingSection), findsNothing);
  });

  testWidgets(
    'existing overview and reviewed Analyze destinations still open',
    (tester) async {
      await tester.pumpWidget(
        _testApp(
          const _RouterHarness(section: TechniqueDashboardSection.overview),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('open-section')));
      await tester.pumpAndSettle();
      expect(find.byType(OverviewSection), findsOneWidget);

      Navigator.of(tester.element(find.byType(OverviewSection))).pop();
      await tester.pumpAndSettle();

      await tester.pumpWidget(
        _testApp(
          const _RouterHarness(section: TechniqueDashboardSection.aiAnalysis),
        ),
      );
      await tester.tap(find.byKey(const ValueKey<String>('open-section')));
      await tester.pumpAndSettle();
      expect(find.byType(AnalyzeSection), findsOneWidget);
      final analyze = tester.widget<AnalyzeSection>(
        find.byType(AnalyzeSection),
      );
      expect(analyze.technique.supportsReviewedSingleAttemptV2A, isTrue);
    },
  );

  testWidgets(
    'unsupported technique exposes no analysis entry',
    (tester) async {
      const fixture = TechniqueModel(
        id: 'fixture-technique',
        englishName: 'Fixture Technique',
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

      expect(
        TechniqueSectionRouter.isAvailable(
          section: TechniqueDashboardSection.aiAnalysis,
          technique: fixture,
        ),
        isFalse,
      );
      expect(fixture.supportsReviewedSingleAttemptV2A, isFalse);
      expect(fixture.hasApprovedEducationalPracticeGuidance, isFalse);

      await tester.pumpWidget(
        _testApp(
          TechniquePrimaryActions(technique: fixture, onAiAnalysis: () {}),
        ),
      );

      expect(find.text('Analyze Fixture Technique'), findsNothing);
      expect(
        find.byKey(const ValueKey<String>('technique-analyze-action')),
        findsNothing,
      );
      expect(find.textContaining('Uchi Mata'), findsNothing);
    },
  );

  testWidgets('primary actions expose exactly one technique-local Analyze', (
    tester,
  ) async {
    var analyzeTaps = 0;

    await tester.pumpWidget(
      _testApp(
        TechniquePrimaryActions(
          technique: uchiMata,
          onAiAnalysis: () => analyzeTaps += 1,
        ),
      ),
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('technique-analyze-action')),
    );
    expect(analyzeTaps, 1);
    expect(
      find.byKey(const ValueKey<String>('technique-training-action')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey<String>('technique-progress-action')),
      findsNothing,
    );
  });

  testWidgets('empty media cards have no active affordance or player route', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(_testApp(const MediaSection(technique: uchiMata)));
    await tester.pumpAndSettle();

    final officialImage = find.byKey(
      const ValueKey<String>('media-card-uchi-mata-official-image-001'),
    );
    await tester.ensureVisible(officialImage);
    await tester.tap(officialImage);
    await tester.pumpAndSettle();
    expect(find.byType(Dialog), findsOneWidget);
    Navigator.of(tester.element(find.byType(Dialog))).pop();
    await tester.pumpAndSettle();

    final deadCard = find.byKey(
      const ValueKey<String>('media-card-uchi-mata-competition-analysis-001'),
    );
    await tester.ensureVisible(deadCard);
    expect(
      tester
          .widgetList<InkWell>(
            find.descendant(of: deadCard, matching: find.byType(InkWell)),
          )
          .every((widget) => widget.onTap == null),
      isTrue,
    );
    expect(find.byType(VideoDetailScreen), findsNothing);

    final topExecutionCard = find.byKey(
      const ValueKey<String>('media-card-uchi-mata-top-execution-001'),
    );
    await tester.ensureVisible(topExecutionCard);
    expect(
      tester
          .widgetList<InkWell>(
            find.descendant(
              of: topExecutionCard,
              matching: find.byType(InkWell),
            ),
          )
          .every((widget) => widget.onTap == null),
      isTrue,
    );
    expect(find.text('Open Analysis'), findsNothing);
    expect(find.byIcon(Icons.play_circle_outline_rounded), findsNothing);
  });

  testWidgets('competition search result is not exposed as approved media', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const CompetitionAnalysisSection(technique: uchiMata)),
    );

    expect(find.textContaining('Watch Competition Example'), findsNothing);
    expect(
      find.byKey(const ValueKey<String>('competition-content-incomplete')),
      findsOneWidget,
    );
  });

  testWidgets('quiz requires a selection and preserves answer progression', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(QuizSection(quizzes: uchiMata.quiz)));

    ElevatedButton primaryAction() => tester.widget<ElevatedButton>(
      find.byKey(const ValueKey<String>('quiz-primary-action')),
    );

    expect(primaryAction().onPressed, isNull);

    await tester.tap(find.byKey(const ValueKey<String>('quiz-option-0')));
    await tester.pump();
    expect(primaryAction().onPressed, isNotNull);

    await tester.tap(find.byKey(const ValueKey<String>('quiz-primary-action')));
    await tester.pump();
    expect(find.text('Next Question'), findsOneWidget);
  });
}

Widget _testApp(Widget body, {Locale locale = const Locale('en')}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LanguageProvider>(
        create: (_) => LanguageProvider(),
      ),
      ChangeNotifierProvider<FavoriteProvider>(
        create: (_) => FavoriteProvider(storage: UserPreferencesStorage()),
      ),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: body,
        ),
      ),
    ),
  );
}

class _RouterHarness extends StatelessWidget {
  final TechniqueDashboardSection section;

  const _RouterHarness({required this.section});

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      key: const ValueKey<String>('open-section'),
      onPressed: () {
        TechniqueSectionRouter.open(
          context: context,
          section: section,
          technique: uchiMata,
        );
      },
      child: const Text('Open'),
    );
  }
}
