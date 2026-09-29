import 'training_activity_contract.dart';

export 'training_activity_contract.dart';

enum ClubStatus { active, inactive }

enum ClubMembershipStatus { active, inactive }

enum TrainingGroupStatus { active, inactive }

enum ClubTrainingSessionStatus { scheduled, completed, cancelled }

enum AttendanceState { present, absent, excused }

enum ClubSessionType {
  judoTechnical,
  randori,
  tactical,
  physicalPreparation,
  recovery,
  assessment,
  mixed,
  other,
  unspecifiedLegacy,
}

/// The current Profile is a single local-athlete record, not a multi-athlete
/// identity database. Club membership may reference only this stable local
/// slot until an approved multi-athlete identity model exists.
abstract final class LocalAthleteReference {
  static const current = 'local-athlete-profile:current';
}

class Club {
  const Club({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  static const nameMaxLength = 120;
  static const descriptionMaxLength = 500;

  final String id;
  final String name;
  final String? description;
  final ClubStatus status;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  bool get isValid =>
      _validId(id) &&
      _validRequired(name, nameMaxLength) &&
      _validOptional(description, descriptionMaxLength) &&
      _validTimestampOrder(createdAtUtc, updatedAtUtc);

  factory Club.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'name',
      'description',
      'status',
      'created_at_utc',
      'updated_at_utc',
    });
    final value = Club(
      id: _requiredString(json, 'id'),
      name: _requiredString(json, 'name'),
      description: _optionalString(json, 'description'),
      status: _enumValue(ClubStatus.values, json['status']),
      createdAtUtc: _utcDateTime(json, 'created_at_utc'),
      updatedAtUtc: _utcDateTime(json, 'updated_at_utc'),
    );
    if (!value.isValid) throw const FormatException('Invalid club.');
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'status': status.name,
    'created_at_utc': createdAtUtc.toIso8601String(),
    'updated_at_utc': updatedAtUtc.toIso8601String(),
  };
}

class ClubMembership {
  const ClubMembership({
    required this.id,
    required this.clubId,
    required this.athleteReferenceId,
    required this.status,
    required this.joinDateUtc,
    required this.membershipNumber,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  static const membershipNumberMaxLength = 80;

  final String id;
  final String clubId;
  final String athleteReferenceId;
  final ClubMembershipStatus status;
  final DateTime joinDateUtc;
  final String? membershipNumber;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  bool get isValid =>
      _validId(id) &&
      _validId(clubId) &&
      athleteReferenceId == LocalAthleteReference.current &&
      joinDateUtc.isUtc &&
      _validOptional(membershipNumber, membershipNumberMaxLength) &&
      _validTimestampOrder(createdAtUtc, updatedAtUtc);

  factory ClubMembership.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'club_id',
      'athlete_reference_id',
      'status',
      'join_date_utc',
      'membership_number',
      'created_at_utc',
      'updated_at_utc',
    });
    final value = ClubMembership(
      id: _requiredString(json, 'id'),
      clubId: _requiredString(json, 'club_id'),
      athleteReferenceId: _requiredString(json, 'athlete_reference_id'),
      status: _enumValue(ClubMembershipStatus.values, json['status']),
      joinDateUtc: _utcDateTime(json, 'join_date_utc'),
      membershipNumber: _optionalString(json, 'membership_number'),
      createdAtUtc: _utcDateTime(json, 'created_at_utc'),
      updatedAtUtc: _utcDateTime(json, 'updated_at_utc'),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid club membership.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'club_id': clubId,
    'athlete_reference_id': athleteReferenceId,
    'status': status.name,
    'join_date_utc': joinDateUtc.toIso8601String(),
    'membership_number': membershipNumber,
    'created_at_utc': createdAtUtc.toIso8601String(),
    'updated_at_utc': updatedAtUtc.toIso8601String(),
  };
}

