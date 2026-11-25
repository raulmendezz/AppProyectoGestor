import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_proyecto/config/api_config.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/api_helper.dart';

// Solicitudes de asuntos propios del profesor logueado.
class SolicitudesService {
  // GET /api/moscosos-solicitudes (la API ya devuelve solo las del profesor).
  static Future<List<SolicitudAsuntoPropio>> obtenerSolicitudes() async {
    final respuesta = await enviar(http.get(
      ApiConfig.url(ApiConfig.solicitudes),
      headers: cabeceras(),
    ));
    final List lista = leerRespuesta(respuesta);
    return lista.map((json) => SolicitudAsuntoPropio.fromJson(json)).toList();
  }

  // POST /api/moscosos-solicitudes. Devuelve la solicitud ya guardada (con su id).
  static Future<SolicitudAsuntoPropio> crearSolicitud(SolicitudAsuntoPropio solicitud) async {
    final respuesta = await enviar(http.post(
      ApiConfig.url(ApiConfig.solicitudes),
      headers: cabeceras(),
      body: jsonEncode(solicitud.toJson()),
    ));
    return SolicitudAsuntoPropio.fromJson(leerRespuesta(respuesta));
  }

  // PATCH /api/moscosos-solicitudes/{id}/estado (solo admin). Aprobar o rechazar.
  static Future<SolicitudAsuntoPropio> cambiarEstado(int id, EstadoSolicitud estado) async {
    final respuesta = await enviar(http.patch(
      ApiConfig.url('${ApiConfig.solicitudes}/$id/estado'),
      headers: cabeceras(),
      body: jsonEncode({'estado': estado.valorApi}),
    ));
    return SolicitudAsuntoPropio.fromJson(leerRespuesta(respuesta));
  }

  // PUT /api/moscosos-solicitudes/{id} (admin). Cambia el tipo lectivo.
  // No se manda el profesor: si se manda, la API lo devuelve sin nombre en la respuesta.
  static Future<SolicitudAsuntoPropio> cambiarTipoLectivo(SolicitudAsuntoPropio solicitud, TipoLectivo tipo) async {
    final respuesta = await enviar(http.put(
      ApiConfig.url('${ApiConfig.solicitudes}/${solicitud.id}'),
      headers: cabeceras(),
      body: jsonEncode({
        'fecha': solicitud.fecha.toIso8601String().substring(0, 10),
        'estado': solicitud.estado.valorApi,
        'tipoLectivo': tipo.valorApi,
      }),
    ));
    return SolicitudAsuntoPropio.fromJson(leerRespuesta(respuesta));
  }

  // DELETE /api/moscosos-solicitudes/{id}. El profesor solo puede borrar las pendientes.
  static Future<void> eliminarSolicitud(int id) async {
    final respuesta = await enviar(http.delete(
      ApiConfig.url('${ApiConfig.solicitudes}/$id'),
      headers: cabeceras(),
    ));
    leerRespuesta(respuesta); // Solo para lanzar el error si la API lo rechaza.
  }
}
