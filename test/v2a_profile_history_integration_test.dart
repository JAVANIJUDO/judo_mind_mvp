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
  testWidgets(
    'real V2A provider save is rendered by the same Profile History state',
    (tester) async {
      final historyProvider = LocalAttemptHistoryProvider(
        repository: LocalAttemptHistoryRepository(
          storage: _HistoryStorage(),
          utcNow: () => DateTime.utc(2026, 8, 12, 12),
        ),
      );
      await historyProvider.initialize();
      await historyProvider.save(validSingleAttemptV2AResult());
      expect(historyProvider.saveState, LocalAttemptSaveState.saved);
      expect(historyProvider.records, hasLength(1));

      final profileProvider = LocalAthleteProfileProvider(
        repository: LocalAthleteProfileRepository(storage: _ProfileStorage()),
      );
      await profileProvider.initialize();

      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: historyProvider),
            ChangeNotifierProvider.value(value: profileProvider),
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
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('local-analysis-history-list')),
        400,
        scrollable: find.byType(Scrollable).first,
      );

      expect(
        find.byKey(const ValueKey('local-analysis-history-list')),
        findsOneWidget,
      );
      expect(
        find.byKey(
          const ValueKey('history-record-analysis-v2a-history-fixture'),
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('Saved local validation results: 1'),
        findsOneWidget,
      );
    },
  );
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
