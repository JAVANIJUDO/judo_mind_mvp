import 'training_activity_contract.dart';

class ExerciseLocalizedContent {
  const ExerciseLocalizedContent({
    required this.name,
    required this.description,
    required this.instructions,
    required this.commonError,
    required this.safety,
  });

  final String name;
  final String? description;
  final String? instructions;
  final String? commonError;
  final String? safety;
}

class ExerciseLibraryEntry {
  const ExerciseLibraryEntry({
    required this.id,
    required this.revision,
    required this.source,
    required this.reviewStatus,
    required this.nameEn,
    required this.nameFa,
    required this.descriptionEn,
    required this.descriptionFa,
    required this.instructionsEn,
    required this.instructionsFa,
    required this.activityCategory,
    required this.modality,
    required this.equipment,
    required this.supportedDosageModes,
    required this.commonErrorEn,
    required this.commonErrorFa,
    required this.safetyEn,
    required this.safetyFa,
    required this.mediaReference,
    required this.sourceReference,
    required this.provenanceNotes,
    required this.reviewedBy,
    required this.reviewedAtUtc,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required this.archived,
  });

  static const nameMaxLength = 120;
  static const longTextMaxLength = 1200;
  static const referenceMaxLength = 500;
  static const equipmentMaxItems = 20;

  final String id;
  final int revision;
  final ExerciseLibrarySource source;
  final ExerciseReviewStatus reviewStatus;
  final String? nameEn;
  final String? nameFa;
  final String? descriptionEn;
  final String? descriptionFa;
  final String? instructionsEn;
  final String? instructionsFa;
  final TrainingSessionItemType activityCategory;
  final ExerciseModality modality;
  final List<String> equipment;
  final List<TrainingDosageMode> supportedDosageModes;
  final String? commonErrorEn;
  final String? commonErrorFa;
  final String? safetyEn;
  final String? safetyFa;
  final String? mediaReference;
  final String? sourceReference;
  final String? provenanceNotes;
  final String? reviewedBy;
  final DateTime? reviewedAtUtc;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final bool archived;

  bool get isApproved =>
      source == ExerciseLibrarySource.approvedRepository &&
      reviewStatus == ExerciseReviewStatus.approved;

  bool get isCoachAuthored => source == ExerciseLibrarySource.coachAuthored;

  bool get isValid =>
      _validId(id) &&
      revision >= 1 &&
      _validAtLeastOneName &&
      _validLocalizedFields &&
      equipment.length <= equipmentMaxItems &&
      equipment.every((value) => _validRequired(value, nameMaxLength)) &&
      equipment.toSet().length == equipment.length &&
      supportedDosageModes.isNotEmpty &&
      supportedDosageModes.toSet().length == supportedDosageModes.length &&
      _validOptional(mediaReference, referenceMaxLength) &&
      _validOptional(sourceReference, referenceMaxLength) &&
      _validOptional(provenanceNotes, longTextMaxLength) &&
      _validOptional(reviewedBy, nameMaxLength) &&
      createdAtUtc.isUtc &&
      updatedAtUtc.isUtc &&
      !updatedAtUtc.isBefore(createdAtUtc) &&
      (reviewedAtUtc == null || reviewedAtUtc!.isUtc) &&
      _validApprovalBoundary;

  bool get _validApprovalBoundary {
    if (source == ExerciseLibrarySource.coachAuthored) {
      return reviewStatus == ExerciseReviewStatus.notScientificallyReviewed &&
          reviewedBy == null &&
          reviewedAtUtc == null;
    }
    if (reviewStatus != ExerciseReviewStatus.approved) return false;
    return _validRequired(nameEn ?? '', nameMaxLength) &&
        _validRequired(nameFa ?? '', nameMaxLength) &&
        _validLocalizedPair(descriptionEn, descriptionFa, longTextMaxLength) &&
        _validLocalizedPair(
          instructionsEn,
          instructionsFa,
          longTextMaxLength,
        ) &&
        _validLocalizedPair(commonErrorEn, commonErrorFa, longTextMaxLength) &&
        _validLocalizedPair(safetyEn, safetyFa, longTextMaxLength) &&
        _validRequired(sourceReference ?? '', referenceMaxLength) &&
        _validRequired(provenanceNotes ?? '', longTextMaxLength) &&
        _validRequired(reviewedBy ?? '', nameMaxLength) &&
        reviewedAtUtc != null;
  }

  bool get _validAtLeastOneName =>
      (nameEn != null && _validRequired(nameEn!, nameMaxLength)) ||
      (nameFa != null && _validRequired(nameFa!, nameMaxLength));

  bool get _validLocalizedFields =>
      _validOptional(descriptionEn, longTextMaxLength) &&
      _validOptional(descriptionFa, longTextMaxLength) &&
      _validOptional(instructionsEn, longTextMaxLength) &&
      _validOptional(instructionsFa, longTextMaxLength) &&
      _validOptional(commonErrorEn, longTextMaxLength) &&
      _validOptional(commonErrorFa, longTextMaxLength) &&
      _validOptional(safetyEn, longTextMaxLength) &&
      _validOptional(safetyFa, longTextMaxLength);

