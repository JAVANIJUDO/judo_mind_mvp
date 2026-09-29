import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/providers/local_club_administration_provider.dart';
import 'package:judo_mind/core/providers/local_exercise_library_provider.dart';
import 'package:judo_mind/data/repositories/local_club_administration_repository.dart';
import 'package:judo_mind/data/repositories/local_exercise_library_repository.dart';
import 'package:judo_mind/data/storage/local_club_administration_storage.dart';
import 'package:judo_mind/data/storage/local_exercise_library_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/local_club_administration.dart';
import 'package:judo_mind/models/local_exercise_library.dart';
import 'package:judo_mind/models/training_activity_contract.dart';
import 'package:judo_mind/screens/club/exercise_library_screen.dart';
import 'package:judo_mind/screens/club/widgets/session_planner_dialog.dart';
import 'package:provider/provider.dart';

void main() {
  group('exercise library contract', () {
    test(
      'empty approved repository is honest and duplicate IDs fail closed',
      () {
        const empty = LocalExerciseLibrarySnapshot.empty();
        expect(empty.approvedCount, 0);
        expect(empty.coachAuthoredCount, 0);
        final entry = _coachEntry();
        expect(
          LocalExerciseLibrarySnapshot(
            schemaVersion: LocalExerciseLibrarySnapshot.currentSchemaVersion,
            entries: [entry, entry],
          ).isValid,
          isFalse,
        );
      },
    );

    test('approved status requires complete evidence and localization', () {
      final incomplete = _coachEntry(
        source: ExerciseLibrarySource.approvedRepository,
        reviewStatus: ExerciseReviewStatus.approved,
      );
      expect(incomplete.isValid, isFalse);

      final approved = _coachEntry(
        source: ExerciseLibrarySource.approvedRepository,
        reviewStatus: ExerciseReviewStatus.approved,
        sourceReference: 'review-source-1',
        provenanceNotes: 'Curated evidence record.',
        reviewedBy: 'reviewer-1',
        reviewedAtUtc: DateTime.utc(2026, 8, 24),
      );
      expect(approved.isValid, isTrue);
    });

    test(
      'English and Persian resolve while deferred locale is unavailable',
      () {
        final entry = _coachEntry();
        expect(entry.resolve('en')!.name, 'Local exercise');
        expect(entry.resolve('fa')!.name, 'تمرین محلی');
        expect(entry.resolve('de'), isNull);
      },
    );

    test('reference and revision round-trip without session dosage', () {
      final reference = _coachEntry().toSessionSnapshot();
      final decoded = SessionExerciseReferenceSnapshot.fromJson(
        reference.toJson(),
      );
      expect(decoded.exerciseId, 'exercise-1');
      expect(decoded.revision, 1);
      expect(decoded.toJson().containsKey('sets'), isFalse);
    });
  });

  group('local provider', () {
    test(
      'create edit archive restore recover and filters preserve identity',
      () async {
        final storage = _ExerciseStorage();
        var sequence = 0;
        final provider = LocalExerciseLibraryProvider(
          repository: LocalExerciseLibraryRepository(storage: storage),
          clock: () => DateTime.utc(2026, 8, 24, 10, sequence++),
          idFactory: (_) => 'exercise-stable',
        );
        expect(await provider.initialize(), isTrue);
        expect(await provider.createCoachAuthored(_input()), isTrue);
        expect(await provider.createCoachAuthored(_input()), isFalse);
        final original = provider.snapshot.entries.single;
        expect(original.id, 'exercise-stable');
        expect(original.revision, 1);
        expect(
          original.reviewStatus,
          ExerciseReviewStatus.notScientificallyReviewed,
        );

        expect(
          provider.query(
            const ExerciseLibraryQuery(search: 'Local'),
            languageCode: 'en',
          ),
          hasLength(1),
        );
        expect(
          provider.query(
            const ExerciseLibraryQuery(
              source: ExerciseLibrarySource.approvedRepository,
            ),
            languageCode: 'en',
          ),
          isEmpty,
        );
        expect(
          provider.query(
            const ExerciseLibraryQuery(
              activityCategory:
                  TrainingSessionItemType.physicalConditioningCustom,
              reviewStatus: ExerciseReviewStatus.notScientificallyReviewed,
            ),
            languageCode: 'fa',
          ),
          hasLength(1),
        );

        final savedSessionSnapshot = original.toSessionSnapshot();
        expect(
          await provider.editCoachAuthored(
            exerciseId: original.id,
            input: _input(nameEn: 'Edited local exercise'),
          ),
          isTrue,
        );
        expect(provider.snapshot.entries.single.revision, 2);
        expect(savedSessionSnapshot.revision, 1);
        expect(savedSessionSnapshot.nameEn, 'Local exercise');

        expect(
          await provider.setArchived(exerciseId: original.id, archived: true),
          isTrue,
        );
        expect(provider.snapshot.entries.single.archived, isTrue);
        expect(savedSessionSnapshot.nameEn, 'Local exercise');
        expect(
          provider.query(
            const ExerciseLibraryQuery(includeArchived: false),
            languageCode: 'en',
          ),
          isEmpty,
        );
        expect(
          await provider.setArchived(exerciseId: original.id, archived: false),
          isTrue,
        );

        final recovered = LocalExerciseLibraryProvider(
          repository: LocalExerciseLibraryRepository(storage: storage),
        );
        expect(await recovered.initialize(), isTrue);
        expect(recovered.snapshot.entries.single.id, original.id);
        expect(recovered.snapshot.entries.single.revision, 4);
        expect(recovered.snapshot.entries.single.archived, isFalse);
      },
    );

    test('corrupt storage is not overwritten', () async {
      final storage = _ExerciseStorage()..payload = '{bad';
      final repository = LocalExerciseLibraryRepository(storage: storage);
      expect((await repository.load()).isSuccess, isFalse);
      final before = storage.payload;
      final save = await repository.save(
        LocalExerciseLibrarySnapshot(
          schemaVersion: LocalExerciseLibrarySnapshot.currentSchemaVersion,
          entries: [_coachEntry()],
        ),
      );
      expect(save.isSuccess, isFalse);
      expect(storage.payload, before);
    });
  });

  testWidgets(
    '360px English and Persian empty states render without overflow',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(360, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      for (final locale in const [Locale('en'), Locale('fa')]) {
        final provider = LocalExerciseLibraryProvider(
          repository: LocalExerciseLibraryRepository(
            storage: _ExerciseStorage(),
          ),
        );
        await provider.initialize();
        await tester.pumpWidget(_libraryApp(provider, locale));
        await tester.pumpAndSettle();
        expect(
          find.byKey(const ValueKey('exercise-library-empty-state')),
          findsOneWidget,
        );
        expect(tester.takeException(), isNull);
        if (locale.languageCode == 'fa') {
          expect(
            Directionality.of(tester.element(find.byType(Scaffold))),
            TextDirection.rtl,
          );
          expect(
            find.textContaining('مخزن تمرین‌های تأییدشده'),
            findsOneWidget,
          );
        }
      }
    },
  );

  testWidgets('composer selection links snapshot and leaves dosage to coach', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(700, 1000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final library = LocalExerciseLibraryProvider(
      repository: LocalExerciseLibraryRepository(storage: _ExerciseStorage()),
      idFactory: (_) => 'exercise-linked',
      clock: () => DateTime.utc(2026, 8, 24),
    );
    await library.initialize();
    await library.createCoachAuthored(_input());
    final club = await _seedClub();

    await tester.pumpWidget(
      _localizedApp(
        locale: const Locale('en'),
        home: SessionPlannerDialog(
          provider: club,
          exerciseLibraryProvider: library,
          groups: club.snapshot.groups,
        ),
      ),
    );
    await _tap(
      tester,
      find.byKey(const ValueKey('choose-library-exercise-action')),
    );
    await tester.pumpAndSettle();
    await _tap(
      tester,
      find.byKey(const ValueKey('select-library-exercise-exercise-linked')),
    );
    await tester.pumpAndSettle();
    expect(
      find.byKey(const ValueKey('linked-exercise-session-item-3')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('session-item-sets-0')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('session-item-repetitions-0')),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(TextFormField, 'English name'),
      findsNothing,
      reason: 'Library selection must not reopen repeated entry editing.',
    );
  });
}

