import 'package:flutter/material.dart';

import 'app_language.dart';


class LanguageProvider extends ChangeNotifier {


  AppLanguage _currentLanguage = AppLanguage.english;


  AppLanguage get currentLanguage => _currentLanguage;



  String get languageCode =>
      _currentLanguage.code;



  void changeLanguage(AppLanguage language) {


    _currentLanguage = language;


    notifyListeners();

  }


}