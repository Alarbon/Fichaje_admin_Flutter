import 'package:fichaje_admin/share_preferences/preferences.dart';
import 'package:flutter/material.dart';

class LoginProvider extends ChangeNotifier {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? _errorMessage;

  bool _isLogged = false;

  bool get isLogged => _isLogged;

  String? get errorMessage => _errorMessage;

  LoginProvider() {
    _isLogged = Preferences.isLogged;
  }

  TextEditingController get usernameController => _usernameController;

  TextEditingController get passwordController => _passwordController;

  void login() {
    final username = _usernameController.text;
    final password = _passwordController.text;
    if (username.isEmpty || password.isEmpty) {
      _errorMessage = 'Usuario o contraseña vacíos';
      notifyListeners();
      return;
    }
    if (username == 'alarbon' && password == 'alarbon1234') {
      _errorMessage = null;
      _isLogged = true;
      Preferences.isLogged = true;

     print( Preferences.isLogged);

      //limpio el formulario
      _usernameController.clear();
      _passwordController.clear();

      notifyListeners();
    } else {
      _errorMessage = 'Usuario o contraseña incorrectos';
      notifyListeners();
    }
  }

  void signOut() {
    _isLogged = false;
    Preferences.isLogged = false;
    notifyListeners();
  }
}
