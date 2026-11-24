import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';

class _MenuProvider {
  List<OpcionMenu> opciones = const [
    OpcionMenu(icono: Icons.description_outlined, titulo: 'Permisos', subtitulo: 'Solicitudes y días'),
    OpcionMenu(icono: Icons.calendar_today, titulo: 'Calendario', subtitulo: 'Días y bloqueos'),
    OpcionMenu(icono: Icons.notifications_none, titulo: 'Avisos', subtitulo: 'Notificaciones'),
    OpcionMenu(icono: Icons.badge_outlined, titulo: 'Mi perfil', subtitulo: 'Tus datos'),
    OpcionMenu(icono: Icons.settings_outlined, titulo: 'Ajustes', subtitulo: 'Preferencias'),
  ];
}

final menuProvider = _MenuProvider();
