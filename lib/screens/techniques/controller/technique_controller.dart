import 'package:flutter/material.dart';

import '../../../models/technique_model.dart';
import '../repository/technique_repository.dart';


class TechniqueController extends ChangeNotifier {


  final TechniqueRepository _repository =
      const TechniqueRepository();


  List<TechniqueModel> _allTechniques = [];


  List<TechniqueModel> techniques = [];


  String selectedCategory = "All";


  String selectedDifficulty = "All Levels";


  String searchText = "";



  TechniqueController(){

    loadTechniques();

  }



  void loadTechniques(){

    _allTechniques =
        _repository.getAllTechniques();


    techniques =
        _allTechniques;


  }



  void updateSearch(String value){

    searchText = value;

    _applyFilters();

  }



  void updateCategory(String value){

    selectedCategory = value;

    _applyFilters();

  }



  void updateDifficulty(String value){

    selectedDifficulty = value;

    _applyFilters();

  }



  void _applyFilters(){


    techniques =
        _allTechniques.where((technique){


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


}