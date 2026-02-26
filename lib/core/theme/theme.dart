import 'package:stock_app/core/theme/app_pallete.dart';
import 'package:flutter/material.dart';

class AppTheme {
  // style field border
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
    borderSide: BorderSide(color: color, width: 3),
    borderRadius: BorderRadius.circular(10),
  );

  // light theme mode
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    primaryColor: AppPallete.themeColor,
    colorScheme: ColorScheme.light(
      primary: AppPallete.themeColor,
      secondary: AppPallete.gradient1,
      error: AppPallete.errorColor,
      surface: AppPallete.whiteColor,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.themeColor,
      foregroundColor: AppPallete.whiteColor,
      elevation: 0,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: const Color(0xFFEBEBF5),
      labelStyle: const TextStyle(
        color: AppPallete.themeColor,
        fontWeight: FontWeight.w600,
      ),
      side: const BorderSide(color: Color(0xFFDEDDE9)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      filled: true,
      fillColor: AppPallete.whiteColor,
      border: _border(),
      enabledBorder: _border(AppPallete.themeColor),
      focusedBorder: _border(AppPallete.gradient1),
      errorBorder: _border(AppPallete.errorColor),
    ),
    cardTheme: CardThemeData(
      color: AppPallete.whiteColor,
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.05),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppPallete.themeColor,
        foregroundColor: AppPallete.whiteColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: AppPallete.themeColor),
    ),
  );
}
