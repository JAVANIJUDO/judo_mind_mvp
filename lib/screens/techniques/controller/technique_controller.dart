import 'package:flutter/foundation.dart';

import '../../../models/technique_model.dart';
import '../../../core/constants/techniques.dart';



class TechniqueController extends ChangeNotifier {


  String _searchText = "";

  String _selectedCategory = "All";

  String _selectedDifficulty = "All Levels";



  String get searchText => _searchText;


  String get selectedCategory =>
      _selectedCategory;


  String get selectedDifficulty =>
      _selectedDifficulty;



  List<TechniqueModel> get techniques {


    return JudoTechniques.techniques.where((technique){


      final query =

          _searchText
              .toLowerCase()
              .trim();



      final searchMatch =


          query.isEmpty ||


          technique.nameEn
              .toLowerCase()
              .contains(query)

          ||

          technique.nameJp
              .toLowerCase()
              .contains(query)

          ||

          technique.category
              .toLowerCase()
              .contains(query);



      final categoryMatch =


          _selectedCategory == "All"

          ||

          technique.category ==
              _selectedCategory

          ||

          technique.type ==
              _selectedCategory;



      final difficultyMatch =


          _selectedDifficulty ==
              "All Levels"

          ||

          technique.difficulty ==
              _selectedDifficulty;



      return searchMatch &&
          categoryMatch &&
          difficultyMatch;


    }).toList();


  }



  void updateSearch(String value){


    _searchText = value;


    notifyListeners();

  }



  void updateCategory(String value){


    _selectedCategory = value;


    notifyListeners();

  }



  void updateDifficulty(String value){


    _selectedDifficulty = value;


    notifyListeners();

  }


}