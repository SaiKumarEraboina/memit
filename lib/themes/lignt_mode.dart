import 'package:flutter/material.dart';
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade100,
    primary: Colors.grey.shade700,
    secondary: Colors.grey.shade300,
    tertiary: Colors.grey.shade200,
    inversePrimary: Colors.black,
  ),
  scaffoldBackgroundColor: Colors.grey.shade100,

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white.withValues(alpha: 0.9),
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: Colors.grey.shade900,           
      fontWeight: FontWeight.bold,
      fontSize: 20,
    ), 
    iconTheme: IconThemeData(color: Colors.grey.shade800),
  ),

  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: Colors.white.withValues(alpha: 0.6),
    elevation: 0,
    selectedItemColor: Colors.black,
    unselectedItemColor: Colors.grey.shade600,
    selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
    unselectedLabelStyle: const TextStyle(fontSize: 12),
    type: BottomNavigationBarType.fixed,
  ),
);
