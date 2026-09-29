import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:judo_mind/core/language/language_provider.dart';
import 'package:judo_mind/core/scientific_transparency/scientific_transparency_model.dart';
import 'package:judo_mind/core/scientific_transparency/uchi_mata_scientific_transparency.dart';
import 'package:judo_mind/data/storage/user_preferences_storage.dart';
import 'package:judo_mind/data/techniques/seoi_nage.dart';
import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/screens/techniques/widgets/technique_card.dart';

const _csvPath =
    'docs/scientific_foundation/JM_NON_UCHI_MATA_TECHNIQUE_UNLOCK_READINESS.csv';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('readiness artifact has 66 unique non-Uchi audit rows', () {
    final table = _readAuditTable();

    expect(table, hasLength(66));
    final techniqueIds = table.map((row) => row['technique_id']!).toList();
    expect(techniqueIds.toSet(), hasLength(66));
    expect(techniqueIds, isNot(contains('001')));
    expect(table.where((row) => row['technique_id'] == '002'), hasLength(1));
    expect(table.where((row) => row['technique_id'] == '005'), hasLength(1));
    expect(
      table.where(
        (row) =>
            row['identity_state'] ==
            'NORMALIZED_PENDING_HUMAN_CONFIRMATION',
      ),
      hasLength(62),
    );
    expect(
      table.where(
        (row) =>
            row['route_state'] ==
            'GENERIC_FOUNDATION_IDENTITY_REVIEW_AND_MODEL_BLOCKED',
      ),
      hasLength(62),
    );
    expect(
      table.where(
        (row) =>
            row['route_state'] ==
            'GENERIC_FOUNDATION_AVAILABLE_PRODUCT_GATE_LOCKED',
      ),
      hasLength(4),
    );
  });

  test('audit classifications and capability expectations fail closed', () {
    final table = _readAuditTable();
    const allowedStates = <String>{
      'READ_ONLY_EDUCATIONAL_READY',
      'READ_ONLY_PARTIAL_CONTENT',
      'CONTENT_REMEDIATION_REQUIRED',
      'ROUTE_OR_MODEL_BLOCKED',
      'DUPLICATE_OR_IDENTITY_CONFLICT',
    };

    for (final row in table) {
      expect(allowedStates, contains(row['read_only_unlock_state']));
      expect(row['scientific_card_expected'], 'NO');
      expect(row['analysis_expected'], 'NO');
    }

    expect(
      table.where(
        (row) => row['read_only_unlock_state'] == 'READ_ONLY_EDUCATIONAL_READY',
      ),
      isEmpty,
      reason: 'The audit must not silently make a technique openable.',
    );
    expect(
      table.where(
        (row) => row['read_only_unlock_state'] == 'READ_ONLY_PARTIAL_CONTENT',
      ),
      isEmpty,
    );
  });

  test('runtime registry stays unique and exposes only Uchi Mata', () {
    final techniques = TechniqueFactory.allTechniques;
    final ids = techniques.map((technique) => technique.id).toList();

    expect(ids, hasLength(5));
    expect(ids.toSet(), hasLength(5));
    expect(TechniqueFactory.officialRoadmapTechniqueCount, 67);
    expect(TechniqueFactory.productionTechniqueIds, const <String>{'001'});
    expect(TechniqueFactory.readOnlyEducationalTechniqueIds, isEmpty);
    expect(TechniqueFactory.productionTechniques.single.id, '001');
    expect(TechniqueFactory.navigableTechniques.single.id, '001');

    for (final technique in TechniqueFactory.previewTechniques) {
      expect(technique.id, isNot('001'));
      expect(technique.supportsReviewedSingleAttemptV2A, isFalse);
      expect(
        UchiMataScientificTransparency.forTechnique(technique.id),
        same(ScientificTransparencySnapshot.failClosed),
      );
    }
  });

  test('unknown and malformed catalog identities fail closed', () {
    for (final id in <String>['', ' ', '001-extra', 'uchi-mata', '999']) {
      final snapshot = UchiMataScientificTransparency.forTechnique(id);
      expect(snapshot, same(ScientificTransparencySnapshot.failClosed));
      expect(snapshot.scientificApprovalIssued, isFalse);
      expect(snapshot.candidateSources, isEmpty);
    }
  });

  testWidgets('existing preview renders safely in English', (tester) async {
    final language = await _languageProvider('en');
    await tester.pumpWidget(
      _previewApp(language: language, locale: const Locale('en')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seoi Nage'), findsOneWidget);
    expect(find.byKey(const ValueKey('technique-preview-002')), findsOneWidget);
    expect(find.textContaining('Scientific status'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('existing preview renders safely in Persian RTL', (tester) async {
    final language = await _languageProvider('fa');
    await tester.pumpWidget(
      _previewApp(language: language, locale: const Locale('fa')),
    );
    await tester.pumpAndSettle();

    final preview = find.byKey(const ValueKey('technique-preview-002'));
    expect(find.text('سئوی ناگه'), findsOneWidget);
    expect(preview, findsOneWidget);
    expect(Directionality.of(tester.element(preview)), TextDirection.rtl);
    expect(tester.takeException(), isNull);
  });
}

List<Map<String, String>> _readAuditTable() {
  final lines = File(_csvPath)
      .readAsLinesSync()
      .where((line) => line.trim().isNotEmpty)
      .toList(growable: false);
  expect(lines, isNotEmpty);
  final header = lines.first.split(',');
  expect(header, hasLength(16));

  return lines
      .skip(1)
      .map((line) {
        final values = line.split(',');
        expect(values, hasLength(header.length), reason: line);
        return <String, String>{
          for (var index = 0; index < header.length; index++)
            header[index]: values[index],
        };
      })
      .toList(growable: false);
}

Future<LanguageProvider> _languageProvider(String languageCode) async {
  SharedPreferences.setMockInitialValues(<String, Object>{
    UserPreferencesStorage.languagePreferenceKey: languageCode,
  });
  final provider = LanguageProvider();
  await provider.initialize();
  return provider;
}

Widget _previewApp({
  required LanguageProvider language,
  required Locale locale,
}) {
  return ChangeNotifierProvider<LanguageProvider>.value(
    value: language,
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: const Scaffold(
        body: TechniqueCard(technique: seoiNage, isPreview: true),
      ),
    ),
  );
}
