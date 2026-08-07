import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../core/ai/analysis/single_camera_analysis_service.dart';
import '../../data/ai/http_single_camera_analysis_service.dart';
import '../../data/storage/user_preferences_storage.dart';
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
}
