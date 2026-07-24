import 'package:flutter/material.dart';

import '../../screens/home/home_screen.dart';
import '../../screens/techniques/techniques_screen.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/settings/settings_screen.dart';



class AppRoutes {


  static const String splash = "/";

  static const String home = "/home";

  static const String techniques = "/techniques";

  static const String settings = "/settings";



  static Map<String, WidgetBuilder> routes = {


  splash: (context) => const SplashScreen(),


  home: (context) => const HomeScreen(),


  techniques: (context) => const TechniquesScreen(),


  settings: (context) => const SettingsScreen(),


};


}