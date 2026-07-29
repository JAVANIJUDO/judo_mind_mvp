import 'package:flutter/foundation.dart';

import '../../data/storage/user_preferences_storage.dart';
import '../dependency_injection/injection_container.dart';

class FavoriteProvider extends ChangeNotifier {
  FavoriteProvider({
    UserPreferencesStorage? storage,
  }) : _storage = storage ?? sl<UserPreferencesStorage>();

  final UserPreferencesStorage _storage;

  final Set<String> _favoriteTechniqueIds = <String>{};

  bool _isLoading = false;
  bool _isInitialized = false;

  Set<String> get favoriteTechniqueIds =>
      Set<String>.unmodifiable(_favoriteTechniqueIds);

  bool get isLoading => _isLoading;

  bool get isInitialized => _isInitialized;

  int get favoritesCount => _favoriteTechniqueIds.length;

  Future<void> initialize() async {
    if (_isInitialized || _isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final storedIds = await _storage.getFavoriteTechniques();

      _favoriteTechniqueIds
        ..clear()
        ..addAll(storedIds);

      _isInitialized = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool isFavorite(String techniqueId) {
    return _favoriteTechniqueIds.contains(techniqueId);
  }

  Future<void> toggleFavorite(String techniqueId) async {
    if (techniqueId.trim().isEmpty) {
      return;
    }

    if (_favoriteTechniqueIds.contains(techniqueId)) {
      _favoriteTechniqueIds.remove(techniqueId);
    } else {
      _favoriteTechniqueIds.add(techniqueId);
    }

    notifyListeners();

    await _saveFavorites();
  }

  Future<void> addFavorite(String techniqueId) async {
    if (techniqueId.trim().isEmpty) {
      return;
    }

    final wasAdded = _favoriteTechniqueIds.add(techniqueId);

    if (!wasAdded) {
      return;
    }

    notifyListeners();
    await _saveFavorites();
  }

  Future<void> removeFavorite(String techniqueId) async {
    final wasRemoved = _favoriteTechniqueIds.remove(techniqueId);

    if (!wasRemoved) {
      return;
    }

    notifyListeners();
    await _saveFavorites();
  }

  Future<void> clearFavorites() async {
    if (_favoriteTechniqueIds.isEmpty) {
      return;
    }

    _favoriteTechniqueIds.clear();
    notifyListeners();

    await _saveFavorites();
  }

  Future<void> _saveFavorites() async {
    await _storage.saveFavoriteTechniques(
      _favoriteTechniqueIds.toList(growable: false),
    );
  }
}