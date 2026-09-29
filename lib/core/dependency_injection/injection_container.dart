import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../core/ai/analysis/single_camera_analysis_service.dart';
import '../../core/ai/analysis/single_attempt_v2a_service.dart';
import '../../core/ai/analysis/guided_single_attempt_v2a_service.dart';
import '../../data/ai/http_guided_single_attempt_v2a_service.dart';
import '../../data/ai/http_single_attempt_v2a_service.dart';
import '../../data/ai/http_single_camera_analysis_service.dart';
import '../../data/repositories/local_attempt_history_repository.dart';
import '../../data/repositories/local_athlete_profile_repository.dart';
import '../../data/repositories/local_club_administration_repository.dart';
import '../../data/repositories/local_exercise_library_repository.dart';
import '../../data/storage/user_preferences_storage.dart';
import '../../data/storage/local_attempt_history_storage.dart';
import '../../data/storage/local_athlete_profile_storage.dart';
import '../../data/storage/local_club_administration_storage.dart';
import '../../data/storage/local_exercise_library_storage.dart';
import '../../data/repositories/local_technique_repository.dart';
import '../../data/sources/local/local_technique_data_source.dart';
import '../../data/sources/local/technique_local_data_source.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  if (!sl.isRegistered<TechniqueLocalDataSource>()) {
    sl.registerLazySingleton<TechniqueLocalDataSource>(
      () => LocalTechniqueDataSource(),
    );
  }

  if (!sl.isRegistered<LocalTechniqueRepository>()) {
    sl.registerLazySingleton<LocalTechniqueRepository>(
      () => LocalTechniqueRepository(sl<TechniqueLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<UserPreferencesStorage>()) {
    sl.registerLazySingleton<UserPreferencesStorage>(
      () => UserPreferencesStorage(),
    );
  }

  if (!sl.isRegistered<LocalAttemptHistoryStorage>()) {
    sl.registerLazySingleton<LocalAttemptHistoryStorage>(
      SharedPreferencesLocalAttemptHistoryStorage.new,
    );
  }

  if (!sl.isRegistered<LocalAttemptHistoryRepository>()) {
    sl.registerLazySingleton<LocalAttemptHistoryRepository>(
      () => LocalAttemptHistoryRepository(
        storage: sl<LocalAttemptHistoryStorage>(),
      ),
    );
  }

  if (!sl.isRegistered<LocalAthleteProfileStorage>()) {
    sl.registerLazySingleton<LocalAthleteProfileStorage>(
      SharedPreferencesLocalAthleteProfileStorage.new,
    );
  }

  if (!sl.isRegistered<LocalAthleteProfileRepository>()) {
    sl.registerLazySingleton<LocalAthleteProfileRepository>(
      () => LocalAthleteProfileRepository(
        storage: sl<LocalAthleteProfileStorage>(),
      ),
    );
  }

  if (!sl.isRegistered<LocalClubAdministrationStorage>()) {
    sl.registerLazySingleton<LocalClubAdministrationStorage>(
      SharedPreferencesLocalClubAdministrationStorage.new,
    );
  }

  if (!sl.isRegistered<ClubAdministrationRepository>()) {
    sl.registerLazySingleton<ClubAdministrationRepository>(
      () => LocalClubAdministrationRepository(
        storage: sl<LocalClubAdministrationStorage>(),
      ),
    );
  }

  if (!sl.isRegistered<LocalExerciseLibraryStorage>()) {
    sl.registerLazySingleton<LocalExerciseLibraryStorage>(
      SharedPreferencesLocalExerciseLibraryStorage.new,
    );
  }

  if (!sl.isRegistered<LocalExerciseLibraryUsageStorage>()) {
    sl.registerLazySingleton<LocalExerciseLibraryUsageStorage>(
      SharedPreferencesLocalExerciseLibraryUsageStorage.new,
    );
  }

  if (!sl.isRegistered<ExerciseLibraryRepository>()) {
    sl.registerLazySingleton<ExerciseLibraryRepository>(
      () => LocalExerciseLibraryRepository(
        storage: sl<LocalExerciseLibraryStorage>(),
      ),
    );
  }

  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(
      http.Client.new,
      dispose: (client) => client.close(),
    );
  }

  if (!sl.isRegistered<SingleCameraAnalysisService>()) {
    sl.registerLazySingleton<SingleCameraAnalysisService>(
      () => HttpSingleCameraAnalysisService(client: sl<http.Client>()),
    );
  }

  if (!sl.isRegistered<SingleAttemptV2AService>()) {
    sl.registerLazySingleton<SingleAttemptV2AService>(
      () => HttpSingleAttemptV2AService(client: sl<http.Client>()),
    );
  }

  if (!sl.isRegistered<GuidedSingleAttemptV2AService>()) {
    sl.registerLazySingleton<GuidedSingleAttemptV2AService>(
      () => HttpGuidedSingleAttemptV2AService(client: sl<http.Client>()),
    );
  }
}
