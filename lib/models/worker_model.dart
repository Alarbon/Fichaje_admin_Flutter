import 'package:fichaje_admin/models/signing_model.dart';

class Worker {
  String name;
  String lastName;
  int dni;
  int phone;
  DateTime birthdate;
  bool isLogged = false;
  List<Signing>? signings;

  Worker({
    required this.name,
    required this.lastName,
    required this.dni,
    required this.phone,
    required this.birthdate,
    required this.isLogged,
    this.signings,
  });

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'lastName': lastName,
      'dni': dni,
      'phone': phone,
      'birthdate': birthdate.toIso8601String(),
      'isLogged': isLogged,
      'signings': signings?.map((e) => e.toJson()).toList(),
    };
  }

  // fromjson
  factory Worker.fromJson(Map<String, dynamic> json) {
    return Worker(
      name: json['name'],
      lastName: json['lastName'],
      dni: json['dni'],
      phone: json['phone'],
      birthdate: DateTime.parse(json['birthdate']),
      isLogged: json['isLogged'],
      signings: json['signings'] == null
          ? null
          : List<Signing>.from(json["signings"].map((x) => Signing.fromJson(x))),
    );
  }
}
