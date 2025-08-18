import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;
  late final SharedPreferences prefs;
  ThemeMode get currentTheme => _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  ThemeProvider() {
    _loadTheme();
  }
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _cashTheme();
    notifyListeners();
  }

  Future<void> _loadTheme() async {
    prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('user_theme') ?? false;
    notifyListeners();
  }

  Future<void> _cashTheme() async {
    await prefs.setBool('user_theme', _isDarkMode);
  }
}
