import 'package:app_proyecto/models/models.dart';

class _UsuariosProvider {
  Usuario usuarioActual = const Usuario(
    nombre: 'Ana García López',
    rol: 'Profesora',
    correo: 'ana.garcia@centro.es',
    telefono: '600 111 222',
  );
}

final usuariosProvider = _UsuariosProvider();
