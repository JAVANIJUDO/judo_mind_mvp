import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/data/ai/local_grounded_sensei_service.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/grounded_sensei.dart';
import 'package:judo_mind/screens/technique_detail/widgets/analyze/grounded_sensei_explanation_card.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  testWidgets('English explanation is collapsed then exposes four findings', (
    tester,
  ) async {
    final explanation = await _explanation('en');
    await _pumpCard(tester, explanation, const Locale('en'));

    expect(find.text('Grounded Sensei'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('grounded-sensei-finding-UM-TIM-001')),
      findsNothing,
    );

    await tester.tap(find.byKey(const ValueKey('grounded-sensei-expansion')));
    await tester.pumpAndSettle();

    for (final id in GroundedSenseiRequest.supportedMetricIds) {
      expect(
        find.byKey(ValueKey('grounded-sensei-finding-$id')),
        findsOneWidget,
      );
    }
    expect(find.textContaining('18.4 degrees'), findsOneWidget);
    expect(
      find.textContaining('No replacement estimate is generated'),
      findsOneWidget,
    );
    expect(find.textContaining('78%'), findsNothing);
    expect(find.textContaining('performance rating'), findsOneWidget);
  });

  testWidgets('Persian explanation and safety do not fall back to English', (
    tester,
  ) async {
    final explanation = await _explanation('fa');
    await _pumpCard(tester, explanation, const Locale('fa'));
    await tester.tap(find.byKey(const ValueKey('grounded-sensei-expansion')));
    await tester.pumpAndSettle();

    expect(find.text('سنسِی مبتنی بر شواهد'), findsOneWidget);
    expect(
      find.textContaining('۱۸.۴'),
      findsNothing,
      reason:
          'Dart preserves the original numeric value without relabeling it.',
    );
    expect(find.textContaining('18.4 درجه'), findsOneWidget);
    expect(
      find.text(uchiMata.getTranslation('fa')!.safetyTips.first),
      findsOneWidget,
    );
    expect(find.text(uchiMata.safetyTips.first), findsNothing);
    expect(find.text('Why it matters'), findsNothing);
    expect(find.text('Next action'), findsNothing);
  });

  testWidgets('locale mismatch fails closed', (tester) async {
    final explanation = await _explanation('en');
    await _pumpCard(tester, explanation, const Locale('fa'));

    expect(
      find.byKey(const ValueKey('grounded-sensei-unavailable')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('grounded-sensei-expansion')),
      findsNothing,
    );
  });
}

Future<GroundedSenseiExplanation> _explanation(String locale) {
  final request = validSingleAttemptV2ARequest();
  return const LocalGroundedSenseiService().explain(
    GroundedSenseiRequest(
      technique: uchiMata,
      reviewedRequest: request,
      reviewedResult: validSingleAttemptV2AResultForRequest(request),
      locale: locale,
    ),
  );
}

Future<void> _pumpCard(
  WidgetTester tester,
  GroundedSenseiExplanation explanation,
  Locale locale,
) async {
  await tester.binding.setSurfaceSize(const Size(900, 2200));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SingleChildScrollView(
          child: GroundedSenseiExplanationCard(explanation: explanation),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
