import '../../models/technique_model.dart';


abstract class TechniqueRepository {


  Future<List<TechniqueModel>> getTechniques();


  Future<TechniqueModel?> getTechniqueById(
    String id,
  );


}