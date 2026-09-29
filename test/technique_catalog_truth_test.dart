import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/language/language_provider.dart';
import 'package:judo_mind/data/techniques/o_soto_gari.dart';
import 'package:judo_mind/data/techniques/uchi_mata.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/screens/techniques/widgets/technique_card.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('production card shows approved two-level Uchi Mata taxonomy', (
    tester,
  ) async {
    await tester.pumpWidget(_testApp(const TechniqueCard(technique: uchiMata)));

    expect(find.text('Nage-waza • Ashi-waza'), findsOneWidget);
    expect(find.byKey(const ValueKey('technique-preview-001')), findsNothing);
  });

  testWidgets('preview card hides unsupported secondary taxonomy and closes', (
    tester,
  ) async {
    await tester.pumpWidget(
      _testApp(const TechniqueCard(technique: oSotoGari, isPreview: true)),
    );

    expect(find.text('Ashi-waza'), findsOneWidget);
    expect(find.textContaining('Koshi-waza'), findsNothing);
    expect(find.byKey(const ValueKey('technique-preview-003')), findsOneWidget);
    expect(find.textContaining('Preview only'), findsOneWidget);
  });
}

Widget _testApp(Widget child) {
  return ChangeNotifierProvider<LanguageProvider>(
    create: (_) => LanguageProvider(),
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}
