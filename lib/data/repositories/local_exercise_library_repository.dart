import 'dart:convert';

import '../../models/local_exercise_library.dart';
import '../storage/local_exercise_library_storage.dart';

enum LocalExerciseLibraryFailure {
  corruptedStorage,
  storageUnavailable,
  invalidData,
  writeFailed,
}

class LocalExerciseLibraryLoadResult {
  const LocalExerciseLibraryLoadResult.success(this.snapshot) : failure = null;

  const LocalExerciseLibraryLoadResult.failure(this.failure) : snapshot = null;

  final LocalExerciseLibrarySnapshot? snapshot;
  final LocalExerciseLibraryFailure? failure;

  bool get isSuccess => snapshot != null && failure == null;
}

class LocalExerciseLibrarySaveResult {
  const LocalExerciseLibrarySaveResult.success(this.snapshot) : failure = null;

  const LocalExerciseLibrarySaveResult.failure(this.failure) : snapshot = null;

  final LocalExerciseLibrarySnapshot? snapshot;
  final LocalExerciseLibraryFailure? failure;

  bool get isSuccess => snapshot != null && failure == null;
}

abstract interface class ExerciseLibraryRepository {
  Future<LocalExerciseLibraryLoadResult> load();

  Future<LocalExerciseLibrarySaveResult> save(
    LocalExerciseLibrarySnapshot snapshot,
  );
}

class LocalExerciseLibraryRepository implements ExerciseLibraryRepository {
  const LocalExerciseLibraryRepository({required this.storage});

  final LocalExerciseLibraryStorage storage;

  @override
  Future<LocalExerciseLibraryLoadResult> load() async {
    final String? payload;
    try {
      payload = await storage.readPayload();
    } catch (_) {
      return const LocalExerciseLibraryLoadResult.failure(
        LocalExerciseLibraryFailure.storageUnavailable,
      );
    }
    if (payload == null) {
      return const LocalExerciseLibraryLoadResult.success(
        LocalExerciseLibrarySnapshot.empty(),
      );
    }
    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Exercise library must be an object.');
      }
      return LocalExerciseLibraryLoadResult.success(
        LocalExerciseLibrarySnapshot.fromJson(decoded),
      );
    } catch (_) {
      return const LocalExerciseLibraryLoadResult.failure(
        LocalExerciseLibraryFailure.corruptedStorage,
      );
    }
  }

  @override
  Future<LocalExerciseLibrarySaveResult> save(
    LocalExerciseLibrarySnapshot snapshot,
  ) async {
    if (!snapshot.isValid) {
      return const LocalExerciseLibrarySaveResult.failure(
        LocalExerciseLibraryFailure.invalidData,
      );
    }
    final current = await load();
    if (!current.isSuccess) {
      return LocalExerciseLibrarySaveResult.failure(current.failure!);
    }
    try {
      final wrote = await storage.writePayload(jsonEncode(snapshot.toJson()));
      if (!wrote) {
        return const LocalExerciseLibrarySaveResult.failure(
          LocalExerciseLibraryFailure.writeFailed,
        );
      }
      return LocalExerciseLibrarySaveResult.success(snapshot);
    } catch (_) {
      return const LocalExerciseLibrarySaveResult.failure(
        LocalExerciseLibraryFailure.writeFailed,
      );
    }
  }
}
