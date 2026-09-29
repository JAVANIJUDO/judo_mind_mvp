import 'dart:convert';
import 'dart:typed_data';

import '../../models/local_exercise_library.dart';
import '../../models/training_activity_contract.dart';

typedef ExerciseCsvClock = DateTime Function();

abstract final class ExerciseLibraryCsvContract {
  static const schemaVersion = '1.0.0';
  static const listSeparator = '|';
  static const headers = <String>[
    'schema_version',
    'exercise_id',
    'authoring_locale',
    'name_en',
    'name_fa',
    'description_en',
    'description_fa',
    'activity_category',
    'modality',
    'equipment',
    'supported_dosage_modes',
    'instructions_en',
    'instructions_fa',
    'safety_en',
    'safety_fa',
    'source_title',
    'source_url',
    'media_reference',
    'media_license_status',
    'coach_notes',
  ];
}

enum ExerciseCsvIssueCode {
  emptyFile,
  invalidUtf8,
  malformedCsv,
  malformedHeader,
  unsupportedSchema,
  missingId,
  duplicateInFile,
  duplicateStored,
  invalidAuthoringLocale,
  missingRequiredName,
  invalidActivityCategory,
  invalidModality,
  invalidDosageMode,
  invalidSourceUrl,
  invalidMediaLicense,
  mediaLicenseRequired,
  invalidRecord,
}

class ExerciseCsvIssue {
  const ExerciseCsvIssue({
    required this.code,
    required this.rowNumber,
    this.field,
    this.value,
  });

  final ExerciseCsvIssueCode code;
  final int rowNumber;
  final String? field;
  final String? value;
}

class ExerciseCsvRowResult {
  const ExerciseCsvRowResult({
    required this.rowNumber,
    required this.exerciseId,
    required this.entry,
    required this.issues,
  });

  final int rowNumber;
  final String? exerciseId;
  final ExerciseLibraryEntry? entry;
  final List<ExerciseCsvIssue> issues;

  bool get isValid => entry != null && issues.isEmpty;
}

class ExerciseCsvPreview {
  const ExerciseCsvPreview({required this.rows, required this.fileIssues});

  final List<ExerciseCsvRowResult> rows;
  final List<ExerciseCsvIssue> fileIssues;

  int get totalRows => rows.length;
  int get validRows => rows.where((row) => row.isValid).length;
  int get invalidRows => totalRows - validRows;
  int get duplicateRows => rows
      .where(
        (row) => row.issues.any(
          (issue) =>
              issue.code == ExerciseCsvIssueCode.duplicateInFile ||
              issue.code == ExerciseCsvIssueCode.duplicateStored,
        ),
      )
      .length;
  List<ExerciseLibraryEntry> get validEntries => List.unmodifiable(
    rows.where((row) => row.isValid).map((row) => row.entry!),
  );
  bool get canImport => fileIssues.isEmpty && validEntries.isNotEmpty;
}

class ExerciseLibraryCsvImporter {
  ExerciseLibraryCsvImporter({ExerciseCsvClock? clock})
    : _clock = clock ?? _utcNow;

  final ExerciseCsvClock _clock;

  ExerciseCsvPreview parseBytes(
    Uint8List bytes, {
    Set<String> existingExerciseIds = const {},
  }) {
    String text;
    try {
      text = utf8.decode(bytes, allowMalformed: false);
    } on FormatException {
      return const ExerciseCsvPreview(
        rows: [],
        fileIssues: [
          ExerciseCsvIssue(
            code: ExerciseCsvIssueCode.invalidUtf8,
            rowNumber: 1,
          ),
        ],
      );
    }
    return parseText(text, existingExerciseIds: existingExerciseIds);
  }

  ExerciseCsvPreview parseText(
    String text, {
    Set<String> existingExerciseIds = const {},
  }) {
    if (text.startsWith('\ufeff')) text = text.substring(1);
    if (text.trim().isEmpty) {
      return const ExerciseCsvPreview(
        rows: [],
        fileIssues: [
          ExerciseCsvIssue(code: ExerciseCsvIssueCode.emptyFile, rowNumber: 1),
        ],
      );
    }

    late final List<List<String>> records;
    try {
      records = _decodeCsv(text);
    } on FormatException {
      return const ExerciseCsvPreview(
        rows: [],
        fileIssues: [
          ExerciseCsvIssue(
            code: ExerciseCsvIssueCode.malformedCsv,
            rowNumber: 1,
          ),
        ],
      );
    }
    if (records.isEmpty || !_sameHeader(records.first)) {
      return const ExerciseCsvPreview(
        rows: [],
        fileIssues: [
          ExerciseCsvIssue(
            code: ExerciseCsvIssueCode.malformedHeader,
            rowNumber: 1,
          ),
        ],
      );
    }

    final dataRows = records
        .skip(1)
        .where((row) => row.any((v) => v.isNotEmpty));
    final normalized = dataRows.toList(growable: false);
    final idCounts = <String, int>{};
    for (final row in normalized) {
      if (row.length == ExerciseLibraryCsvContract.headers.length) {
        final id = row[1].trim();
        if (id.isNotEmpty) idCounts[id] = (idCounts[id] ?? 0) + 1;
      }
    }
    final now = _clock().toUtc();
    final results = <ExerciseCsvRowResult>[];
    for (var index = 0; index < normalized.length; index++) {
      results.add(
        _parseRow(
          normalized[index],
          rowNumber: index + 2,
          now: now,
          existingIds: existingExerciseIds,
          idCounts: idCounts,
        ),
      );
    }
    return ExerciseCsvPreview(
      rows: List.unmodifiable(results),
      fileIssues: const [],
    );
  }

