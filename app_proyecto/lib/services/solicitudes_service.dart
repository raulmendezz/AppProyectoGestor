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
}
