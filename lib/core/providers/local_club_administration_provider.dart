import 'package:flutter/foundation.dart';

import '../../data/repositories/local_club_administration_repository.dart';
import '../../models/local_club_administration.dart';

enum LocalClubAdministrationState { initial, loading, ready, saving, failure }

typedef ClubClock = DateTime Function();
typedef ClubIdFactory = String Function(String prefix, DateTime now);

class LocalClubAdministrationProvider extends ChangeNotifier {
  LocalClubAdministrationProvider({
    required this.repository,
    ClubClock? clock,
    ClubIdFactory? idFactory,
  }) : _clock = clock ?? _utcNow,
       _idFactory = idFactory ?? _defaultId;

  final ClubAdministrationRepository repository;
  final ClubClock _clock;
  final ClubIdFactory _idFactory;

  LocalClubAdministrationState _state = LocalClubAdministrationState.initial;
  LocalClubAdministrationSnapshot _snapshot =
      const LocalClubAdministrationSnapshot.empty();
  LocalClubAdministrationFailure? _failure;
  bool _migrationPending = false;

  LocalClubAdministrationState get state => _state;
  LocalClubAdministrationSnapshot get snapshot => _snapshot;
  LocalClubAdministrationFailure? get failure => _failure;
  bool get migrationPending => _migrationPending;
  bool get isBusy =>
      _state == LocalClubAdministrationState.loading ||
      _state == LocalClubAdministrationState.saving;

  Future<bool> initialize() async {
    _state = LocalClubAdministrationState.loading;
    _failure = null;
    notifyListeners();
    final result = await repository.load();
    if (!result.isSuccess) {
      _state = LocalClubAdministrationState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }
    _snapshot = result.snapshot!;
    _migrationPending = result.wasMigrated;
    _state = LocalClubAdministrationState.ready;
    notifyListeners();
    return true;
  }

  Future<bool> saveClub({required String name, String? description}) async {
    final normalizedName = name.trim();
    final normalizedDescription = _normalize(description);
    final now = _clock().toUtc();
    final existing = _snapshot.club;
    final club = Club(
      id: existing?.id ?? _idFactory('club', now),
      name: normalizedName,
      description: normalizedDescription,
      status: existing?.status ?? ClubStatus.active,
      createdAtUtc: existing?.createdAtUtc ?? now,
      updatedAtUtc: now,
    );
    if (!club.isValid) return false;
    return _persist(
      LocalClubAdministrationSnapshot(
        schemaVersion: LocalClubAdministrationSnapshot.currentSchemaVersion,
        club: club,
        memberships: _snapshot.memberships,
        groups: _snapshot.groups,
        sessions: _snapshot.sessions,
        attendanceRecords: _snapshot.attendanceRecords,
      ),
    );
  }

  Future<bool> linkCurrentAthlete({String? membershipNumber}) async {
    final club = _snapshot.club;
    if (club == null ||
        _snapshot.memberships.any(
          (value) => value.athleteReferenceId == LocalAthleteReference.current,
        )) {
      return false;
    }
    final now = _clock().toUtc();
    final membership = ClubMembership(
      id: _idFactory('membership', now),
      clubId: club.id,
      athleteReferenceId: LocalAthleteReference.current,
      status: ClubMembershipStatus.active,
      joinDateUtc: now,
      membershipNumber: _normalize(membershipNumber),
      createdAtUtc: now,
      updatedAtUtc: now,
    );
    if (!membership.isValid) return false;
    return _persist(
      LocalClubAdministrationSnapshot(
        schemaVersion: _snapshot.schemaVersion,
        club: club,
        memberships: List.unmodifiable([..._snapshot.memberships, membership]),
        groups: _snapshot.groups,
        sessions: _snapshot.sessions,
        attendanceRecords: _snapshot.attendanceRecords,
      ),
    );
  }

  Future<bool> createGroup({
    required String name,
    String? description,
    required Iterable<String> membershipIds,
  }) async {
    final club = _snapshot.club;
    if (club == null) return false;
    final selected = membershipIds.toSet().toList(growable: false);
    final known = _snapshot.memberships.map((value) => value.id).toSet();
    if (selected.any((id) => !known.contains(id))) return false;
    final now = _clock().toUtc();
    final group = TrainingGroup(
      id: _idFactory('group', now),
      clubId: club.id,
      name: name.trim(),
      description: _normalize(description),
      status: TrainingGroupStatus.active,
      membershipIds: List.unmodifiable(selected),
      createdAtUtc: now,
      updatedAtUtc: now,
    );
    if (!group.isValid) return false;
    return _persist(
      LocalClubAdministrationSnapshot(
        schemaVersion: _snapshot.schemaVersion,
        club: club,
        memberships: _snapshot.memberships,
        groups: List.unmodifiable([..._snapshot.groups, group]),
        sessions: _snapshot.sessions,
        attendanceRecords: _snapshot.attendanceRecords,
      ),
    );
  }

  Future<bool> createSession({
    required String groupId,
    required ClubSessionType sessionType,
    String? title,
    String? objective,
    required DateTime scheduledAt,
    int? durationMinutes,
    Iterable<TrainingSessionItem> items = const [],
  }) => _saveSession(
    groupId: groupId,
    sessionType: sessionType,
    title: title,
    objective: objective,
    scheduledAt: scheduledAt,
    durationMinutes: durationMinutes,
    items: items,
  );

  Future<bool> updateSession({
    required String sessionId,
    required String groupId,
    required ClubSessionType sessionType,
    String? title,
    String? objective,
    required DateTime scheduledAt,
    int? durationMinutes,
    Iterable<TrainingSessionItem> items = const [],
  }) => _saveSession(
    sessionId: sessionId,
    groupId: groupId,
    sessionType: sessionType,
    title: title,
    objective: objective,
    scheduledAt: scheduledAt,
    durationMinutes: durationMinutes,
    items: items,
  );

