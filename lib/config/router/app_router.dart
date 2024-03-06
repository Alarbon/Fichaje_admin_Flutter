import 'package:fichaje_admin/providers/login_provider.dart';
import 'package:fichaje_admin/screens/home_screen.dart';
import 'package:fichaje_admin/screens/worker_details_screen.dart';
import 'package:fichaje_admin/share_preferences/preferences.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../screens/login_screen.dart';

final appRouter = GoRouter(
  initialLocation: Preferences.isLogged ? '/home' : '/login',
  errorPageBuilder: (context, state) => const MaterialPage(
    child: Scaffold(
      body: Center(
        child: Text('Página de error: Ruta no encontrada'),
      ),
    ),
  ),
  routes: [
    GoRoute(
        path: '/home',
        builder: (context, state) =>
            LoginProvider().isLogged ? HomeScreen() : const LoginScreen()),
    GoRoute(
        path: '/login',
        builder: (context, state) =>
            LoginProvider().isLogged ? HomeScreen() : const LoginScreen()),

    GoRoute(
        path: '/worker_details',
        builder: (context, state) =>
            LoginProvider().isLogged ? const WorkerDetailsScreen() : const LoginScreen()),
  ],
);
