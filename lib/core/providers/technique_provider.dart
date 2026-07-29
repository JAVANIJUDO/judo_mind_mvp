import '../dependency_injection/injection_container.dart';
import 'package:flutter/material.dart';
import '../../core/dependency_injection/injection_container.dart';
import '../../data/repositories/local_technique_repository.dart';
import '../../models/technique_model.dart';


class TechniqueProvider extends ChangeNotifier {


  final LocalTechniqueRepository repository =
      sl<LocalTechniqueRepository>();


  List<TechniqueModel> _allTechniques = [];


  List<TechniqueModel> techniques = [];


  String selectedCategory = "All";


  String selectedDifficulty = "All Levels";


  String searchText = "";



  TechniqueProvider() {

    loadTechniques();

  }



  void loadTechniques() {

    _allTechniques =
        repository.getTechniquesSync();


    techniques =
        _allTechniques;


    notifyListeners();

  }



  void updateSearch(String value) {

    searchText = value;

    _applyFilters();

  }



  void updateCategory(String value) {

    selectedCategory = value;

    _applyFilters();

  }



  void updateDifficulty(String value) {

    selectedDifficulty = value;

    _applyFilters();

  }



  void _applyFilters() {


    techniques =
        _allTechniques.where((technique) {


      final queryMatch =

          searchText.isEmpty ||

          technique.nameEn
              .toLowerCase()
              .contains(
                searchText.toLowerCase(),
              );



      final categoryMatch =

          selectedCategory == "All" ||

          technique.category ==
              selectedCategory ||

          technique.type ==
              selectedCategory;



      final difficultyMatch =

          selectedDifficulty ==
              "All Levels" ||

          technique.difficulty ==
              selectedDifficulty;



      return queryMatch &&
          categoryMatch &&
          difficultyMatch;


    }).toList();


    notifyListeners();

  }



  TechniqueModel? getById(String id) {

    try {

      return _allTechniques.firstWhere(
        (item) => item.id == id,
      );

    } catch (_) {

      return null;

    }

  }


}