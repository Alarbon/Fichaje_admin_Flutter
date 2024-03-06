import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;
  static bool _darkMode = false;
  static bool _isLogged = false;

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  // Modo oscuro
  static bool get darkMode {
    return _preferences.getBool('darkMode') ?? false;
  }

  static set darkMode(bool value) {
    _darkMode = value;
    _preferences.setBool('darkMode', _darkMode);
  }

  // Usuario logueado
  static bool get isLogged {
    return _preferences.getBool('isLogged') ?? false;
  }

  static set isLogged(bool value) {
    _isLogged = value;
    _preferences.setBool('isLogged', _isLogged);
  }
}
