import '../../../models/technique_model.dart';
import '../../../data/techniques/technique_factory.dart';

class TechniqueRepository {


  const TechniqueRepository();


  List<TechniqueModel> getAllTechniques(){

return TechniqueFactory.allTechniques;
  }


}