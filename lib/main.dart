import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/l10n/language_controller.dart';
import 'l10n/app_localizations.dart';


void main() {

  runApp(
    ChangeNotifierProvider(
      create: (_) => LanguageController(),
      child: const JudoMindApp(),
    ),
  );

}



class JudoMindApp extends StatelessWidget {

  const JudoMindApp({super.key});


  @override
  Widget build(BuildContext context) {


    final languageController =
        Provider.of<LanguageController>(context);


    return MaterialApp(

      debugShowCheckedModeBanner: false,


      title: "Judo Mind",


      theme: AppTheme.darkTheme,


      locale: languageController.locale,


      localizationsDelegates: const [

        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,

        GlobalWidgetsLocalizations.delegate,

        GlobalCupertinoLocalizations.delegate,

      ],


      supportedLocales:
          AppLocalizations.supportedLocales,


      initialRoute: AppRoutes.home,


      routes: AppRoutes.routes,

    );


  }

}