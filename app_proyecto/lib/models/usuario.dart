import 'package:app_proyecto/models/profesor.dart';

// Rol del usuario. "valorApi" es el texto exacto que usa la API.
enum RolUsuario {
  admin('ADMIN', 'Administrador'),
  profesor('PROFESOR', 'Profesor');

  const RolUsuario(this.valorApi, this.texto);
  final String valorApi;
  final String texto; // Para mostrarlo en pantalla.

  static RolUsuario desdeApi(String valor) {
    return RolUsuario.values.firstWhere((e) => e.valorApi == valor);
  }
}

// Usuario que ha iniciado sesión. Viene de GET /api/auth/me.
class Usuario {
  final String username;
  final RolUsuario rol;
  final Profesor? profesor; // null si es un admin sin profesor enlazado.

  Usuario({
    required this.username,
    required this.rol,
    this.profesor,
  });

  // Si no hay profesor (admin), usamos el username.
  String get nombre => profesor?.nombreCompleto ?? username;

  String get primerNombre => profesor?.nombre ?? username;

  String get iniciales {
    final partes = nombre.split(' ');
    final texto = partes.length > 1 ? '${partes[0][0]}${partes[1][0]}' : partes[0][0];
    return texto.toUpperCase();
  }

  // Ejemplo: {"username":"user","rol":"PROFESOR","profesor":{"idProfesor":1,...}}
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'],
      rol: RolUsuario.desdeApi(json['rol']),
      profesor: json['profesor'] == null ? null : Profesor.fromJson(json['profesor']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'rol': rol.valorApi,
      'profesor': profesor?.toJson(),
    };
  }
}
