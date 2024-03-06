import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fichaje_admin/models/worker_model.dart';

class SigningWorkersService {
  final _firebaseFirestore = FirebaseFirestore.instance;

  SigningWorkersService();

  // dar de alta un trabajador
  Future<void> addWorker(Worker worker) async {
    try {
      await _firebaseFirestore.collection('workers').add(worker.toJson());
    } catch (e) {
      throw Exception('Error al añadir el trabajador');
    }
  }

  // dar de baja un trabajador
  Future<void> deleteWorker(int dni) async {
    try {
      _firebaseFirestore
          .collection('workers')
          .where('dni', isEqualTo: dni)
          .get()
          .then((value) {
        for (var element in value.docs) {
          element.reference.delete();
        }
      });
    } catch (e) {
      throw Exception('Error al eliminar el trabajador');
    }
  }

  //buscar trabajador por dni

  Future<Worker?> getWorkerByDni(int dni) async {
    try {
      final response = await _firebaseFirestore
          .collection('workers')
          .where('dni', isEqualTo: dni)
          .get();
      if (response.docs.isEmpty) {
        return null;
      }
      return Worker.fromJson(response.docs.first.data());
    } catch (e) {
      throw Exception('Error al buscar el trabajador');
    }
  }

  //editar trabajador
  Future<void> updateWorker(Worker worker) async {
    try {
          //intento recuperar la id de firebase
    final response = await _firebaseFirestore
          .collection('workers')
          .where('dni', isEqualTo: worker.dni)
          .get();


      await _firebaseFirestore
          .collection('workers')
          .doc(response.docs.first.id)
          .update(worker.toJson());
    } catch (e) {
      throw Exception('Error al editar el trabajador');
    }
  }

  //obtener todos los trabajadores
  Future<List<Worker>> getWorkers() async {
    try {
      List<Worker> workers = [];
      final workersSnapshot =
          await _firebaseFirestore.collection('workers').get();
      if (workersSnapshot.docs.isNotEmpty) {
        for (var worker in workersSnapshot.docs) {
          workers.add(Worker.fromJson(worker.data()));
        }
        return workers;
      } else {
        return [];
      }
    } catch (e) {
      throw Exception('Error al obtener los trabajadores');
    }
  }

    Future<List<Worker>> searchWorkerbyDNI(String dni)async {
      // traer los trabajadores que tengan el dni que se pasa por parametro
      final response = await _firebaseFirestore
          .collection('workers')
          .where('dni', isEqualTo: int.parse(dni))
          .get();
      if (response.docs.isEmpty) {
        return [];
      }
      return response.docs.map((e) => Worker.fromJson(e.data())).toList();

    }
}
