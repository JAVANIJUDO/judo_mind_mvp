import 'package:shared_preferences/shared_preferences.dart';

class UserPreferencesStorage {
  static const String favoriteTechniquesKey = 'favorite_techniques';
  static const String recentTechniquesKey = 'recent_techniques';
  static const String languagePreferenceKey = 'selected_language_code_v1';

  Future<List<String>> getFavoriteTechniques() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(favoriteTechniquesKey) ?? [];
  }

  Future<void> saveFavoriteTechniques(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(favoriteTechniquesKey, ids);
  }

  Future<List<String>> getRecentTechniques() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(recentTechniquesKey) ?? [];
  }

  Future<void> saveRecentTechniques(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(recentTechniquesKey, ids);
  }

  Future<String?> getLanguageCode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(languagePreferenceKey);
  }

  Future<bool> saveLanguageCode(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(languagePreferenceKey, languageCode);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(favoriteTechniquesKey);
    await prefs.remove(recentTechniquesKey);
  }
}
