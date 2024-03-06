import 'package:fichaje_admin/firebase_options.dart';
import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/router/app_router.dart';
import 'providers/login_provider.dart';
import 'share_preferences/preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
          lazy: false,
        ),
        ChangeNotifierProvider(
          create: (_) => SigningWorkersProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    return MaterialApp.router(
      title: 'Fichaje App',
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: settingsProvider.darkMode
          ? ThemeData.dark().copyWith(
              colorScheme: const ColorScheme.dark(primary: Colors.blueAccent),
              primaryColor: Colors.blueAccent,
              hintColor: Colors.deepPurpleAccent,
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.blueAccent,
                textTheme: ButtonTextTheme.primary,
              ),
            )
          : ThemeData.light().copyWith(
             colorScheme: const ColorScheme.light(primary: Colors.deepPurple),
              primaryColor: Colors.deepPurple,
              hintColor: Colors.deepPurpleAccent,
              buttonTheme: const ButtonThemeData(
                buttonColor: Colors.deepPurple,
                textTheme: ButtonTextTheme.primary,
              ),
            ),
    );
  }
}
