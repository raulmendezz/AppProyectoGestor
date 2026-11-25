import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_proyecto/config/api_config.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/api_helper.dart';

// Periodos bloqueados del calendario. Leer: todos. Crear, editar y borrar: solo admin.
class BloqueosService {
  // GET /api/bloqueos-calendario
  static Future<List<BloqueoCalendario>> obtenerBloqueos() async {
    final respuesta = await enviar(http.get(
      ApiConfig.url(ApiConfig.bloqueos),
      headers: cabeceras(),
    ));
    final List lista = leerRespuesta(respuesta);
    return lista.map((json) => BloqueoCalendario.fromJson(json)).toList();
  }

  // POST /api/bloqueos-calendario. Devuelve el bloqueo guardado (con su id).
  static Future<BloqueoCalendario> crearBloqueo(BloqueoCalendario bloqueo) async {
    final respuesta = await enviar(http.post(
      ApiConfig.url(ApiConfig.bloqueos),
      headers: cabeceras(),
      body: jsonEncode(bloqueo.toJson()),
    ));
    return BloqueoCalendario.fromJson(leerRespuesta(respuesta));
  }

  // PUT /api/bloqueos-calendario/{id}
  static Future<BloqueoCalendario> actualizarBloqueo(BloqueoCalendario bloqueo) async {
    final respuesta = await enviar(http.put(
      ApiConfig.url('${ApiConfig.bloqueos}/${bloqueo.id}'),
      headers: cabeceras(),
      body: jsonEncode(bloqueo.toJson()),
    ));
    return BloqueoCalendario.fromJson(leerRespuesta(respuesta));
  }

  // DELETE /api/bloqueos-calendario/{id}
  static Future<void> eliminarBloqueo(int id) async {
    final respuesta = await enviar(http.delete(
      ApiConfig.url('${ApiConfig.bloqueos}/$id'),
      headers: cabeceras(),
    ));
    leerRespuesta(respuesta); // Solo para lanzar el error si la API lo rechaza.
  }
}
