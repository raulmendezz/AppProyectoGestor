import 'package:flutter/material.dart';

class Evento {
  final String hora;
  final String titulo;
  final String estado;
  final String horario;
  final Color color;

  const Evento({
    required this.hora,
    required this.titulo,
    required this.estado,
    required this.horario,
    required this.color,
  });
}
