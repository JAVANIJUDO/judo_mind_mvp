import 'package:flutter/material.dart';

import 'judo_design_tokens.dart';
import 'judo_typography.dart';

/// ===========================================================
/// Judo Mind Design System 1.0
/// Global Application Theme
/// ===========================================================

abstract final class JudoTheme {
  const JudoTheme._();

  static ThemeData get dark {
    final colorScheme = const ColorScheme.dark(
      primary: JudoColors.primary,
      secondary: JudoColors.secondary,
      surface: JudoColors.surface,
      error: JudoColors.danger,
      onPrimary: JudoColors.white,
      onSecondary: JudoColors.white,
      onSurface: JudoColors.textPrimary,
      onError: JudoColors.white,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: JudoColors.background,

      textTheme: const TextTheme(
        displayLarge: JudoTypography.displayLarge,
        displayMedium: JudoTypography.displayMedium,
        headlineLarge: JudoTypography.headingLarge,
        headlineMedium: JudoTypography.headingMedium,
        headlineSmall: JudoTypography.headingSmall,
        titleLarge: JudoTypography.titleLarge,
        titleMedium: JudoTypography.titleMedium,
        titleSmall: JudoTypography.titleSmall,
        bodyLarge: JudoTypography.bodyLarge,
        bodyMedium: JudoTypography.bodyMedium,
        bodySmall: JudoTypography.bodySmall,
        labelLarge: JudoTypography.labelLarge,
        labelMedium: JudoTypography.labelMedium,
        labelSmall: JudoTypography.labelSmall,
      ),

      appBarTheme: const AppBarTheme(
        backgroundColor: JudoColors.background,
        foregroundColor: JudoColors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: JudoTypography.headingMedium,
        iconTheme: IconThemeData(
          color: JudoColors.textPrimary,
          size: JudoIconSize.md,
        ),
      ),

      cardTheme: CardThemeData(
        color: JudoColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.md,
          ),
          side: const BorderSide(
            color: JudoColors.border,
          ),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: JudoColors.border,
        thickness: 1,
        space: 1,
      ),

      iconTheme: const IconThemeData(
        color: JudoColors.textSecondary,
        size: JudoIconSize.md,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: JudoColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: JudoSpacing.lg,
          vertical: JudoSpacing.md,
        ),
        hintStyle: JudoTypography.bodyMedium.copyWith(
          color: JudoColors.textHint,
        ),
        labelStyle: JudoTypography.labelLarge,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.md,
          ),
          borderSide: const BorderSide(
            color: JudoColors.border,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.md,
          ),
          borderSide: const BorderSide(
            color: JudoColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.md,
          ),
          borderSide: const BorderSide(
            color: JudoColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.md,
          ),
          borderSide: const BorderSide(
            color: JudoColors.danger,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(
            0,
            JudoButtonHeight.normal,
          ),
          backgroundColor: JudoColors.primary,
          foregroundColor: JudoColors.white,
          elevation: 0,
          textStyle: JudoTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: JudoSpacing.lg,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              JudoRadius.md,
            ),
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            0,
            JudoButtonHeight.normal,
          ),
          foregroundColor: JudoColors.textPrimary,
          textStyle: JudoTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: JudoSpacing.lg,
          ),
          side: const BorderSide(
            color: JudoColors.border,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              JudoRadius.md,
            ),
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            0,
            JudoButtonHeight.compact,
          ),
          foregroundColor: JudoColors.primary,
          textStyle: JudoTypography.labelLarge,
          padding: const EdgeInsets.symmetric(
            horizontal: JudoSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              JudoRadius.sm,
            ),
          ),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: JudoColors.surfaceVariant,
        contentTextStyle: JudoTypography.bodyMedium,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.md,
          ),
        ),
      ),

      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: JudoColors.surface,
        modalBackgroundColor: JudoColors.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: false,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: JudoColors.surface,
        surfaceTintColor: Colors.transparent,
        titleTextStyle: JudoTypography.headingMedium,
        contentTextStyle: JudoTypography.bodyMedium,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            JudoRadius.lg,
          ),
        ),
      ),

      progressIndicatorTheme:
          const ProgressIndicatorThemeData(
        color: JudoColors.primary,
        linearTrackColor: JudoColors.surfaceVariant,
        circularTrackColor: JudoColors.surfaceVariant,
      ),
    );
  }
}