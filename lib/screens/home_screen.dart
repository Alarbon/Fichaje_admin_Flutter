import 'package:fichaje_admin/providers/login_provider.dart';
import 'package:fichaje_admin/screens/add_worker_screen.dart';
import 'package:fichaje_admin/screens/home_view.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:sidebarx/sidebarx.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      key: _key,
      appBar: isSmallScreen
          ? AppBar(
              title: const Text("Fichaje Alarbon",
                  style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.transparent,
              flexibleSpace: Container(
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
              ),
              leading: IconButton(
                onPressed: () {
                  _key.currentState?.openDrawer();
                },
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            )
          : null,
      drawer: ExampleSidebarX(controller: _controller),
      body: Row(
        children: [
          if (!isSmallScreen) ExampleSidebarX(controller: _controller),
          Expanded(
            child: Center(
              child: _Screens(
                controller: _controller,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ExampleSidebarX extends StatelessWidget {
  const ExampleSidebarX({super.key, required SidebarXController controller, Q})
      : _controller = controller;

  final SidebarXController _controller;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signingWorkersProvider = Provider.of<LoginProvider>(context);
    return SidebarX(
      controller: _controller,
      theme: SidebarXTheme(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF8A2387),
              Color(0xFFE94057),
              Color(0xFFF27121),
            ],
          ),
        ),
        textStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
        selectedTextStyle: const TextStyle(color: Colors.white),
        itemTextPadding: const EdgeInsets.only(left: 30),
        selectedItemTextPadding: const EdgeInsets.only(left: 30),
        itemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        selectedItemDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Colors.red,
          ),
          gradient: LinearGradient(
            colors: [
              Colors.red.withOpacity(0.3),
              Colors.deepOrangeAccent.withOpacity(0.3)
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.white70.withOpacity(0.28),
              blurRadius: 30,
            )
          ],
        ),
        iconTheme: IconThemeData(
          color: Colors.white.withOpacity(0.7),
          size: 20,
        ),
        selectedIconTheme: const IconThemeData(
          color: Colors.white,
          size: 20,
        ),
      ),
      extendedTheme: const SidebarXTheme(
        width: 200,
        decoration: BoxDecoration(
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
      ),
      footerDivider: Container(
        color: Colors.red,
      ),
      headerBuilder: (context, extended) {
        return SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  width: size.width < 600
                      ? 30
                      : size.width < 1800
                          ? size.width * 0.027
                          : size.width * 0.017,
                  color: Colors.white,
                ),
                const SizedBox(height: 10),
                Text(
                  'Fichaje Alarbon',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: size.width < 600
                        ? size.height * 0.005
                        : size.height * 0.014,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
        );
      },
      items: [
        const SidebarXItem(
          // ignore: deprecated_member_use
          icon: FontAwesomeIcons.home,
          label: 'Home',
        ),
        const SidebarXItem(
          icon: FontAwesomeIcons.userPlus,
          label: 'Añadir Trabajador',
        ),
        SidebarXItem(
          // ignore: deprecated_member_use
          icon: FontAwesomeIcons.signOutAlt,
          label: 'Cerrar Sesión',
          onTap: () {
            signingWorkersProvider.signOut();
            context.go('/login');
          },
        ),
      ],
    );
  }
}

class _Screens extends StatelessWidget {
  const _Screens({
    required this.controller,
  });

  final SidebarXController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        switch (controller.selectedIndex) {
          case 0:
            return const HomeView();
          case 1:
            return const AddWorkerScreen();
          default:
            return Opacity(
              opacity: 0.2,
              child: Text(
                "Error 404: Página no encontrada, contacte al administrador",
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.displayLarge,
              ),
            );
        }
      },
    );
  }
}
