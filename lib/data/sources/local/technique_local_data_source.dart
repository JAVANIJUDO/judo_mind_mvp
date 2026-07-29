import '../../../models/technique_model.dart';

/// Contract for reading technique content from local sources.
///
/// The current implementation can read data from Dart constants.
/// Later implementations may read from:
/// - Local JSON files
/// - SQLite / Drift
/// - Hive / Isar
/// - Cached API responses
abstract class TechniqueLocalDataSource {
  /// Returns all locally available techniques.
  Future<List<TechniqueModel>> getTechniques();

  /// Returns a technique matching [id].
  ///
  /// Returns null when no technique with the requested ID exists.
  Future<TechniqueModel?> getTechniqueById(String id);

  /// Temporary synchronous API used only during migration.
  ///
  /// This method will be removed after TechniqueController is retired.
  List<TechniqueModel> getTechniquesSync();
}