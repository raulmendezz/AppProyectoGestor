import 'package:http/http.dart' as http;
import 'package:app_proyecto/config/api_config.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/api_helper.dart';

// Periodos bloqueados del calendario (la app solo los lee).
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
}
