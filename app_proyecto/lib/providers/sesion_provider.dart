import 'package:app_proyecto/models/models.dart';

/// Usuario que ha iniciado sesión. Es el único usuario accesible en la app.
/// De momento son datos de prueba; en la Fase 5 vendrán de /api/auth/me.
class _SesionProvider {
  Usuario usuarioActual = Usuario(
    username: 'user',
    rol: RolUsuario.profesor,
    profesor: Profesor(
      id: 1,
      nombre: 'Raul',
      apellidos: 'Martinez Lopez',
      departamento: 'Tecnologia',
      especialidad: 'Informatica',
      telefono: '600123456',
    ),
  );
}

final sesionProvider = _SesionProvider();
