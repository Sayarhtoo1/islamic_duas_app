import 'package:flutter/material.dart';
import 'package:islamic_duas_app/providers/settings_provider.dart'; // Import SettingsProvider

class ColorOption {
  final String name;
  final Color color;

  ColorOption(this.name, this.color);
}

class AppTheme {
  static ThemeData lightTheme(double textSize, SettingsProvider settings) {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: const Color.fromARGB(255, 1, 94, 4), // Deep Green
      hintColor: const Color(0xFFFFD700), // Gold
      scaffoldBackgroundColor: const Color.fromARGB(255, 250, 250, 250), // Cream
      cardColor: const Color(0xFFFFFFFF), // White for cards
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF4CAF50), // Deep Green
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'MyanmarFont',
          fontSize: 18 * (textSize / 16), // Scale with textSize
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'MyanmarFont',
            fontSize: 20 * (textSize / 16), // Scale with textSize
            fontWeight: FontWeight.bold,
            color: settings.myanmarTitleColor,
            height: 1.5), // Myanmar title color from settings
        displayMedium: TextStyle(
            fontFamily: 'MyanmarFont',
            fontSize: 18 * (textSize / 16), // Scale with textSize
            fontWeight: FontWeight.bold,
            color: settings.myanmarTitleColor, // Using Myanmar title color for displayMedium as well
            height: 1.5),
        bodyLarge: TextStyle(fontFamily: 'MyanmarFont', fontSize: 20 * (textSize / 16), color: settings.sourceTextColor, height: 1.5),
        bodyMedium: TextStyle(fontFamily: 'MyanmarFont', fontSize: 18 * (textSize / 16), color: settings.sourceTextColor, height: 1.5),
        bodySmall: TextStyle(fontFamily: 'MyanmarFont', fontSize: 16 * (textSize / 16), color: settings.sourceTextColor, height: 1.5),
        headlineMedium: TextStyle(fontFamily: 'ArabicFont', fontSize: 36 * (textSize / 16), color: settings.arabicTextColor, height: 1.5), // Arabic text color from settings
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: const Color.fromARGB(255, 255, 255, 255), // Gold
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static ThemeData darkTheme(double textSize, SettingsProvider settings) {
    return ThemeData(
      primarySwatch: Colors.green,
      primaryColor: const Color.fromARGB(255, 0, 70, 0), // Darker Green
      hintColor: const Color(0xFFFFD700), // Gold
      scaffoldBackgroundColor: const Color.fromARGB(255, 30, 30, 30), // Dark Grey
      cardColor: const Color.fromARGB(255, 45, 45, 45), // Darker Grey for cards
      appBarTheme: AppBarTheme(
        backgroundColor: const Color.fromARGB(255, 20, 90, 20), // Dark Green
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontFamily: 'MyanmarFont',
          fontSize: 18 * (textSize / 16), // Scale with textSize
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        displayLarge: TextStyle(
            fontFamily: 'MyanmarFont',
            fontSize: 20 * (textSize / 16), // Scale with textSize
            fontWeight: FontWeight.bold,
            color: settings.myanmarTitleColor,
            height: 1.5), // Myanmar title color from settings
        displayMedium: TextStyle(
            fontFamily: 'MyanmarFont',
            fontSize: 18 * (textSize / 16), // Scale with textSize
            fontWeight: FontWeight.bold,
            color: settings.myanmarTitleColor, // Using Myanmar title color for displayMedium as well
            height: 1.5),
        bodyLarge: TextStyle(fontFamily: 'MyanmarFont', fontSize: 20 * (textSize / 16), color: settings.sourceTextColor, height: 1.5),
        bodyMedium: TextStyle(fontFamily: 'MyanmarFont', fontSize: 18 * (textSize / 16), color: settings.sourceTextColor, height: 1.5),
        bodySmall: TextStyle(fontFamily: 'MyanmarFont', fontSize: 16 * (textSize / 16), color: settings.sourceTextColor, height: 1.5),
        headlineMedium: TextStyle(fontFamily: 'ArabicFont', fontSize: 36 * (textSize / 16), color: settings.arabicTextColor, height: 1.5), // Arabic text color from settings
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: const Color.fromARGB(255, 100, 100, 100), // Darker button
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  static final List<ColorOption> availableTextColors = [
    ColorOption('Black', Colors.black),
    ColorOption('Black87', Colors.black87), // Added Black87
    ColorOption('Red', Colors.red),
    ColorOption('Blue', Colors.blue),
    ColorOption('Green', Colors.green),
    ColorOption('Purple', Colors.purple),
    ColorOption('Default Myanmar Title', const Color.fromARGB(255, 117, 47, 47)), // Added default Myanmar title color
    ColorOption('Default Arabic Text', const Color.fromARGB(255, 231, 35, 35)), // Added default Arabic text color
  ];
}
