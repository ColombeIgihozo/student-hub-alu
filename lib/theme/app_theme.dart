import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const gold = Color(0xFF6C8CFF);
  static const gold2 = Color(0xFF8BA4FF);
  static const goldSoft = Color(0x246C8CFF);
  static const goldLine = Color(0x576C8CFF);
  static const bg = Color(0xFF0D0D0D);
  static const s1 = Color(0xFF1A1A1A);
  static const s2 = Color(0xFF242424);
  static const s3 = Color(0xFF2E2E2E);
  static const txt = Color(0xFFFFFFFF);
  static const txt2 = Color(0xFFAAAAAA);
  static const txt3 = Color(0xFF6E6E6E);
  static const line = Color(0x12FFFFFF);
  static const line2 = Color(0x1FFFFFFF);
  static const error = Color(0xFFE76F51);
  static const onGold = Color(0xFF1A1200);
  static const splashRadial = Color(0xFF0B1530);
}

class AppTheme {
  static ThemeData dark() {
    final heading = GoogleFonts.poppinsTextTheme();
    final body = GoogleFonts.interTextTheme();

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.bg,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.gold,
        surface: AppColors.s1,
        onPrimary: AppColors.onGold,
        onSurface: AppColors.txt,
      ),
      textTheme: body.apply(
        bodyColor: AppColors.txt,
        displayColor: AppColors.txt,
      ).copyWith(
        headlineLarge: heading.headlineLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.txt,
        ),
        headlineMedium: heading.headlineMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.txt,
        ),
        titleLarge: heading.titleLarge?.copyWith(
          fontWeight: FontWeight.w700,
          color: AppColors.txt,
        ),
      ),
      dividerColor: AppColors.line,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.s1,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.line2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.goldLine),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: AppColors.txt3),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: AppColors.s3,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static TextStyle heading(BuildContext context, {double size = 18}) {
    return GoogleFonts.poppins(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: AppColors.txt,
    );
  }

  static TextStyle body(BuildContext context, {double size = 14, Color? color}) {
    return GoogleFonts.inter(
      fontSize: size,
      color: color ?? AppColors.txt,
    );
  }

  static TextStyle muted(BuildContext context, {double size = 12}) {
    return GoogleFonts.inter(fontSize: size, color: AppColors.txt2);
  }
}

double _hue(double value) => value % 360.0;

Color coverGradientStart(double hue) =>
    HSLColor.fromAHSL(1, _hue(hue), 0.55, 0.42).toColor();

Color coverGradientEnd(double hue) =>
    HSLColor.fromAHSL(1, _hue(hue + 28), 0.45, 0.16).toColor();

Color avatarGradientStart(double hue) =>
    HSLColor.fromAHSL(1, _hue(hue), 0.55, 0.68).toColor();

Color avatarGradientEnd(double hue) =>
    HSLColor.fromAHSL(1, _hue(hue + 30), 0.50, 0.46).toColor();
