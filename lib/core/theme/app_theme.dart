import 'package:flutter/material.dart';

class AppTheme {
  static const Color background = Color(0xFF050505);

  static const Color card = Color(0xFF121212);

  static const Color primaryBlue = Color(0xFF0066FF);

  static const Color gold = Color(0xFFD4AF37);

  static const Color white = Color(0xFFFFFFFF);


  static ThemeData darkTheme = ThemeData(

    brightness: Brightness.dark,

    scaffoldBackgroundColor: background,

    primaryColor: primaryBlue,


    colorScheme: const ColorScheme.dark(
      primary: primaryBlue,
      secondary: gold,
      surface: card,
    ),


    textTheme: const TextTheme(

      headlineLarge: TextStyle(
        color: white,
        fontSize: 32,
        fontWeight: FontWeight.bold,
      ),


      titleLarge: TextStyle(
        color: white,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),


      bodyMedium: TextStyle(
        color: white,
        fontSize: 16,
      ),

    ),

  );
}