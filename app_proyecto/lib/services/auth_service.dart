import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:app_proyecto/config/api_config.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/api_helper.dart';

// Login, datos del usuario logueado y cierre de sesión.
class AuthService {
  // Token JWT de la sesión actual. Lo usan todos los servicios en sus cabeceras.
  static String? token;

  // POST /api/auth/login. Si va bien, guarda el token.
  static Future<void> login(String username, String password) async {
    final respuesta = await enviar(http.post(
      ApiConfig.url(ApiConfig.login),
      headers: cabeceras(),
      body: jsonEncode({'username': username, 'password': password}),
    ));
    final json = leerRespuesta(respuesta);
    token = json['token'];
  }

  // GET /api/auth/me. Devuelve el usuario logueado con su profesor.
  static Future<Usuario> obtenerUsuario() async {
    final respuesta = await enviar(http.get(
      ApiConfig.url(ApiConfig.me),
      headers: cabeceras(),
    ));
    return Usuario.fromJson(leerRespuesta(respuesta));
  }

  static void cerrarSesion() {
    token = null;
  }
}
