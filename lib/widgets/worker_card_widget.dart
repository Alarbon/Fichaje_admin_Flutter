import 'package:fichaje_admin/models/signing_model.dart';
import 'package:fichaje_admin/providers/settings_provider.dart';
import 'package:fichaje_admin/providers/signing_workers_provider.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fichaje_admin/models/worker_model.dart';
import 'package:provider/provider.dart'; // Asegúrate de importar el modelo Worker

class WorkerCard extends StatelessWidget {
  final Worker worker;

  const WorkerCard({super.key, required this.worker});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final signingWorkersService = Provider.of<SigningWorkersProvider>(context);
    // Formatear la fecha de nacimiento
    String formattedBirthdate =
        DateFormat('dd/MM/yyyy').format(worker.birthdate);

    return InkWell(
      onTap: () {
        //llamo al metodo que

        signingWorkersService.prepareSelectedWorker(worker);

        context.push('/worker_details');
      },
      child: Container(
        //borde blanco con el mismo rendondeado que el card
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
              color: settingsProvider.darkMode ? Colors.white : Colors.black,
              width: 2.0),
        ),
        child: Card(
          shadowColor: Colors.blue,
          elevation: 60.0,
          child: SizedBox(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ignore: deprecated_member_use
                  const Icon(FontAwesomeIcons.userAlt),
                  const SizedBox(width: 30),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${worker.name} ${worker.lastName}'),
                      const SizedBox(height: 5),
                      Text('DNI: ${worker.dni}'),
                      const SizedBox(height: 5),
                      Text('Teléfono: ${worker.phone}'),
                      const SizedBox(height: 5),
                      SizedBox(
                        //en pantalla pequeña vs grande
                        width: size.width < 600
                            ? size.width * 0.2
                            : size.width * 0.12,
                        child: Text(
                          'Fecha Nacimiento: $formattedBirthdate',
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
