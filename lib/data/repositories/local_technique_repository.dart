import '../../models/technique_model.dart';

import '../sources/local/technique_local_data_source.dart';
import 'technique_repository.dart';


class LocalTechniqueRepository implements TechniqueRepository {


  final TechniqueLocalDataSource dataSource;


  const LocalTechniqueRepository(
    this.dataSource,
  );


  @override
  Future<List<TechniqueModel>> getTechniques() async {

    return dataSource.getTechniques();

  }



  @override
  Future<TechniqueModel?> getTechniqueById(
    String id,
  ) async {

    return dataSource.getTechniqueById(id);

  }



  // Temporary sync adapter
  // Used during migration from old controller.

  List<TechniqueModel> getTechniquesSync() {

    return dataSource.getTechniquesSync();

  }


}