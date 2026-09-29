import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/providers/local_club_administration_provider.dart';
import 'package:judo_mind/data/repositories/local_club_administration_repository.dart';
import 'package:judo_mind/data/storage/local_club_administration_storage.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/local_club_administration.dart';
import 'package:judo_mind/screens/club/widgets/session_planner_dialog.dart';

void main() {
  testWidgets(
    'coach builds three inline sections and one save returns the whole plan',
    (tester) async {
      final seeded = await _seedProvider();
      SessionPlannerDraft? result;
      await tester.pumpWidget(
        _hostApp(
          locale: const Locale('en'),
          onOpen: (context) async {
            result = await showDialog<SessionPlannerDraft>(
              context: context,
              builder: (_) => SessionPlannerDialog(
                provider: seeded.provider,
                groups: seeded.provider.snapshot.groups,
              ),
            );
          },
        ),
      );
      await _tapVisible(tester, find.text('Open composer'));
      await _selectDropdown(
        tester,
        const ValueKey('session-type-field'),
        'Mixed',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-duration-field')),
        '90',
      );

      await _tapVisible(
        tester,
        find.byKey(const ValueKey('add-session-item-action')),
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-duration-0')),
        '10',
      );

      await _tapVisible(
        tester,
        find.byKey(const ValueKey('add-session-item-action')),
      );
      await _selectDropdown(
        tester,
        const ValueKey('session-item-type-field-1'),
        'Uchikomi',
      );
      await _selectDropdown(
        tester,
        const ValueKey('session-item-dosage-mode-1'),
        'Sets × repetitions',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-sets-1')),
        '3',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-repetitions-1')),
        '10',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-rest-field-1')),
        '60',
      );

      await _tapVisible(
        tester,
        find.byKey(const ValueKey('add-session-item-action')),
      );
      await _selectDropdown(
        tester,
        const ValueKey('session-item-type-field-2'),
        'Randori',
      );
      await _selectDropdown(
        tester,
        const ValueKey('session-item-dosage-mode-2'),
        'Rounds × duration',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-rounds-2')),
        '4',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-round-duration-2')),
        '4',
      );
      await tester.enterText(
        find.byKey(const ValueKey('session-item-rest-field-2')),
        '60',
      );
      await tester.pump();

      expect(find.textContaining('Warm-up — 10 min'), findsOneWidget);
      expect(
        find.textContaining('Uchikomi — 3 × 10 — Rest: 60 sec'),
        findsOneWidget,
      );
      expect(
        find.textContaining('Randori — 4 rounds × 4 min — Rest: 60 sec'),
        findsOneWidget,
      );
      expect(find.text('Planned sections: 3'), findsOneWidget);
      expect(
        find.text('Calculable planned activity time: 26 min (partial)'),
        findsOneWidget,
      );
      expect(
        seeded.storage.writeCount,
        seeded.writesAfterSeed,
        reason: 'Editing the composer must remain in memory.',
      );

      await _tapVisible(
        tester,
        find.byKey(const ValueKey('save-session-action')),
      );
      expect(result, isNotNull);
      expect(result!.items, hasLength(3));
      expect(result!.items.map((item) => item.type), [
        TrainingSessionItemType.warmUp,
        TrainingSessionItemType.uchikomi,
        TrainingSessionItemType.randori,
      ]);
      expect(result!.items.map((item) => item.order), [0, 1, 2]);

      expect(
        await seeded.provider.createSession(
          groupId: result!.groupId,
          sessionType: result!.sessionType,
          title: result!.title,
          objective: result!.objective,
          scheduledAt: result!.scheduledAt,
          durationMinutes: result!.durationMinutes,
          items: result!.items,
        ),
        isTrue,
      );
      expect(seeded.storage.writeCount, seeded.writesAfterSeed + 1);
      expect(seeded.provider.snapshot.sessions.single.items, hasLength(3));
    },
  );

  testWidgets('dosage mode exposes only its relevant inline fields', (
    tester,
  ) async {
    final seeded = await _seedProvider();
    await tester.pumpWidget(
      _dialogApp(
        locale: const Locale('en'),
        child: SessionPlannerDialog(
          provider: seeded.provider,
          groups: seeded.provider.snapshot.groups,
        ),
      ),
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('add-session-item-action')),
    );
    expect(
      find.byKey(const ValueKey('session-item-duration-0')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('session-item-repetitions-0')),
      findsNothing,
    );

    await _selectDropdown(
      tester,
      const ValueKey('session-item-dosage-mode-0'),
      'Repetitions',
    );
    expect(
      find.byKey(const ValueKey('session-item-repetitions-0')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('session-item-duration-0')), findsNothing);

    await _selectDropdown(
      tester,
      const ValueKey('session-item-dosage-mode-0'),
      'Sets × repetitions',
    );
    expect(find.byKey(const ValueKey('session-item-sets-0')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('session-item-repetitions-0')),
      findsOneWidget,
    );

    await _selectDropdown(
      tester,
      const ValueKey('session-item-dosage-mode-0'),
      'Rounds × duration',
    );
    expect(find.byKey(const ValueKey('session-item-rounds-0')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('session-item-round-duration-0')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('session-item-sets-0')), findsNothing);

    await _selectDropdown(
      tester,
      const ValueKey('session-item-dosage-mode-0'),
      'Distance',
    );
    expect(
      find.byKey(const ValueKey('session-item-distance-0')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('session-item-rounds-0')), findsNothing);

    await _selectDropdown(
      tester,
      const ValueKey('session-item-dosage-mode-0'),
      'Descriptive / custom',
    );
    expect(
      find.byKey(const ValueKey('session-item-description-0')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('session-item-distance-0')), findsNothing);

    await _tapVisible(
      tester,
      find.byKey(const ValueKey('toggle-session-item-0')),
    );
    expect(
      find.byKey(const ValueKey('session-item-description-0')),
      findsNothing,
    );
    await _tapVisible(
      tester,
      find.byKey(const ValueKey('toggle-session-item-0')),
    );
    expect(
      find.byKey(const ValueKey('session-item-description-0')),
      findsOneWidget,
    );
  });

  testWidgets(
    'duplicate uses a new ID, delete is scoped, reorder and attendance persist',
    (tester) async {
      final seeded = await _seedProvider();
      final first = seeded.provider.buildSessionItem(
        id: 'item-a',
        type: TrainingSessionItemType.warmUp,
        customTitle: 'Preparation',
        order: 0,
        dosage: _duration(10),
      )!;
      final second = seeded.provider.buildSessionItem(
        id: 'item-b',
        type: TrainingSessionItemType.randori,
        order: 1,
        dosage: _rounds(4, 4),
        restSeconds: 60,
      )!;
      final group = seeded.provider.snapshot.groups.single;
      expect(
        await seeded.provider.createSession(
          groupId: group.id,
          sessionType: ClubSessionType.mixed,
          scheduledAt: DateTime.utc(2026, 8, 21, 18),
          durationMinutes: 90,
          items: [first, second],
        ),
        isTrue,
      );
      final original = seeded.provider.snapshot.sessions.single;
      final membership = seeded.provider.snapshot.memberships.single;
      expect(
        await seeded.provider.recordAttendance(
          sessionId: original.id,
          membershipId: membership.id,
          attendanceState: AttendanceState.present,
        ),
        isTrue,
      );
      final writesBeforeComposer = seeded.storage.writeCount;
      SessionPlannerDraft? result;
      await tester.pumpWidget(
        _hostApp(
          locale: const Locale('en'),
          onOpen: (context) async {
            result = await showDialog<SessionPlannerDraft>(
              context: context,
              builder: (_) => SessionPlannerDialog(
                provider: seeded.provider,
                groups: seeded.provider.snapshot.groups,
                existingSession: original,
              ),
            );
          },
        ),
      );
      await _tapVisible(tester, find.text('Open composer'));
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('duplicate-session-item-0')),
      );
      expect(
        find.byKey(const ValueKey('remove-session-item-2')),
        findsOneWidget,
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('remove-session-item-0')),
      );
      expect(
        find.byKey(const ValueKey('remove-session-item-1')),
        findsOneWidget,
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('move-session-item-up-1')),
      );
      expect(seeded.storage.writeCount, writesBeforeComposer);
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('save-session-action')),
      );

      expect(result, isNotNull);
      expect(result!.items, hasLength(2));
      expect(result!.items.first.id, 'item-b');
      expect(result!.items.last.id, isNot('item-a'));
      expect(result!.items.last.id, startsWith('session-item-'));
      expect(result!.items.map((item) => item.order), [0, 1]);
      expect(
        await seeded.provider.updateSession(
          sessionId: original.id,
          groupId: result!.groupId,
          sessionType: result!.sessionType,
          title: result!.title,
          objective: result!.objective,
          scheduledAt: result!.scheduledAt,
          durationMinutes: result!.durationMinutes,
          items: result!.items,
        ),
        isTrue,
      );
      expect(seeded.storage.writeCount, writesBeforeComposer + 1);
      expect(
        seeded.provider.snapshot.attendanceRecords.single.state,
        AttendanceState.present,
      );
    },
  );

  testWidgets(
    'cancel and system back require discard and never persist draft',
    (tester) async {
      final seeded = await _seedProvider();
      final writesBeforeComposer = seeded.storage.writeCount;
      SessionPlannerDraft? result;
      await tester.pumpWidget(
        _hostApp(
          locale: const Locale('en'),
          onOpen: (context) async {
            result = await showDialog<SessionPlannerDraft>(
              context: context,
              builder: (_) => SessionPlannerDialog(
                provider: seeded.provider,
                groups: seeded.provider.snapshot.groups,
              ),
            );
          },
        ),
      );
      await _tapVisible(tester, find.text('Open composer'));
      await tester.enterText(
        find.byKey(const ValueKey('session-title-field')),
        'Unsaved plan',
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('cancel-session-plan-action')),
      );
      expect(find.text('Unsaved changes'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('continue-editing-session-action')),
      );
      await tester.pumpAndSettle();
      expect(find.byType(SessionPlannerDialog), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('Unsaved changes'), findsOneWidget);
      await tester.tap(
        find.byKey(const ValueKey('discard-session-changes-action')),
      );
      await tester.pumpAndSettle();
      expect(result, isNull);
      expect(find.byType(SessionPlannerDialog), findsNothing);
      expect(seeded.storage.writeCount, writesBeforeComposer);
      expect(seeded.provider.snapshot.sessions, isEmpty);
    },
  );

  testWidgets('English and Persian accordion fit a 360 logical-pixel width', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 760));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    for (final locale in const [Locale('en'), Locale('fa')]) {
      final seeded = await _seedProvider();
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
      await tester.pumpWidget(
        _dialogApp(
          locale: locale,
          child: SessionPlannerDialog(
            provider: seeded.provider,
            groups: seeded.provider.snapshot.groups,
          ),
        ),
      );
      await _tapVisible(
        tester,
        find.byKey(const ValueKey('add-session-item-action')),
      );
      expect(
        find.byKey(const ValueKey('session-plan-summary')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('session-item-type-field-0')),
        findsOneWidget,
      );
      expect(
        Directionality.of(tester.element(find.byType(SessionPlannerDialog))),
        locale.languageCode == 'fa' ? TextDirection.rtl : TextDirection.ltr,
      );
      expect(tester.takeException(), isNull);
    }
  });
}

