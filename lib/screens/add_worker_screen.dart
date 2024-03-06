import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:fichaje_admin/widgets/label_form.dart';
import 'package:fichaje_admin/widgets/my_date_picker_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class AddWorkerScreen extends StatelessWidget {
  const AddWorkerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () {
              settingsProvider.toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 580,
                width: 500,
                decoration: const BoxDecoration(
                  //que este rendondeado
                  borderRadius: BorderRadius.all(Radius.circular(20)),
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
                //ahora formulario para añadir un worker
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        'Añadir Trabajador',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.black54,
                          fontSize: 30,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      LabelForm(
                          label: 'Nombre',
                          controller: signingWorkersProvider.nameController,
                          settingsProvider: settingsProvider,
                          // ignore: deprecated_member_use
                          icon: FontAwesomeIcons.userAlt),
                      const SizedBox(height: 20),
                      LabelForm(
                          label: 'Apellidos',
                          controller: signingWorkersProvider.lastNameController,
                          settingsProvider: settingsProvider,
                          icon: FontAwesomeIcons.personBurst),
                      const SizedBox(height: 20),
                      LabelForm(
                          label: 'DNI númerico',
                          controller: signingWorkersProvider.dniController,
                          settingsProvider: settingsProvider,
                          icon: FontAwesomeIcons.imdb),
                      const SizedBox(height: 20),
                        LabelForm(
                          label: 'Numero de telefono',
                          controller: signingWorkersProvider.phoneController,
                          settingsProvider: settingsProvider,
                          icon: FontAwesomeIcons.phone),
                      const SizedBox(height: 20),
                      MyDatePickerFormField(
                          onDateSaved: (date) {},
                          signingWorkersProvider: signingWorkersProvider,
                          settingsProvider: settingsProvider),
                      const SizedBox(height: 20),
                      if (signingWorkersProvider.errorMessage != null)
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            signingWorkersProvider.errorMessage!,
                            style: TextStyle(
                                //fondo para que se vea bien la letra
                                color: Colors.red[900],
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          await signingWorkersProvider.addWorker();
                          if (signingWorkersProvider.errorMessage == null) {
                            //Le doy feedback al usuario de que se ha añadido el trabajador con un snackbar
                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Trabajador añadido',
                                    style: TextStyle(color: Colors.white)
                                    // Cambiar color del texto según el modo oscuro
                                    ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                                margin: const EdgeInsets.all(20),
                              ),
                            );
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
                                Color(0xFF8A2387), // Morado oscuro
                                Color(0xFFE94057), // Morado claro
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'Registrar Trabajador',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