class TrainingGroup {
  const TrainingGroup({
    required this.id,
    required this.clubId,
    required this.name,
    required this.description,
    required this.status,
    required this.membershipIds,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  static const nameMaxLength = 120;
  static const descriptionMaxLength = 500;

  final String id;
  final String clubId;
  final String name;
  final String? description;
  final TrainingGroupStatus status;
  final List<String> membershipIds;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  bool get isValid =>
      _validId(id) &&
      _validId(clubId) &&
      _validRequired(name, nameMaxLength) &&
      _validOptional(description, descriptionMaxLength) &&
      membershipIds.every(_validId) &&
      membershipIds.toSet().length == membershipIds.length &&
      _validTimestampOrder(createdAtUtc, updatedAtUtc);

  factory TrainingGroup.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'club_id',
      'name',
      'description',
      'status',
      'membership_ids',
      'created_at_utc',
      'updated_at_utc',
    });
    final membershipIds = _stringList(json, 'membership_ids');
    final value = TrainingGroup(
      id: _requiredString(json, 'id'),
      clubId: _requiredString(json, 'club_id'),
      name: _requiredString(json, 'name'),
      description: _optionalString(json, 'description'),
      status: _enumValue(TrainingGroupStatus.values, json['status']),
      membershipIds: List.unmodifiable(membershipIds),
      createdAtUtc: _utcDateTime(json, 'created_at_utc'),
      updatedAtUtc: _utcDateTime(json, 'updated_at_utc'),
    );
    if (!value.isValid) throw const FormatException('Invalid training group.');
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'club_id': clubId,
    'name': name,
    'description': description,
    'status': status.name,
    'membership_ids': membershipIds,
    'created_at_utc': createdAtUtc.toIso8601String(),
    'updated_at_utc': updatedAtUtc.toIso8601String(),
  };
}

class TrainingSessionDosage {
  const TrainingSessionDosage({
    required this.mode,
    required this.durationMinutes,
    required this.repetitions,
    required this.sets,
    required this.rounds,
    required this.roundDurationMinutes,
    required this.distanceMeters,
    required this.description,
  });

  static const descriptionMaxLength = 500;

  final TrainingDosageMode mode;
  final int? durationMinutes;
  final int? repetitions;
  final int? sets;
  final int? rounds;
  final int? roundDurationMinutes;
  final double? distanceMeters;
  final String? description;

  bool get isValid => switch (mode) {
    TrainingDosageMode.duration =>
      _positiveInt(durationMinutes) &&
          repetitions == null &&
          sets == null &&
          rounds == null &&
          roundDurationMinutes == null &&
          distanceMeters == null &&
          description == null,
    TrainingDosageMode.repetitions =>
      durationMinutes == null &&
          _positiveInt(repetitions) &&
          sets == null &&
          rounds == null &&
          roundDurationMinutes == null &&
          distanceMeters == null &&
          description == null,
    TrainingDosageMode.setsRepetitions =>
      durationMinutes == null &&
          _positiveInt(repetitions) &&
          _positiveInt(sets) &&
          rounds == null &&
          roundDurationMinutes == null &&
          distanceMeters == null &&
          description == null,
    TrainingDosageMode.roundsDuration =>
      durationMinutes == null &&
          repetitions == null &&
          sets == null &&
          _positiveInt(rounds) &&
          _positiveInt(roundDurationMinutes) &&
          distanceMeters == null &&
          description == null,
    TrainingDosageMode.distance =>
      durationMinutes == null &&
          repetitions == null &&
          sets == null &&
          rounds == null &&
          roundDurationMinutes == null &&
          distanceMeters != null &&
          distanceMeters!.isFinite &&
          distanceMeters! > 0 &&
          description == null,
    TrainingDosageMode.descriptiveCustom =>
      durationMinutes == null &&
          repetitions == null &&
          sets == null &&
          rounds == null &&
          roundDurationMinutes == null &&
          distanceMeters == null &&
          _validRequired(description ?? '', descriptionMaxLength),
  };

  factory TrainingSessionDosage.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'mode',
      'duration_minutes',
      'repetitions',
      'sets',
      'rounds',
      'round_duration_minutes',
      'distance_meters',
      'description',
    });
    final value = TrainingSessionDosage(
      mode: _enumValue(TrainingDosageMode.values, json['mode']),
      durationMinutes: _optionalInt(json, 'duration_minutes'),
      repetitions: _optionalInt(json, 'repetitions'),
      sets: _optionalInt(json, 'sets'),
      rounds: _optionalInt(json, 'rounds'),
      roundDurationMinutes: _optionalInt(json, 'round_duration_minutes'),
      distanceMeters: _optionalDouble(json, 'distance_meters'),
      description: _optionalString(json, 'description'),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid training dosage.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'mode': mode.name,
    'duration_minutes': durationMinutes,
    'repetitions': repetitions,
    'sets': sets,
    'rounds': rounds,
    'round_duration_minutes': roundDurationMinutes,
    'distance_meters': distanceMeters,
    'description': description,
  };
}

