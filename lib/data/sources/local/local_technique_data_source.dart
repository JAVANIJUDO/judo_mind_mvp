import '../../../core/constants/techniques.dart';
import '../../../models/technique_model.dart';
import 'technique_local_data_source.dart';


class LocalTechniqueDataSource implements TechniqueLocalDataSource {


  @override
  Future<List<TechniqueModel>> getTechniques() async {

    return JudoTechniques.techniques;

  }



  @override
  Future<TechniqueModel?> getTechniqueById(
    String id,
  ) async {

    try {

      return JudoTechniques.techniques.firstWhere(
        (technique) => technique.id == id,
      );

    } catch (_) {

      return null;

    }

  }



  // Migration adapter
  // Keeps old Controller compatible
  // while moving data access to new architecture.
  @override
  List<TechniqueModel> getTechniquesSync() {

    return JudoTechniques.techniques;

  }


}