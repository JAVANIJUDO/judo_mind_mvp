import 'dart:convert';

import '../../models/local_club_administration.dart';
import '../storage/local_club_administration_storage.dart';

enum LocalClubAdministrationFailure {
  corruptedStorage,
  storageUnavailable,
  invalidData,
  writeFailed,
}

class LocalClubAdministrationLoadResult {
  const LocalClubAdministrationLoadResult.success(
    this.snapshot, {
    required this.sourceSchemaVersion,
    required this.wasMigrated,
  }) : failure = null;

  const LocalClubAdministrationLoadResult.failure(this.failure)
    : snapshot = null,
      sourceSchemaVersion = null,
      wasMigrated = false;

  final LocalClubAdministrationSnapshot? snapshot;
  final LocalClubAdministrationFailure? failure;
  final String? sourceSchemaVersion;
  final bool wasMigrated;

  bool get isSuccess => snapshot != null && failure == null;
}

class LocalClubAdministrationSaveResult {
  const LocalClubAdministrationSaveResult.success(this.snapshot)
    : failure = null;

  const LocalClubAdministrationSaveResult.failure(this.failure)
    : snapshot = null;

  final LocalClubAdministrationSnapshot? snapshot;
  final LocalClubAdministrationFailure? failure;

  bool get isSuccess => snapshot != null && failure == null;
}

abstract interface class ClubAdministrationRepository {
  Future<LocalClubAdministrationLoadResult> load();

  Future<LocalClubAdministrationSaveResult> save(
    LocalClubAdministrationSnapshot snapshot,
  );
}

class LocalClubAdministrationRepository
    implements ClubAdministrationRepository {
  const LocalClubAdministrationRepository({required this.storage});

  final LocalClubAdministrationStorage storage;

  @override
  Future<LocalClubAdministrationLoadResult> load() async {
    final String? payload;
    try {
      payload = await storage.readPayload();
    } catch (_) {
      return const LocalClubAdministrationLoadResult.failure(
        LocalClubAdministrationFailure.storageUnavailable,
      );
    }

    if (payload == null) {
      return const LocalClubAdministrationLoadResult.success(
        LocalClubAdministrationSnapshot.empty(),
        sourceSchemaVersion:
            LocalClubAdministrationSnapshot.currentSchemaVersion,
        wasMigrated: false,
      );
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Club payload must be an object.');
      }
      final sourceSchemaVersion =
          LocalClubAdministrationSnapshot.sourceSchemaVersion(decoded);
      return LocalClubAdministrationLoadResult.success(
        LocalClubAdministrationSnapshot.fromJson(decoded),
        sourceSchemaVersion: sourceSchemaVersion,
        wasMigrated:
            sourceSchemaVersion !=
            LocalClubAdministrationSnapshot.currentSchemaVersion,
      );
    } catch (_) {
      return const LocalClubAdministrationLoadResult.failure(
        LocalClubAdministrationFailure.corruptedStorage,
      );
    }
  }

  @override
  Future<LocalClubAdministrationSaveResult> save(
    LocalClubAdministrationSnapshot snapshot,
  ) async {
    if (!snapshot.isValid) {
      return const LocalClubAdministrationSaveResult.failure(
        LocalClubAdministrationFailure.invalidData,
      );
    }

    final current = await load();
    if (!current.isSuccess) {
      return LocalClubAdministrationSaveResult.failure(current.failure!);
    }

    try {
      final wrote = await storage.writePayload(jsonEncode(snapshot.toJson()));
      if (!wrote) {
        return const LocalClubAdministrationSaveResult.failure(
          LocalClubAdministrationFailure.writeFailed,
        );
      }
      return LocalClubAdministrationSaveResult.success(snapshot);
    } catch (_) {
      return const LocalClubAdministrationSaveResult.failure(
        LocalClubAdministrationFailure.writeFailed,
      );
    }
  }
}
