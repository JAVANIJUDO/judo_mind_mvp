import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/constants/modules.dart';
import 'package:judo_mind/core/dependency_injection/injection_container.dart';
import 'package:judo_mind/core/language/language_provider.dart';
import 'package:judo_mind/core/providers/favorite_provider.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/core/providers/recent_techniques_provider.dart';
import 'package:judo_mind/core/routes/app_routes.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/data/storage/user_preferences_storage.dart';
import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/module_model.dart';
import 'package:judo_mind/screens/home/home_capability_contract.dart';
import 'package:judo_mind/screens/home/home_screen.dart';
import 'package:judo_mind/screens/home/module_directory_screen.dart';
import 'package:judo_mind/screens/technique_detail/technique_detail_screen.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/analyze_section.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('five athlete journeys have exact fail-closed destinations', () {
    expect(AthleteHomeCapabilities.journeys, hasLength(5));
    expect(
      AthleteHomeCapabilities.journeys.map((item) => item.id),
      AthleteHomeJourneyId.values,
    );
    expect(
      AthleteHomeCapabilities.journeys.map((item) => item.destination),
      const [
        AthleteHomeDestination.techniques,
        null,
        AthleteHomeDestination.reviewedUchiMataAnalysis,
        AthleteHomeDestination.progressOverview,
        null,
      ],
    );
  });

  test('official module readiness is 1 implemented, 7 partial, 10 closed', () {
    final implemented = JudoMindModules.modules
        .where(
          (module) => module.readiness == JudoMindModuleReadiness.implemented,
        )
        .length;
    final partial = JudoMindModules.modules
        .where(
          (module) =>
              module.readiness == JudoMindModuleReadiness.demoOnly ||
              module.readiness == JudoMindModuleReadiness.foundationOnly,
        )
        .length;

    expect(
      (
        implemented,
        partial,
        JudoMindModules.modules.length - implemented - partial,
      ),
      (1, 7, 10),
    );
  });

  testWidgets('root Home prioritizes four working actions and no root Back', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(393, 873));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_testApp(home: const HomeScreen()));

    expect(find.byType(BackButton), findsNothing);
    for (final journey in const [
      AthleteHomeJourneyId.learn,
      AthleteHomeJourneyId.analyze,
      AthleteHomeJourneyId.trackProgress,
    ]) {
      expect(
        find.byKey(ValueKey('home-journey-${journey.name}')),
        findsOneWidget,
      );
    }
    expect(find.byKey(const ValueKey('home-primary-profile')), findsOneWidget);
    expect(find.byKey(const ValueKey('home-journey-train')), findsNothing);
    expect(
      find.byKey(const ValueKey('home-journey-connectWithCoach')),
      findsNothing,
    );
    expect(
      find.byKey(const ValueKey('home-coming-later-train')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('home-coming-later-connectWithCoach')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('continue-uchi-mata')), findsNothing);
    expect(find.byKey(const ValueKey('continue-local-history')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'Hero fallback opens featured reference, while Learn opens catalog',
    (tester) async {
      await tester.pumpWidget(_testApp(home: const HomeScreen()));

      await tester.tap(find.byKey(const ValueKey('home-hero-primary-action')));
      await tester.pumpAndSettle();
      final detail = tester.widget<TechniqueDetailScreen>(
        find.byType(TechniqueDetailScreen),
      );
      expect(detail.technique, TechniqueFactory.featuredReferenceTechnique);
      expect(find.text('TECHNIQUES_DESTINATION'), findsNothing);

      tester.state<NavigatorState>(find.byType(Navigator)).pop();
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('home-journey-learn')));
      await tester.pumpAndSettle();
      expect(find.text('TECHNIQUES_DESTINATION'), findsOneWidget);
      expect(find.byType(TechniqueDetailScreen), findsNothing);
    },
  );

  testWidgets('Hero prefers real latest-history destination when data exists', (
    tester,
  ) async {
    final history = LocalAttemptHistoryProvider(
      repository: LocalAttemptHistoryRepository(storage: _HistoryStorage()),
    );
    await history.initialize();
    await history.save(validSingleAttemptV2AResult());

    await tester.pumpWidget(
      ChangeNotifierProvider<LocalAttemptHistoryProvider>.value(
        value: history,
        child: _testApp(home: const HomeScreen()),
      ),
    );

    expect(find.text('View latest analysis'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('home-hero-primary-action')));
    await tester.pumpAndSettle();
    expect(find.text('HISTORY_DESTINATION'), findsOneWidget);
    expect(find.byType(TechniqueDetailScreen), findsNothing);
  });

  testWidgets('Continue reference appears only from initialized local data', (
    tester,
  ) async {
    await sl.reset();
    addTearDown(sl.reset);
    SharedPreferences.setMockInitialValues({
      UserPreferencesStorage.recentTechniquesKey: [
        TechniqueFactory.featuredReferenceTechnique.id,
      ],
    });
    sl.registerLazySingleton<UserPreferencesStorage>(
      UserPreferencesStorage.new,
    );
    final recent = RecentTechniquesProvider();
    await recent.initialize();

    await tester.pumpWidget(
      ChangeNotifierProvider<RecentTechniquesProvider>.value(
        value: recent,
        child: _testApp(home: const HomeScreen()),
      ),
    );

    expect(find.byKey(const ValueKey('continue-uchi-mata')), findsOneWidget);
    expect(find.byKey(const ValueKey('continue-local-history')), findsNothing);
  });

  testWidgets('Header and journeys reach distinct approved destinations', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(home: const HomeScreen()));

    await tester.tap(find.byKey(const ValueKey('home-journey-learn')));
    await tester.pumpAndSettle();
    expect(find.text('TECHNIQUES_DESTINATION'), findsOneWidget);
    _pop(tester);
    await tester.pumpAndSettle();

    final trackProgress = find.byKey(
      const ValueKey('home-journey-trackProgress'),
    );
    await tester.ensureVisible(trackProgress);
    await tester.tap(trackProgress);
    await tester.pumpAndSettle();
    expect(find.text('PROGRESS_DESTINATION'), findsOneWidget);
    expect(find.text('PROFILE_DESTINATION'), findsNothing);
    _pop(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('home-settings-action')));
    await tester.pumpAndSettle();
    expect(find.text('SETTINGS_DESTINATION'), findsOneWidget);
    _pop(tester);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('home-profile-action')));
    await tester.pumpAndSettle();
    expect(find.text('PROFILE_DESTINATION'), findsOneWidget);
    expect(find.text('HISTORY_DESTINATION'), findsNothing);
  });

  testWidgets('Home Analyze is explicitly Uchi Mata scoped and preserves V2A', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(home: const HomeScreen()));

    expect(find.text('Analyze Uchi Mata'), findsOneWidget);
    final analyze = find.byKey(const ValueKey('home-journey-analyze'));
    await tester.ensureVisible(analyze);
    await tester.tap(analyze);
    await tester.pumpAndSettle();

    final section = tester.widget<AnalyzeSection>(find.byType(AnalyzeSection));
    expect(section.technique, TechniqueFactory.featuredReferenceTechnique);
    expect(section.technique.supportsReviewedSingleAttemptV2A, isTrue);
  });

  testWidgets('nested Home preserves explicit Back behavior', (tester) async {
    await tester.pumpWidget(
      _testApp(
        home: Builder(
          builder: (context) => Center(
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const HomeScreen(showBackButton: true),
                ),
              ),
              child: const Text('OPEN_NESTED_HOME'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('OPEN_NESTED_HOME'));
    await tester.pumpAndSettle();
    expect(find.byType(BackButton), findsOneWidget);
  });

  testWidgets('Persian Home is RTL with scoped Analyze and reference CTA', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      _testApp(home: const HomeScreen(), locale: const Locale('fa')),
    );
    final persian = await AppLocalizations.delegate.load(const Locale('fa'));

    expect(
      Directionality.of(tester.element(find.byType(HomeScreen))),
      TextDirection.rtl,
    );
    expect(find.text('کاوش اوچی ماتا'), findsOneWidget);
    expect(find.text(persian.homeAnalyzeUchiMataTitle), findsOneWidget);
    expect(find.text(persian.journeyConnectCoachTitle), findsOneWidget);
    expect(find.text('Analyze Uchi Mata'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'directory shows available first and collapses 12 closed modules',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 5000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_testApp(home: const ModuleDirectoryScreen()));

      expect(JudoMindModules.modules, hasLength(18));
      expect(
        find.byKey(const ValueKey('module-directory-home')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('module-directory-techniques')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('module-directory-monitoring-progress-mastery'),
        ),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('module-directory-athlete-profile')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('module-directory-app-management-settings')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('module-directory-club-administration')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('module-directory-sensi-bot')),
        findsNothing,
      );
      expect(find.text('12 official modules are coming later'), findsOneWidget);

      final homeInkWell = tester.widget<InkWell>(
        find.descendant(
          of: find.byKey(const ValueKey('module-directory-home')),
          matching: find.byType(InkWell),
        ),
      );
      expect(homeInkWell.onTap, isNull);
      expect(find.text('Current destination'), findsOneWidget);

      await tester.tap(
        find.byKey(const ValueKey('module-unavailable-expansion')),
      );
      await tester.pumpAndSettle();
      for (final module in JudoMindModules.modules.where(
        (module) => !module.isReachable,
      )) {
        expect(
          find.byKey(ValueKey('module-directory-${module.id}')),
          findsOneWidget,
        );
        expect(module.route, isNull, reason: module.id);
      }
      expect(
        find.byKey(const ValueKey('module-unavailable-shared-reason')),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'directory surfaces filter registry without duplicate identities',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 5000));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(_testApp(home: const ModuleDirectoryScreen()));

      for (final surface in JudoMindPlatformSurface.values) {
        expect(
          find.byKey(ValueKey('module-surface-${surface.name}')),
          findsOneWidget,
        );
      }
      await tester.tap(
        find.byKey(const ValueKey('module-surface-coachWorkspace')),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.byKey(const ValueKey('module-unavailable-expansion')),
      );
      await tester.pumpAndSettle();

      final expected = JudoMindModules.modules.where(
        (module) =>
            module.surfaces.contains(JudoMindPlatformSurface.coachWorkspace),
      );
      for (final module in expected) {
        expect(
          find.byKey(ValueKey('module-directory-${module.id}')),
          findsOneWidget,
        );
      }
    },
  );

  testWidgets('Settings directory entry reaches Settings', (tester) async {
    await tester.pumpWidget(_testApp(home: const ModuleDirectoryScreen()));
    final settings = find.byKey(
      const ValueKey('module-directory-app-management-settings'),
    );
    await tester.scrollUntilVisible(
      settings,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(settings);
    await tester.pumpAndSettle();
    expect(find.text('SETTINGS_DESTINATION'), findsOneWidget);
  });

  testWidgets('Monitoring directory entry reaches Progress Overview', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(home: const ModuleDirectoryScreen()));
    final monitoring = find.byKey(
      const ValueKey('module-directory-monitoring-progress-mastery'),
    );
    await tester.ensureVisible(monitoring);
    await tester.pumpAndSettle();
    await tester.tap(monitoring);
    await tester.pumpAndSettle();
    expect(find.text('PROGRESS_DESTINATION'), findsOneWidget);
  });

  testWidgets('Club directory entry reaches only the local foundation', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(home: const ModuleDirectoryScreen()));
    final club = find.byKey(
      const ValueKey('module-directory-club-administration'),
    );
    await tester.scrollUntilVisible(
      club,
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(club);
    await tester.pumpAndSettle();
    expect(find.text('CLUB_DESTINATION'), findsOneWidget);
    expect(
      JudoMindModules.athleteHomeModules.any(
        (module) => module.id == 'club-administration',
      ),
      isFalse,
    );
  });
}

void _pop(WidgetTester tester) {
  tester.state<NavigatorState>(find.byType(Navigator)).pop();
}

Widget _testApp({required Widget home, Locale locale = const Locale('en')}) {
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
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
      routes: {
        AppRoutes.techniques: (_) =>
            const Scaffold(body: Text('TECHNIQUES_DESTINATION')),
        AppRoutes.profile: (_) =>
            const Scaffold(body: Text('PROFILE_DESTINATION')),
        AppRoutes.localAnalysisHistory: (_) =>
            const Scaffold(body: Text('HISTORY_DESTINATION')),
        AppRoutes.progressOverview: (_) =>
            const Scaffold(body: Text('PROGRESS_DESTINATION')),
        AppRoutes.settings: (_) =>
            const Scaffold(body: Text('SETTINGS_DESTINATION')),
        AppRoutes.clubAdministration: (_) =>
            const Scaffold(body: Text('CLUB_DESTINATION')),
      },
    ),
  );
}

class _HistoryStorage implements LocalAttemptHistoryStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}
