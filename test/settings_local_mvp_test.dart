import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/capabilities/current_scientific_capabilities.dart';
import 'package:judo_mind/core/constants/modules.dart';
import 'package:judo_mind/core/language/app_language.dart';
import 'package:judo_mind/core/language/language_provider.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/core/routes/app_routes.dart';
import 'package:judo_mind/data/repositories/local_athlete_profile_repository.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_athlete_profile_storage.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:judo_mind/data/storage/user_preferences_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/local_athlete_profile.dart';
import 'package:judo_mind/screens/settings/settings_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets(
    'English and Persian apply immediately with complete RTL labels',
    (tester) async {
      final language = LanguageProvider();
      await language.initialize();
      final history = await _historyProvider();
      await _pumpSettings(tester, language: language, history: history);

      expect(find.text('Local data & privacy'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byType(SettingsScreen))),
        TextDirection.ltr,
      );

      await tester.tap(find.byKey(const ValueKey('settings-language-fa')));
      await tester.pumpAndSettle();
      final persian = await AppLocalizations.delegate.load(const Locale('fa'));

      expect(
        Directionality.of(tester.element(find.byType(SettingsScreen))),
        TextDirection.rtl,
      );
      expect(find.text(persian.settingsLocalDataTitle), findsOneWidget);
      expect(
        find.text(persian.settingsScientificBoundaryTitle),
        findsOneWidget,
      );
      expect(find.text('Local data & privacy'), findsNothing);
      expect(find.text('Scientific & capability transparency'), findsNothing);
      expect(find.text('Application information'), findsNothing);
    },
  );

  test(
    'selected language persists through the real local storage boundary',
    () async {
      final first = LanguageProvider(storage: UserPreferencesStorage());
      await first.initialize();
      expect(await first.changeLanguage(AppLanguage.persian), isTrue);

      final recreated = LanguageProvider(storage: UserPreferencesStorage());
      await recreated.initialize();
      expect(recreated.currentLanguage, AppLanguage.persian);
    },
  );

  testWidgets('real History count and honest empty state are displayed', (
    tester,
  ) async {
    final storage = _MemoryHistoryStorage();
    final repository = LocalAttemptHistoryRepository(storage: storage);
    await repository.save(validSingleAttemptV2AResult());
    final history = LocalAttemptHistoryProvider(repository: repository);
    await history.initialize();

    await _pumpSettings(
      tester,
      language: await _languageProvider(),
      history: history,
    );
    expect(find.text('Local validation history records: 1'), findsOneWidget);

    await history.clearHistory();
    await tester.pumpAndSettle();
    expect(find.text('Local validation history records: 0'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('settings-history-empty')),
      findsOneWidget,
    );
  });

  testWidgets('canceling clear preserves every History record', (tester) async {
    final storage = _MemoryHistoryStorage();
    final repository = LocalAttemptHistoryRepository(storage: storage);
    await repository.save(validSingleAttemptV2AResult());
    final history = LocalAttemptHistoryProvider(repository: repository);
    await history.initialize();
    await _pumpSettings(
      tester,
      language: await _languageProvider(),
      history: history,
    );

    await tester.scrollUntilVisible(
      find.byKey(const ValueKey('clear-analysis-history')),
      300,
    );
    await tester.tap(find.byKey(const ValueKey('clear-analysis-history')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('cancel-clear-history')));
    await tester.pumpAndSettle();

    expect(history.records, hasLength(1));
    expect(storage.writeCount, 1, reason: 'Only the original save may write.');
  });

  testWidgets(
    'confirmed clear removes only History and preserves Profile and language',
    (tester) async {
      final historyRepository = LocalAttemptHistoryRepository(
        storage: SharedPreferencesLocalAttemptHistoryStorage(),
      );
      await historyRepository.save(validSingleAttemptV2AResult());
      final history = LocalAttemptHistoryProvider(
        repository: historyRepository,
      );
      await history.initialize();

      final profileRepository = LocalAthleteProfileRepository(
        storage: SharedPreferencesLocalAthleteProfileStorage(),
      );
      final profile = LocalAthleteProfile.fromInput(
        displayName: 'Local judoka',
        beltRank: 'Brown',
        club: 'Local club',
        country: 'IR',
        biography: 'Local profile must survive.',
      );
      expect((await profileRepository.save(profile)).isSuccess, isTrue);

      final language = LanguageProvider(storage: UserPreferencesStorage());
      await language.initialize();
      expect(await language.changeLanguage(AppLanguage.english), isTrue);

      await _pumpSettings(tester, language: language, history: history);
      await tester.scrollUntilVisible(
        find.byKey(const ValueKey('clear-analysis-history')),
        300,
      );
      await tester.tap(find.byKey(const ValueKey('clear-analysis-history')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('confirm-clear-history')));
      await tester.pumpAndSettle();

      expect(history.records, isEmpty);
      expect(
        (await profileRepository.load()).profile?.toJson(),
        profile.toJson(),
      );
      final recreatedLanguage = LanguageProvider(
        storage: UserPreferencesStorage(),
      );
      await recreatedLanguage.initialize();
      expect(recreatedLanguage.currentLanguage, AppLanguage.english);
      expect(
        find.text('Local validation history was cleared.'),
        findsOneWidget,
      );
    },
  );

  testWidgets('unsupported preferences are not presented as working toggles', (
    tester,
  ) async {
    await _pumpSettings(
      tester,
      language: await _languageProvider(),
      history: await _historyProvider(),
    );

    expect(find.byType(Switch), findsNothing);
    expect(find.byType(SwitchListTile), findsNothing);
    expect(find.text('Notifications'), findsNothing);
    expect(find.text('Cloud backup'), findsNothing);
    expect(find.text('Subscriptions'), findsNothing);
  });

  testWidgets('scientific limitations expose validation-only V2A wording', (
    tester,
  ) async {
    await _pumpSettings(
      tester,
      language: await _languageProvider(),
      history: await _historyProvider(),
    );

    expect(CurrentScientificCapabilities.approvedMetricIds, {
      'UM-TIM-001',
      'UM-ANG-001',
      'UM-ANG-002',
      'UM-ANG-003',
    });
    expect(CurrentScientificCapabilities.reviewRequiredAutoPromotion, isFalse);
    expect(
      CurrentScientificCapabilities.multiPersonEvidenceStatus,
      'insufficient',
    );
    expect(CurrentScientificCapabilities.interactionMetricsReportable, isFalse);
    final scientificDetails = find.byKey(
      const ValueKey('settings-scientific-details-expansion'),
    );
    await tester.scrollUntilVisible(scientificDetails, 300);
    await tester.ensureVisible(scientificDetails);
    await tester.pumpAndSettle();
    await tester.tap(scientificDetails);
    await tester.pumpAndSettle();
    expect(
      find.text(
        'Single-Attempt V2A validation is currently limited to the engineering '
        'metrics UM-ANG-001, UM-ANG-002, UM-ANG-003, UM-TIM-001. These metrics '
        'are not scientifically approved for definitive technique assessment.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'A result requiring review remains pending until it is confirmed by a '
        'qualified human reviewer.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('approved Uchi Mata metrics'), findsNothing);
    expect(find.textContaining('review_required'), findsNothing);
    expect(
      find.byKey(const ValueKey('settings-review-required-boundary')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('settings-multi-person-boundary')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('settings-interaction-boundary')),
      findsOneWidget,
    );
  });

  testWidgets('Persian Settings renders qualified-review wording without enums', (
    tester,
  ) async {
    final language = await _languageProvider();
    expect(await language.changeLanguage(AppLanguage.persian), isTrue);
    await _pumpSettings(
      tester,
      language: language,
      history: await _historyProvider(),
    );
    await tester.pumpAndSettle();

    final scientificDetails = find.byKey(
      const ValueKey('settings-scientific-details-expansion'),
    );
    await tester.scrollUntilVisible(scientificDetails, 300);
    await tester.ensureVisible(scientificDetails);
    await tester.pumpAndSettle();
    await tester.tap(scientificDetails);
    await tester.pumpAndSettle();

    expect(
      find.text(
        'اعتبارسنجی V2A تک‌تلاش در حال حاضر فقط به معیارهای مهندسی '
        'UM-ANG-001, UM-ANG-002, UM-ANG-003, UM-TIM-001 محدود است. این معیارها '
        'برای ارزیابی قطعی تکنیک، تأیید علمی نشده‌اند.',
      ),
      findsOneWidget,
    );
    expect(
      find.text(
        'نتیجه‌ای که نیازمند بازبینی است، تا زمان تأیید بازبین انسانی واجد '
        'صلاحیت در وضعیت انتظار باقی می‌ماند.',
      ),
      findsOneWidget,
    );
    expect(find.textContaining('شاخص‌های تأییدشده اوچی‌ماتا'), findsNothing);
    expect(find.textContaining('review_required'), findsNothing);
  });

  test('Settings routes stay real and the registry remains exactly 18', () {
    final settings = JudoMindModules.modules.singleWhere(
      (module) => module.id == 'app-management-settings',
    );
    expect(settings.route, AppRoutes.settings);
    expect(settings.isReachable, isTrue);
    expect(AppRoutes.routes[AppRoutes.settings], isNotNull);
    expect(JudoMindModules.modules, hasLength(18));
    expect(
      JudoMindModules.modules.map((module) => module.id).toSet(),
      hasLength(18),
    );
  });
}

Future<LanguageProvider> _languageProvider() async {
  final provider = LanguageProvider(storage: UserPreferencesStorage());
  await provider.initialize();
  return provider;
}

Future<LocalAttemptHistoryProvider> _historyProvider() async {
  final provider = LocalAttemptHistoryProvider(
    repository: LocalAttemptHistoryRepository(storage: _MemoryHistoryStorage()),
  );
  await provider.initialize();
  return provider;
}

Future<void> _pumpSettings(
  WidgetTester tester, {
  required LanguageProvider language,
  required LocalAttemptHistoryProvider history,
}) {
  return tester.pumpWidget(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: language),
        ChangeNotifierProvider.value(value: history),
      ],
      child: Consumer<LanguageProvider>(
        builder: (context, provider, child) => MaterialApp(
          locale: Locale(provider.languageCode),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const SettingsScreen(),
        ),
      ),
    ),
  );
}

class _MemoryHistoryStorage implements LocalAttemptHistoryStorage {
  String? payload;
  int writeCount = 0;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    writeCount += 1;
    payload = value;
    return true;
  }
}
