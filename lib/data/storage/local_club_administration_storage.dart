import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalClubAdministrationStorage {
  Future<String?> readPayload();

  Future<bool> writePayload(String payload);
}

class SharedPreferencesLocalClubAdministrationStorage
    implements LocalClubAdministrationStorage {
  SharedPreferencesLocalClubAdministrationStorage({
    Future<SharedPreferences> Function()? preferencesLoader,
  }) : _preferencesLoader = preferencesLoader ?? SharedPreferences.getInstance;

  static const storageKey = 'local_club_administration_v1';

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
