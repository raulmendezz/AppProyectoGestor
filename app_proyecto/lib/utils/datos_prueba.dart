import 'package:app_proyecto/models/models.dart';

// Datos de prueba para diseñar las pantallas sin la API (Fase 4).
// En la Fase 5 se sustituyen por los providers y este archivo se borra.

final _profesorPrueba = Profesor(
  id: 1,
  nombre: 'Raul',
  apellidos: 'Martinez Lopez',
  departamento: 'Tecnologia',
  especialidad: 'Informatica',
);

final solicitudesPrueba = [
  SolicitudAsuntoPropio(
    id: 3,
    fecha: DateTime(2026, 12, 10),
    estado: EstadoSolicitud.pendiente,
    tipoLectivo: TipoLectivo.lectivo,
    profesor: _profesorPrueba,
  ),
  SolicitudAsuntoPropio(
    id: 1,
    fecha: DateTime(2026, 12, 15),
    estado: EstadoSolicitud.aprobada,
    tipoLectivo: TipoLectivo.lectivo,
    profesor: _profesorPrueba,
  ),
  SolicitudAsuntoPropio(
    id: 7,
    fecha: DateTime(2027, 2, 3),
    estado: EstadoSolicitud.rechazada,
    tipoLectivo: TipoLectivo.noLectivo,
    profesor: _profesorPrueba,
  ),
];
