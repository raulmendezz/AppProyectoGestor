import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';

// Etiqueta de color con el estado de una solicitud.
class ChipEstado extends StatelessWidget {
  final EstadoSolicitud estado;

  const ChipEstado({super.key, required this.estado});

  // Color de cada estado. Es static para usarlo también en el calendario.
  static Color colorDe(EstadoSolicitud estado) {
    return switch (estado) {
      EstadoSolicitud.pendiente => Colors.amber.shade700,
      EstadoSolicitud.aprobada => Colors.green,
      EstadoSolicitud.rechazada => Colors.red,
    };
  }

  @override
  Widget build(BuildContext context) {
    final color = colorDe(estado);

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