  TrainingSessionItem? buildSessionItem({
    String? id,
    required TrainingSessionItemType type,
    String? customTitle,
    SessionExerciseReferenceSnapshot? exerciseSnapshot,
    required int order,
    required TrainingSessionDosage dosage,
    int? restSeconds,
    String? coachNotes,
  }) {
    final now = _clock().toUtc();
    final item = TrainingSessionItem(
      id: id ?? _idFactory('session-item', now),
      type: type,
      customTitle: _normalize(customTitle),
      exerciseSnapshot: exerciseSnapshot,
      order: order,
      dosage: dosage,
      restSeconds: restSeconds,
      coachNotes: _normalize(coachNotes),
    );
    return item.isValid ? item : null;
  }

  /// Reserves a stable, in-memory identifier for a planner draft item.
  ///
  /// This does not persist any state. The identifier reaches storage only if
  /// the coach saves the complete session plan.
  String createSessionItemDraftId() {
    final now = _clock().toUtc();
    return _idFactory('session-item', now);
  }

  Future<bool> _saveSession({
    String? sessionId,
    required String groupId,
    required ClubSessionType sessionType,
    String? title,
    String? objective,
    required DateTime scheduledAt,
    int? durationMinutes,
    required Iterable<TrainingSessionItem> items,
  }) async {
    final club = _snapshot.club;
    final group = _snapshot.groups.where((value) => value.id == groupId);
    if (club == null ||
        group.length != 1 ||
        sessionType == ClubSessionType.unspecifiedLegacy) {
      return false;
    }
    final existingMatches = sessionId == null
        ? const <ClubTrainingSession>[]
        : _snapshot.sessions.where((value) => value.id == sessionId).toList();
    if (sessionId != null && existingMatches.length != 1) return false;
    final existing = existingMatches.isEmpty ? null : existingMatches.single;
    final now = _clock().toUtc();
    final orderedItems = items
        .toList(growable: false)
        .asMap()
        .entries
        .map((entry) => entry.value.withOrder(entry.key))
        .toList(growable: false);
    final session = ClubTrainingSession(
      id: existing?.id ?? _idFactory('session', now),
      clubId: club.id,
      groupId: groupId,
      sessionType: sessionType,
      title: _normalize(title),
      objective: _normalize(objective),
      scheduledAtUtc: scheduledAt.toUtc(),
      durationMinutes: durationMinutes,
      status: existing?.status ?? ClubTrainingSessionStatus.scheduled,
      items: List.unmodifiable(orderedItems),
      createdAtUtc: existing?.createdAtUtc ?? now,
      updatedAtUtc: now,
    );
    if (!session.isValid) return false;
    final sessions =
        _snapshot.sessions
            .where((value) => value.id != session.id)
            .toList(growable: true)
          ..add(session);
    return _persist(
      LocalClubAdministrationSnapshot(
        schemaVersion: _snapshot.schemaVersion,
        club: club,
        memberships: _snapshot.memberships,
        groups: _snapshot.groups,
        sessions: List.unmodifiable(sessions),
        attendanceRecords: _snapshot.attendanceRecords,
      ),
    );
  }

  Future<bool> recordAttendance({
    required String sessionId,
    required String membershipId,
    required AttendanceState attendanceState,
  }) async {
    final club = _snapshot.club;
    if (club == null) return false;
    final sessionMatches = _snapshot.sessions.where(
      (value) => value.id == sessionId,
    );
    if (sessionMatches.length != 1) return false;
    final session = sessionMatches.single;
    final groupMatches = _snapshot.groups.where(
      (value) => value.id == session.groupId,
    );
    if (groupMatches.length != 1 ||
        !groupMatches.single.membershipIds.contains(membershipId)) {
      return false;
    }
    final now = _clock().toUtc();
    final current = _snapshot.attendanceRecords.where(
      (value) =>
          value.sessionId == sessionId && value.membershipId == membershipId,
    );
    if (current.length > 1) return false;
    final record = AttendanceRecord(
      id: current.isEmpty ? _idFactory('attendance', now) : current.single.id,
      sessionId: sessionId,
      membershipId: membershipId,
      state: attendanceState,
      recordedAtUtc: now,
    );
    final records =
        _snapshot.attendanceRecords
            .where(
              (value) =>
                  value.sessionId != sessionId ||
                  value.membershipId != membershipId,
            )
            .toList(growable: true)
          ..add(record);
    return _persist(
      LocalClubAdministrationSnapshot(
        schemaVersion: _snapshot.schemaVersion,
        club: club,
        memberships: _snapshot.memberships,
        groups: _snapshot.groups,
        sessions: _snapshot.sessions,
        attendanceRecords: List.unmodifiable(records),
      ),
    );
  }

  Future<bool> _persist(LocalClubAdministrationSnapshot candidate) async {
    if (isBusy || !candidate.isValid) return false;
    _state = LocalClubAdministrationState.saving;
    _failure = null;
    notifyListeners();
    final result = await repository.save(candidate);
    if (!result.isSuccess) {
      _state = LocalClubAdministrationState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }
    _snapshot = result.snapshot!;
    _migrationPending = false;
    _state = LocalClubAdministrationState.ready;
    notifyListeners();
    return true;
  }
}

DateTime _utcNow() => DateTime.now().toUtc();

int _idSequence = 0;

String _defaultId(String prefix, DateTime now) =>
    '$prefix-${now.microsecondsSinceEpoch}-${_idSequence++}';

String? _normalize(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
