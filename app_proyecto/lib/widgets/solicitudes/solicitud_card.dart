import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/solicitudes/chip_estado.dart';

// Tarjeta de una solicitud: fecha a la izquierda, datos en el centro y estado a la derecha.
class SolicitudCard extends StatelessWidget {
  final SolicitudAsuntoPropio solicitud;

  const SolicitudCard({super.key, required this.solicitud});

  @override
  Widget build(BuildContext context) {
    final colorPrincipal = Theme.of(context).colorScheme.primary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          // Día y mes, como una hoja de calendario.
          Column(
            children: [
              Text(
                '${solicitud.fecha.day}',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colorPrincipal),
              ),
              Text(
                DateFormat.MMM('es').format(solicitud.fecha).toUpperCase(),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${fechaLarga(solicitud.fecha)} ${solicitud.fecha.year}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(solicitud.tipoLectivo.texto, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          ChipEstado(estado: solicitud.estado),
        ],
      ),
    );
  }
}
