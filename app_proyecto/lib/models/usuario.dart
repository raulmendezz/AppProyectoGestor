class Usuario {
  final String nombre;
  final String rol;
  final String correo;
  final String telefono;

  const Usuario({
    required this.nombre,
    required this.rol,
    required this.correo,
    required this.telefono,
  });

  String get primerNombre => nombre.split(' ').first;

  String get iniciales {
    final partes = nombre.split(' ');
    return partes.length > 1 ? '${partes[0][0]}${partes[1][0]}' : partes[0][0];
  }
}
