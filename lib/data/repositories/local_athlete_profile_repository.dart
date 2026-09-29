import 'dart:convert';

import '../../models/local_athlete_profile.dart';
import '../storage/local_athlete_profile_storage.dart';

enum LocalAthleteProfileFailure {
  corruptedStorage,
  storageUnavailable,
  invalidProfile,
  writeFailed,
}

class LocalAthleteProfileLoadResult {
  const LocalAthleteProfileLoadResult.success(this.profile) : failure = null;

  const LocalAthleteProfileLoadResult.failure(this.failure) : profile = null;

  final LocalAthleteProfile? profile;
  final LocalAthleteProfileFailure? failure;

  bool get isSuccess => profile != null && failure == null;
}

class LocalAthleteProfileSaveResult {
  const LocalAthleteProfileSaveResult.success(this.profile) : failure = null;

  const LocalAthleteProfileSaveResult.failure(this.failure) : profile = null;

  final LocalAthleteProfile? profile;
  final LocalAthleteProfileFailure? failure;

  bool get isSuccess => profile != null && failure == null;
}

class LocalAthleteProfileRepository {
  const LocalAthleteProfileRepository({required this.storage});

  final LocalAthleteProfileStorage storage;

  Future<LocalAthleteProfileLoadResult> load() async {
    final String? payload;
    try {
      payload = await storage.readPayload();
    } catch (_) {
      return const LocalAthleteProfileLoadResult.failure(
        LocalAthleteProfileFailure.storageUnavailable,
      );
    }

    if (payload == null) {
      return const LocalAthleteProfileLoadResult.success(
        LocalAthleteProfile.empty(),
      );
    }

    try {
      final decoded = jsonDecode(payload);
      if (decoded is! Map<String, dynamic>) {
        throw const FormatException('Profile payload must be an object.');
      }
      return LocalAthleteProfileLoadResult.success(
        LocalAthleteProfile.fromJson(decoded),
      );
    } catch (_) {
      return const LocalAthleteProfileLoadResult.failure(
        LocalAthleteProfileFailure.corruptedStorage,
      );
    }
  }

  Future<LocalAthleteProfileSaveResult> save(
    LocalAthleteProfile profile,
  ) async {
    if (!profile.isValid) {
      return const LocalAthleteProfileSaveResult.failure(
        LocalAthleteProfileFailure.invalidProfile,
      );
    }

    final existing = await load();
    if (!existing.isSuccess) {
      return LocalAthleteProfileSaveResult.failure(existing.failure!);
    }

    try {
      final wrote = await storage.writePayload(jsonEncode(profile.toJson()));
      if (!wrote) {
        return const LocalAthleteProfileSaveResult.failure(
          LocalAthleteProfileFailure.writeFailed,
        );
      }
      return LocalAthleteProfileSaveResult.success(profile);
    } catch (_) {
      return const LocalAthleteProfileSaveResult.failure(
        LocalAthleteProfileFailure.writeFailed,
      );
    }
  }
}
