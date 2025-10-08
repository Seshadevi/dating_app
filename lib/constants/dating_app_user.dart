import 'dart:ui';
import 'package:flutter/material.dart';

class DatingColors {
  static const Color black = Color(0xFF000000); // true black
  static const Color darkGrey = Color(0xFF161616);
  static const Color primaryGreen = Color(0xFFFCD0D7);
  static const Color darkGreen = Color(0xFF92AB26);
  static const Color lightpink = Color(0xFFEB507F);
  static const Color qpidColor = Color(0xFFD68F95);
  static const Color lightpinks = Color(0xFFFEDFDD);
  static const Color middlepink = Color(0xFFFEDFDE);
  static const Color everqpidColor = Color(0xFFFEB3B8);

  static const Color accentTeal = Color(0xFF00BCD4);
  static const Color yellow = Color(0xFFF9E109);
  static const Color lightyellow = Color(0xFFE6EBA4);
  static const Color white = Color(0xFFFFFFFF);

  // Background Colors
  static const Color lightBlue = Color(0xFFE8F4FD);
  static const Color lightGreen = Color(0xFFE8F5E8);
  static const Color backgroundWhite = Color(0xFFFAFAFA);
  static const Color brown = Color(0xFF483737);

  // Status Colors
  static const Color successGreen = Color(0xFF34A853);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color errorRed = Color(0xFFDC3545);

  // Text Colors
  static const Color primaryText = Color(0xFF2C3E50);
  static const Color secondaryText = Color(0xFF6C757D);

  // Card and Surface Colors
  static const Color surfaceGrey = Color(0xFFF8F9FA);
  static const Color mediumGrey = Color(0xFFB8BDC2);
  static const Color lightgrey = Color(0xFF95A5A6);
  static const Color middlegrey = Color(0xFF757575);
}

class DatingTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: DatingColors.primaryGreen,
    scaffoldBackgroundColor: DatingColors.backgroundWhite,
    colorScheme: const ColorScheme.light(
      primary: DatingColors.primaryGreen,
      secondary: DatingColors.lightpink,
      background: DatingColors.backgroundWhite,
      onPrimary: DatingColors.white,
      onSecondary: DatingColors.primaryText,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DatingColors.primaryGreen,
      foregroundColor: DatingColors.white,
      elevation: 0,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: DatingColors.primaryText),
      bodyMedium: TextStyle(color: DatingColors.secondaryText),
      titleLarge: TextStyle(color: DatingColors.primaryText),
    ),
    cardColor: DatingColors.surfaceGrey,
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: DatingColors.darkGreen,
    scaffoldBackgroundColor: Color(0xFF0F0F0F),
    colorScheme: const ColorScheme.dark(
      primary: DatingColors.darkGreen,
      secondary: Color(0xFFB23A59),
      background: Color(0xFF0F0F0F),
      onPrimary: Colors.white,
      onSecondary: Colors.white70,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: DatingColors.darkGreen,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen;
        }
        return Colors.grey;
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return DatingColors.primaryGreen.withOpacity(0.5);
        }
        return Colors.grey.withOpacity(0.3);
      }),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white),
    ),
    cardColor: DatingColors.darkGrey,
  );
}
