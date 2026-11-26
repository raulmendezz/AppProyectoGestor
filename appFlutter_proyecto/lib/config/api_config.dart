import 'package:shared_preferences/shared_preferences.dart';

// Configuración de la API. Si cambia la dirección del servidor, solo se toca aquí.
class ApiConfig {
  static const String _keyUrl = 'server_url';

  // URL activa. Se carga al arrancar desde SharedPreferences; si no hay nada guardado,
  // se usa el valor de --dart-define=API_URL o, en su defecto, localhost.
  static String urlBase = String.fromEnvironment('API_URL', defaultValue: 'http://10.0.2.2:8080');

  // Tiempo máximo de espera de cada petición.
  static const Duration tiempoEspera = Duration(seconds: 10);

  // Endpoints que usa la app.
  static const String login = '/api/auth/login';
  static const String me = '/api/auth/me';
  static const String bloqueos = '/api/bloqueos-calendario';
  static const String solicitudes = '/api/moscosos-solicitudes';
  static const String configuracion = '/api/configuracion';

  // Construye la URL completa, por ejemplo: ApiConfig.url(ApiConfig.me).
  static Uri url(String ruta) => Uri.parse('$urlBase$ruta');

  // Carga la URL guardada en el dispositivo. Llamar desde main() antes de runApp.
  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final guardada = prefs.getString(_keyUrl);
    if (guardada != null && guardada.isNotEmpty) urlBase = guardada;
  }

  // Guarda una nueva URL en el dispositivo para que persista entre sesiones.
  static Future<void> guardarUrl(String nuevaUrl) async {
    urlBase = nuevaUrl;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUrl, nuevaUrl);
  }
}
