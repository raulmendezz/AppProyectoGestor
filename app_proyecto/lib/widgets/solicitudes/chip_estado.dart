import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';

// Etiqueta de color con el estado de una solicitud.
class ChipEstado extends StatelessWidget {
  final EstadoSolicitud estado;

  const ChipEstado({super.key, required this.estado});

  @override
  Widget build(BuildContext context) {
    final color = switch (estado) {
      EstadoSolicitud.pendiente => Colors.amber.shade700,
      EstadoSolicitud.aprobada => Colors.green,
      EstadoSolicitud.rechazada => Colors.red,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        estado.texto,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}
