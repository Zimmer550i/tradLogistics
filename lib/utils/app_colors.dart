import 'package:flutter/material.dart';

class AppColors {
  // --- BASE COLORS ---

  /// White: #FFFFFF
  static const Color white = Color(0xFFFFFFFF);

  /// Black: #000000
  static const Color black = Color(0xFF000000);

  // --- PRIMARY COLORS ---

  /// Primary Blue: #0A72B9
  static const Color blue = Color(0xFF0A72B9);

  /// Primary Light Blue: #62C5E2
  static const Color lightBlue = Color(0xFF62C5E2);

  /// Primary Dark Blue (Teal/Cyan): #0276A1
  static const Color darkBlue = Color(0xFF0276A1);

  // --- ACCENT COLORS ---

  /// Accent Error (Red): #CA2A3E
  static const Color error = Color(0xFFCA2A3E);

  /// Accent Warning (Orange): #EE8233
  static const Color warning = Color(0xFFEE8233);

  // --- NEUTRAL COLORS ---

  // Note: Neutral colors are defined as a MaterialColor using the 
  // provided shades (25, 50, 100, 200, 300, 400, 500, 600, 700, 800, 900).
  // The 'default' shade (500) is #737373.

  /// Neutral Gray MaterialColor. Default shade is 500 (#737373).
  static MaterialColor neutral = const MaterialColor(0xFF737373, <int, Color>{
    25: Color(0xFFFCFCFC),
    50: Color(0xFFF8F8F8),
    100: Color(0xFFF2F2F2),
    200: Color(0xFFE5E5E5),
    300: Color(0xFFD1D1D1),
    400: Color(0xFFA3A3A3),
    500: Color(0xFF737373), // Primary shade
    600: Color(0xFF525252),
    700: Color(0xFF383838),
    800: Color(0xFF2A2A2A),
    900: Color(0xFF1E1E1C),
  });
}