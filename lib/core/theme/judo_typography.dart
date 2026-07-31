import 'package:flutter/material.dart';

import 'judo_design_tokens.dart';

/// ===========================================================
/// Judo Mind Design System 1.0
/// Typography Tokens
/// ===========================================================
///
/// All application text styles must gradually migrate to this
/// centralized typography system.
///
/// This file must remain independent from feature-specific code.
abstract final class JudoTypography {
  const JudoTypography._();

  // -----------------------------------------------------------
  // Display
  // -----------------------------------------------------------

  static const TextStyle displayLarge = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 36,
    height: 1.15,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.8,
  );

  static const TextStyle displayMedium = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 32,
    height: 1.18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.6,
  );

  // -----------------------------------------------------------
  // Headings
  // -----------------------------------------------------------

  static const TextStyle headingLarge = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 24,
    height: 1.25,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle headingMedium = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 20,
    height: 1.30,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle headingSmall = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 18,
    height: 1.30,
    fontWeight: FontWeight.w700,
  );

  // -----------------------------------------------------------
  // Titles
  // -----------------------------------------------------------

  static const TextStyle titleLarge = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 17,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleMedium = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 15,
    height: 1.35,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle titleSmall = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w600,
  );

  // -----------------------------------------------------------
  // Body
  // -----------------------------------------------------------

  static const TextStyle bodyLarge = TextStyle(
    color: JudoColors.textSecondary,
    fontSize: 16,
    height: 1.60,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodyMedium = TextStyle(
    color: JudoColors.textSecondary,
    fontSize: 15,
    height: 1.50,
    fontWeight: FontWeight.w400,
  );

  static const TextStyle bodySmall = TextStyle(
    color: JudoColors.textSecondary,
    fontSize: 13,
    height: 1.45,
    fontWeight: FontWeight.w400,
  );

  // -----------------------------------------------------------
  // Labels
  // -----------------------------------------------------------

  static const TextStyle labelLarge = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 14,
    height: 1.25,
    fontWeight: FontWeight.w700,
  );

  static const TextStyle labelMedium = TextStyle(
    color: JudoColors.textSecondary,
    fontSize: 12,
    height: 1.25,
    fontWeight: FontWeight.w600,
  );

  static const TextStyle labelSmall = TextStyle(
    color: JudoColors.textHint,
    fontSize: 11,
    height: 1.20,
    fontWeight: FontWeight.w600,
  );

  // -----------------------------------------------------------
  // Brand styles
  // -----------------------------------------------------------

  static const TextStyle techniqueTitle = TextStyle(
    color: JudoColors.gold,
    fontSize: 30,
    height: 1.18,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.4,
  );

  static const TextStyle sectionTitle = TextStyle(
    color: JudoColors.textPrimary,
    fontSize: 19,
    height: 1.30,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle goldSectionTitle = TextStyle(
    color: JudoColors.gold,
    fontSize: 19,
    height: 1.30,
    fontWeight: FontWeight.w800,
  );

  static const TextStyle link = TextStyle(
    color: JudoColors.primary,
    fontSize: 14,
    height: 1.35,
    fontWeight: FontWeight.w700,
    decoration: TextDecoration.underline,
    decorationColor: JudoColors.primary,
  );

  // -----------------------------------------------------------
  // Utility
  // -----------------------------------------------------------

  static TextStyle withColor(
    TextStyle style,
    Color color,
  ) {
    return style.copyWith(color: color);
  }

  static TextStyle responsiveTechniqueTitle(
    double availableWidth,
  ) {
    if (availableWidth < 360) {
      return techniqueTitle.copyWith(fontSize: 25);
    }

    if (availableWidth >= 720) {
      return techniqueTitle.copyWith(fontSize: 34);
    }

    return techniqueTitle;
  }
}