class TrainingSessionItem {
  const TrainingSessionItem({
    required this.id,
    required this.type,
    required this.customTitle,
    this.exerciseSnapshot,
    required this.order,
    required this.dosage,
    required this.restSeconds,
    required this.coachNotes,
  });

  static const titleMaxLength = 120;
  static const notesMaxLength = 1000;

  final String id;
  final TrainingSessionItemType type;
  final String? customTitle;
  final SessionExerciseReferenceSnapshot? exerciseSnapshot;
  final int order;
  final TrainingSessionDosage dosage;
  final int? restSeconds;
  final String? coachNotes;

  bool get requiresCoachAuthoredTitle =>
      type == TrainingSessionItemType.physicalConditioningCustom ||
      type == TrainingSessionItemType.customCoachAuthored;

  bool get isValid =>
      _validId(id) &&
      order >= 0 &&
      dosage.isValid &&
      (exerciseSnapshot == null ||
          (exerciseSnapshot!.isValid &&
              exerciseSnapshot!.activityCategory == type &&
              exerciseSnapshot!.supportedDosageModes.contains(dosage.mode))) &&
      (restSeconds == null || restSeconds! >= 0) &&
      _validOptional(coachNotes, notesMaxLength) &&
      (requiresCoachAuthoredTitle && exerciseSnapshot == null
          ? _validRequired(customTitle ?? '', titleMaxLength)
          : _validOptional(customTitle, titleMaxLength));

  TrainingSessionItem withOrder(int value) => TrainingSessionItem(
    id: id,
    type: type,
    customTitle: customTitle,
    exerciseSnapshot: exerciseSnapshot,
    order: value,
    dosage: dosage,
    restSeconds: restSeconds,
    coachNotes: coachNotes,
  );

  factory TrainingSessionItem.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'type',
      'custom_title',
      'exercise_snapshot',
      'order',
      'dosage',
      'rest_seconds',
      'coach_notes',
    });
    final value = TrainingSessionItem(
      id: _requiredString(json, 'id'),
      type: _enumValue(TrainingSessionItemType.values, json['type']),
      customTitle: _optionalString(json, 'custom_title'),
      exerciseSnapshot: json['exercise_snapshot'] == null
          ? null
          : SessionExerciseReferenceSnapshot.fromJson(
              _map(json['exercise_snapshot']),
            ),
      order: _requiredInt(json, 'order'),
      dosage: TrainingSessionDosage.fromJson(_map(json['dosage'])),
      restSeconds: _optionalInt(json, 'rest_seconds'),
      coachNotes: _optionalString(json, 'coach_notes'),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid training session item.');
    }
    return value;
  }

  factory TrainingSessionItem.fromSchema2Json(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'type',
      'custom_title',
      'order',
      'dosage',
      'rest_seconds',
      'coach_notes',
    });
    final value = TrainingSessionItem(
      id: _requiredString(json, 'id'),
      type: _enumValue(TrainingSessionItemType.values, json['type']),
      customTitle: _optionalString(json, 'custom_title'),
      exerciseSnapshot: null,
      order: _requiredInt(json, 'order'),
      dosage: TrainingSessionDosage.fromJson(_map(json['dosage'])),
      restSeconds: _optionalInt(json, 'rest_seconds'),
      coachNotes: _optionalString(json, 'coach_notes'),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid schema 2 session item.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'custom_title': customTitle,
    'exercise_snapshot': exerciseSnapshot?.toJson(),
    'order': order,
    'dosage': dosage.toJson(),
    'rest_seconds': restSeconds,
    'coach_notes': coachNotes,
  };
}

class ClubTrainingSession {
  const ClubTrainingSession({
    required this.id,
    required this.clubId,
    required this.groupId,
    required this.sessionType,
    required this.title,
    required this.objective,
    required this.scheduledAtUtc,
    required this.durationMinutes,
    required this.status,
    required this.items,
    required this.createdAtUtc,
    required this.updatedAtUtc,
  });

  static const titleMaxLength = 120;
  static const objectiveMaxLength = 500;

