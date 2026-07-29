import 'package:flutter/material.dart';

import '../../data/repositories/local_technique_repository.dart';
import '../../data/sources/local/local_technique_data_source.dart';
import '../../models/technique_model.dart';


class TechniqueProvider extends ChangeNotifier {


  late final LocalTechniqueRepository repository;


  List<TechniqueModel> techniques = [];


  TechniqueProvider() {

    final dataSource =
        LocalTechniqueDataSource();


    repository =
        LocalTechniqueRepository(
          dataSource,
        );


    loadTechniques();

  }



  Future<void> loadTechniques() async {


    techniques =
        await repository.getTechniques();


    notifyListeners();

  }



  TechniqueModel? getById(String id) {


    try {

      return techniques.firstWhere(
        (item) => item.id == id,
      );

    } catch (_) {

      return null;

    }

  }


}