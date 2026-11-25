// Profesor tal y como lo devuelve la API (dentro de una solicitud o en /api/auth/me).
class Profesor {
  final int id;
  final String nombre;
  final String apellidos;
  final String departamento;
  final String especialidad;
  final String? telefono; // Solo viene en /api/auth/me.

  Profesor({
    required this.id,
    required this.nombre,
    required this.apellidos,
    required this.departamento,
    required this.especialidad,
    this.telefono,
  });

  String get nombreCompleto => '$nombre $apellidos';

  factory Profesor.fromJson(Map<String, dynamic> json) {
    return Profesor(
      // En las solicitudes y en /me se llama "idProfesor"; en /api/profesores, "id".
      id: json['idProfesor'] ?? json['id'],
      nombre: json['nombre'],
      apellidos: json['apellidos'],
      departamento: json['departamento'],
      especialidad: json['especialidad'],
      telefono: json['telefono'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idProfesor': id,
      'nombre': nombre,
      'apellidos': apellidos,
      'departamento': departamento,
      'especialidad': especialidad,
      'telefono': telefono,
    };
  }
}
