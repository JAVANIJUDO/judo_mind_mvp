import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/providers/local_exercise_library_provider.dart';
import 'package:judo_mind/data/files/exercise_csv_file_selector.dart';
import 'package:judo_mind/data/import/exercise_library_csv_importer.dart';
import 'package:judo_mind/data/repositories/local_exercise_library_repository.dart';
import 'package:judo_mind/data/storage/local_exercise_library_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/training_activity_contract.dart';
import 'package:judo_mind/screens/club/exercise_library_screen.dart';
import 'package:provider/provider.dart';

void main() {
  final importer = ExerciseLibraryCsvImporter(
    clock: () => DateTime.utc(2026, 8, 24, 12),
  );

  test('UTF-8 Persian row creates only a coach-authored unreviewed record', () {
    final preview = importer.parseBytes(
      Uint8List.fromList(
        utf8.encode(
          _csv([
            _row(id: 'fa-1', locale: 'fa', nameEn: '', nameFa: 'تمرین کش'),
          ]),
        ),
      ),
    );
    expect(preview.totalRows, 1);
    expect(preview.validRows, 1);
    final entry = preview.validEntries.single;
    expect(entry.nameEn, isNull);
    expect(entry.resolve('en'), isNull);
    expect(entry.resolve('fa')!.name, 'تمرین کش');
    expect(entry.source, ExerciseLibrarySource.coachAuthored);
    expect(entry.reviewStatus, ExerciseReviewStatus.notScientificallyReviewed);
    expect(entry.reviewedBy, isNull);
    expect(entry.reviewedAtUtc, isNull);
  });

  test('schema, enum, duplicate, URL and media rules fail closed per row', () {
    final preview = importer.parseText(
      _csv([
        _row(id: 'duplicate'),
        _row(id: 'duplicate'),
        _row(id: 'stored'),
        _row(id: 'bad-schema').replaceFirst('1.0.0', '2.0.0'),
        _row(id: 'bad-category').replaceFirst('warmUp', 'unknown'),
        _row(id: 'bad-url', sourceUrl: 'https://example.test/search?q=x'),
        _row(
          id: 'bad-media',
          mediaReference: 'video.mp4',
          mediaLicense: 'review_required',
        ),
      ]),
      existingExerciseIds: const {'stored'},
    );
    expect(preview.validRows, 0);
    expect(preview.duplicateRows, 3);
    final codes = preview.rows
        .expand((row) => row.issues)
        .map((issue) => issue.code)
        .toSet();
    expect(codes, contains(ExerciseCsvIssueCode.unsupportedSchema));
    expect(codes, contains(ExerciseCsvIssueCode.invalidActivityCategory));
    expect(codes, contains(ExerciseCsvIssueCode.invalidSourceUrl));
    expect(codes, contains(ExerciseCsvIssueCode.mediaLicenseRequired));
  });

  test('quoted commas, escaped quotes and multiline fields are preserved', () {
    final row = _row(id: 'quoted', descriptionEn: 'First, second\n"third"');
    final preview = importer.parseText(_csv([row]));
    expect(preview.validRows, 1);
    expect(preview.validEntries.single.descriptionEn, 'First, second\n"third"');
  });

  test(
    'preview performs no write and confirmed valid rows persist atomically',
    () async {
      final storage = _CountingStorage();
      final provider = LocalExerciseLibraryProvider(
        repository: LocalExerciseLibraryRepository(storage: storage),
        usageStorage: _UsageStorage(),
      );
      expect(await provider.initialize(), isTrue);
      final preview = importer.parseText(
        _csv([
          _row(id: 'valid-1'),
          _row(id: 'invalid-1', locale: 'fa', nameFa: ''),
        ]),
      );
      expect(storage.writeCount, 0, reason: 'Preview/cancel must not persist.');
      expect(preview.validRows, 1);
      expect(preview.invalidRows, 1);
      expect(
        await provider.importCoachAuthoredEntries(preview.validEntries),
        isTrue,
      );
      expect(storage.writeCount, 1);
      expect(provider.snapshot.entries.single.id, 'valid-1');

      final recovered = LocalExerciseLibraryProvider(
        repository: LocalExerciseLibraryRepository(storage: storage),
      );
      expect(await recovered.initialize(), isTrue);
      expect(recovered.snapshot.entries.single.id, 'valid-1');
    },
  );

  test(
    'favorites and deterministic recents survive provider recovery',
    () async {
      final storage = _CountingStorage();
      final usage = _UsageStorage();
      final provider = LocalExerciseLibraryProvider(
        repository: LocalExerciseLibraryRepository(storage: storage),
        usageStorage: usage,
      );
      await provider.initialize();
      final preview = importer.parseText(
        _csv([_row(id: 'one'), _row(id: 'two')]),
      );
      await provider.importCoachAuthoredEntries(preview.validEntries);
      expect(await provider.toggleFavorite('one'), isTrue);
      expect(await provider.recordSelection('one'), isTrue);
      expect(await provider.recordSelection('two'), isTrue);
      expect(await provider.recordSelection('one'), isTrue);
      expect(provider.recentEntries.map((entry) => entry.id), ['one', 'two']);

      final recovered = LocalExerciseLibraryProvider(
        repository: LocalExerciseLibraryRepository(storage: storage),
        usageStorage: usage,
      );
      await recovered.initialize();
      expect(recovered.favoriteEntries.single.id, 'one');
      expect(recovered.recentEntries.map((entry) => entry.id), ['one', 'two']);
    },
  );

  test(
    'manual coach authoring requires only the declared app-language name',
    () async {
      final storage = _CountingStorage();
      final provider = LocalExerciseLibraryProvider(
        repository: LocalExerciseLibraryRepository(storage: storage),
        idFactory: (_) => 'single-language',
        clock: () => DateTime.utc(2026, 8, 24),
      );
      await provider.initialize();
      expect(
        await provider.createCoachAuthored(
          const CoachAuthoredExerciseInput(
            authoringLocale: ExerciseAuthoringLocale.fa,
            nameFa: 'تمرین محلی',
            activityCategory: TrainingSessionItemType.warmUp,
            modality: ExerciseModality.bodyweight,
            supportedDosageModes: [TrainingDosageMode.duration],
          ),
        ),
        isTrue,
      );
      expect(provider.snapshot.entries.single.nameEn, isNull);
      expect(provider.snapshot.entries.single.resolve('en'), isNull);
    },
  );

  test(
    'search normalizes Persian separators and Arabic keyboard variants',
    () async {
      final storage = _CountingStorage();
      final provider = LocalExerciseLibraryProvider(
        repository: LocalExerciseLibraryRepository(storage: storage),
      );
      await provider.initialize();
      final preview = importer.parseText(
        _csv([
          _row(
            id: 'uchikomi-fa',
            locale: 'fa',
            nameEn: '',
            nameFa: 'تمرین آزمایشی اوچی‌کومی',
          ),
          _row(
            id: 'body-fa',
            locale: 'fa',
            nameEn: '',
            nameFa: 'حرکت آزمایشی با وزن بدن',
          ),
          _row(
            id: 'variant-fa',
            locale: 'fa',
            nameEn: '',
            nameFa: 'تمرین كيفي',
          ),
          _row(id: 'english', nameEn: 'Upper Body Pull'),
        ]),
      );
      expect(
        await provider.importCoachAuthoredEntries(preview.validEntries),
        isTrue,
      );

      Iterable<String> ids(String query, String language) => provider
          .query(ExerciseLibraryQuery(search: query), languageCode: language)
          .map((entry) => entry.id);

      expect(ids('اوچی کومی', 'fa'), contains('uchikomi-fa'));
      expect(ids('اوچی   کومی', 'fa'), contains('uchikomi-fa'));
      expect(ids('اوچی‌کومی', 'fa'), contains('uchikomi-fa'));
      expect(ids('بدن', 'fa'), contains('body-fa'));
      expect(ids('کیفی', 'fa'), contains('variant-fa'));
      expect(ids('UPPER body', 'en'), contains('english'));
      expect(
        provider.snapshot.entries
            .singleWhere((entry) => entry.id == 'uchikomi-fa')
            .nameFa,
        'تمرین آزمایشی اوچی‌کومی',
      );
      expect(
        provider.snapshot.entries
            .singleWhere((entry) => entry.id == 'variant-fa')
            .nameFa,
        'تمرین كيفي',
      );
    },
  );

  testWidgets('cancelled picker preserves storage on a 360px Persian surface', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final storage = _CountingStorage();
    final provider = LocalExerciseLibraryProvider(
      repository: LocalExerciseLibraryRepository(storage: storage),
    );
    await provider.initialize();
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          locale: const Locale('fa'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ExerciseLibraryScreen(
            csvFileSelector: _CancelledSelector(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    final l10n = AppLocalizations.of(
      tester.element(find.byType(ExerciseLibraryScreen)),
    )!;
    expect(l10n.exerciseImportCsvAction, 'واردکردن از CSV');
    expect(l10n.exerciseImportPreviewTitle, 'پیش‌نمایش واردکردن CSV');
    expect(l10n.exerciseImportConfirmAction, 'واردکردن ردیف‌های معتبر');
    expect(
      find.byKey(const ValueKey('exercise-filter-favorites')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('exercise-filter-recent')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('exercise-filter-favorites')));
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('exercise-favorites-empty')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('exercise-filter-recent')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('exercise-recent-empty')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('import-exercise-csv-action')));
    await tester.pumpAndSettle();
    expect(storage.writeCount, 0);
    expect(tester.takeException(), isNull);
  });

  test('documentation-only example row remains valid and is not seeded', () {
    final guide = File(
      'docs/content_authoring/EXERCISE_LIBRARY_CSV_IMPORT_V1.md',
    ).readAsStringSync();
    final match = RegExp(r'```csv\r?\n([^\r\n]+)\r?\n```').firstMatch(guide);
    expect(match, isNotNull);
    final preview = importer.parseText(
      '${ExerciseLibraryCsvContract.headers.join(',')}\n${match!.group(1)}',
    );
    expect(preview.validRows, 1);
    expect(preview.validEntries.single.id, 'example-band-warmup-001');
    expect(
      preview.validEntries.single.reviewStatus,
      ExerciseReviewStatus.notScientificallyReviewed,
    );
  });

  testWidgets('removing the last active favorite returns to all results', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final provider = LocalExerciseLibraryProvider(
      repository: LocalExerciseLibraryRepository(storage: _CountingStorage()),
      usageStorage: _UsageStorage(),
      idFactory: (_) => 'favorite-one',
      clock: () => DateTime.utc(2026, 8, 24),
    );
    await provider.initialize();
    await provider.createCoachAuthored(
      const CoachAuthoredExerciseInput(
        authoringLocale: ExerciseAuthoringLocale.en,
        nameEn: 'Favorite exercise',
        activityCategory: TrainingSessionItemType.warmUp,
        modality: ExerciseModality.bodyweight,
        supportedDosageModes: [TrainingDosageMode.duration],
      ),
    );
    await provider.toggleFavorite('favorite-one');
    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ExerciseLibraryScreen(
            csvFileSelector: _CancelledSelector(),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('exercise-filter-favorites')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(
      find.byKey(const ValueKey('exercise-favorite-favorite-one')),
    );
    await tester.tap(
      find.byKey(const ValueKey('exercise-favorite-favorite-one')),
    );
    await tester.pumpAndSettle();
    expect(provider.favoriteEntries, isEmpty);
    expect(
      tester
          .widget<FilterChip>(find.byKey(const ValueKey('exercise-filter-all')))
          .selected,
      isTrue,
    );
    expect(
      find.byKey(const ValueKey('exercise-entry-favorite-one')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}

String _csv(List<String> rows) =>
    '${ExerciseLibraryCsvContract.headers.join(',')}\r\n${rows.join('\r\n')}';

String _row({
  required String id,
  String locale = 'en',
  String nameEn = 'Band row',
  String nameFa = '',
  String descriptionEn = '',
  String sourceUrl = '',
  String mediaReference = '',
  String mediaLicense = 'not_provided',
}) {
  final values = <String>[
    '1.0.0',
    id,
    locale,
    nameEn,
    nameFa,
    descriptionEn,
    '',
    'warmUp',
    'resistanceBand',
    'band|mat',
    'duration|repetitions',
    '',
    '',
    '',
    '',
    '',
    sourceUrl,
    mediaReference,
    mediaLicense,
    '',
  ];
  return values.map(_quote).join(',');
}

String _quote(String value) => value.contains(RegExp('[,"\r\n]'))
    ? '"${value.replaceAll('"', '""')}"'
    : value;

class _CountingStorage implements LocalExerciseLibraryStorage {
  String? payload;
  int writeCount = 0;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    writeCount++;
    payload = value;
    return true;
  }
}

class _UsageStorage implements LocalExerciseLibraryUsageStorage {
  String? payload;

  @override
  Future<String?> readUsagePayload() async => payload;

  @override
  Future<bool> writeUsagePayload(String value) async {
    payload = value;
    return true;
  }
}

class _CancelledSelector implements ExerciseCsvFileSelector {
  const _CancelledSelector();

  @override
  Future<ExerciseCsvFileSelection?> selectCsv() async => null;
}
