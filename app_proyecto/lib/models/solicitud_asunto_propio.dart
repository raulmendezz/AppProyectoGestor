import 'package:app_proyecto/models/profesor.dart';

// Estado de una solicitud. "valorApi" es el texto exacto que usa la API.
enum EstadoSolicitud {
  pendiente('PENDIENTE'),
  aprobada('APROBADA'),
  rechazada('RECHAZADA');

  const EstadoSolicitud(this.valorApi);
  final String valorApi;

  static EstadoSolicitud desdeApi(String valor) {
    return EstadoSolicitud.values.firstWhere((e) => e.valorApi == valor);
  }
}

// Si el día pedido es lectivo o no lectivo.
enum TipoLectivo {
  lectivo('LECTIVO'),
  noLectivo('NO_LECTIVO');

  const TipoLectivo(this.valorApi);
  final String valorApi;

  static TipoLectivo desdeApi(String valor) {
    return TipoLectivo.values.firstWhere((e) => e.valorApi == valor);
  }
}

// Solicitud de un día de asuntos propios. Viene de /api/moscosos-solicitudes.
class SolicitudAsuntoPropio {
  final int? id; // null cuando la solicitud es nueva y aún no se ha enviado.
  final DateTime fecha;
  final EstadoSolicitud estado;
  final TipoLectivo tipoLectivo;
  final Profesor profesor;

  SolicitudAsuntoPropio({
    this.id,
    required this.fecha,
    required this.estado,
    required this.tipoLectivo,
    required this.profesor,
  });

  factory SolicitudAsuntoPropio.fromJson(Map<String, dynamic> json) {
    return SolicitudAsuntoPropio(
      id: json['idSolicitud'],
      fecha: DateTime.parse(json['fecha']),
      estado: EstadoSolicitud.desdeApi(json['estado']),
      tipoLectivo: TipoLectivo.desdeApi(json['tipoLectivo']),
      profesor: Profesor.fromJson(json['profesor']),
    );
  }

  // Cuerpo para el POST. Del profesor basta con el id.
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'idSolicitud': id,
      'fecha': fecha.toIso8601String().substring(0, 10),
      'estado': estado.valorApi,
      'tipoLectivo': tipoLectivo.valorApi,
      'profesor': {'idProfesor': profesor.id},
    };
  }
}
