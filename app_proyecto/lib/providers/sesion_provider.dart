import 'package:app_proyecto/models/models.dart';

/// Usuario que ha iniciado sesión. Es el único usuario accesible en la app.
class _SesionProvider {
  Usuario usuarioActual = const Usuario(
    nombre: 'Ana García López',
    rol: 'Profesora',
    correo: 'ana.garcia@centro.es',
    telefono: '600 111 222',
  );
}

final sesionProvider = _SesionProvider();
