import 'package:flutter/material.dart';

/// ===========================================================
/// Judo Mind Design System 1.0
/// Design Tokens
/// ===========================================================

class JudoColors {
  JudoColors._();

  static const background = Color(0xFF050505);
  static const surface = Color(0xFF111111);
  static const surfaceVariant = Color(0xFF1B1B1B);

  static const primary = Color(0xFF0066FF);
  static const secondary = Color(0xFF00A8E8);

  static const gold = Color(0xFFD4AF37);

  static const success = Color(0xFF00B894);
  static const warning = Color(0xFFFFB020);
  static const danger = Color(0xFFFF5A5F);

  static const white = Colors.white;

  static const textPrimary = Colors.white;
  static const textSecondary = Colors.white70;
  static const textHint = Colors.white54;

  static const border = Color(0x22FFFFFF);
}

class JudoRadius {
  JudoRadius._();

  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 28.0;
}

class JudoSpacing {
  JudoSpacing._();

  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const xxxl = 40.0;
}

class JudoIconSize {
  JudoIconSize._();

  static const sm = 18.0;
  static const md = 22.0;
  static const lg = 28.0;
  static const xl = 36.0;
}

class JudoButtonHeight {
  JudoButtonHeight._();

  static const compact = 40.0;
  static const normal = 46.0;
  static const large = 54.0;
}

class JudoAnimation {
  JudoAnimation._();

  static const fast = Duration(milliseconds: 150);
  static const normal = Duration(milliseconds: 250);
  static const slow = Duration(milliseconds: 450);
}