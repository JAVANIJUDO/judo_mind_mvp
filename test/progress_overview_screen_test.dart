import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/constants/modules.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/core/routes/app_routes.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/module_model.dart';
import 'package:judo_mind/screens/progress/progress_overview_screen.dart';
import 'package:provider/provider.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  testWidgets('empty History renders explicit no-evidence and no Mastery', (
    tester,
  ) async {
    await _pumpProgress(tester, provider: await _provider());

    expect(find.byKey(const ValueKey('progress-no-evidence')), findsOneWidget);
    expect(find.text('No saved progress evidence'), findsOneWidget);
    expect(find.text('Mastery is unavailable'), findsOneWidget);
    expect(find.text('Analyze Uchi Mata'), findsOneWidget);
    expect(find.text('Open local analysis history'), findsNothing);
    expect(find.textContaining('mastery score'), findsNothing);
    expect(find.textContaining('%'), findsNothing);
  });

  testWidgets('one attempt renders exact separate evidence counts', (
    tester,
  ) async {
    final provider = await _provider(attemptIds: const ['attempt-1']);
    await _pumpProgress(tester, provider: provider);

    expect(
      find.descendant(
        of: find.byKey(const ValueKey('progress-total-attempts')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('progress-reportable-count')),
        matching: find.text('2'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('progress-review-required-count')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('progress-withheld-count')),
        matching: find.text('1'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('scientific boundaries remain visible and fail closed', (
    tester,
  ) async {
    await _pumpProgress(
      tester,
      provider: await _provider(attemptIds: const ['attempt-1']),
    );

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('progress-scientific-details')),
      350,
    );
    await tester.tap(find.byKey(const ValueKey('progress-scientific-details')));
    await tester.pumpAndSettle();
    expect(
      find.textContaining('UM-ANG-001 remains pending human review'),
      findsOneWidget,
    );
    expect(
      find.text('Multi-person evidence remains insufficient.'),
      findsOneWidget,
    );
    expect(
      find.text('Interaction metrics remain non-reportable.'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('progress-mastery-unavailable')),
      300,
    );
    expect(
      find.byKey(const ValueKey('progress-mastery-unavailable')),
      findsOneWidget,
    );
    expect(find.textContaining('performance score'), findsNothing);
    expect(find.textContaining('improved'), findsNothing);
    expect(find.textContaining('ranking:'), findsNothing);
  });

  testWidgets('Progress action opens raw History as a different destination', (
    tester,
  ) async {
    await _pumpProgress(
      tester,
      provider: await _provider(attemptIds: const ['attempt-1']),
      historyBuilder: (_) => const Scaffold(
        body: SizedBox(key: ValueKey('raw-history-destination')),
      ),
    );

    expect(find.byType(ProgressOverviewScreen), findsOneWidget);
    expect(AppRoutes.progressOverview, isNot(AppRoutes.localAnalysisHistory));
    expect(AppRoutes.progressOverview, isNot(AppRoutes.profile));
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('progress-open-history')),
      400,
    );
    await tester.tap(find.byKey(const ValueKey('progress-open-history')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('raw-history-destination')),
      findsOneWidget,
    );
  });

  testWidgets('Persian Progress is RTL with no English fallback', (
    tester,
  ) async {
    await _pumpProgress(
      tester,
      provider: await _provider(attemptIds: const ['attempt-1']),
      locale: const Locale('fa'),
    );
    final persian = await AppLocalizations.delegate.load(const Locale('fa'));

    expect(
      Directionality.of(tester.element(find.byType(ProgressOverviewScreen))),
      TextDirection.rtl,
    );
    expect(find.text(persian.progressOverviewTitle), findsOneWidget);
    expect(find.text('شواهد علمی معیارها'), findsNothing);
    expect(find.text('Scientific progress evidence'), findsNothing);
    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('progress-mastery-unavailable')),
      400,
    );
    expect(find.text(persian.progressMasteryUnavailableTitle), findsOneWidget);
    expect(find.text('Mastery is unavailable'), findsNothing);
  });

  test('Monitoring module is an honest reachable foundation, not Mastery', () {
    final module = JudoMindModules.modules.singleWhere(
      (item) => item.id == 'monitoring-progress-mastery',
    );

    expect(JudoMindModules.modules, hasLength(18));
    expect(module.availability, JudoMindModuleAvailability.available);
    expect(module.readiness, JudoMindModuleReadiness.foundationOnly);
    expect(module.route, AppRoutes.progressOverview);
    expect(module.isReachable, isTrue);
    expect(AppRoutes.routes[module.route], isNotNull);
  });
}

Future<LocalAttemptHistoryProvider> _provider({
  List<String> attemptIds = const [],
}) async {
  final repository = LocalAttemptHistoryRepository(
    storage: _MemoryHistoryStorage(),
  );
  for (final attemptId in attemptIds) {
    await repository.save(validSingleAttemptV2AResult(analysisId: attemptId));
  }
  final provider = LocalAttemptHistoryProvider(repository: repository);
  await provider.initialize();
  return provider;
}

Future<void> _pumpProgress(
  WidgetTester tester, {
  required LocalAttemptHistoryProvider provider,
  Locale locale = const Locale('en'),
  WidgetBuilder? historyBuilder,
}) {
  return tester.pumpWidget(
    ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        routes: {
          AppRoutes.localAnalysisHistory:
              historyBuilder ?? (_) => const SizedBox(),
        },
        home: const ProgressOverviewScreen(),
      ),
    ),
  );
}

class _MemoryHistoryStorage implements LocalAttemptHistoryStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}
