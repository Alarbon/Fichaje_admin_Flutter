import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/login_provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);

    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: size.height,
          width: size.width,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF8A2387),
                Color(0xFFE94057),
                Color(0xFFF27121),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              Image.asset('assets/images/logo.png', width: 60),
              const SizedBox(height: 20),
              const Text(
                'Fichaje Alarbon',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 40),
              Container(
                height: 480,
                width: 355,
                decoration: BoxDecoration(
                  color: settingsProvider.darkMode
                      ? Colors.black54
                      : Colors.white70,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Hola!',
                      style: TextStyle(
                        fontSize: 35,
                        color: settingsProvider.darkMode
                            ? Colors.white
                            : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'Inicia sesión para continuar',
                      style: TextStyle(
                        color: settingsProvider.darkMode
                            ? Colors.grey
                            : Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 40),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: loginProvider.usernameController,
                        decoration: InputDecoration(
                          labelText: 'Usuario',
                          suffixIcon: Icon(
                            FontAwesomeIcons.user,
                            color: settingsProvider.darkMode
                                ? Colors.grey
                                : Colors.grey[700],
                            size: 17,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TextField(
                        controller: loginProvider.passwordController,

                        obscureText: settingsProvider
                            .obscureText, // Controla la visibilidad de la contraseña
                        decoration: InputDecoration(
                          labelText: 'Contraseña',
                          suffixIcon: IconButton(
                            icon: Icon(
                              settingsProvider.obscureText
                                  ? FontAwesomeIcons.eyeSlash
                                  : FontAwesomeIcons.eye,
                              color: settingsProvider.darkMode
                                  ? Colors.grey
                                  : Colors.grey[700],
                              size: 20,
                            ),
                            onPressed: () {
                              settingsProvider.obscureText =
                                  !settingsProvider.obscureText;
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (loginProvider.errorMessage != null)
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          loginProvider.errorMessage!,
                          style: TextStyle(
                              color: settingsProvider.darkMode
                                  ? Colors.redAccent[200]
                                  : Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        loginProvider.login();
                        if (loginProvider.errorMessage == null) {
                          context.go('/home'); 
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        width: 250,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xFF8A2387),
                              Color(0xFFE94057),
                              Color(0xFFF27121),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Center(
                          child: Text(
                            'Iniciar sesión',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Si tienes problemas contacte con el admin.',
                      style: TextStyle(
                        color: settingsProvider.darkMode
                            ? Colors.grey
                            : Colors.grey[700],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
