// Configuración de la API. Si cambia la dirección del servidor, solo se toca aquí.
class ApiConfig {
  // Se puede cambiar al ejecutar, sin tocar el código:
  //   flutter run --dart-define=API_URL=http://10.0.2.2:8080       (emulador Android)
  //   flutter run --dart-define=API_URL=http://192.168.1.X:8080    (móvil por Wi-Fi, IP del PC)
  // Sin --dart-define se usa localhost:8080, que con el móvil por USB necesita
  // "adb reverse tcp:8080 tcp:8080" (se pierde si cambia el dispositivo o se reinicia adb).
  static const String urlBase = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:8080');

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