Widget _libraryApp(LocalExerciseLibraryProvider provider, Locale locale) =>
    ChangeNotifierProvider.value(
      value: provider,
      child: _localizedApp(locale: locale, home: const ExerciseLibraryScreen()),
    );

Widget _localizedApp({required Locale locale, required Widget home}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    );

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<LocalClubAdministrationProvider> _seedClub() async {
  var id = 0;
  final provider = LocalClubAdministrationProvider(
    repository: LocalClubAdministrationRepository(storage: _ClubStorage()),
    clock: () => DateTime.utc(2026, 8, 24),
    idFactory: (prefix, _) => '$prefix-${++id}',
  );
  await provider.initialize();
  await provider.saveClub(name: 'Local Club');
  await provider.createGroup(name: 'Adults', membershipIds: const []);
  return provider;
}

CoachAuthoredExerciseInput _input({String nameEn = 'Local exercise'}) =>
    CoachAuthoredExerciseInput(
      authoringLocale: ExerciseAuthoringLocale.en,
      nameEn: nameEn,
      nameFa: 'تمرین محلی',
      activityCategory: TrainingSessionItemType.physicalConditioningCustom,
      modality: ExerciseModality.physicalConditioning,
      supportedDosageModes: const [TrainingDosageMode.setsRepetitions],
    );

ExerciseLibraryEntry _coachEntry({
  ExerciseLibrarySource source = ExerciseLibrarySource.coachAuthored,
  ExerciseReviewStatus reviewStatus =
      ExerciseReviewStatus.notScientificallyReviewed,
  String? sourceReference,
  String? provenanceNotes,
  String? reviewedBy,
  DateTime? reviewedAtUtc,
}) => ExerciseLibraryEntry(
  id: 'exercise-1',
  revision: 1,
  source: source,
  reviewStatus: reviewStatus,
  nameEn: 'Local exercise',
  nameFa: 'تمرین محلی',
  descriptionEn: null,
  descriptionFa: null,
  instructionsEn: null,
  instructionsFa: null,
  activityCategory: TrainingSessionItemType.physicalConditioningCustom,
  modality: ExerciseModality.physicalConditioning,
  equipment: const [],
  supportedDosageModes: const [TrainingDosageMode.setsRepetitions],
  commonErrorEn: null,
  commonErrorFa: null,
  safetyEn: null,
  safetyFa: null,
  mediaReference: null,
  sourceReference: sourceReference,
  provenanceNotes: provenanceNotes,
  reviewedBy: reviewedBy,
  reviewedAtUtc: reviewedAtUtc,
  createdAtUtc: DateTime.utc(2026, 8, 24),
  updatedAtUtc: DateTime.utc(2026, 8, 24),
  archived: false,
);

class _ExerciseStorage implements LocalExerciseLibraryStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    jsonDecode(value);
    return true;
  }
}

class _ClubStorage implements LocalClubAdministrationStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}
