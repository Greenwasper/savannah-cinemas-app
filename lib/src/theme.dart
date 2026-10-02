import 'package:flutter/material.dart';

abstract final class SavannahColors {
  static const background = Color(0xFF14141C);
  static const surface = Color(0xFF1E1E2A);
  static const surfaceRaised = Color(0xFF292939);
  static const line = Color(0xFF353549);
  static const text = Color(0xFFF2EADB);
  static const muted = Color(0xFF9E9CAF);
  static const gold = Color(0xFFEDAA3B);
  static const goldInk = Color(0xFF1B1204);
  static const clay = Color(0xFFD2512F);
}

abstract final class SavannahTheme {
  static ThemeData get dark {
    final scheme =
        ColorScheme.fromSeed(
          seedColor: SavannahColors.gold,
          brightness: Brightness.dark,
          surface: SavannahColors.surface,
        ).copyWith(
          primary: SavannahColors.gold,
          onPrimary: SavannahColors.goldInk,
          surface: SavannahColors.surface,
          onSurface: SavannahColors.text,
          outline: SavannahColors.line,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: SavannahColors.background,
      colorScheme: scheme,
      fontFamily: 'Arial',
      textTheme: const TextTheme(
        displaySmall: TextStyle(
          color: SavannahColors.text,
          fontSize: 38,
          height: .98,
          fontWeight: FontWeight.w800,
          letterSpacing: -1.2,
        ),
        headlineSmall: TextStyle(
          color: SavannahColors.text,
          fontSize: 23,
          fontWeight: FontWeight.w800,
          letterSpacing: -.45,
        ),
        titleMedium: TextStyle(
          color: SavannahColors.text,
          fontWeight: FontWeight.w700,
        ),
        bodyMedium: TextStyle(color: SavannahColors.text, height: 1.45),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SavannahColors.surface,
        hintStyle: const TextStyle(color: SavannahColors.muted),
        labelStyle: const TextStyle(color: SavannahColors.muted),
        prefixIconColor: SavannahColors.muted,
        suffixIconColor: SavannahColors.muted,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: SavannahColors.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: SavannahColors.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: SavannahColors.gold, width: 1.4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: SavannahColors.clay),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: SavannahColors.gold,
          foregroundColor: SavannahColors.goldInk,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
