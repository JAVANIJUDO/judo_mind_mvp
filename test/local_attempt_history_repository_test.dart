import 'package:flutter_test/flutter_test.dart';
import 'package:judo_mind/core/providers/local_attempt_history_provider.dart';
import 'package:judo_mind/data/repositories/local_attempt_history_repository.dart';
import 'package:judo_mind/data/storage/local_attempt_history_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'support/single_attempt_v2a_fixture.dart';

void main() {
  test('missing storage is valid empty history', () async {
    final repository = LocalAttemptHistoryRepository(storage: _MemoryStorage());

    final result = await repository.load();

    expect(result.isSuccess, isTrue);
    expect(result.records, isEmpty);
  });

  test(
    'save, recreation, deduplication and ordering are deterministic',
    () async {
      final storage = _MemoryStorage();
      var now = DateTime.utc(2026, 8, 12, 3, 20);
      LocalAttemptHistoryRepository repository() =>
          LocalAttemptHistoryRepository(storage: storage, utcNow: () => now);

      final first = await repository().save(
        validSingleAttemptV2AResult(analysisId: 'analysis-b'),
      );
      now = DateTime.utc(2026, 8, 12, 3, 21);
      final second = await repository().save(
        validSingleAttemptV2AResult(analysisId: 'analysis-a'),
      );
      final duplicate = await repository().save(
        validSingleAttemptV2AResult(analysisId: 'analysis-a'),
      );
      final recreated = await repository().load();

      expect(first.outcome, LocalAttemptSaveOutcome.saved);
      expect(second.outcome, LocalAttemptSaveOutcome.saved);
      expect(duplicate.outcome, LocalAttemptSaveOutcome.alreadySaved);
      expect(storage.writeCount, 2);
      expect(recreated.isSuccess, isTrue);
      expect(recreated.records.map((record) => record.analysisId), [
        'analysis-a',
        'analysis-b',
      ]);
    },
  );

  test('SharedPreferences storage survives repository recreation', () async {
    SharedPreferences.setMockInitialValues({});
    final firstRepository = LocalAttemptHistoryRepository(
      storage: SharedPreferencesLocalAttemptHistoryStorage(),
      utcNow: () => DateTime.utc(2026, 8, 12, 3, 22),
    );

    final saved = await firstRepository.save(validSingleAttemptV2AResult());
    final recreatedRepository = LocalAttemptHistoryRepository(
      storage: SharedPreferencesLocalAttemptHistoryStorage(),
    );
    final loaded = await recreatedRepository.load();

    expect(saved.outcome, LocalAttemptSaveOutcome.saved);
    expect(loaded.isSuccess, isTrue);
    expect(loaded.records, hasLength(1));
    expect(loaded.records.single.analysisId, 'analysis-v2a-history-fixture');
  });

  test('corrupted payload fails closed and is never overwritten', () async {
    final storage = _MemoryStorage(payload: '{not-valid-json');
    final repository = LocalAttemptHistoryRepository(storage: storage);

    final loaded = await repository.load();
    final save = await repository.save(validSingleAttemptV2AResult());

    expect(loaded.failure, LocalAttemptHistoryFailure.corruptedStorage);
    expect(save.outcome, LocalAttemptSaveOutcome.failure);
    expect(save.failure, LocalAttemptHistoryFailure.corruptedStorage);
    expect(storage.writeCount, 0);
    expect(storage.payload, '{not-valid-json');
  });

  test(
    'provider exposes explicit saved, already-saved and failure states',
    () async {
      final storage = _MemoryStorage();
      final repository = LocalAttemptHistoryRepository(storage: storage);
      final result = validSingleAttemptV2AResult();

      final firstProvider = LocalAttemptHistoryProvider(repository: repository);
      expect(storage.writeCount, 0, reason: 'Provider must not auto-save.');
      firstProvider.prepareResult(result.analysisId);
      expect(
        storage.writeCount,
        0,
        reason: 'Preparing a result must not save.',
      );
      await firstProvider.save(result);
      expect(firstProvider.saveState, LocalAttemptSaveState.saved);

      final recreatedProvider = LocalAttemptHistoryProvider(
        repository: LocalAttemptHistoryRepository(storage: storage),
      );
      expect(await recreatedProvider.initialize(), isTrue);
      expect(recreatedProvider.records, hasLength(1));
      await recreatedProvider.save(result);
      expect(recreatedProvider.saveState, LocalAttemptSaveState.alreadySaved);

      final failedProvider = LocalAttemptHistoryProvider(
        repository: LocalAttemptHistoryRepository(
          storage: _MemoryStorage(writeSucceeds: false),
        ),
      );
      await failedProvider.save(result);
      expect(failedProvider.saveState, LocalAttemptSaveState.failure);
      expect(failedProvider.failure, LocalAttemptHistoryFailure.writeFailed);
    },
  );
}

class _MemoryStorage implements LocalAttemptHistoryStorage {
  _MemoryStorage({this.payload, this.writeSucceeds = true});

  String? payload;
  bool writeSucceeds;
  int writeCount = 0;

  @override
  Future<String?> readPayload() async => payload;

  @override
  Future<bool> writePayload(String value) async {
    writeCount += 1;
    if (writeSucceeds) {
      payload = value;
    }
    return writeSucceeds;
  }
}
