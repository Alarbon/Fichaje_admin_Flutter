import 'dart:async';

import 'package:fichaje_admin/helpers/debouncer.dart';
import 'package:fichaje_admin/models/signing_model.dart';
import 'package:fichaje_admin/models/worker_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/signing_workers_service.dart';

class SigningWorkersProvider extends ChangeNotifier {
  late final SigningWorkersService _signingWorkersService =
      SigningWorkersService();

  List<Worker>? _workers;
  Worker? _selectedWorker;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dniController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _errorMessage;

  final debounce =
      Debouncer<String>(duration: const Duration(milliseconds: 500));
  final StreamController<Worker> _suggestStreamController =
      StreamController.broadcast();
  Stream<Worker> get suggestionStream => _suggestStreamController.stream;

  void getSuggestionsByQuery(String searchTerm) {
    debounce.value = '';
    debounce.onValue = (value) async {
      final results =
          await _signingWorkersService.getWorkerByDni(int.parse(value));
      _suggestStreamController.add(results!);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debounce.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }

  TextEditingController get lastNameController => _lastNameController;
  TextEditingController get nameController => _nameController;
  TextEditingController get dniController => _dniController;
  TextEditingController get phoneController => _phoneController;
  DateTime? get selectedDate => _selectedDate;
  String? get errorMessage => _errorMessage;

  List<Worker>? get workers => _workers;
  Worker? get selectedWorker => _selectedWorker;

  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  // contructor
  SigningWorkersProvider() {
    getWorkers();
  }

  Future<void> addWorker() async {
    if (!verifyWorkerData(false)) {
      return;
    }
    final newWorker = Worker(
      name: _nameController.text,
      lastName: _lastNameController.text,
      dni: int.parse(_dniController.text),
      phone: int.parse(_phoneController.text),
      birthdate: _selectedDate!,
      isLogged: false,
    );

    _workers?.add(newWorker);
    await _signingWorkersService.addWorker(newWorker);

    //envio snackbar para dar feedback al usuario de que se ha añadido el usuario
    _nameController.clear();
    _lastNameController.clear();
    _dniController.clear();
    _phoneController.clear();
    _selectedDate = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> getWorkers() async {
    _workers = await _signingWorkersService.getWorkers();
    notifyListeners();
  }

  void prepareSelectedWorker(Worker worker) {
    _nameController.text = worker.name;
    _lastNameController.text = worker.lastName;
    _dniController.text = worker.dni.toString();
    _phoneController.text = worker.phone.toString();
    _selectedDate = worker.birthdate;
    _selectedWorker = worker;
    _errorMessage = null;
    notifyListeners();
  }

  void cleanDataFormWorker() {
    _nameController.clear();
    _lastNameController.clear();
    _dniController.clear();
    _phoneController.clear();
    _selectedDate = null;
    _selectedWorker = null;
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> editWorker() {

    if (!verifyWorkerData(true)) {
      return Future.value();
    }

    _selectedWorker!.name = _nameController.text;
    _selectedWorker!.lastName = _lastNameController.text;
    _selectedWorker!.dni = int.parse(_dniController.text);
    _selectedWorker!.phone = int.parse(_phoneController.text);
    _selectedWorker!.birthdate = _selectedDate!;

    _signingWorkersService.updateWorker(_selectedWorker!);
    //actualizo la lista de trabajadores
    _workers = _workers!
        .map((worker) =>
            worker.dni == _selectedWorker!.dni ? _selectedWorker : worker)
        .cast<Worker>()
        .toList();
    return Future.value();
  }

  Future<void> deleteWorker() async {
    await _signingWorkersService.deleteWorker(_selectedWorker!.dni);
    _workers!.removeWhere((element) => element.dni == _selectedWorker!.dni);
    cleanDataFormWorker();
  }

  bool verifyWorkerData(bool isEditing) {
    if (isEditing) {
      if (_nameController.text == selectedWorker!.name &&
          _lastNameController.text == selectedWorker!.lastName &&
          _dniController.text == selectedWorker!.dni.toString() &&
          _selectedDate == selectedWorker!.birthdate &&
          _phoneController.text == selectedWorker!.phone.toString()) {
        _errorMessage = 'No se ha modificado ningún campo';
        notifyListeners();
        return false;
      }
    }
    if (_nameController.text.isEmpty ||
        _lastNameController.text.isEmpty ||
        _dniController.text.isEmpty ||
        _selectedDate == null) {
      _errorMessage = 'Todos los campos son obligatorios';
      notifyListeners();
      return false;
    }

    //compruebo que el dni son solo numeros
    if (int.tryParse(_dniController.text) == null) {
      _errorMessage = 'El DNI debe ser un número';
      notifyListeners();
      return false;
    }

    //compruebo que el telefono son solo numeros
    if (int.tryParse(_phoneController.text) == null) {
      _errorMessage = 'El teléfono debe ser un número';
      notifyListeners();
      return false;
    }

    //compruebo que el telefono tenga 9 digitos
    if (_phoneController.text.length != 9) {
      _errorMessage = 'El teléfono debe tener 9 dígitos';
      notifyListeners();
      return false;
    }
    //compruebo que el dni tenga 8 digitos
    if (_dniController.text.length != 8) {
      _errorMessage = 'El DNI debe tener 8 dígitos';
      notifyListeners();
      return false;
    }

    if (!isEditing) {
      //compruebo que el dni no se repita si no estoy editando
      if (_workers!
          .any((element) => element.dni == int.parse(_dniController.text))) {
        _errorMessage = 'El DNI ya existe';
        notifyListeners();
        return false;
      }
    }
    _errorMessage = null;
    notifyListeners();

    return true;
  }

  String prepareMensaje() {
    List<Signing>? signings = selectedWorker!.signings;
    String mensaje = '';

    if (signings == null || signings.isEmpty) {
      return 'No hay fichajes';
    }

    for (var signing in signings) {
      // Formatear la fecha
      String formattedDate =
          DateFormat('dd/MM/yyyy HH:mm:ss').format(signing.date);
      mensaje += '${signing.type}: $formattedDate\n';
    }
    return mensaje;
  }
}
