import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/providers/local_athlete_profile_provider.dart';
import 'package:judo_mind/data/repositories/local_athlete_profile_repository.dart';
import 'package:judo_mind/data/storage/local_athlete_profile_storage.dart';
import 'package:judo_mind/models/local_athlete_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('profile normalizes optional input and round-trips strict JSON', () {
    final profile = LocalAthleteProfile.fromInput(
      displayName: '  Mohammad  ',
      beltRank: 'Black belt',
      club: '',
      country: 'Iran',
      biography: 'Judoka and coach.',
    );
    final decoded = LocalAthleteProfile.fromJson(
      jsonDecode(jsonEncode(profile.toJson())) as Map<String, dynamic>,
    );

    expect(decoded.isValid, isTrue);
    expect(decoded.displayName, 'Mohammad');
    expect(decoded.club, isNull);
    expect(decoded.toJson()['provenance'], 'self-reported');
    expect(decoded.toJson()['storage_scope'], 'local-device');
  });

  test('unsupported, extra, typed and oversized fields fail closed', () {
    final baseline = LocalAthleteProfile.fromInput(
      displayName: 'Judoka',
    ).toJson();
    final mutations = <void Function(Map<String, dynamic>)>[
      (json) => json['schema_version'] = '2.0.0',
      (json) => json['provenance'] = 'verified',
      (json) => json['official_ranking'] = 1,
      (json) => json['display_name'] = 42,
      (json) => json['biography'] = 'x' * 501,
    ];

    for (final mutate in mutations) {
      final json = Map<String, dynamic>.from(baseline);
      mutate(json);
      expect(() => LocalAthleteProfile.fromJson(json), throwsFormatException);
    }
  });

  test(
    'missing storage is empty and SharedPreferences survives recreation',
    () async {
      SharedPreferences.setMockInitialValues({});
      LocalAthleteProfileRepository repository() =>
          LocalAthleteProfileRepository(
            storage: SharedPreferencesLocalAthleteProfileStorage(),
          );

      final empty = await repository().load();
      final saved = await repository().save(
        LocalAthleteProfile.fromInput(displayName: 'Local Judoka'),
      );
      final recreated = await repository().load();

      expect(empty.isSuccess, isTrue);
      expect(empty.profile!.isEmpty, isTrue);
      expect(saved.isSuccess, isTrue);
      expect(recreated.profile!.displayName, 'Local Judoka');
    },
  );

  test('corrupted storage fails closed and is not overwritten', () async {
    final storage = _MemoryProfileStorage(payload: '{invalid');
    final repository = LocalAthleteProfileRepository(storage: storage);

    final loaded = await repository.load();
    final saved = await repository.save(
      LocalAthleteProfile.fromInput(displayName: 'Replacement'),
    );

    expect(loaded.failure, LocalAthleteProfileFailure.corruptedStorage);
    expect(saved.failure, LocalAthleteProfileFailure.corruptedStorage);
    expect(storage.writeCount, 0);
    expect(storage.payload, '{invalid');
  });

  test('provider exposes loading, ready and write failure', () async {
    final provider = LocalAthleteProfileProvider(
      repository: LocalAthleteProfileRepository(
        storage: _MemoryProfileStorage(),
      ),
    );
    expect(await provider.initialize(), isTrue);
    expect(provider.state, LocalAthleteProfileState.ready);

    final failed = LocalAthleteProfileProvider(
      repository: LocalAthleteProfileRepository(
        storage: _MemoryProfileStorage(writeSucceeds: false),
      ),
    );
    expect(await failed.initialize(), isTrue);
    expect(
      await failed.save(LocalAthleteProfile.fromInput(displayName: 'Judoka')),
      isFalse,
    );
    expect(failed.state, LocalAthleteProfileState.failure);
    expect(failed.failure, LocalAthleteProfileFailure.writeFailed);
  });
}

class _MemoryProfileStorage implements LocalAthleteProfileStorage {
  _MemoryProfileStorage({this.payload, this.writeSucceeds = true});

  String? payload;
  final bool writeSucceeds;
  int writeCount = 0;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    writeCount++;
    if (writeSucceeds) {
      payload = value;
    }
    return writeSucceeds;
  }
}
