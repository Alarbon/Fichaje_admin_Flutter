import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:flutter/material.dart';

class LabelForm extends StatelessWidget {
  const LabelForm({
    super.key,
    required this.label,
    required this.controller,
    required this.settingsProvider,
    required this.icon,
  });
  final String label;
  final TextEditingController controller;
  final SettingsProvider settingsProvider;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        // fondo del input blanco
        filled: true,
        fillColor:
            settingsProvider.darkMode ? Colors.grey[900] : Colors.grey[300],
        labelText: label,
        suffixIcon: Icon(
          icon,
          color: settingsProvider.darkMode ? Colors.grey : Colors.grey[700],
          size: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}