import 'dart:convert';

import '../../models/local_attempt_history_record.dart';
import '../../models/single_attempt_analysis_v2a.dart';
import '../storage/local_attempt_history_storage.dart';

enum LocalAttemptHistoryFailure {
  corruptedStorage,
  storageUnavailable,
  invalidResult,
  writeFailed,
}

enum LocalAttemptSaveOutcome { saved, alreadySaved, failure }

class LocalAttemptHistoryLoadResult {
  const LocalAttemptHistoryLoadResult.success(this.records) : failure = null;

  const LocalAttemptHistoryLoadResult.failure(this.failure)
    : records = const [];

  final List<LocalAttemptHistoryRecord> records;
  final LocalAttemptHistoryFailure? failure;

  bool get isSuccess => failure == null;
}

class LocalAttemptHistorySaveResult {
  const LocalAttemptHistorySaveResult({
    required this.outcome,
    this.record,
    this.failure,
  });

  final LocalAttemptSaveOutcome outcome;
  final LocalAttemptHistoryRecord? record;
  final LocalAttemptHistoryFailure? failure;
}

class LocalAttemptHistoryRepository {
  LocalAttemptHistoryRepository({
    required this.storage,
    DateTime Function()? utcNow,
  }) : _utcNow = utcNow ?? (() => DateTime.now().toUtc());

  static const envelopeSchemaVersion = '1.0.0';

  final LocalAttemptHistoryStorage storage;
  final DateTime Function() _utcNow;

  Future<LocalAttemptHistoryLoadResult> load() async {
    final String? payload;
    try {
      payload = await storage.readPayload();
    } catch (_) {
      return const LocalAttemptHistoryLoadResult.failure(
        LocalAttemptHistoryFailure.storageUnavailable,
      );
    }

    if (payload == null) {
      return const LocalAttemptHistoryLoadResult.success([]);
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('History envelope must be an object.');
      }
      if (decoded['schema_version'] != envelopeSchemaVersion) {
        throw const FormatException('Unsupported history envelope schema.');
      }
      final rawRecords = decoded['records'];
      if (rawRecords is! List) {
        throw const FormatException('History records must be a list.');
      }
      final records = rawRecords
          .map(
            (item) => LocalAttemptHistoryRecord.fromJson(
              _asMap(item, 'history record'),
            ),
          )
          .toList(growable: false);
      if (records.map((record) => record.analysisId).toSet().length !=
          records.length) {
        throw const FormatException(
          'History contains duplicate analysis identifiers.',
        );
      }
      return LocalAttemptHistoryLoadResult.success(
        List.unmodifiable(_sortRecords(records)),
      );
    } catch (_) {
      return const LocalAttemptHistoryLoadResult.failure(
        LocalAttemptHistoryFailure.corruptedStorage,
      );
    }
  }

  Future<LocalAttemptHistorySaveResult> save(
    SingleAttemptAnalysisV2A result,
  ) async {
    if (!result.hasExpectedScientificBoundary) {
      return const LocalAttemptHistorySaveResult(
        outcome: LocalAttemptSaveOutcome.failure,
        failure: LocalAttemptHistoryFailure.invalidResult,
      );
    }

    final existing = await load();
    if (!existing.isSuccess) {
      return LocalAttemptHistorySaveResult(
        outcome: LocalAttemptSaveOutcome.failure,
        failure: existing.failure,
      );
    }

    final duplicate = existing.records.where(
      (record) => record.analysisId == result.analysisId,
    );
    if (duplicate.isNotEmpty) {
      return LocalAttemptHistorySaveResult(
        outcome: LocalAttemptSaveOutcome.alreadySaved,
        record: duplicate.single,
      );
    }

    final LocalAttemptHistoryRecord record;
    try {
      record = LocalAttemptHistoryRecord.fromAnalysis(
        result,
        savedAtUtc: _utcNow(),
      );
    } catch (_) {
      return const LocalAttemptHistorySaveResult(
        outcome: LocalAttemptSaveOutcome.failure,
        failure: LocalAttemptHistoryFailure.invalidResult,
      );
    }

    final records = _sortRecords([...existing.records, record]);
    final payload = jsonEncode({
      'schema_version': envelopeSchemaVersion,
      'records': records.map((item) => item.toJson()).toList(),
    });

    try {
      final wrote = await storage.writePayload(payload);
      if (!wrote) {
        return const LocalAttemptHistorySaveResult(
          outcome: LocalAttemptSaveOutcome.failure,
          failure: LocalAttemptHistoryFailure.writeFailed,
        );
      }
    } catch (_) {
      return const LocalAttemptHistorySaveResult(
        outcome: LocalAttemptSaveOutcome.failure,
        failure: LocalAttemptHistoryFailure.writeFailed,
      );
    }

    return LocalAttemptHistorySaveResult(
      outcome: LocalAttemptSaveOutcome.saved,
      record: record,
    );
  }

  /// Clears only the versioned local attempt-history envelope.
  ///
  /// Existing malformed storage is not silently overwritten. A caller must
  /// first have a valid load result before this explicit destructive action
  /// can succeed.
  Future<LocalAttemptHistoryLoadResult> clear() async {
    final existing = await load();
    if (!existing.isSuccess) {
      return existing;
    }

    final payload = jsonEncode({
      'schema_version': envelopeSchemaVersion,
      'records': const <Object>[],
    });
    try {
      final wrote = await storage.writePayload(payload);
      if (!wrote) {
        return const LocalAttemptHistoryLoadResult.failure(
          LocalAttemptHistoryFailure.writeFailed,
        );
      }
      return const LocalAttemptHistoryLoadResult.success([]);
    } catch (_) {
      return const LocalAttemptHistoryLoadResult.failure(
        LocalAttemptHistoryFailure.writeFailed,
      );
    }
  }

  static List<LocalAttemptHistoryRecord> _sortRecords(
    Iterable<LocalAttemptHistoryRecord> records,
  ) {
    return records.toList(growable: false)..sort((left, right) {
      final byTime = right.savedAtUtc.compareTo(left.savedAtUtc);
      return byTime != 0 ? byTime : left.analysisId.compareTo(right.analysisId);
    });
  }
}

Map<String, dynamic> _asMap(Object? value, String name) {
  if (value is Map<String, dynamic>) {
    return value;
  }
  throw FormatException('$name must be an object.');
}
