import 'package:flutter/material.dart';

class AppColors {
  // Primary: #0056D2
  static const MaterialColor primary = MaterialColor(0xFF0056D2, <int, Color>{
    50: Color(0xFFF0F5FD),
    100: Color(0xFFCCDEF6),
    200: Color(0xFF99BDED),
    300: Color(0xFF669BE4),
    400: Color(0xFF3378DB),
    500: Color(0xFF0056D2), // Base
    600: Color(0xFF0044AA),
    700: Color(0xFF003380),
    800: Color(0xFF002255),
    900: Color(0xFF00112A),
  });

  // Secondary: #415A77
  static const MaterialColor secondary = MaterialColor(0xFF415A77, <int, Color>{
    50: Color(0xFFF2F4F6),
    100: Color(0xFFD8DEE5),
    200: Color(0xFFB2BDC9),
    300: Color(0xFF8D9CAE),
    400: Color(0xFF677B92),
    500: Color(0xFF415A77), // Base
    600: Color(0xFF34485F),
    700: Color(0xFF273647),
    800: Color(0xFF1A2430),
    900: Color(0xFF0D1218),
  });

  // Tertiary: #FF6B00
  static const MaterialColor tertiary = MaterialColor(0xFFFF6B00, <int, Color>{
    50: Color(0xFFFFF0E5),
    100: Color(0xFFFFE1CC),
    200: Color(0xFFFFC499),
    300: Color(0xFFFFA666),
    400: Color(0xFFFF8933),
    500: Color(0xFFFF6B00), // Base
    600: Color(0xFFCC5500),
    700: Color(0xFF994000),
    800: Color(0xFF662A00),
    900: Color(0xFF331500),
  });

  // Neutral: #1B263B
  static const MaterialColor neutral = MaterialColor(0xFF1B263B, <int, Color>{
    50: Color(0xFFF4F5F6),
    100: Color(0xFFD1D4D7),
    200: Color(0xFFA4A8B0),
    300: Color(0xFF767D89),
    400: Color(0xFF485162),
    500: Color(0xFF1B263B), // Base
    600: Color(0xFF161F2E),
    700: Color(0xFF111824),
    800: Color(0xFF0B0F17),
    900: Color(0xFF05070C),
  });

  // Backward compatibility colors
  static const Color background = Color(0xFF0B0F17);
  static const Color accent = Color(0xFF3378DB);
  static const Color primaryText = Color(0xFFF4F5F6);
  static const Color secondaryText = Color(0xFF767D89);
  static const Color surface = Color(0xFF111824);
  static const Color border = Color(0xFF485162);
  static const Color inputBackground = Color(0xFF161F2E);
  static const Color error = Color(0xFFFF5252);
  static const Color success = Color(0xFF00C853);
  static const Color warning = Color(0xFFFFAB00);
}
