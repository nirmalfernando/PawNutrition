import 'package:flutter/material.dart';

final ThemeData appTheme = ThemeData(
  primarySwatch: Colors.brown,
  primaryColor: const Color(0xFF8D6E63),
  colorScheme: const ColorScheme.light(
    primary: Color(0xFF8D6E63),
    secondary: Color(0xFFFF9800),
  ),
  fontFamily: 'Roboto',
  appBarTheme: const AppBarTheme(
    color: Color(0xFF5D4037),
    elevation: 0,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFF9800),
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
);
