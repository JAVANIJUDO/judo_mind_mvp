import 'package:get_it/get_it.dart';

import '../../data/repositories/local_technique_repository.dart';
import '../../data/sources/local/local_technique_data_source.dart';
import '../../data/sources/local/technique_local_data_source.dart';

final GetIt sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<TechniqueLocalDataSource>(
    () => LocalTechniqueDataSource(),
  );

  sl.registerLazySingleton<LocalTechniqueRepository>(
    () => LocalTechniqueRepository(
      sl<TechniqueLocalDataSource>(),
    ),
  );
}