  final String id;
  final String clubId;
  final String groupId;
  final ClubSessionType sessionType;
  final String? title;
  final String? objective;
  final DateTime scheduledAtUtc;
  final int? durationMinutes;
  final ClubTrainingSessionStatus status;
  final List<TrainingSessionItem> items;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;

  bool get isValid =>
      _validId(id) &&
      _validId(clubId) &&
      _validId(groupId) &&
      _validOptional(title, titleMaxLength) &&
      _validOptional(objective, objectiveMaxLength) &&
      scheduledAtUtc.isUtc &&
      (durationMinutes == null ||
          (durationMinutes! >= 1 && durationMinutes! <= 1440)) &&
      items.every((value) => value.isValid) &&
      _unique(items.map((value) => value.id)) &&
      _ordersAreContiguous(items) &&
      _validTimestampOrder(createdAtUtc, updatedAtUtc);

  factory ClubTrainingSession.fromJson(
    Map<String, dynamic> json, {
    bool schema2Items = false,
  }) {
    _requireExactKeys(json, const {
      'id',
      'club_id',
      'group_id',
      'session_type',
      'title',
      'objective',
      'scheduled_at_utc',
      'duration_minutes',
      'status',
      'items',
      'created_at_utc',
      'updated_at_utc',
    });
    final duration = json['duration_minutes'];
    if (duration != null && duration is! int) {
      throw const FormatException('duration_minutes must be an integer.');
    }
    final value = ClubTrainingSession(
      id: _requiredString(json, 'id'),
      clubId: _requiredString(json, 'club_id'),
      groupId: _requiredString(json, 'group_id'),
      sessionType: _enumValue(ClubSessionType.values, json['session_type']),
      title: _optionalString(json, 'title'),
      objective: _optionalString(json, 'objective'),
      scheduledAtUtc: _utcDateTime(json, 'scheduled_at_utc'),
      durationMinutes: duration as int?,
      status: _enumValue(ClubTrainingSessionStatus.values, json['status']),
      items: List.unmodifiable(
        _list(json, 'items').map(
          (value) => schema2Items
              ? TrainingSessionItem.fromSchema2Json(_map(value))
              : TrainingSessionItem.fromJson(_map(value)),
        ),
      ),
      createdAtUtc: _utcDateTime(json, 'created_at_utc'),
      updatedAtUtc: _utcDateTime(json, 'updated_at_utc'),
    );
    if (!value.isValid) throw const FormatException('Invalid session.');
    return value;
  }

  factory ClubTrainingSession.fromLegacyJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'club_id',
      'group_id',
      'scheduled_at_utc',
      'duration_minutes',
      'status',
      'created_at_utc',
      'updated_at_utc',
    });
    final duration = json['duration_minutes'];
    if (duration != null && duration is! int) {
      throw const FormatException('duration_minutes must be an integer.');
    }
    final value = ClubTrainingSession(
      id: _requiredString(json, 'id'),
      clubId: _requiredString(json, 'club_id'),
      groupId: _requiredString(json, 'group_id'),
      sessionType: ClubSessionType.unspecifiedLegacy,
      title: null,
      objective: null,
      scheduledAtUtc: _utcDateTime(json, 'scheduled_at_utc'),
      durationMinutes: duration as int?,
      status: _enumValue(ClubTrainingSessionStatus.values, json['status']),
      items: const [],
      createdAtUtc: _utcDateTime(json, 'created_at_utc'),
      updatedAtUtc: _utcDateTime(json, 'updated_at_utc'),
    );
    if (!value.isValid) throw const FormatException('Invalid legacy session.');
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'club_id': clubId,
    'group_id': groupId,
    'session_type': sessionType.name,
    'title': title,
    'objective': objective,
    'scheduled_at_utc': scheduledAtUtc.toIso8601String(),
    'duration_minutes': durationMinutes,
    'status': status.name,
    'items': items.map((value) => value.toJson()).toList(),
    'created_at_utc': createdAtUtc.toIso8601String(),
    'updated_at_utc': updatedAtUtc.toIso8601String(),
  };
}

