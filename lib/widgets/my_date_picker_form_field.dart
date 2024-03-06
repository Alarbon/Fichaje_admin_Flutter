


import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

class MyDatePickerFormField extends StatelessWidget {
  final Function(DateTime) onDateSaved;
  final SigningWorkersProvider signingWorkersProvider;
  final SettingsProvider settingsProvider;

  const MyDatePickerFormField({
    super.key,
    required this.onDateSaved,
    required this.signingWorkersProvider,
    required this.settingsProvider,
  });

  @override
  Widget build(BuildContext context) {
    DateTime? selectedDate = signingWorkersProvider.selectedDate;

    Future<void> selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate ?? DateTime.now(),
        firstDate: DateTime(1900),
        lastDate: DateTime.now(),
      );

      if (picked != null && picked != selectedDate) {
        onDateSaved(picked);
        signingWorkersProvider.setDate(picked);
      }
    }

    return TextFormField(
      readOnly: true,
      onTap: () => selectDate(context),
      decoration: InputDecoration(
        filled: true,
        fillColor:
            settingsProvider.darkMode ? Colors.grey[900] : Colors.grey[300],
        labelText: 'Fecha de Nacimiento',
        suffixIcon: Icon(
          // ignore: deprecated_member_use
          FontAwesomeIcons.calendarAlt,
          color: settingsProvider.darkMode ? Colors.grey : Colors.grey[700],
          size: 17,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      controller: TextEditingController(
        text: selectedDate != null
            ? DateFormat('dd/MM/yyyy').format(selectedDate)
            : '',
      ),
    );
  }
}
