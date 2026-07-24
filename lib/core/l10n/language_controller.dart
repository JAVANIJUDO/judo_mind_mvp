import 'package:flutter/material.dart';


class LanguageController extends ChangeNotifier {

  Locale _locale = const Locale('en');


  Locale get locale => _locale;



  void changeLanguage(String languageCode) {


    switch (languageCode) {

      case 'fa':

        _locale = const Locale('fa');

        break;


      case 'ar':

        _locale = const Locale('ar');

        break;


      case 'ja':

        _locale = const Locale('ja');

        break;


      case 'fr':

        _locale = const Locale('fr');

        break;


      case 'de':

        _locale = const Locale('de');

        break;


      case 'ru':

        _locale = const Locale('ru');

        break;


      default:

        _locale = const Locale('en');

    }


    notifyListeners();

  }



  bool get isRTL {


    return _locale.languageCode == 'fa' ||
        _locale.languageCode == 'ar';

  }

}