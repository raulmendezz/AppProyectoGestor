// Periodo del calendario en el que no se pueden pedir asuntos propios
// (vacaciones, exámenes...). Viene de GET /api/bloqueos-calendario.
class BloqueoCalendario {
  final int id;
  final DateTime fechaInicio;
  final DateTime fechaFin;
  final String tipo;

  BloqueoCalendario({
    required this.id,
    required this.fechaInicio,
    required this.fechaFin,
    required this.tipo,
  });

  // Ejemplo: {"id":1,"fechaInicio":"2026-12-24","fechaFin":"2026-12-31","tipo":"VACACIONES"}
  factory BloqueoCalendario.fromJson(Map<String, dynamic> json) {
    return BloqueoCalendario(
      id: json['id'],
      fechaInicio: DateTime.parse(json['fechaInicio']),
      fechaFin: DateTime.parse(json['fechaFin']),
      tipo: json['tipo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // La API espera solo la fecha (yyyy-MM-dd), sin la hora.
      'fechaInicio': fechaInicio.toIso8601String().substring(0, 10),
      'fechaFin': fechaFin.toIso8601String().substring(0, 10),
      'tipo': tipo,
    };
  }
}