class AttendanceRecord {
  const AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.membershipId,
    required this.state,
    required this.recordedAtUtc,
  });

  final String id;
  final String sessionId;
  final String membershipId;
  final AttendanceState state;
  final DateTime recordedAtUtc;

  bool get isValid =>
      _validId(id) &&
      _validId(sessionId) &&
      _validId(membershipId) &&
      recordedAtUtc.isUtc;

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'session_id',
      'membership_id',
      'state',
      'recorded_at_utc',
    });
    final value = AttendanceRecord(
      id: _requiredString(json, 'id'),
      sessionId: _requiredString(json, 'session_id'),
      membershipId: _requiredString(json, 'membership_id'),
      state: _enumValue(AttendanceState.values, json['state']),
      recordedAtUtc: _utcDateTime(json, 'recorded_at_utc'),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid attendance record.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'session_id': sessionId,
    'membership_id': membershipId,
    'state': state.name,
    'recorded_at_utc': recordedAtUtc.toIso8601String(),
  };
}

class LocalClubAdministrationSnapshot {
  const LocalClubAdministrationSnapshot({
    required this.schemaVersion,
    required this.club,
    required this.memberships,
    required this.groups,
    required this.sessions,
    required this.attendanceRecords,
  });

  const LocalClubAdministrationSnapshot.empty()
    : schemaVersion = currentSchemaVersion,
      club = null,
      memberships = const [],
      groups = const [],
      sessions = const [],
      attendanceRecords = const [];

  static const currentSchemaVersion = '3.0.0';
  static const previousSchemaVersion = '2.0.0';
  static const legacySchemaVersion = '1.0.0';
  static const storageScope = 'local-single-device';

  final String schemaVersion;
  final Club? club;
  final List<ClubMembership> memberships;
  final List<TrainingGroup> groups;
  final List<ClubTrainingSession> sessions;
  final List<AttendanceRecord> attendanceRecords;

  int get rosterCount => memberships.length;
  int get groupCount => groups.length;
  int get sessionCount => sessions.length;
  int get recordedAttendanceCount => attendanceRecords.length;

  bool get isValid {
    if (schemaVersion != currentSchemaVersion) return false;
    if (club == null) {
      return memberships.isEmpty &&
          groups.isEmpty &&
          sessions.isEmpty &&
          attendanceRecords.isEmpty;
    }
    if (!club!.isValid ||
        memberships.any(
          (value) => !value.isValid || value.clubId != club!.id,
        ) ||
        groups.any((value) => !value.isValid || value.clubId != club!.id) ||
        sessions.any((value) => !value.isValid || value.clubId != club!.id) ||
        attendanceRecords.any((value) => !value.isValid)) {
      return false;
    }
    if (!_unique(memberships.map((value) => value.id)) ||
        !_unique(memberships.map((value) => value.athleteReferenceId)) ||
        !_unique(groups.map((value) => value.id)) ||
        !_unique(sessions.map((value) => value.id)) ||
        !_unique(attendanceRecords.map((value) => value.id))) {
      return false;
    }

    final membershipById = {for (final value in memberships) value.id: value};
    final groupById = {for (final value in groups) value.id: value};
    final sessionById = {for (final value in sessions) value.id: value};
    for (final group in groups) {
      if (group.membershipIds.any((id) => !membershipById.containsKey(id))) {
        return false;
      }
    }
    for (final session in sessions) {
      final group = groupById[session.groupId];
      if (group == null || group.clubId != session.clubId) return false;
    }
    final attendancePairs = <String>{};
    for (final record in attendanceRecords) {
      final session = sessionById[record.sessionId];
      final membership = membershipById[record.membershipId];
      final group = session == null ? null : groupById[session.groupId];
      if (session == null ||
          membership == null ||
          group == null ||
          !group.membershipIds.contains(record.membershipId) ||
          !attendancePairs.add('${record.sessionId}:${record.membershipId}')) {
        return false;
      }
    }
    return true;
  }