  ExerciseCsvRowResult _parseRow(
    List<String> row, {
    required int rowNumber,
    required DateTime now,
    required Set<String> existingIds,
    required Map<String, int> idCounts,
  }) {
    final issues = <ExerciseCsvIssue>[];
    if (row.length != ExerciseLibraryCsvContract.headers.length) {
      return ExerciseCsvRowResult(
        rowNumber: rowNumber,
        exerciseId: null,
        entry: null,
        issues: [
          ExerciseCsvIssue(
            code: ExerciseCsvIssueCode.malformedCsv,
            rowNumber: rowNumber,
          ),
        ],
      );
    }
    final values = <String, String>{
      for (var i = 0; i < ExerciseLibraryCsvContract.headers.length; i++)
        ExerciseLibraryCsvContract.headers[i]: row[i].trim(),
    };
    void issue(ExerciseCsvIssueCode code, String field) => issues.add(
      ExerciseCsvIssue(
        code: code,
        rowNumber: rowNumber,
        field: field,
        value: values[field],
      ),
    );

    if (values['schema_version'] != ExerciseLibraryCsvContract.schemaVersion) {
      issue(ExerciseCsvIssueCode.unsupportedSchema, 'schema_version');
    }
    final id = values['exercise_id']!;
    if (id.isEmpty) {
      issue(ExerciseCsvIssueCode.missingId, 'exercise_id');
    } else {
      if ((idCounts[id] ?? 0) > 1) {
        issue(ExerciseCsvIssueCode.duplicateInFile, 'exercise_id');
      }
      if (existingIds.contains(id)) {
        issue(ExerciseCsvIssueCode.duplicateStored, 'exercise_id');
      }
    }

    final locale = _enumOrNull(
      ExerciseAuthoringLocale.values,
      values['authoring_locale']!,
    );
    if (locale == null) {
      issue(ExerciseCsvIssueCode.invalidAuthoringLocale, 'authoring_locale');
    } else if ((locale == ExerciseAuthoringLocale.en &&
            values['name_en']!.isEmpty) ||
        (locale == ExerciseAuthoringLocale.fa && values['name_fa']!.isEmpty)) {
      issue(ExerciseCsvIssueCode.missingRequiredName, 'name_${locale.name}');
    }
    final category = _enumOrNull(
      TrainingSessionItemType.values,
      values['activity_category']!,
    );
    if (category == null) {
      issue(ExerciseCsvIssueCode.invalidActivityCategory, 'activity_category');
    }
    final modality = _enumOrNull(ExerciseModality.values, values['modality']!);
    if (modality == null) {
      issue(ExerciseCsvIssueCode.invalidModality, 'modality');
    }
    final dosage = _parseEnumList(
      TrainingDosageMode.values,
      values['supported_dosage_modes']!,
    );
    if (dosage == null || dosage.isEmpty) {
      issue(ExerciseCsvIssueCode.invalidDosageMode, 'supported_dosage_modes');
    }
    final sourceUrl = _optional(values['source_url']!);
    if (sourceUrl != null && !_validSourceUrl(sourceUrl)) {
      issue(ExerciseCsvIssueCode.invalidSourceUrl, 'source_url');
    }
    final license = values['media_license_status']!;
    const licenses = {'not_provided', 'owned_or_licensed', 'review_required'};
    if (!licenses.contains(license)) {
      issue(ExerciseCsvIssueCode.invalidMediaLicense, 'media_license_status');
    }
    final media = _optional(values['media_reference']!);
    if (media != null && license != 'owned_or_licensed') {
      issue(ExerciseCsvIssueCode.mediaLicenseRequired, 'media_reference');
    }
    if (issues.isNotEmpty) {
      return ExerciseCsvRowResult(
        rowNumber: rowNumber,
        exerciseId: _optional(id),
        entry: null,
        issues: List.unmodifiable(issues),
      );
    }

    final notes = <String>[
      if (values['source_title']!.isNotEmpty)
        'source_title=${values['source_title']}',
      'media_license_status=$license',
      if (values['coach_notes']!.isNotEmpty)
        'coach_notes=${values['coach_notes']}',
    ].join('\n');
    final entry = ExerciseLibraryEntry(
      id: id,
      revision: 1,
      source: ExerciseLibrarySource.coachAuthored,
      reviewStatus: ExerciseReviewStatus.notScientificallyReviewed,
      nameEn: _optional(values['name_en']!),
      nameFa: _optional(values['name_fa']!),
      descriptionEn: _optional(values['description_en']!),
      descriptionFa: _optional(values['description_fa']!),
      instructionsEn: _optional(values['instructions_en']!),
      instructionsFa: _optional(values['instructions_fa']!),
      activityCategory: category!,
      modality: modality!,
      equipment: List.unmodifiable(_splitList(values['equipment']!)),
      supportedDosageModes: List.unmodifiable(dosage!),
      commonErrorEn: null,
      commonErrorFa: null,
      safetyEn: _optional(values['safety_en']!),
      safetyFa: _optional(values['safety_fa']!),
      mediaReference: media,
      sourceReference: sourceUrl,
      provenanceNotes: notes,
      reviewedBy: null,
      reviewedAtUtc: null,
      createdAtUtc: now,
      updatedAtUtc: now,
      archived: false,
    );
    if (!entry.isValid) {
      issues.add(
        ExerciseCsvIssue(
          code: ExerciseCsvIssueCode.invalidRecord,
          rowNumber: rowNumber,
        ),
      );
    }
    return ExerciseCsvRowResult(
      rowNumber: rowNumber,
      exerciseId: id,
      entry: issues.isEmpty ? entry : null,
      issues: List.unmodifiable(issues),
    );
  }
}

