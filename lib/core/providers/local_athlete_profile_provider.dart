import 'package:flutter/foundation.dart';

import '../../data/repositories/local_athlete_profile_repository.dart';
import '../../models/local_athlete_profile.dart';

enum LocalAthleteProfileState { initial, loading, ready, saving, failure }

class LocalAthleteProfileProvider extends ChangeNotifier {
  LocalAthleteProfileProvider({required this.repository});

  final LocalAthleteProfileRepository repository;

  LocalAthleteProfileState _state = LocalAthleteProfileState.initial;
  LocalAthleteProfile _profile = const LocalAthleteProfile.empty();
  LocalAthleteProfileFailure? _failure;

  LocalAthleteProfileState get state => _state;
  LocalAthleteProfile get profile => _profile;
  LocalAthleteProfileFailure? get failure => _failure;
  bool get isBusy =>
      _state == LocalAthleteProfileState.loading ||
      _state == LocalAthleteProfileState.saving;

  Future<bool> initialize() async {
    _state = LocalAthleteProfileState.loading;
    _failure = null;
    notifyListeners();

    final result = await repository.load();
    if (!result.isSuccess) {
      _state = LocalAthleteProfileState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }

    _profile = result.profile!;
    _state = LocalAthleteProfileState.ready;
    notifyListeners();
    return true;
  }

  Future<bool> save(LocalAthleteProfile profile) async {
    if (isBusy) {
      return false;
    }
    _state = LocalAthleteProfileState.saving;
    _failure = null;
    notifyListeners();

    final result = await repository.save(profile);
    if (!result.isSuccess) {
      _state = LocalAthleteProfileState.failure;
      _failure = result.failure;
      notifyListeners();
      return false;
    }

    _profile = result.profile!;
    _state = LocalAthleteProfileState.ready;
    notifyListeners();
    return true;
  }
}