  ExerciseLocalizedContent? resolve(String languageCode) =>
      switch (languageCode) {
        'en' when nameEn != null => ExerciseLocalizedContent(
          name: nameEn!,
          description: descriptionEn,
          instructions: instructionsEn,
          commonError: commonErrorEn,
          safety: safetyEn,
        ),
        'fa' when nameFa != null => ExerciseLocalizedContent(
          name: nameFa!,
          description: descriptionFa,
          instructions: instructionsFa,
          commonError: commonErrorFa,
          safety: safetyFa,
        ),
        _ => null,
      };

  SessionExerciseReferenceSnapshot toSessionSnapshot() =>
      SessionExerciseReferenceSnapshot(
        exerciseId: id,
        revision: revision,
        source: source,
        reviewStatus: reviewStatus,
        nameEn: nameEn,
        nameFa: nameFa,
        activityCategory: activityCategory,
        modality: modality,
        supportedDosageModes: List.unmodifiable(supportedDosageModes),
      );

  factory ExerciseLibraryEntry.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'id',
      'revision',
      'source',
      'review_status',
      'name_en',
      'name_fa',
      'description_en',
      'description_fa',
      'instructions_en',
      'instructions_fa',
      'activity_category',
      'modality',
      'equipment',
      'supported_dosage_modes',
      'common_error_en',
      'common_error_fa',
      'safety_en',
      'safety_fa',
      'media_reference',
      'source_reference',
      'provenance_notes',
      'reviewed_by',
      'reviewed_at_utc',
      'created_at_utc',
      'updated_at_utc',
      'archived',
    });
    final equipment = _stringList(json, 'equipment');
    final dosage = _stringList(json, 'supported_dosage_modes');
    final value = ExerciseLibraryEntry(
      id: _requiredString(json, 'id'),
      revision: _requiredInt(json, 'revision'),
      source: _enumValue(ExerciseLibrarySource.values, json['source']),
      reviewStatus: _enumValue(
        ExerciseReviewStatus.values,
        json['review_status'],
      ),
      nameEn: _optionalString(json, 'name_en'),
      nameFa: _optionalString(json, 'name_fa'),
      descriptionEn: _optionalString(json, 'description_en'),
      descriptionFa: _optionalString(json, 'description_fa'),
      instructionsEn: _optionalString(json, 'instructions_en'),
      instructionsFa: _optionalString(json, 'instructions_fa'),
      activityCategory: _enumValue(
        TrainingSessionItemType.values,
        json['activity_category'],
      ),
      modality: _enumValue(ExerciseModality.values, json['modality']),
      equipment: List.unmodifiable(equipment),
      supportedDosageModes: List.unmodifiable(
        dosage.map((value) => _enumValue(TrainingDosageMode.values, value)),
      ),
      commonErrorEn: _optionalString(json, 'common_error_en'),
      commonErrorFa: _optionalString(json, 'common_error_fa'),
      safetyEn: _optionalString(json, 'safety_en'),
      safetyFa: _optionalString(json, 'safety_fa'),
      mediaReference: _optionalString(json, 'media_reference'),
      sourceReference: _optionalString(json, 'source_reference'),
      provenanceNotes: _optionalString(json, 'provenance_notes'),
      reviewedBy: _optionalString(json, 'reviewed_by'),
      reviewedAtUtc: _optionalUtc(json, 'reviewed_at_utc'),
      createdAtUtc: _utc(json, 'created_at_utc'),
      updatedAtUtc: _utc(json, 'updated_at_utc'),
      archived: _requiredBool(json, 'archived'),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid exercise library entry.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'revision': revision,
    'source': source.name,
    'review_status': reviewStatus.name,
    'name_en': nameEn,
    'name_fa': nameFa,
    'description_en': descriptionEn,
    'description_fa': descriptionFa,
    'instructions_en': instructionsEn,
    'instructions_fa': instructionsFa,
    'activity_category': activityCategory.name,
    'modality': modality.name,
    'equipment': equipment,
    'supported_dosage_modes': supportedDosageModes
        .map((value) => value.name)
        .toList(growable: false),
    'common_error_en': commonErrorEn,
    'common_error_fa': commonErrorFa,
    'safety_en': safetyEn,
    'safety_fa': safetyFa,
    'media_reference': mediaReference,
    'source_reference': sourceReference,
    'provenance_notes': provenanceNotes,
    'reviewed_by': reviewedBy,
    'reviewed_at_utc': reviewedAtUtc?.toIso8601String(),
    'created_at_utc': createdAtUtc.toIso8601String(),
    'updated_at_utc': updatedAtUtc.toIso8601String(),
    'archived': archived,
  };
}

class LocalExerciseLibrarySnapshot {
  const LocalExerciseLibrarySnapshot({
    required this.schemaVersion,
    required this.entries,
  });

