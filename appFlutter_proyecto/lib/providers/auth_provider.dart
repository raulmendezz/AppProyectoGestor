import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/auth_service.dart';

// Sesión del usuario: login, datos del usuario logueado y cierre de sesión.
class AuthProvider extends ChangeNotifier {
  Usuario? _usuario;
  EstadoCarga _estado = EstadoCarga.vacio; // vacio = nadie ha iniciado sesión.
  String _mensajeError = '';

  Usuario? get usuario => _usuario;
  EstadoCarga get estado => _estado;
  String get mensajeError => _mensajeError;

  // Hace login y pide los datos del usuario. Devuelve true si todo fue bien.
  Future<bool> login(String username, String password) async {
    _estado = EstadoCarga.cargando;
    notifyListeners();

    try {
      await AuthService.login(username, password);
      _usuario = await AuthService.obtenerUsuario();
      _estado = EstadoCarga.ok;
      notifyListeners();
      return true;
    } catch (e) {
      AuthService.cerrarSesion(); // Por si el login fue bien pero /me falló.
      _mensajeError = e.toString();
      _estado = EstadoCarga.error;
      notifyListeners();
      return false;
    }
  }

  void cerrarSesion() {
    AuthService.cerrarSesion();
    _usuario = null;
    _estado = EstadoCarga.vacio;
    notifyListeners();
  }
}