List<List<String>> _decodeCsv(String source) {
  final records = <List<String>>[];
  var record = <String>[];
  final field = StringBuffer();
  var quoted = false;
  var afterQuote = false;

  void finishField() {
    record.add(field.toString());
    field.clear();
    afterQuote = false;
  }

  void finishRecord() {
    finishField();
    records.add(List.unmodifiable(record));
    record = <String>[];
  }

  for (var i = 0; i < source.length; i++) {
    final char = source[i];
    if (quoted) {
      if (char == '"') {
        if (i + 1 < source.length && source[i + 1] == '"') {
          field.write('"');
          i++;
        } else {
          quoted = false;
          afterQuote = true;
        }
      } else {
        field.write(char);
      }
      continue;
    }
    if (afterQuote && char != ',' && char != '\r' && char != '\n') {
      throw const FormatException('Characters after closing quote.');
    }
    if (char == '"') {
      if (field.isNotEmpty) throw const FormatException('Quote inside field.');
      quoted = true;
    } else if (char == ',') {
      finishField();
    } else if (char == '\r' || char == '\n') {
      if (char == '\r' && i + 1 < source.length && source[i + 1] == '\n') i++;
      finishRecord();
    } else {
      field.write(char);
    }
  }
  if (quoted) throw const FormatException('Unclosed quoted field.');
  if (field.isNotEmpty || record.isNotEmpty) finishRecord();
  return records;
}

bool _sameHeader(List<String> actual) =>
    actual.length == ExerciseLibraryCsvContract.headers.length &&
    List.generate(
      actual.length,
      (i) => actual[i] == ExerciseLibraryCsvContract.headers[i],
    ).every((value) => value);

T? _enumOrNull<T extends Enum>(List<T> values, String raw) {
  for (final value in values) {
    if (value.name == raw) return value;
  }
  return null;
}

List<T>? _parseEnumList<T extends Enum>(List<T> values, String raw) {
  final parts = _splitList(raw);
  final result = <T>[];
  for (final part in parts) {
    final value = _enumOrNull(values, part);
    if (value == null || result.contains(value)) return null;
    result.add(value);
  }
  return result;
}

List<String> _splitList(String raw) => raw
    .split(ExerciseLibraryCsvContract.listSeparator)
    .map((value) => value.trim())
    .where((value) => value.isNotEmpty)
    .toSet()
    .toList(growable: false);

String? _optional(String value) => value.isEmpty ? null : value;

bool _validSourceUrl(String raw) {
  final uri = Uri.tryParse(raw);
  if (uri == null ||
      !uri.isAbsolute ||
      (uri.scheme != 'http' && uri.scheme != 'https')) {
    return false;
  }
  if (uri.pathSegments.any((part) => part.toLowerCase() == 'search')) {
    return false;
  }
  final keys = uri.queryParameters.keys.map((key) => key.toLowerCase()).toSet();
  return !keys.any({'q', 'query', 'search'}.contains);
}

DateTime _utcNow() => DateTime.now().toUtc();
