import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeModeOption { system, light, dark }

class SettingsProvider with ChangeNotifier {
  ThemeModeOption _themeMode = ThemeModeOption.system;
  Color _myanmarTitleColor = const Color.fromARGB(255, 117, 47, 47); // Default for Myanmar titles
  Color _arabicTextColor = const Color.fromARGB(255, 231, 35, 35); // Default for Arabic text
  Color _sourceTextColor = Colors.black87; // Default for source text
  double _textSize = 16.0;
  String _geminiApiKey = ""; // New: Gemini API Key

  ThemeModeOption get themeMode => _themeMode;
  Color get myanmarTitleColor => _myanmarTitleColor;
  Color get arabicTextColor => _arabicTextColor;
  Color get sourceTextColor => _sourceTextColor;
  double get textSize => _textSize;
  String get geminiApiKey => _geminiApiKey; // New: Getter for API Key

  SettingsProvider() {
    loadSettings(); // Call the public method
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeIndex = prefs.getInt('themeMode') ?? 0;
    _themeMode = ThemeModeOption.values[themeModeIndex];

    final myanmarTitleColorValue = prefs.getInt('myanmarTitleColor') ?? const Color.fromARGB(255, 117, 47, 47).value;
    _myanmarTitleColor = Color(myanmarTitleColorValue);

    final arabicTextColorValue = prefs.getInt('arabicTextColor') ?? const Color.fromARGB(255, 231, 35, 35).value;
    _arabicTextColor = Color(arabicTextColorValue);

    final sourceTextColorValue = prefs.getInt('sourceTextColor') ?? Colors.black87.value;
    _sourceTextColor = Color(sourceTextColorValue);

    _textSize = prefs.getDouble('textSize') ?? 16.0;
    _geminiApiKey = prefs.getString('geminiApiKey') ?? ""; // Load API Key
    debugPrint('Gemini API Key loaded: $_geminiApiKey'); // Add debug print for loading
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeModeOption option) async {
    _themeMode = option;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('themeMode', option.index);
    notifyListeners();
  }

  Future<void> setMyanmarTitleColor(Color color) async {
    _myanmarTitleColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('myanmarTitleColor', color.value);
    notifyListeners();
  }

  Future<void> setArabicTextColor(Color color) async {
    _arabicTextColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('arabicTextColor', color.value);
    notifyListeners();
  }

  Future<void> setSourceTextColor(Color color) async {
    _sourceTextColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('sourceTextColor', color.value);
    notifyListeners();
  }

  Future<void> setTextSize(double size) async {
    _textSize = size;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textSize', size);
    notifyListeners();
  }

  Future<void> setGeminiApiKey(String key) async {
    _geminiApiKey = key;
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString('geminiApiKey', key);
    debugPrint('Gemini API Key saved: $_geminiApiKey (Success: $success)'); // Add debug print with success status
    notifyListeners();
  }

  ThemeMode get currentThemeMode {
    switch (_themeMode) {
      case ThemeModeOption.system:
        return ThemeMode.system;
      case ThemeModeOption.light:
        return ThemeMode.light;
      case ThemeModeOption.dark:
        return ThemeMode.dark;
    }
  }
}