Widget _hostApp({
  required Locale locale,
  required Future<void> Function(BuildContext context) onOpen,
}) => _dialogApp(
  locale: locale,
  child: Builder(
    builder: (context) => ElevatedButton(
      onPressed: () => onOpen(context),
      child: const Text('Open composer'),
    ),
  ),
);

Widget _dialogApp({required Locale locale, required Widget child}) =>
    MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

Future<void> _tapVisible(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _selectDropdown(
  WidgetTester tester,
  ValueKey<String> key,
  String value,
) async {
  await _tapVisible(tester, find.byKey(key));
  await tester.tap(find.text(value).last);
  await tester.pumpAndSettle();
}

TrainingSessionDosage _duration(int minutes) => TrainingSessionDosage(
  mode: TrainingDosageMode.duration,
  durationMinutes: minutes,
  repetitions: null,
  sets: null,
  rounds: null,
  roundDurationMinutes: null,
  distanceMeters: null,
  description: null,
);

TrainingSessionDosage _rounds(int rounds, int minutes) => TrainingSessionDosage(
  mode: TrainingDosageMode.roundsDuration,
  durationMinutes: null,
  repetitions: null,
  sets: null,
  rounds: rounds,
  roundDurationMinutes: minutes,
  distanceMeters: null,
  description: null,
);

Future<
  ({
    LocalClubAdministrationProvider provider,
    _ClubStorage storage,
    int writesAfterSeed,
  })
>
_seedProvider() async {
  final storage = _ClubStorage();
  var id = 0;
  final provider = LocalClubAdministrationProvider(
    repository: LocalClubAdministrationRepository(storage: storage),
    clock: () => DateTime.utc(2026, 8, 21, 10),
    idFactory: (prefix, _) => '$prefix-${++id}',
  );
  expect(await provider.initialize(), isTrue);
  expect(await provider.saveClub(name: 'Local Dojo'), isTrue);
  expect(await provider.linkCurrentAthlete(), isTrue);
  expect(
    await provider.createGroup(
      name: 'Adults',
      membershipIds: [provider.snapshot.memberships.single.id],
    ),
    isTrue,
  );
  return (
    provider: provider,
    storage: storage,
    writesAfterSeed: storage.writeCount,
  );
}

class _ClubStorage implements LocalClubAdministrationStorage {
  String? payload;
  int writeCount = 0;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    writeCount += 1;
    return true;
  }
}
