// lib/providers/theme_provider.dart
import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  void toggleTheme() {
    _isDarkTheme = !_isDarkTheme;
    notifyListeners(); // This notifies all listening widgets to rebuild
  }

  void setTheme(bool isDark) {
    _isDarkTheme = isDark;
    notifyListeners();
  }
}