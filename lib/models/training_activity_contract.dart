enum TrainingSessionItemType {
  warmUp,
  ukemi,
  technicalInstruction,
  uchikomi,
  nagekomi,
  gripFightingKumiKata,
  tachiWaza,
  neWaza,
  randori,
  tacticalPractice,
  coolDown,
  physicalConditioningCustom,
  customCoachAuthored,
}

enum TrainingDosageMode {
  duration,
  repetitions,
  setsRepetitions,
  roundsDuration,
  distance,
  descriptiveCustom,
}

enum ExerciseLibrarySource { approvedRepository, coachAuthored }

enum ExerciseAuthoringLocale { en, fa }

enum ExerciseReviewStatus {
  approved,
  reviewRequired,
  notScientificallyReviewed,
}

enum ExerciseModality {
  freeWeight,
  machine,
  bodyweight,
  physicalConditioning,
  resistanceBand,
  shadowTraining,
  mobilityRecovery,
  judoSpecificDrill,
  other,
}

/// Immutable exercise identity and display evidence retained by a session.
///
/// The live library entry may later be edited or archived. This snapshot keeps
/// the historical meaning of an already-saved plan unchanged.
class SessionExerciseReferenceSnapshot {
  const SessionExerciseReferenceSnapshot({
    required this.exerciseId,
    required this.revision,
    required this.source,
    required this.reviewStatus,
    required this.nameEn,
    required this.nameFa,
    required this.activityCategory,
    required this.modality,
    required this.supportedDosageModes,
  });

  final String exerciseId;
  final int revision;
  final ExerciseLibrarySource source;
  final ExerciseReviewStatus reviewStatus;
  final String? nameEn;
  final String? nameFa;
  final TrainingSessionItemType activityCategory;
  final ExerciseModality modality;
  final List<TrainingDosageMode> supportedDosageModes;

  bool get isValid =>
      _validContractId(exerciseId) &&
      revision >= 1 &&
      ((nameEn != null && _validContractText(nameEn!, 120)) ||
          (nameFa != null && _validContractText(nameFa!, 120))) &&
      supportedDosageModes.isNotEmpty &&
      supportedDosageModes.toSet().length == supportedDosageModes.length &&
      (source == ExerciseLibrarySource.approvedRepository
          ? reviewStatus == ExerciseReviewStatus.approved &&
                nameEn != null &&
                nameFa != null
          : reviewStatus == ExerciseReviewStatus.notScientificallyReviewed);

  String? localizedName(String languageCode) => switch (languageCode) {
    'en' => nameEn,
    'fa' => nameFa,
    _ => null,
  };

  factory SessionExerciseReferenceSnapshot.fromJson(Map<String, dynamic> json) {
    _requireContractKeys(json, const {
      'exercise_id',
      'revision',
      'source',
      'review_status',
      'name_en',
      'name_fa',
      'activity_category',
      'modality',
      'supported_dosage_modes',
    });
    final modes = json['supported_dosage_modes'];
    if (modes is! List<dynamic>) {
      throw const FormatException('supported_dosage_modes must be a list.');
    }
    final value = SessionExerciseReferenceSnapshot(
      exerciseId: _requiredContractString(json, 'exercise_id'),
      revision: _requiredContractInt(json, 'revision'),
      source: _contractEnum(ExerciseLibrarySource.values, json['source']),
      reviewStatus: _contractEnum(
        ExerciseReviewStatus.values,
        json['review_status'],
      ),
      nameEn: _optionalContractString(json, 'name_en'),
      nameFa: _optionalContractString(json, 'name_fa'),
      activityCategory: _contractEnum(
        TrainingSessionItemType.values,
        json['activity_category'],
      ),
      modality: _contractEnum(ExerciseModality.values, json['modality']),
      supportedDosageModes: List.unmodifiable(
        modes.map((value) => _contractEnum(TrainingDosageMode.values, value)),
      ),
    );
    if (!value.isValid) {
      throw const FormatException('Invalid exercise reference snapshot.');
    }
    return value;
  }

  Map<String, dynamic> toJson() => {
    'exercise_id': exerciseId,
    'revision': revision,
    'source': source.name,
    'review_status': reviewStatus.name,
    'name_en': nameEn,
    'name_fa': nameFa,
    'activity_category': activityCategory.name,
    'modality': modality.name,
    'supported_dosage_modes': supportedDosageModes
        .map((value) => value.name)
        .toList(growable: false),
  };
}

T _contractEnum<T extends Enum>(List<T> values, Object? raw) {
  if (raw is! String) throw const FormatException('Enum must be text.');
  return values.singleWhere(
    (value) => value.name == raw,
    orElse: () => throw FormatException('Unsupported enum value: $raw'),
  );
}

void _requireContractKeys(Map<String, dynamic> json, Set<String> expected) {
  final keys = json.keys.toSet();
  if (keys.length != expected.length || !keys.containsAll(expected)) {
    throw const FormatException('Unexpected object fields.');
  }
}

String _requiredContractString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is String) return value;
  throw FormatException('$key must be text.');
}

String? _optionalContractString(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value == null || value is String) return value as String?;
  throw FormatException('$key must be text or null.');
}

int _requiredContractInt(Map<String, dynamic> json, String key) {
  final value = json[key];
  if (value is int) return value;
  throw FormatException('$key must be an integer.');
}

bool _validContractId(String value) =>
    RegExp(r'^[A-Za-z0-9][A-Za-z0-9._:-]{0,99}$').hasMatch(value);

bool _validContractText(String value, int maxLength) =>
    value.isNotEmpty &&
    value == value.trim() &&
    value.length <= maxLength &&
    !value.contains(RegExp(r'[\u0000-\u0008\u000B\u000C\u000E-\u001F]'));
