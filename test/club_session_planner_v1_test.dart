import 'dart:convert';

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
  test(
    'schema 1.0.0 migrates in memory without changing stored source',
    () async {
      final legacy = _legacySnapshotJson();
      final originalPayload = jsonEncode(legacy);
      final storage = _ClubStorage()..payload = originalPayload;
      final repository = LocalClubAdministrationRepository(storage: storage);

      final result = await repository.load();

      expect(result.isSuccess, isTrue);
      expect(result.sourceSchemaVersion, '1.0.0');
      expect(result.wasMigrated, isTrue);
      expect(result.snapshot!.schemaVersion, '3.0.0');
      expect(result.snapshot!.club!.id, 'club-1');
      expect(result.snapshot!.memberships.single.id, 'membership-1');
      expect(result.snapshot!.groups.single.id, 'group-1');
      expect(result.snapshot!.sessions.single.id, 'session-1');
      expect(result.snapshot!.sessions.single.groupId, 'group-1');
      expect(result.snapshot!.sessions.single.durationMinutes, 90);
      expect(
        result.snapshot!.sessions.single.sessionType,
        ClubSessionType.unspecifiedLegacy,
      );
      expect(result.snapshot!.sessions.single.items, isEmpty);
      expect(result.snapshot!.attendanceRecords.single.id, 'attendance-1');
      expect(storage.payload, originalPayload);

      var id = 0;
      final provider = LocalClubAdministrationProvider(
        repository: repository,
        clock: () => DateTime.utc(2026, 8, 21, 10),
        idFactory: (prefix, _) => '$prefix-${++id}',
      );
      expect(await provider.initialize(), isTrue);
      expect(provider.migrationPending, isTrue);
      expect(
        await provider.saveClub(
          name: provider.snapshot.club!.name,
          description: provider.snapshot.club!.description,
        ),
        isTrue,
      );
      expect(provider.migrationPending, isFalse);
      expect(jsonDecode(storage.payload!)['schema_version'], '3.0.0');
    },
  );

  test('schema 2.0.0 migrates linked-field absence to schema 3.0.0', () async {
    final seeded = await _seedProvider();
    final item = seeded.provider.buildSessionItem(
      type: TrainingSessionItemType.warmUp,
      order: 0,
      dosage: _validDosage(TrainingDosageMode.duration),
    )!;
    expect(
      await seeded.provider.createSession(
        groupId: seeded.provider.snapshot.groups.single.id,
        sessionType: ClubSessionType.mixed,
        scheduledAt: DateTime.utc(2026, 8, 22),
        items: [item],
      ),
      isTrue,
    );
    final schema2 = jsonDecode(seeded.storage.payload!) as Map<String, dynamic>;
    schema2['schema_version'] = '2.0.0';
    for (final session in schema2['sessions'] as List<dynamic>) {
      for (final item in session['items'] as List<dynamic>) {
        (item as Map<String, dynamic>).remove('exercise_snapshot');
      }
    }
    final source = jsonEncode(schema2);
    seeded.storage.payload = source;

    final result = await LocalClubAdministrationRepository(
      storage: seeded.storage,
    ).load();
    expect(result.isSuccess, isTrue);
    expect(result.sourceSchemaVersion, '2.0.0');
    expect(result.wasMigrated, isTrue);
    expect(result.snapshot!.schemaVersion, '3.0.0');
    expect(
      result.snapshot!.sessions.single.items.single.exerciseSnapshot,
      isNull,
    );
    expect(seeded.storage.payload, source);
  });

  test('unknown and malformed old schemas fail closed', () {
    final unknown = _legacySnapshotJson()..['schema_version'] = '4.0.0';
    expect(
      () => LocalClubAdministrationSnapshot.fromJson(unknown),
      throwsFormatException,
    );

    final malformed = _legacySnapshotJson();
    (malformed['sessions'] as List<dynamic>).single['duration_minutes'] = '90';
    expect(
      () => LocalClubAdministrationSnapshot.fromJson(malformed),
      throwsFormatException,
    );
  });

  test('all dosage modes accept only their own valid fields', () {
    for (final mode in TrainingDosageMode.values) {
      final dosage = _validDosage(mode);
      expect(dosage.isValid, isTrue, reason: mode.name);
      expect(
        TrainingSessionDosage.fromJson(dosage.toJson()).isValid,
        isTrue,
        reason: mode.name,
      );

      final contradictory = dosage.toJson();
      final conflictingKey = mode == TrainingDosageMode.duration
          ? 'repetitions'
          : 'duration_minutes';
      contradictory[conflictingKey] = 3;
      expect(
        () => TrainingSessionDosage.fromJson(contradictory),
        throwsFormatException,
        reason: '${mode.name} must reject contradictory fields',
      );

      final invalidRequired = dosage.toJson();
      final invalidKey = switch (mode) {
        TrainingDosageMode.duration => 'duration_minutes',
        TrainingDosageMode.repetitions => 'repetitions',
        TrainingDosageMode.setsRepetitions => 'sets',
        TrainingDosageMode.roundsDuration => 'rounds',
        TrainingDosageMode.distance => 'distance_meters',
        TrainingDosageMode.descriptiveCustom => 'description',
      };
      invalidRequired[invalidKey] = mode == TrainingDosageMode.descriptiveCustom
          ? '   '
          : 0;
      expect(
        () => TrainingSessionDosage.fromJson(invalidRequired),
        throwsFormatException,
        reason: '${mode.name} must reject an invalid required value',
      );
    }
  });

  test('custom items require coach text and rest is non-negative', () {
    final missingTitle = TrainingSessionItem(
      id: 'item-1',
      type: TrainingSessionItemType.customCoachAuthored,
      customTitle: null,
      order: 0,
      dosage: _validDosage(TrainingDosageMode.repetitions),
      restSeconds: null,
      coachNotes: null,
    );
    expect(missingTitle.isValid, isFalse);

    final valid = TrainingSessionItem(
      id: 'item-1',
      type: TrainingSessionItemType.physicalConditioningCustom,
      customTitle: 'Coach-defined movement',
      order: 0,
      dosage: _validDosage(TrainingDosageMode.descriptiveCustom),
      restSeconds: 0,
      coachNotes: 'Planned only.',
    );
    expect(valid.isValid, isTrue);
    expect(
      TrainingSessionItem.fromJson(valid.toJson()).customTitle,
      'Coach-defined movement',
    );

    final invalidRest = valid.toJson()..['rest_seconds'] = -1;
    expect(
      () => TrainingSessionItem.fromJson(invalidRest),
      throwsFormatException,
    );
  });

  test(
    'provider creates and updates ordered items while preserving attendance',
    () async {
      final seeded = await _seedProvider();
      final provider = seeded.provider;
      final group = provider.snapshot.groups.single;
      final membership = provider.snapshot.memberships.single;
      final first = provider.buildSessionItem(
        type: TrainingSessionItemType.warmUp,
        order: 0,
        dosage: _validDosage(TrainingDosageMode.duration),
      )!;
      final second = provider.buildSessionItem(
        type: TrainingSessionItemType.randori,
        order: 1,
        dosage: _validDosage(TrainingDosageMode.roundsDuration),
      )!;

      expect(
        await provider.createSession(
          groupId: group.id,
          sessionType: ClubSessionType.mixed,
          title: 'Evening plan',
          objective: 'Coach-authored objective',
          scheduledAt: DateTime.utc(2026, 8, 21, 18),
          durationMinutes: 90,
          items: [first, second],
        ),
        isTrue,
      );
      final session = provider.snapshot.sessions.single;
      expect(
        await provider.recordAttendance(
          sessionId: session.id,
          membershipId: membership.id,
          attendanceState: AttendanceState.present,
        ),
        isTrue,
      );

      final editedSecond = provider.buildSessionItem(
        id: second.id,
        type: TrainingSessionItemType.randori,
        order: 1,
        dosage: _validDosage(TrainingDosageMode.repetitions),
        coachNotes: 'Edited by coach',
      )!;
      expect(
        await provider.updateSession(
          sessionId: session.id,
          groupId: group.id,
          sessionType: ClubSessionType.randori,
          title: 'Updated plan',
          scheduledAt: DateTime.utc(2026, 8, 21, 19),
          items: [editedSecond],
        ),
        isTrue,
      );

      final updated = provider.snapshot.sessions.single;
      expect(updated.id, session.id);
      expect(updated.createdAtUtc, session.createdAtUtc);
      expect(updated.items, hasLength(1));
      expect(updated.items.single.id, second.id);
      expect(updated.items.single.order, 0);
      expect(updated.items.single.coachNotes, 'Edited by coach');
      expect(
        provider.snapshot.attendanceRecords.single.state,
        AttendanceState.present,
      );

      final recovered = LocalClubAdministrationSnapshot.fromJson(
        jsonDecode(seeded.storage.payload!) as Map<String, dynamic>,
      );
      expect(recovered.sessions.single.items.single.order, 0);
      expect(recovered.attendanceRecords.single.state, AttendanceState.present);
      expect(
        await provider.createSession(
          groupId: group.id,
          sessionType: ClubSessionType.unspecifiedLegacy,
          scheduledAt: DateTime.utc(2026, 8, 22),
        ),
        isFalse,
      );
    },
  );

  testWidgets('small-screen planner keeps explicit type and save reachable', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(360, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final seeded = await _seedProvider();
    SessionPlannerDraft? result;

    await tester.pumpWidget(
      _dialogApp(
        locale: const Locale('en'),
        child: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () async {
              result = await showDialog<SessionPlannerDraft>(
                context: context,
                builder: (_) => SessionPlannerDialog(
                  provider: seeded.provider,
                  groups: seeded.provider.snapshot.groups,
                ),
              );
            },
            child: const Text('Open planner'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('Open planner'));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('session-planner-scroll-view')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('save-session-action')), findsOneWidget);
    expect(find.text('No plan items were added.'), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('save-session-action')));
    await tester.pumpAndSettle();
    expect(find.text('Select a session type.'), findsOneWidget);
    expect(find.byType(SessionPlannerDialog), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('session-type-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tactical').last);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('save-session-action')));
    await tester.pumpAndSettle();

    expect(result?.sessionType, ClubSessionType.tactical);
    expect(result?.items, isEmpty);
  });

  testWidgets('Persian labels are natural, RTL and use localized digits', (
    tester,
  ) async {
    final seeded = await _seedProvider();
    await tester.pumpWidget(
      _dialogApp(
        locale: const Locale('fa'),
        child: SessionPlannerDialog(
          provider: seeded.provider,
          groups: seeded.provider.snapshot.groups,
        ),
      ),
    );

    expect(
      Directionality.of(tester.element(find.byType(SessionPlannerDialog))),
      TextDirection.rtl,
    );
    expect(find.text('نوع جلسه'), findsOneWidget);
    expect(find.text('نوشتن دستی'), findsOneWidget);
    expect(find.textContaining('بنیاد محلی تک‌دستگاهی'), findsNothing);
    expect(tester.takeException(), isNull);
  });
}

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

