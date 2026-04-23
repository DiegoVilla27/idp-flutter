import 'package:flutter/material.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF2962FF);
  static const _secondaryColor = Color(0xFF263238);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        primary: _primaryColor,
        onPrimary: Colors.white,
        surface: Colors.white,
        onSurface: _secondaryColor,
        secondary: const Color(0xFF00B0FF),
        secondaryContainer: const Color(0xFFE1F5FE),
      ),
      scaffoldBackgroundColor: const Color(0xFFF8FAFC), // Modern slate white
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleTextStyle: TextStyle(
          color: _secondaryColor,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
        iconTheme: IconThemeData(color: _secondaryColor, size: 28),
      ),
      cardTheme: CardThemeData(
        elevation: 12,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
              color: Colors.grey.withValues(alpha: 0.08), width: 1.5),
        ),
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: _secondaryColor,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFF546E7A),
          fontSize: 15,
          height: 1.5,
        ),
        labelSmall: TextStyle(
          color: _secondaryColor,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 64),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          elevation: 8,
          shadowColor: _primaryColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF1E2125);
    const darkBackground = Color(0xFF0F1113);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: _primaryColor,
        brightness: Brightness.dark,
        primary: _primaryColor,
        surface: darkSurface,
        onSurface: Colors.white,
        secondary: const Color(0xFF40C4FF),
      ),
      scaffoldBackgroundColor: darkBackground,
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        backgroundColor: darkBackground,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.w900,
          letterSpacing: -1,
        ),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      iconTheme: const IconThemeData(color: Colors.white, size: 24),
      textTheme: const TextTheme(
        titleLarge: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w800,
          letterSpacing: -0.5,
        ),
        bodyMedium: TextStyle(
          color: Color(0xFFB0BEC5),
          fontSize: 15,
          height: 1.5,
        ),
        labelSmall: TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(
              color: Colors.white.withValues(alpha: 0.05), width: 1.5),
        ),
        color: darkSurface,
      ),
    );
  }
}
