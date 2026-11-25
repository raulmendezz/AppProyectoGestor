import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:app_proyecto/config/api_config.dart';
import 'package:app_proyecto/services/auth_service.dart';

// Error con un mensaje listo para enseñar al usuario.
class ApiException implements Exception {
  final String mensaje;
  final int? codigo; // Código HTTP (401, 409...), null si no hubo respuesta.

  ApiException(this.mensaje, {this.codigo});

  @override
  String toString() => mensaje;
}

// Cabeceras de todas las peticiones. Si hay sesión, añade el token.
Map<String, String> cabeceras() {
  return {
    'Content-Type': 'application/json',
    if (AuthService.token != null) 'Authorization': 'Bearer ${AuthService.token}',
  };
}

// Espera la petición con tiempo límite y traduce los fallos de conexión.
Future<http.Response> enviar(Future<http.Response> peticion) async {
  try {
    return await peticion.timeout(ApiConfig.tiempoEspera);
  } on TimeoutException {
    throw ApiException('El servidor tarda demasiado en responder.');
  } on SocketException {
    throw ApiException('No se puede conectar con el servidor.');
  } on http.ClientException {
    throw ApiException('No se puede conectar con el servidor.');
  }
}

// Devuelve el JSON de la respuesta, o lanza ApiException si la API dio error.
dynamic leerRespuesta(http.Response respuesta) {
  // La API no siempre indica UTF-8, así que lo decodificamos a mano (tildes, ñ).
  final texto = utf8.decode(respuesta.bodyBytes);

  if (respuesta.statusCode >= 200 && respuesta.statusCode < 300) {
    return texto.isEmpty ? null : jsonDecode(texto);
  }

  // Los errores de la API vienen así: {"status":409,"message":"..."}
  String mensaje = 'Error ${respuesta.statusCode}';
  try {
    mensaje = jsonDecode(texto)['message'] ?? mensaje;
  } catch (_) {
    // El cuerpo no era JSON: nos quedamos con el mensaje genérico.
  }
  throw ApiException(mensaje, codigo: respuesta.statusCode);
}
