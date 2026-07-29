import '../../../models/technique_model.dart';

import '../../../data/repositories/local_technique_repository.dart';
import '../../../data/sources/local/local_technique_data_source.dart';


class TechniqueRepository {


  final LocalTechniqueRepository _repository;


   TechniqueRepository()
      : _repository =  LocalTechniqueRepository(
          LocalTechniqueDataSource(),
        );



  List<TechniqueModel> getAllTechniques() {

    // Temporary synchronous adapter
    // Keeps current Controller compatible.

    return _repository
        .getTechniquesSync();

  }


}