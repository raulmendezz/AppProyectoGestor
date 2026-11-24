// Configuración de la API. Si cambia la dirección del servidor, solo se toca aquí.
class ApiConfig {
  // Con el móvil por USB y "adb reverse tcp:8080 tcp:8080",
  // localhost del móvil apunta al puerto 8080 del ordenador.
  static const String urlBase = 'http://localhost:8080';

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
}
