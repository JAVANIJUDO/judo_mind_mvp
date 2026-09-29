import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/technique_model.dart';
import 'package:judo_mind/models/technique_translation.dart';
import 'package:judo_mind/screens/technique_detail/generic_technique_detail_adapter.dart';
import 'package:judo_mind/screens/technique_detail/generic_technique_detail_screen.dart';
import 'package:judo_mind/screens/technique_detail/technique_detail_route_destination.dart';
import 'package:judo_mind/screens/technique_detail/technique_detail_route_policy.dart';

void main() {
  test(
    'roadmap and runtime identities remain unique without inventing records',
    () {
      final runtimeIds = TechniqueFactory.allTechniques
          .map((technique) => technique.id)
          .toList(growable: false);

      expect(TechniqueFactory.officialRoadmapTechniqueCount, 67);
      expect(runtimeIds, hasLength(5));
      expect(runtimeIds.toSet(), hasLength(runtimeIds.length));
      expect(TechniqueFactory.readOnlyEducationalTechniqueIds, isEmpty);
      expect(TechniqueFactory.navigableTechniques, const [uchiMata]);
    },
  );

  test(
    '001 keeps specialized route and current non-001 records stay locked',
    () {
      final uchiRoute = TechniqueDetailRoutePolicy.resolve('001');
      expect(uchiRoute.kind, TechniqueDetailRouteKind.specializedUchiMata);
      expect(uchiRoute.technique, same(uchiMata));

      for (final id in const ['002', '003', '004', '005']) {
        final route = TechniqueDetailRoutePolicy.resolve(id);
        expect(route.kind, TechniqueDetailRouteKind.locked, reason: id);
        expect(
          route.blockReason,
          id == '003'
              ? TechniqueDetailRouteBlockReason.identityConflict
              : TechniqueDetailRouteBlockReason.notReadOnlyEligible,
          reason: id,
        );
      }
    },
  );

  test(
    'only explicitly eligible valid non-001 identity uses generic route',
    () {
      final route = TechniqueDetailRoutePolicy.resolve(
        '006',
        catalog: const [_genericFixture],
        readOnlyEducationalIds: const {'006'},
      );

      expect(route.kind, TechniqueDetailRouteKind.genericReadOnly);
      expect(route.technique, same(_genericFixture));
      expect(route.isOpenable, isTrue);
    },
  );

  test(
    'malformed unknown duplicate and non-eligible identities fail closed',
    () {
      for (final id in const ['', ' ', '6', '0006', '006 ', 'uchi-mata']) {
        final route = TechniqueDetailRoutePolicy.resolve(
          id,
          catalog: const [_genericFixture],
          readOnlyEducationalIds: const {'006'},
        );
        expect(route.kind, TechniqueDetailRouteKind.locked, reason: id);
        expect(
          route.blockReason,
          TechniqueDetailRouteBlockReason.malformedId,
          reason: id,
        );
      }

      expect(
        TechniqueDetailRoutePolicy.resolve(
          '999',
          catalog: const [_genericFixture],
          readOnlyEducationalIds: const {'999'},
        ).blockReason,
        TechniqueDetailRouteBlockReason.unknownId,
      );
      expect(
        TechniqueDetailRoutePolicy.resolve(
          '006',
          catalog: const [_genericFixture, _genericFixture],
          readOnlyEducationalIds: const {'006'},
        ).blockReason,
        TechniqueDetailRouteBlockReason.duplicateId,
      );
      expect(
        TechniqueDetailRoutePolicy.resolve(
          '006',
          catalog: const [_genericFixture],
        ).blockReason,
        TechniqueDetailRouteBlockReason.notReadOnlyEligible,
      );
    },
  );

  test(
    'strict adapter does not silently fill missing Persian list content',
    () {
      final content = GenericTechniqueDetailAdapter.fromTechnique(
        _genericFixture,
        languageCode: 'fa-IR',
      );

      expect(content.name, 'تکنیک نمونه');
      expect(content.description, 'شرح آموزشی فارسی.');
      expect(content.executionSteps, const ['گام فارسی']);
      expect(content.keyPoints, isEmpty);
      expect(content.commonMistakes, isEmpty);
      expect(content.safetyTips, isEmpty);
      expect(content.combinations, isEmpty);
      expect(content.counters, isEmpty);
    },
  );

  testWidgets(
    'generic English detail renders present fields and no capability',
    (tester) async {
      await tester.pumpWidget(
        _localizedApp(
          const GenericTechniqueDetailScreen(technique: _genericFixture),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey<String>('generic-technique-detail-screen')),
        findsOneWidget,
      );
      expect(find.text('Neutral Fixture Technique'), findsWidgets);
      expect(find.text('Existing educational description.'), findsOneWidget);
      expect(find.text('Existing execution step.'), findsOneWidget);
      _expectNoScientificOrAnalysisSurface();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'generic Persian detail is RTL and missing fields are unavailable',
    (tester) async {
      final persian = await AppLocalizations.delegate.load(const Locale('fa'));
      await tester.pumpWidget(
        _localizedApp(
          const GenericTechniqueDetailScreen(technique: _genericFixture),
          locale: const Locale('fa'),
        ),
      );
      await tester.pumpAndSettle();

      final screen = find.byKey(
        const ValueKey<String>('generic-technique-detail-screen'),
      );
      expect(screen, findsOneWidget);
      expect(Directionality.of(tester.element(screen)), TextDirection.rtl);
      expect(find.text('تکنیک نمونه'), findsWidgets);
      expect(find.text('شرح آموزشی فارسی.'), findsOneWidget);
      expect(
        find.text(persian.approvedContentUnavailable, skipOffstage: false),
        findsWidgets,
      );
      _expectNoScientificOrAnalysisSurface();
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'resolved generic destination supports push and back navigation',
    (tester) async {
      final decision = TechniqueDetailRoutePolicy.resolve(
        '006',
        catalog: const [_genericFixture],
        readOnlyEducationalIds: const {'006'},
      );

      await tester.pumpWidget(_localizedApp(_RouteHarness(decision: decision)));
      await tester.tap(
        find.byKey(const ValueKey<String>('open-generic-route')),
      );
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('generic-technique-detail-screen')),
        findsOneWidget,
      );

      await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
      await tester.pumpAndSettle();
      expect(
        find.byKey(const ValueKey<String>('route-harness')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('locked destination remains unavailable and cannot leak detail', (
    tester,
  ) async {
    final decision = TechniqueDetailRoutePolicy.resolve(
      '006',
      catalog: const [_genericFixture],
    );
    await tester.pumpWidget(
      _localizedApp(TechniqueDetailRouteDestination(decision: decision)),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(
        const ValueKey<String>('technique-detail-locked-notReadOnlyEligible'),
      ),
      findsOneWidget,
    );
    expect(find.text('Existing educational description.'), findsNothing);
    _expectNoScientificOrAnalysisSurface();
  });
}

void _expectNoScientificOrAnalysisSurface() {
  expect(
    find.byKey(const ValueKey<String>('scientific-status-card')),
    findsNothing,
  );
  expect(
    find.byKey(const ValueKey<String>('technique-analyze-action')),
    findsNothing,
  );
  expect(find.textContaining('Candidate source'), findsNothing);
  expect(find.textContaining('Uchi Mata'), findsNothing);
  expect(find.textContaining('force'), findsNothing);
  expect(find.textContaining('torque'), findsNothing);
  expect(find.textContaining('score'), findsNothing);
}

Widget _localizedApp(Widget home, {Locale locale = const Locale('en')}) {
  return MaterialApp(
    locale: locale,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: home,
  );
}

class _RouteHarness extends StatelessWidget {
  const _RouteHarness({required this.decision});

  final TechniqueDetailRouteDecision decision;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey<String>('route-harness'),
      body: Center(
        child: FilledButton(
          key: const ValueKey<String>('open-generic-route'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) =>
                  TechniqueDetailRouteDestination(decision: decision),
            ),
          ),
          child: const Text('Open'),
        ),
      ),
    );
  }
}

const TechniqueModel _genericFixture = TechniqueModel(
  id: '006',
  englishName: 'Neutral Fixture Technique',
  japaneseName: '試',
  category: 'Nage Waza',
  type: 'Te Waza',
  beltLevel: 'Intermediate',
  difficulty: 'Intermediate',
  description: 'Existing educational description.',
  technicalAnalysis: 'Existing educational technical explanation.',
  translations: [
    TechniqueTranslation(
      languageCode: 'fa',
      name: 'تکنیک نمونه',
      description: 'شرح آموزشی فارسی.',
      technicalAnalysis: 'توضیح فنی فارسی.',
      executionSteps: ['گام فارسی'],
    ),
  ],
  images: [],
  videos: [],
  trainingVideo: '',
  competitionVideo: '',
  executionSteps: ['Existing execution step.'],
  keyPoints: ['Existing key point.'],
  commonMistakes: [],
  safetyTips: [],
  combinations: [],
  counters: [],
  quiz: [],
  sources: [],
);
