import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalExerciseLibraryStorage {
  Future<String?> readPayload();

  Future<bool> writePayload(String payload);
}

class SharedPreferencesLocalExerciseLibraryStorage
    implements LocalExerciseLibraryStorage {
  SharedPreferencesLocalExerciseLibraryStorage({
    Future<SharedPreferences> Function()? preferencesLoader,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const storageKey = 'local_exercise_library_v1';

  final Future<SharedPreferences> Function() _preferencesLoader;

  @override
  Future<String?> readPayload() async {
    final preferences = await _preferencesLoader();
    return preferences.getString(storageKey);
  }

  @override
  Future<bool> writePayload(String payload) async {
    final preferences = await _preferencesLoader();
    return preferences.setString(storageKey, payload);
  }
}

abstract interface class LocalExerciseLibraryUsageStorage {
  Future<String?> readUsagePayload();

  Future<bool> writeUsagePayload(String payload);
}

class SharedPreferencesLocalExerciseLibraryUsageStorage
    implements LocalExerciseLibraryUsageStorage {
  SharedPreferencesLocalExerciseLibraryUsageStorage({
    Future<SharedPreferences> Function()? preferencesLoader,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const storageKey = 'local_exercise_library_usage_v1';

  final Future<SharedPreferences> Function() _preferencesLoader;

  @override
  Future<String?> readUsagePayload() async {
    final preferences = await _preferencesLoader();
    return preferences.getString(storageKey);
  }

  @override
  Future<bool> writeUsagePayload(String payload) async {
    final preferences = await _preferencesLoader();
    return preferences.setString(storageKey, payload);
  }
}
