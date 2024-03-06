class Signing {
  DateTime date;
  String type;

  Signing({
    required this.date,
    required this.type,
  });

  // tojson
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'type': type,
    };
  }

  // fromjson
  factory Signing.fromJson(Map<String, dynamic> json) {
    return Signing(
      date: DateTime.parse(json['date']),
      type: json['type'],
    );
  }
}
