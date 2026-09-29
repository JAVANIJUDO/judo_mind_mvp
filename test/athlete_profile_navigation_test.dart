import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/constants/modules.dart';
import 'package:judo_mind/core/providers/local_athlete_profile_provider.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/core/routes/app_routes.dart';
import 'package:judo_mind/data/repositories/local_athlete_profile_repository.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_athlete_profile_storage.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/screens/home/home_screen.dart';
import 'package:judo_mind/screens/profile/athlete_profile_screen.dart';
import 'package:judo_mind/screens/profile/local_analysis_history_screen.dart';
import 'package:judo_mind/widgets/module_card.dart';
import 'package:provider/provider.dart';

void main() {
  test('Athlete Profile module uses the real profile route', () {
    final module = JudoMindModules.modules.singleWhere(
      (module) => module.title == 'Athlete Profile',
    );

    expect(module.route, AppRoutes.profile);
    expect(AppRoutes.routes[AppRoutes.profile], isNotNull);
  });

  testWidgets('Local Analysis History is a destination distinct from Profile', (
    tester,
  ) async {
    late BuildContext context;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (buildContext) {
            context = buildContext;
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(AppRoutes.localAnalysisHistory, isNot(AppRoutes.profile));
    expect(
      AppRoutes.routes[AppRoutes.localAnalysisHistory]!(context),
      isA<LocalAnalysisHistoryScreen>(),
    );
    expect(
      AppRoutes.routes[AppRoutes.profile]!(context),
      isA<AthleteProfileScreen>(),
    );
  });

  testWidgets('Home AppBar profile action reaches Athlete Profile', (
    tester,
  ) async {
    final profile = LocalAthleteProfileProvider(
      repository: LocalAthleteProfileRepository(storage: _ProfileStorage()),
    );
    final history = LocalAttemptHistoryProvider(
      repository: LocalAttemptHistoryRepository(storage: _HistoryStorage()),
    );
    await profile.initialize();
    await history.initialize();
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: profile),
          ChangeNotifierProvider.value(value: history),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          routes: {
            AppRoutes.profile: (context) => const AthleteProfileScreen(),
          },
          home: const HomeScreen(),
        ),
      ),
    );

    await tester.tap(find.byKey(const ValueKey('home-profile-action')));
    await tester.pumpAndSettle();

    expect(find.byType(AthleteProfileScreen), findsOneWidget);
  });

  testWidgets('Athlete Profile module tile reaches the same real route', (
    tester,
  ) async {
    final profileModule = JudoMindModules.modules.singleWhere(
      (module) => module.title == 'Athlete Profile',
    );
    await tester.pumpWidget(
      MaterialApp(
        routes: {
          AppRoutes.profile: (context) =>
              const Placeholder(key: ValueKey('profile-route-destination')),
        },
        home: Scaffold(body: ModuleCard(module: profileModule)),
      ),
    );

    await tester.tap(find.byType(ModuleCard));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('profile-route-destination')),
      findsOneWidget,
    );
  });
}

class _ProfileStorage implements LocalAthleteProfileStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
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