TrainingSessionDosage _validDosage(TrainingDosageMode mode) =>
    TrainingSessionDosage(
      mode: mode,
      durationMinutes: mode == TrainingDosageMode.duration ? 10 : null,
      repetitions:
          mode == TrainingDosageMode.repetitions ||
              mode == TrainingDosageMode.setsRepetitions
          ? 12
          : null,
      sets: mode == TrainingDosageMode.setsRepetitions ? 3 : null,
      rounds: mode == TrainingDosageMode.roundsDuration ? 4 : null,
      roundDurationMinutes: mode == TrainingDosageMode.roundsDuration
          ? 3
          : null,
      distanceMeters: mode == TrainingDosageMode.distance ? 25.5 : null,
      description: mode == TrainingDosageMode.descriptiveCustom
          ? 'Coach-defined volume'
          : null,
    );

Future<({LocalClubAdministrationProvider provider, _ClubStorage storage})>
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
  return (provider: provider, storage: storage);
}

Map<String, dynamic> _legacySnapshotJson() {
  const created = '2026-08-20T10:00:00.000Z';
  return <String, dynamic>{
    'schema_version': '1.0.0',
    'storage_scope': 'local-single-device',
    'club': <String, dynamic>{
      'id': 'club-1',
      'name': 'Local Dojo',
      'description': 'Existing value',
      'status': 'active',
      'created_at_utc': created,
      'updated_at_utc': created,
    },
    'memberships': <dynamic>[
      <String, dynamic>{
        'id': 'membership-1',
        'club_id': 'club-1',
        'athlete_reference_id': LocalAthleteReference.current,
        'status': 'active',
        'join_date_utc': created,
        'membership_number': 'M-1',
        'created_at_utc': created,
        'updated_at_utc': created,
      },
    ],
    'groups': <dynamic>[
      <String, dynamic>{
        'id': 'group-1',
        'club_id': 'club-1',
        'name': 'Adults',
        'description': null,
        'status': 'active',
        'membership_ids': <String>['membership-1'],
        'created_at_utc': created,
        'updated_at_utc': created,
      },
    ],
    'sessions': <dynamic>[
      <String, dynamic>{
        'id': 'session-1',
        'club_id': 'club-1',
        'group_id': 'group-1',
        'scheduled_at_utc': '2026-08-21T18:00:00.000Z',
        'duration_minutes': 90,
        'status': 'scheduled',
        'created_at_utc': created,
        'updated_at_utc': created,
      },
    ],
    'attendance_records': <dynamic>[
      <String, dynamic>{
        'id': 'attendance-1',
        'session_id': 'session-1',
        'membership_id': 'membership-1',
        'state': 'present',
        'recorded_at_utc': created,
      },
    ],
  };
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
