import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:judo_mind/core/dependency_injection/injection_container.dart';
import 'package:judo_mind/core/language/language_provider.dart';
import 'package:judo_mind/core/providers/favorite_provider.dart';
import 'package:judo_mind/core/providers/technique_provider.dart';
import 'package:judo_mind/core/scientific_transparency/scientific_transparency_model.dart';
import 'package:judo_mind/core/scientific_transparency/uchi_mata_scientific_transparency.dart';
import 'package:judo_mind/data/storage/user_preferences_storage.dart';
import 'package:judo_mind/data/techniques/o_soto_gari.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/screens/technique_detail/technique_detail_screen.dart';
import 'package:judo_mind/screens/technique_detail/widgets/scientific_transparency/scientific_transparency_panel.dart';
import 'package:judo_mind/screens/techniques/techniques_screen.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    await setupDependencies();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  tearDownAll(() async {
    await sl.reset(dispose: true);
  });

  test('Uchi Mata governed display remains read-only and unapproved', () {
    expect(uchiMata.id, '001');
    final snapshot = UchiMataScientificTransparency.forTechnique(uchiMata.id);

    expect(snapshot.schemaVersion, '1.0.0');
    expect(
      snapshot.scientificStatus,
      ScientificTransparencyStatus.humanReviewPending,
    );
    expect(snapshot.scientificApprovalIssued, isFalse);
    expect(snapshot.candidateSources, hasLength(5));
    expect(snapshot.capabilities, hasLength(9));
    expect(
      snapshot.capabilities.every(
        (item) => item.state != ScientificTransparencyStatus.notApplicable,
      ),
      isTrue,
    );
  });

  test('unknown technique data fails closed', () {
    final snapshot = UchiMataScientificTransparency.forTechnique('unknown');

    expect(snapshot, same(ScientificTransparencySnapshot.failClosed));
    expect(snapshot.scientificStatus, ScientificTransparencyStatus.locked);
    expect(
      snapshot.humanReviewState,
      ScientificTransparencyStatus.notScientificallyReviewed,
    );
    expect(snapshot.scientificApprovalIssued, isFalse);
    expect(snapshot.candidateSources, isEmpty);
    expect(snapshot.capabilities, isEmpty);
    expect(
      UchiMataScientificTransparency.forTechnique('uchi-mata'),
      same(ScientificTransparencySnapshot.failClosed),
      reason: 'The API identifier is not the Flutter catalog identity.',
    );
  });

  testWidgets(
    'production Techniques route renders transparency for actual Uchi Mata',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 1200));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(_productionTestApp(const TechniquesScreen()));
      await tester.pumpAndSettle();

      expect(uchiMata.id, UchiMataScientificTransparency.techniqueId);
      await tester.tap(find.text('Uchi Mata').first);
      await tester.pumpAndSettle();

      expect(find.byType(TechniqueDetailScreen), findsOneWidget);
      expect(
        find.byKey(const ValueKey<String>('scientific-status-card')),
        findsOneWidget,
      );

      final detailsAction = find.byKey(
        const ValueKey<String>('scientific-transparency-view-details'),
      );
      await tester.ensureVisible(detailsAction);
      await tester.tap(detailsAction);
      await tester.pumpAndSettle();

      expect(find.text('Candidate source'), findsNWidgets(5));
      expect(find.text('Review pending'), findsNWidgets(5));
      expect(
        find.byKey(
          const ValueKey<String>('scientific-transparency-capability-panel'),
        ),
        findsOneWidget,
      );
      expect(find.text('Validation only'), findsWidgets);
      expect(find.text('Locked'), findsWidgets);
    },
  );

  testWidgets(
    'unrelated production-like detail receives no Uchi Mata evidence',
    (tester) async {
      await tester.pumpWidget(
        _productionTestApp(const TechniqueDetailScreen(technique: oSotoGari)),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('scientific-status-card')),
        findsNothing,
      );
      final failClosed = UchiMataScientificTransparency.forTechnique(
        oSotoGari.id,
      );
      expect(failClosed.candidateSources, isEmpty);
      expect(failClosed.scientificStatus, ScientificTransparencyStatus.locked);
    },
  );

  testWidgets('Uchi Mata scientific status card renders English boundaries', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const ScientificStatusCard(
          snapshot: UchiMataScientificTransparency.snapshot,
        ),
      ),
    );

    expect(
      find.byKey(const ValueKey<String>('scientific-status-card')),
      findsOneWidget,
    );
    expect(find.text('Scientific status'), findsOneWidget);
    expect(find.text('Human review pending'), findsOneWidget);
    expect(find.text('No scientific approval has been issued'), findsOneWidget);
    expect(find.text('Video analysis: validation only'), findsOneWidget);
    expect(find.text('Sensitive capabilities: locked'), findsOneWidget);
    expect(find.text('View sources and limitations'), findsOneWidget);
    expect(find.text('Approved'), findsNothing);
  });

  testWidgets('Persian card is complete and inherits RTL direction', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const ScientificStatusCard(
          snapshot: UchiMataScientificTransparency.snapshot,
        ),
        locale: const Locale('fa'),
      ),
    );

    final card = find.byKey(const ValueKey<String>('scientific-status-card'));
    expect(card, findsOneWidget);
    expect(Directionality.of(tester.element(card)), TextDirection.rtl);
    expect(find.text('وضعیت علمی'), findsOneWidget);
    expect(find.text('بازبینی انسانی در انتظار است'), findsOneWidget);
    expect(find.text('هنوز تأیید علمی صادر نشده است'), findsOneWidget);
    expect(find.text('تحلیل ویدئو: فقط در مرحله اعتبارسنجی'), findsOneWidget);
    expect(find.text('قابلیت‌های حساس: قفل هستند'), findsOneWidget);
    expect(find.text('مشاهده منابع و محدودیت‌ها'), findsOneWidget);
  });

  testWidgets('details navigation exposes candidate and limitation states', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(
        const ScientificStatusCard(
          snapshot: UchiMataScientificTransparency.snapshot,
        ),
      ),
    );

    await tester.tap(
      find.byKey(
        const ValueKey<String>('scientific-transparency-view-details'),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey<String>('scientific-transparency-details')),
      findsOneWidget,
    );
    expect(find.text('Candidate source'), findsNWidgets(5));
    expect(find.text('Review pending'), findsNWidgets(5));
    expect(
      find.text('Not yet approved for a Judo Mind claim'),
      findsNWidgets(5),
    );
    expect(
      find.byKey(
        const ValueKey<String>('scientific-transparency-capability-panel'),
      ),
      findsOneWidget,
    );
    expect(find.byType(Switch), findsNothing);
    expect(find.textContaining('Enable'), findsNothing);

    for (final limitation in const [
      'Pose estimation provides engineering observations only.',
      'It does not directly measure force or kinetics.',
      'It is not validated as definitive 3D biomechanical analysis.',
      'It does not diagnose technical errors or injury.',
      'It does not predict injury.',
      'It does not make referee decisions.',
      'A statistical association must not be presented as causation.',
      'A risk indicator must not be presented as a certain prediction.',
      'Missing evidence or approval keeps sensitive features locked.',
    ]) {
      expect(find.text(limitation), findsOneWidget, reason: limitation);
    }
  });

  testWidgets('missing display data renders locked and not reviewed', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const ScientificStatusCard(snapshot: null)),
    );

    expect(find.text('Not scientifically reviewed'), findsOneWidget);
    expect(find.text('Sensitive capabilities: locked'), findsOneWidget);
    expect(find.text('Approved'), findsNothing);

    await tester.tap(
      find.byKey(
        const ValueKey<String>('scientific-transparency-view-details'),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(
        const ValueKey<String>('scientific-transparency-sources-locked'),
      ),
      findsOneWidget,
    );
    expect(
      find.byKey(
        const ValueKey<String>('scientific-transparency-capabilities-locked'),
      ),
      findsOneWidget,
    );
  });

  testWidgets('card supports narrow layout and large text without overflow', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      _testApp(
        const ScientificStatusCard(
          snapshot: UchiMataScientificTransparency.snapshot,
        ),
        textScaler: const TextScaler.linear(2),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const ValueKey<String>('scientific-status-card')),
      findsOneWidget,
    );
  });
}

Widget _productionTestApp(Widget home) {
  final storage = UserPreferencesStorage();
  return MultiProvider(
    providers: [
      ChangeNotifierProvider<LanguageProvider>(
        create: (_) => LanguageProvider(storage: storage),
      ),
      ChangeNotifierProvider<FavoriteProvider>(
        create: (_) => FavoriteProvider(storage: storage),
      ),
      ChangeNotifierProvider<TechniqueProvider>(
        create: (_) => TechniqueProvider(),
      ),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

Widget _testApp(
  Widget body, {
  Locale locale = const Locale('en'),
  TextScaler textScaler = TextScaler.noScaling,
}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: body,
        ),
      ),
    ),
  );
}