  const LocalExerciseLibrarySnapshot.empty()
    : schemaVersion = currentSchemaVersion,
      entries = const [];

  static const currentSchemaVersion = '1.0.0';
  static const storageScope = 'local-single-device';

  final String schemaVersion;
  final List<ExerciseLibraryEntry> entries;

  int get approvedCount => entries.where((value) => value.isApproved).length;
  int get coachAuthoredCount =>
      entries.where((value) => value.isCoachAuthored).length;

  bool get isValid =>
      schemaVersion == currentSchemaVersion &&
      entries.every((value) => value.isValid) &&
      _unique(entries.map((value) => value.id));

  factory LocalExerciseLibrarySnapshot.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'schema_version',
      'storage_scope',
      'entries',
    });
    if (json['schema_version'] != currentSchemaVersion ||
        json['storage_scope'] != storageScope) {
      throw const FormatException('Unsupported exercise library schema.');
    }
    final entries = json['entries'];
    if (entries is! List<dynamic>) {
      throw const FormatException('entries must be a list.');
    }
    final value = LocalExerciseLibrarySnapshot(
      schemaVersion: currentSchemaVersion,
      entries: List.unmodifiable(
        entries.map((value) => ExerciseLibraryEntry.fromJson(_map(value))),
      ),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid exercise library snapshot.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'storage_scope': storageScope,
    'entries': entries.map((value) => value.toJson()).toList(growable: false),
  };
}

class ExerciseLibraryUsageState {
  const ExerciseLibraryUsageState({
    required this.schemaVersion,
    required this.favoriteExerciseIds,
    required this.recentExerciseIds,
  });

  const ExerciseLibraryUsageState.empty()
    : schemaVersion = currentSchemaVersion,
      favoriteExerciseIds = const {},
      recentExerciseIds = const [];

  static const currentSchemaVersion = '1.0.0';
  static const maxRecentItems = 10;

  final String schemaVersion;
  final Set<String> favoriteExerciseIds;
  final List<String> recentExerciseIds;

  bool get isValid =>
      schemaVersion == currentSchemaVersion &&
      favoriteExerciseIds.every(_validId) &&
      recentExerciseIds.length <= maxRecentItems &&
      recentExerciseIds.every(_validId) &&
      _unique(recentExerciseIds);

  factory ExerciseLibraryUsageState.fromJson(Map<String, dynamic> json) {
    _requireExactKeys(json, const {
      'schema_version',
      'favorite_exercise_ids',
      'recent_exercise_ids',
    });
    final value = ExerciseLibraryUsageState(
      schemaVersion: _requiredString(json, 'schema_version'),
      favoriteExerciseIds: Set.unmodifiable(
        _stringList(json, 'favorite_exercise_ids'),
      ),
      recentExerciseIds: List.unmodifiable(
        _stringList(json, 'recent_exercise_ids'),
      ),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid exercise library usage state.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'schema_version': schemaVersion,
    'favorite_exercise_ids': favoriteExerciseIds.toList(growable: false)
      ..sort(),
    'recent_exercise_ids': recentExerciseIds,
  };
}

T _enumValue<T extends Enum>(List<T> values, Object? raw) {
  if (raw is! String) throw const FormatException('Enum must be text.');
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

String _requiredString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value;
  throw FormatException('$key must be text.');
}

String? _optionalString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is String) return value as String?;
  throw FormatException('$key must be text or null.');
}

int _requiredInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  throw FormatException('$key must be an integer.');
}

bool _requiredBool(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is bool) return value;
  throw FormatException('$key must be a boolean.');
}

List<String> _stringList(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is! List<dynamic> || value.any((item) => item is! String)) {
    throw FormatException('$key must contain only text.');
  }
  return value.cast<String>();
}

DateTime _utc(Map<String, dynamic> json, String key) {
  final raw = _requiredString(json, key);
  final value = DateTime.tryParse(raw);
  if (value == null || !value.isUtc || value.toIso8601String() != raw) {
    throw FormatException('$key must be a canonical UTC timestamp.');
  }
  return value;
}

DateTime? _optionalUtc(Map<String, dynamic> json, String key) {
  if (json[key] == null) return null;
  return _utc(json, key);
}

bool _validId(String value) =>
    RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:-]{0,99}$').hasMatch(value);

bool _validRequired(String value, int maxLength) =>
    value.isNotEmpty &&
    value == value.trim() &&
    value.length <= maxLength &&
    !value.contains(RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'));

bool _validOptional(String? value, int maxLength) =>
    value == null || _validRequired(value, maxLength);

bool _validLocalizedPair(String? en, String? fa, int maxLength) =>
    (en == null && fa == null) ||
    (en != null &&
        fa != null &&
        _validRequired(en, maxLength) &&
        _validRequired(fa, maxLength));

bool _unique(Iterable<String> values) {
  final list = values.toList(growable: false);
  return list.length == list.toSet().length;
}
