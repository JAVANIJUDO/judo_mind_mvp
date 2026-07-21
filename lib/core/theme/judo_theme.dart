import 'package:flutter/material.dart';

import 'judo_colors.dart';


class JudoTheme {


  static ThemeData darkTheme = ThemeData(

    brightness: Brightness.dark,


    scaffoldBackgroundColor:
        JudoColors.background,


    primaryColor:
        JudoColors.electricBlue,


    colorScheme: const ColorScheme.dark(

      primary:
          JudoColors.electricBlue,

      secondary:
          JudoColors.judoGold,

      surface:
          JudoColors.card,

    ),



    appBarTheme: const AppBarTheme(

      backgroundColor:
          JudoColors.background,

      elevation: 0,

      centerTitle: true,


      titleTextStyle:

          TextStyle(

            color:
                JudoColors.textPrimary,

            fontSize: 22,

            fontWeight:
                FontWeight.bold,

          ),

    ),




    cardTheme: CardThemeData(

      color:
          JudoColors.card,

      elevation: 0,


      shape:
          RoundedRectangleBorder(

            borderRadius:
                BorderRadius.all(

              Radius.circular(20),

            ),

          ),

    ),




    textTheme: const TextTheme(


      headlineLarge:

          TextStyle(

            color:
                JudoColors.textPrimary,

            fontSize: 32,

            fontWeight:
                FontWeight.bold,

          ),



      headlineMedium:

          TextStyle(

            color:
                JudoColors.textPrimary,

            fontSize: 24,

            fontWeight:
                FontWeight.bold,

          ),



      titleLarge:

          TextStyle(

            color:
                JudoColors.textPrimary,

            fontSize: 18,

            fontWeight:
                FontWeight.w600,

          ),



      bodyLarge:

          TextStyle(

            color:
                JudoColors.textSecondary,

            fontSize: 16,

          ),


    ),




    elevatedButtonTheme:

        ElevatedButtonThemeData(


      style:

          ElevatedButton.styleFrom(

            backgroundColor:
                JudoColors.electricBlue,


            foregroundColor:
                Colors.white,


            minimumSize:

                const Size(

                  double.infinity,

                  52,

                ),



            shape:

                RoundedRectangleBorder(

                  borderRadius:
                      BorderRadius.circular(16),

                ),



            textStyle:

                const TextStyle(

                  fontSize: 16,

                  fontWeight:
                      FontWeight.bold,

                ),

          ),

    ),



  );


}