import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/l10n/language_controller.dart';
import 'l10n/app_localizations.dart';
import 'core/language/language_provider.dart';
import 'screens/techniques/controller/technique_controller.dart';
import 'core/providers/technique_provider.dart';

void main() {

  runApp(

    MultiProvider(

      providers: [

  ChangeNotifierProvider(
    create: (_) => LanguageProvider(),
  ),

  // فعلاً حفظ می‌شود
  ChangeNotifierProvider(
    create: (_) => TechniqueController(),
  ),

  // معماری جدید
  ChangeNotifierProvider(
    create: (_) => TechniqueProvider(),
  ),

],


      child: const JudoMindApp(),

    ),

  );

}



class JudoMindApp extends StatelessWidget {

  const JudoMindApp({super.key});


  @override
  Widget build(BuildContext context) {


    final languageProvider =
    Provider.of<LanguageProvider>(context);


    return MaterialApp(

      debugShowCheckedModeBanner: false,


      title: "Judo Mind",


      theme: AppTheme.darkTheme,


      locale: Locale(languageProvider.languageCode),


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