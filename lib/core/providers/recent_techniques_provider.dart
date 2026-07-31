import 'package:flutter/foundation.dart';

import '../../data/storage/user_preferences_storage.dart';
import '../dependency_injection/injection_container.dart';

class RecentTechniquesProvider extends ChangeNotifier {
  final UserPreferencesStorage _storage =
      sl<UserPreferencesStorage>();

  final List<String> _recentTechniqueIds = [];

  bool _isInitialized = false;

  List<String> get recentTechniqueIds =>
      List.unmodifiable(_recentTechniqueIds);

  bool get isInitialized => _isInitialized;

  Future<void> initialize() async {
    if (_isInitialized) return;

    final savedTechniqueIds =
        await _storage.getRecentTechniques();

    _recentTechniqueIds
      ..clear()
      ..addAll(savedTechniqueIds);

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> addRecentTechnique(
    String techniqueId,
  ) async {
    _recentTechniqueIds.remove(techniqueId);
    _recentTechniqueIds.insert(0, techniqueId);

    if (_recentTechniqueIds.length > 10) {
      _recentTechniqueIds.removeRange(
        10,
        _recentTechniqueIds.length,
      );
    }

    await _storage.saveRecentTechniques(
      _recentTechniqueIds,
    );

    notifyListeners();
  }

  Future<void> removeRecentTechnique(
    String techniqueId,
  ) async {
    _recentTechniqueIds.remove(techniqueId);

    await _storage.saveRecentTechniques(
      _recentTechniqueIds,
    );

    notifyListeners();
  }

  Future<void> clearRecentTechniques() async {
    _recentTechniqueIds.clear();

    await _storage.saveRecentTechniques(
      _recentTechniqueIds,
    );

    notifyListeners();
  }

  bool contains(String techniqueId) {
    return _recentTechniqueIds.contains(techniqueId);
  }
}