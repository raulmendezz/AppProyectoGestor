import 'package:flutter/material.dart';

/// Controla si la app está en modo día (claro) o modo noche (oscuro).
class TemaProvider extends ChangeNotifier {
  ThemeMode _modo = ThemeMode.light;

  ThemeMode get modo => _modo;
  bool get esOscuro => _modo == ThemeMode.dark;

  void alternar() {
    _modo = esOscuro ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }
}
