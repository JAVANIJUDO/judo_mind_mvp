import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'l10n/app_localizations.dart';


void main() {

  runApp(const JudoMindApp());

}



class JudoMindApp extends StatelessWidget {

  const JudoMindApp({super.key});


  @override
  Widget build(BuildContext context) {


    return MaterialApp(

      debugShowCheckedModeBanner: false,


      title: "Judo Mind",


      theme: AppTheme.darkTheme,


      // Localization
      localizationsDelegates: const [

        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,

      ],


      supportedLocales: AppLocalizations.supportedLocales,


      initialRoute: AppRoutes.home,


      routes: AppRoutes.routes,


    );


  }

}