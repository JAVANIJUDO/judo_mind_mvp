import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/constants/modules.dart';
import 'package:judo_mind/core/providers/local_athlete_profile_provider.dart';
import 'package:judo_mind/core/providers/local_club_administration_provider.dart';
import 'package:judo_mind/core/routes/app_routes.dart';
import 'package:judo_mind/data/repositories/local_athlete_profile_repository.dart';
import 'package:judo_mind/data/repositories/local_club_administration_repository.dart';
import 'package:judo_mind/data/storage/local_athlete_profile_storage.dart';
import 'package:judo_mind/data/storage/local_club_administration_storage.dart';
import 'package:judo_mind/data/techniques/technique_factory.dart';
import 'package:judo_mind/l10n/app_localizations.dart';
import 'package:judo_mind/models/local_athlete_profile.dart';
import 'package:judo_mind/models/local_club_administration.dart';
import 'package:judo_mind/screens/club/club_administration_screen.dart';
import 'package:provider/provider.dart';

void main() {
  test(
    'strict versioned models serialize without Profile data duplication',
    () {
      final snapshot = _completeSnapshot();
      final encoded = jsonEncode(snapshot.toJson());
      final decoded = LocalClubAdministrationSnapshot.fromJson(
        jsonDecode(encoded) as Map<String, dynamic>,
      );

      expect(decoded.isValid, isTrue);
      expect(decoded.rosterCount, 1);
      expect(decoded.groupCount, 1);
      expect(decoded.sessionCount, 1);
      expect(decoded.recordedAttendanceCount, 1);

      final membershipJson = decoded.memberships.single.toJson();
      expect(
        membershipJson['athlete_reference_id'],
        LocalAthleteReference.current,
      );
      expect(
        membershipJson.keys,
        unorderedEquals(const {
          'id',
          'club_id',
          'athlete_reference_id',
          'status',
          'join_date_utc',
          'membership_number',
          'created_at_utc',
          'updated_at_utc',
        }),
      );
      for (final forbidden in const [
        'display_name',
        'belt_rank',
        'club',
        'country',
        'biography',
        'height',
        'weight',
      ]) {
        expect(membershipJson.containsKey(forbidden), isFalse);
      }
    },
  );

  test(
    'malformed, incompatible and inconsistent storage fails closed',
    () async {
      final storage = _ClubStorage()..payload = '{"schema_version":"9.0.0"}';
      final repository = LocalClubAdministrationRepository(storage: storage);
      final failed = await repository.load();
      expect(failed.failure, LocalClubAdministrationFailure.corruptedStorage);

      final original = storage.payload;
      final save = await repository.save(_completeSnapshot());
      expect(save.failure, LocalClubAdministrationFailure.corruptedStorage);
      expect(
        storage.payload,
        original,
        reason: 'Corrupt data must not be overwritten.',
      );

      final json = _completeSnapshot().toJson()..['unexpected'] = true;
      expect(
        () => LocalClubAdministrationSnapshot.fromJson(json),
        throwsFormatException,
      );

      final inconsistent = _completeSnapshot().toJson();
      (inconsistent['groups'] as List<dynamic>).clear();
      expect(
        () => LocalClubAdministrationSnapshot.fromJson(inconsistent),
        throwsFormatException,
      );
    },
  );

  test('local workflow round-trips and preserves canonical Profile', () async {
    final clubStorage = _ClubStorage();
    final profileStorage = _ProfileStorage();
    final profileRepository = LocalAthleteProfileRepository(
      storage: profileStorage,
    );
    final profile = LocalAthleteProfile.fromInput(
      displayName: 'Current Athlete',
      beltRank: 'Blue',
      country: 'Iran',
    );
    expect((await profileRepository.save(profile)).isSuccess, isTrue);
    final profilePayloadBefore = profileStorage.payload;

    var id = 0;
    final provider = LocalClubAdministrationProvider(
      repository: LocalClubAdministrationRepository(storage: clubStorage),
      clock: () => DateTime.utc(2026, 8, 20, 10),
      idFactory: (prefix, _) => '$prefix-${++id}',
    );
    expect(await provider.initialize(), isTrue);
    expect(provider.snapshot.club, isNull);
    expect(await provider.saveClub(name: 'Judo Club'), isTrue);
    expect(await provider.linkCurrentAthlete(membershipNumber: 'M-1'), isTrue);
    final membership = provider.snapshot.memberships.single;
    expect(
      await provider.createGroup(
        name: 'Adults',
        membershipIds: [membership.id],
      ),
      isTrue,
    );
    final group = provider.snapshot.groups.single;
    expect(
      await provider.createSession(
        groupId: group.id,
        sessionType: ClubSessionType.judoTechnical,
        scheduledAt: DateTime.utc(2026, 8, 21, 18),
        durationMinutes: 90,
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

    final recovered = LocalClubAdministrationProvider(
      repository: LocalClubAdministrationRepository(storage: clubStorage),
    );
    expect(await recovered.initialize(), isTrue);
    expect(recovered.snapshot.club?.name, 'Judo Club');
    expect(
      recovered.snapshot.memberships.single.athleteReferenceId,
      LocalAthleteReference.current,
    );
    expect(recovered.snapshot.groups.single.membershipIds, [membership.id]);
    expect(recovered.snapshot.sessions.single.durationMinutes, 90);
    expect(
      recovered.snapshot.attendanceRecords.single.state,
      AttendanceState.present,
    );
    expect(recovered.snapshot.recordedAttendanceCount, 1);
    expect(profileStorage.payload, profilePayloadBefore);
  });

  testWidgets('English UI completes the local workflow and recovers counts', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(900, 5000));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final storage = _ClubStorage();
    final profileStorage = _ProfileStorage();
    var id = 0;
    final clubProvider = LocalClubAdministrationProvider(
      repository: LocalClubAdministrationRepository(storage: storage),
      clock: () => DateTime.utc(2026, 8, 20, 10),
      idFactory: (prefix, _) => '$prefix-${++id}',
    );
    final profileProvider = LocalAthleteProfileProvider(
      repository: LocalAthleteProfileRepository(storage: profileStorage),
    );
    await clubProvider.initialize();
    await profileProvider.initialize();
    await profileProvider.save(
      LocalAthleteProfile.fromInput(displayName: 'Mohammad'),
    );
    final profileBefore = profileStorage.payload;
    await tester.pumpWidget(
      _app(
        clubProvider: clubProvider,
        profileProvider: profileProvider,
        locale: const Locale('en'),
      ),
    );

    expect(find.byKey(const ValueKey('club-empty-state')), findsOneWidget);
    await tester.tap(find.byKey(const ValueKey('create-club-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('club-name-field')),
      'Local Dojo',
    );
    await tester.tap(find.byKey(const ValueKey('save-club-action')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('link-current-athlete-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('confirm-link-athlete-action')));
    await tester.pumpAndSettle();
    expect(find.text('Mohammad'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('create-group-action')));
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('group-name-field')),
      'Evening group',
    );
    await tester.tap(find.byKey(const ValueKey('save-group-action')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('create-session-action')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('session-type-field')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Judo technical').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('session-duration-field')),
      '75',
    );
    await tester.tap(find.byKey(const ValueKey('save-session-action')));
    await tester.pumpAndSettle();
    expect(find.text('Session plan was saved.'), findsOneWidget);

    final session = clubProvider.snapshot.sessions.single;
    final membership = clubProvider.snapshot.memberships.single;
    await tester.tap(
      find.byKey(
        ValueKey(
          'attendance-${session.id}-${membership.id}-${AttendanceState.present.name}',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(clubProvider.snapshot.rosterCount, 1);
    expect(clubProvider.snapshot.groupCount, 1);
    expect(clubProvider.snapshot.sessionCount, 1);
    expect(clubProvider.snapshot.recordedAttendanceCount, 1);
    expect(find.text('Athletes: 1'), findsOneWidget);
    expect(find.text('Groups: 1'), findsOneWidget);
    expect(find.text('Sessions: 1'), findsOneWidget);
    expect(find.text('Attendance records: 1'), findsOneWidget);
    expect(profileStorage.payload, profileBefore);

    final recovered = LocalClubAdministrationProvider(
      repository: LocalClubAdministrationRepository(storage: storage),
    );
    expect(await recovered.initialize(), isTrue);
    expect(recovered.snapshot.recordedAttendanceCount, 1);
  });

  testWidgets('Persian workspace is complete and RTL', (tester) async {
    final clubProvider = LocalClubAdministrationProvider(
      repository: LocalClubAdministrationRepository(storage: _ClubStorage()),
    );
    final profileProvider = LocalAthleteProfileProvider(
      repository: LocalAthleteProfileRepository(storage: _ProfileStorage()),
    );
    await clubProvider.initialize();
    await profileProvider.initialize();
    await tester.pumpWidget(
      _app(
        clubProvider: clubProvider,
        profileProvider: profileProvider,
        locale: const Locale('fa'),
      ),
    );
    expect(
      Directionality.of(tester.element(find.byType(ClubAdministrationScreen))),
      TextDirection.rtl,
    );
    expect(find.text('هنوز باشگاه محلی ندارید'), findsOneWidget);
    expect(find.textContaining('فقط روی همین دستگاه'), findsOneWidget);
    expect(find.textContaining('بنیاد محلی تک‌دستگاهی'), findsNothing);
    expect(find.text('No local club yet'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('Club is foundation-only, directory-only and routes are intact', () {
    final club = JudoMindModules.modules.singleWhere(
      (module) => module.id == 'club-administration',
    );
    expect(JudoMindModules.modules, hasLength(18));
    expect(
      JudoMindModules.modules.map((value) => value.id).toSet(),
      hasLength(18),
    );
    expect(club.route, AppRoutes.clubAdministration);
    expect(club.readiness.name, 'foundationOnly');
    expect(club.isReachable, isTrue);
    expect(club.showOnAthleteHome, isFalse);
    expect(JudoMindModules.athleteHomeModules.contains(club), isFalse);
    expect(AppRoutes.routes[AppRoutes.home], isNotNull);
    expect(AppRoutes.routes[AppRoutes.techniques], isNotNull);
    expect(AppRoutes.routes[AppRoutes.profile], isNotNull);
    expect(AppRoutes.routes[AppRoutes.settings], isNotNull);
    expect(AppRoutes.routes[AppRoutes.progressOverview], isNotNull);
    expect(AppRoutes.routes[AppRoutes.localAnalysisHistory], isNotNull);
    expect(AppRoutes.routes[AppRoutes.clubAdministration], isNotNull);
    expect(
      TechniqueFactory
          .featuredReferenceTechnique
          .supportsReviewedSingleAttemptV2A,
      isTrue,
    );

    final homeSource = File(
      'lib/screens/home/home_screen.dart',
    ).readAsStringSync();
    expect(homeSource.contains(AppRoutes.clubAdministration), isFalse);
    expect(homeSource.contains('club-administration'), isFalse);
  });
}

Widget _app({
  required LocalClubAdministrationProvider clubProvider,
  required LocalAthleteProfileProvider profileProvider,
  Locale locale = const Locale('en'),
  Widget home = const ClubAdministrationScreen(),
}) {
  return MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: clubProvider),
      ChangeNotifierProvider.value(value: profileProvider),
    ],
    child: MaterialApp(
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

LocalClubAdministrationSnapshot _completeSnapshot() {
  final created = DateTime.utc(2026, 8, 20, 10);
  final club = Club(
    id: 'club-1',
    name: 'Local Dojo',
    description: null,
    status: ClubStatus.active,
    createdAtUtc: created,
    updatedAtUtc: created,
  );
  final membership = ClubMembership(
    id: 'membership-1',
    clubId: club.id,
    athleteReferenceId: LocalAthleteReference.current,
    status: ClubMembershipStatus.active,
    joinDateUtc: created,
    membershipNumber: null,
    createdAtUtc: created,
    updatedAtUtc: created,
  );
  final group = TrainingGroup(
    id: 'group-1',
    clubId: club.id,
    name: 'Adults',
    description: null,
    status: TrainingGroupStatus.active,
    membershipIds: [membership.id],
    createdAtUtc: created,
    updatedAtUtc: created,
  );
  final session = ClubTrainingSession(
    id: 'session-1',
    clubId: club.id,
    groupId: group.id,
    sessionType: ClubSessionType.judoTechnical,
    title: 'Technical session',
    objective: null,
    scheduledAtUtc: created.add(const Duration(days: 1)),
    durationMinutes: 90,
    status: ClubTrainingSessionStatus.scheduled,
    items: const [],
    createdAtUtc: created,
    updatedAtUtc: created,
  );
  final attendance = AttendanceRecord(
    id: 'attendance-1',
    sessionId: session.id,
    membershipId: membership.id,
    state: AttendanceState.present,
    recordedAtUtc: created,
  );
  return LocalClubAdministrationSnapshot(
    schemaVersion: LocalClubAdministrationSnapshot.currentSchemaVersion,
    club: club,
    memberships: [membership],
    groups: [group],
    sessions: [session],
    attendanceRecords: [attendance],
  );
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

class _ProfileStorage implements LocalAthleteProfileStorage {
  String? payload;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    payload = value;
    return true;
  }
}
