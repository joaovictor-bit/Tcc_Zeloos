import 'package:flutter/material.dart';

class AppTheme {
  static const navy = Color(0xFF08104E);
  static const bg = Color(0xFFF4F5FA);
  static const success = Color(0xFF1E9E5A);
  static const warning = Color(0xFFE8A317);
  static const danger = Color(0xFFD64545);
  

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: navy, primary: navy),
        scaffoldBackgroundColor: bg,
        appBarTheme: const AppBarTheme(
            backgroundColor: navy, foregroundColor: Colors.white, centerTitle: true),
        
        inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)),
        navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Colors.white, indicatorColor: Color(0x1F08104E)),
        snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
      );
}
