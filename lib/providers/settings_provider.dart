import 'package:fichaje_admin/share_preferences/preferences.dart';
import 'package:flutter/material.dart';

class SettingsProvider extends ChangeNotifier {
  bool _darkMode = false;

  bool _obscureText = true;

  SettingsProvider() {
    _darkMode = Preferences.darkMode;
  }

  bool get darkMode => _darkMode;

  bool get obscureText => _obscureText;

  set obscureText(bool obscureText) {
    _obscureText = obscureText;
    notifyListeners();
  }

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleTheme() {
    darkMode = !darkMode;
    Preferences.darkMode = darkMode;
    notifyListeners();
  }
}
