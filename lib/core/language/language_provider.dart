import 'package:flutter/material.dart';

import '../../data/storage/user_preferences_storage.dart';
import 'app_language.dart';

class LanguageProvider extends ChangeNotifier {
  LanguageProvider({UserPreferencesStorage? storage})
    : _storage = storage ?? UserPreferencesStorage();

  final UserPreferencesStorage _storage;

  AppLanguage _currentLanguage = AppLanguage.english;
  bool _initialized = false;

  AppLanguage get currentLanguage => _currentLanguage;
  String get languageCode => _currentLanguage.code;
  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    AppLanguage restored = AppLanguage.english;
    try {
      final storedCode = await _storage.getLanguageCode();
      restored = AppLanguage.values.firstWhere(
        (language) => language.code == storedCode,
        orElse: () => AppLanguage.english,
      );
    } catch (_) {
      restored = AppLanguage.english;
    }
    _currentLanguage = restored;
    _initialized = true;
    notifyListeners();
  }

  /// Applies the locale immediately, then persists the selected language.
  Future<bool> changeLanguage(AppLanguage language) async {
    if (_currentLanguage != language) {
      _currentLanguage = language;
      notifyListeners();
    }
    try {
      return await _storage.saveLanguageCode(language.code);
    } catch (_) {
      return false;
    }
  }
}