  factory LocalClubAdministrationSnapshot.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'schema_version',
      'storage_scope',
      'club',
      'memberships',
      'groups',
      'sessions',
      'attendance_records',
    });
    final sourceSchemaVersion = json['schema_version'];
    if ((sourceSchemaVersion != currentSchemaVersion &&
            sourceSchemaVersion != previousSchemaVersion &&
            sourceSchemaVersion != legacySchemaVersion) ||
        json['storage_scope'] != storageScope) {
      throw const FormatException('Unsupported club storage schema.');
    }
    final clubJson = json['club'];
    final value = LocalClubAdministrationSnapshot(
      schemaVersion: currentSchemaVersion,
      club: clubJson == null ? null : Club.fromJson(_map(clubJson)),
      memberships: List.unmodifiable(
        _list(
          json,
          'memberships',
        ).map((value) => ClubMembership.fromJson(_map(value))),
      ),
      groups: List.unmodifiable(
        _list(
          json,
          'groups',
        ).map((value) => TrainingGroup.fromJson(_map(value))),
      ),
      sessions: List.unmodifiable(
        _list(json, 'sessions').map(
          (value) => sourceSchemaVersion == legacySchemaVersion
              ? ClubTrainingSession.fromLegacyJson(_map(value))
              : ClubTrainingSession.fromJson(
                  _map(value),
                  schema2Items: sourceSchemaVersion == previousSchemaVersion,
                ),
        ),
      ),
      attendanceRecords: List.unmodifiable(
        _list(
          json,
          'attendance_records',
        ).map((value) => AttendanceRecord.fromJson(_map(value))),
      ),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid club administration snapshot.');
    }
    return value;
  }

  static String sourceSchemaVersion(Map<String, dynamic> json) {
    final value = json['schema_version'];
    if (value is! String) {
      throw const FormatException('schema_version must be text.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'storage_scope': storageScope,
    'club': club?.toJson(),
    'memberships': memberships.map((value) => value.toJson()).toList(),
    'groups': groups.map((value) => value.toJson()).toList(),
    'sessions': sessions.map((value) => value.toJson()).toList(),
    'attendance_records': attendanceRecords
        .map((value) => value.toJson())
        .toList(),
  };
}

T _enumValue<T extends Enum>(List<T> values, Object? raw) {
  if (raw is! String) throw const FormatException('Enum value must be text.');
  return values.singleWhere(
    (value) => value.name == raw,
    orElse: () => throw FormatException('Unsupported enum value: $raw'),
  );
}

void _requireExactKeys(Map<String, dynamic> json, Set<String> expected) {
  final keys = json.keys.toSet();
  if (keys.length != expected.length || !keys.containsAll(expected)) {
    throw const FormatException('Unexpected object fields.');
  }
}

Map<String, dynamic> _map(Object? value) {
  if (value is Map<String, dynamic>) return value;
  throw const FormatException('Expected an object.');
}

List<dynamic> _list(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is List<dynamic>) return value;
  throw FormatException('$key must be a list.');
}

List<String> _stringList(Map<String, dynamic> json, String key) {
  final values = _list(json, key);
  if (values.any((value) => value is! String)) {
    throw FormatException('$key must contain only strings.');
  }
  return values.cast<String>();
}

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value;
  throw FormatException('$key must be a string.');
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is String) return value as String?;
  throw FormatException('$key must be a string or null.');
}

DateTime _utcDateTime(Map<String, dynamic> json, String key) {
  final raw = _requiredString(json, key);
  final parsed = DateTime.tryParse(raw);
  if (parsed == null || !parsed.isUtc || parsed.toIso8601String() != raw) {
    throw FormatException('$key must be a canonical UTC timestamp.');
  }
  return parsed;
}

bool _validId(String value) =>
    RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:-]{0,99}$').hasMatch(value);

bool _validRequired(String value, int maxLength) =>
    value.isNotEmpty &&
    value == value.trim() &&
    value.length <= maxLength &&
    !_hasControlCharacters(value);

bool _validOptional(String? value, int maxLength) =>
    value == null || _validRequired(value, maxLength);

bool _validTimestampOrder(DateTime created, DateTime updated) =>
    created.isUtc && updated.isUtc && !updated.isBefore(created);

bool _unique(Iterable<String> values) {
  final list = values.toList(growable: false);
  return list.toSet().length == list.length;
}

bool _ordersAreContiguous(List<TrainingSessionItem> items) {
  for (var index = 0; index < items.length; index++) {
    if (items[index].order != index) return false;
  }
  return true;
}

bool _positiveInt(int? value) => value != null && value > 0;

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  throw FormatException('$key must be an integer.');
}

int? _optionalInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is int) return value as int?;
  throw FormatException('$key must be an integer or null.');
}

double? _optionalDouble(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null) return null;
  if (value is num) return value.toDouble();
  throw FormatException('$key must be numeric or null.');
}

bool _hasControlCharacters(String value) =>
    value.contains(RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'));
