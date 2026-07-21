import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';


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



      initialRoute: AppRoutes.home,



      routes: AppRoutes.routes,


    );


  }

}