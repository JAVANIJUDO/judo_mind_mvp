import 'package:flutter/foundation.dart';

import '../../data/repositories/local_attempt_history_repository.dart';
import '../../models/local_attempt_history_record.dart';
import '../../models/single_attempt_analysis_v2a.dart';

enum LocalAttemptSaveState { idle, saving, saved, alreadySaved, failure }

enum LocalAttemptHistoryLoadState { initial, loading, ready, failure }

class LocalAttemptHistoryProvider extends ChangeNotifier {
  LocalAttemptHistoryProvider({required this.repository});

  final LocalAttemptHistoryRepository repository;

  List<LocalAttemptHistoryRecord> _records = const [];
  LocalAttemptHistoryLoadState _loadState =
      LocalAttemptHistoryLoadState.initial;
  LocalAttemptSaveState _saveState = LocalAttemptSaveState.idle;
  LocalAttemptHistoryFailure? _failure;
  String? _preparedAnalysisId;
  bool _isClearing = false;

  List<LocalAttemptHistoryRecord> get records => _records;
  LocalAttemptHistoryLoadState get loadState => _loadState;
  LocalAttemptSaveState get saveState => _saveState;
  LocalAttemptHistoryFailure? get failure => _failure;
  bool get isSaving => _saveState == LocalAttemptSaveState.saving;
  bool get isClearing => _isClearing;

  void prepareResult(String analysisId) {
    if (_preparedAnalysisId == analysisId) {
      return;
    }
    _preparedAnalysisId = analysisId;
    _saveState = LocalAttemptSaveState.idle;
    _failure = null;
    notifyListeners();
  }

  Future<bool> initialize() async {
    _loadState = LocalAttemptHistoryLoadState.loading;
    _failure = null;
    notifyListeners();
    final result = await repository.load();
    if (!result.isSuccess) {
      _loadState = LocalAttemptHistoryLoadState.failure;
      _failure = result.failure;
      _saveState = LocalAttemptSaveState.failure;
      notifyListeners();
      return false;
    }
    _records = result.records;
    _loadState = LocalAttemptHistoryLoadState.ready;
    _failure = null;
    notifyListeners();
    return true;
  }

  Future<void> save(SingleAttemptAnalysisV2A result) async {
    if (isSaving) {
      return;
    }
    prepareResult(result.analysisId);
    _saveState = LocalAttemptSaveState.saving;
    _failure = null;
    notifyListeners();

    final saveResult = await repository.save(result);
    switch (saveResult.outcome) {
      case LocalAttemptSaveOutcome.saved:
        _saveState = LocalAttemptSaveState.saved;
        await _refreshAfterSave();
        break;
      case LocalAttemptSaveOutcome.alreadySaved:
        _saveState = LocalAttemptSaveState.alreadySaved;
        await _refreshAfterSave();
        break;
      case LocalAttemptSaveOutcome.failure:
        _saveState = LocalAttemptSaveState.failure;
        _failure = saveResult.failure;
        break;
    }
    notifyListeners();
  }

  Future<bool> clearHistory() async {
    if (_isClearing || _loadState != LocalAttemptHistoryLoadState.ready) {
      return false;
    }
    _isClearing = true;
    _failure = null;
    notifyListeners();

    final result = await repository.clear();
    _isClearing = false;
    if (!result.isSuccess) {
      _loadState = LocalAttemptHistoryLoadState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }

    _records = const [];
    _loadState = LocalAttemptHistoryLoadState.ready;
    _failure = null;
    notifyListeners();
    return true;
  }

  Future<void> _refreshAfterSave() async {
    final loaded = await repository.load();
    if (loaded.isSuccess) {
      _records = loaded.records;
      _loadState = LocalAttemptHistoryLoadState.ready;
      return;
    }
    _loadState = LocalAttemptHistoryLoadState.failure;
    _saveState = LocalAttemptSaveState.failure;
    _failure = loaded.failure;
  }
}
