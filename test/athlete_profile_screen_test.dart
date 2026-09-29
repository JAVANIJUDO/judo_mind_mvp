import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/providers/local_athlete_profile_provider.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/data/repositories/local_athlete_profile_repository.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_athlete_profile_storage.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/screens/profile/athlete_profile_screen.dart';
import 'package:provider/provider.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  testWidgets('shows honest empty local-only states without mastery claims', (
    tester,
  ) async {
    await _pumpProfile(tester);

    expect(
      find.byKey(const ValueKey('profile-local-disclosure')),
      findsOneWidget,
    );
    expect(find.textContaining('self-reported'), findsWidgets);
    await _scrollTo(
      tester,
      find.byKey(const ValueKey('history-local-disclosure')),
    );
    expect(
      find.byKey(const ValueKey('history-local-disclosure')),
      findsOneWidget,
    );
    await _scrollTo(tester, find.byKey(const ValueKey('history-empty-state')));
    expect(find.byKey(const ValueKey('history-empty-state')), findsOneWidget);
    expect(
      find.textContaining('No saved local validation results'),
      findsOneWidget,
    );
    expect(find.textContaining('performance or mastery score'), findsOneWidget);
  });

  testWidgets('renders original history status, provenance and limitations', (
    tester,
  ) async {
    final historyStorage = _MemoryHistoryStorage();
    final repository = LocalAttemptHistoryRepository(
      storage: historyStorage,
      utcNow: () => DateTime.utc(2026, 8, 12, 8),
    );
    await repository.save(validSingleAttemptV2AResult());
    await _pumpProfile(tester, historyStorage: historyStorage);

    await _scrollTo(
      tester,
      find.byKey(const ValueKey('local-analysis-history-list')),
    );
    expect(
      find.byKey(const ValueKey('local-analysis-history-list')),
      findsOneWidget,
    );
    await tester.tap(
      find.byKey(const ValueKey('history-record-analysis-v2a-history-fixture')),
    );
    await tester.pumpAndSettle();

    await _scrollTo(
      tester,
      find.byKey(const ValueKey('history-metric-UM-ANG-002')),
    );
    expect(
      find.byKey(const ValueKey('history-metric-UM-TIM-001')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('history-metric-UM-ANG-001')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('history-metric-UM-ANG-002')),
      findsOneWidget,
    );
    final l10n = AppLocalizations.of(
      tester.element(find.byType(AthleteProfileScreen)),
    )!;
    expect(find.textContaining('Review required'), findsWidgets);
    expect(find.textContaining(l10n.provenanceModelEstimated), findsWidgets);
    expect(
      find.textContaining(l10n.groundedSenseiWhySupportKnee),
      findsWidgets,
    );
    expect(find.textContaining('Non-reportable'), findsWidgets);
  });

  testWidgets('corrupted profile and history both fail closed', (tester) async {
    await _pumpProfile(
      tester,
      profileStorage: _MemoryProfileStorage(payload: '{bad'),
      historyStorage: _MemoryHistoryStorage(payload: '{bad'),
    );

    expect(find.byKey(const ValueKey('profile-storage-error')), findsOneWidget);
    expect(find.byKey(const ValueKey('history-storage-error')), findsOneWidget);
    expect(find.textContaining('not overwritten'), findsNWidgets(2));
  });
}

Future<void> _scrollTo(WidgetTester tester, Finder target) {
  return tester.scrollUntilVisible(
    target,
    400,
    scrollable: find.byType(Scrollable).first,
  );
}

Future<void> _pumpProfile(
  WidgetTester tester, {
  _MemoryProfileStorage? profileStorage,
  _MemoryHistoryStorage? historyStorage,
}) async {
  final profileProvider = LocalAthleteProfileProvider(
    repository: LocalAthleteProfileRepository(
      storage: profileStorage ?? _MemoryProfileStorage(),
    ),
  );
  final historyProvider = LocalAttemptHistoryProvider(
    repository: LocalAttemptHistoryRepository(
      storage: historyStorage ?? _MemoryHistoryStorage(),
    ),
  );
  await profileProvider.initialize();
  await historyProvider.initialize();

  await tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: profileProvider),
        ChangeNotifierProvider.value(value: historyProvider),
      ],
      child: MaterialApp(
        locale: const Locale('en'),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const AthleteProfileScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

class _MemoryProfileStorage implements LocalAthleteProfileStorage {
  _MemoryProfileStorage({this.payload});
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}

class _MemoryHistoryStorage implements LocalAttemptHistoryStorage {
  _MemoryHistoryStorage({this.payload});
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}
