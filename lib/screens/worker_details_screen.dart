import 'package:fichaje_admin/models/signing_model.dart';
import 'package:fichaje_admin/models/worker_model.dart';
import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:fichaje_admin/widgets/label_form.dart';
import 'package:fichaje_admin/widgets/my_date_picker_form_field.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_whatsapp/share_whatsapp.dart';

class WorkerDetailsScreen extends StatelessWidget {
  const WorkerDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context);
    final settingProvider = Provider.of<SettingsProvider>(context);
    final size = MediaQuery.of(context).size;
    final Worker worker = signingWorkersProvider.selectedWorker!;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(FontAwesomeIcons.arrowLeft, color: Colors.white),
          onPressed: () {
            signingWorkersProvider.cleanDataFormWorker();
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            onPressed: () {
              settingProvider.toggleTheme();
            },
          ),
        ],
        title: const Text(
          'Detalles del Trabajador',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 1,
              child: WorkerInfo(worker: worker),
            ),
            const SizedBox(width: 20),
            worker.signings != null
                ? Expanded(
                    flex: 1,
                    child: SigningsWorker(worker: worker),
                  )
                : Expanded(
                    flex: 1,
                    child: Center(
                      child: Opacity(
                        opacity: 0.2,
                        child: Text(
                          'No hay fichajes de este trabajador',
                          style:
                              TextStyle(fontSize: size.width < 600 ? 20 : 30),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDeleteConfirmationDialog(context);
        },
        backgroundColor: Colors.red,
        child: const Icon(FontAwesomeIcons.trash),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final signingWorkersProvider =
            Provider.of<SigningWorkersProvider>(context, listen: false);
        return AlertDialog(
          title: const Text("Eliminar Trabajador"),
          content: const Text(
              "¿Estás seguro de que deseas eliminar este trabajador?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                context.pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () {
                signingWorkersProvider.deleteWorker();
                context.go('/home');
              },
              child: const Text("Eliminar"),
            ),
          ],
        );
      },
    );
  }
}

class SigningsWorker extends StatelessWidget {
  const SigningsWorker({
    super.key,
    required this.worker,
  });

  final Worker worker;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Center(
            child: Text('Fichajes',
                style: TextStyle(fontSize: size.width < 600 ? 20 : 30))),
        const SizedBox(height: 20),
        SizedBox(
          height: size.height * 0.5,
          width: size.width * 0.3,
          child: ListView.builder(
            itemCount: worker.signings!.length,
            itemBuilder: (_, index) {
              Signing signings = worker.signings![index];
              return ListTile(
                title: Text(
                  '${signings.type}: ${DateFormat('dd/MM/yyyy HH:mm:ss').format(signings.date)}',
                  style: TextStyle(
                    color:
                        signings.type == 'Entrada' ? Colors.green : Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
        InkWell(
          hoverColor: Colors.transparent,
          onTap: () {
            String hola = signingWorkersProvider.prepareMensaje();
            ShareWhatsapp().share(text: hola, phone: worker.phone.toString());
          },
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Compartir por Whatsapp",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(
                width: 15,
              ),
              Icon(
                FontAwesomeIcons.whatsapp,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class WorkerInfo extends StatelessWidget {
  const WorkerInfo({
    super.key,
    required this.worker,
  });

  final Worker worker;

  @override
  Widget build(BuildContext context) {
    final signingWorkersProvider = Provider.of<SigningWorkersProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 20),
          Text(
            'Detalles del Trabajador',
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor:
                  settingsProvider.darkMode ? Colors.white : Colors.black54,
              fontSize: 30,
              color: settingsProvider.darkMode ? Colors.white : Colors.black54,
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
              await signingWorkersProvider.editWorker();
              if (signingWorkersProvider.errorMessage == null) {
                //Le doy feedback al usuario de que se ha añadido el trabajador con un snackbar
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Trabajador editado',
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
                    //colores para boton de guardar
                    Color(0xFF8A2387),
                    Color(0xFFE94057),
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  'Guardar Cambios',
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
    );
  }
}
