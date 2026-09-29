import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/l10n/app_localizations.dart';

void main() {
  test('generated localization contract includes English and Persian', () {
    final languageCodes = AppLocalizations.supportedLocales
        .map((locale) => locale.languageCode)
        .toSet();

    expect(languageCodes, containsAll(<String>['en', 'fa']));
  });

  for (final locale in const [Locale('en'), Locale('fa')]) {
    testWidgets('${locale.languageCode} supplies the expected text direction', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          locale: locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: Text('direction-probe')),
        ),
      );
      await tester.pumpAndSettle();

      final directionality = tester.widget<Directionality>(
        find
            .ancestor(
              of: find.text('direction-probe'),
              matching: find.byType(Directionality),
            )
            .first,
      );
      expect(
        directionality.textDirection,
        locale.languageCode == 'fa' ? TextDirection.rtl : TextDirection.ltr,
      );
    });
  }
}
