import 'package:flutter/material.dart';

class AppColores {
  static const azul = Color(0xFF1C3A70);
  static const dorado = Color(0xFFE9BC3C); // amarillo del logo M&Z
  static const fondoClaro = Color(0xFFF8F9FA);
  static const fondoOscuro = Color(0xFF121212);
  static const tarjetaOscura = Color(0xFF1E1E1E);
  static const splashArriba = Color(0xFF0D1F3C);
  static const splashAbajo = Color(0xFF14171C);
}

class AppTema {
  static ThemeData get claro => _crear(Brightness.light);
  static ThemeData get oscuro => _crear(Brightness.dark);

  static ThemeData _crear(Brightness brillo) {
    final esOscuro = brillo == Brightness.dark;

    return ThemeData(
      brightness: brillo,
      fontFamily: 'Roboto',
      primaryColor: AppColores.azul,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColores.azul,
        brightness: brillo,
        // En modo noche el azul no se ve sobre negro, así que el color principal pasa a ser el dorado.
        primary: esOscuro ? AppColores.dorado : AppColores.azul,
      ),
      scaffoldBackgroundColor: esOscuro ? AppColores.fondoOscuro : AppColores.fondoClaro,
      cardColor: esOscuro ? AppColores.tarjetaOscura : Colors.white,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColores.azul,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
