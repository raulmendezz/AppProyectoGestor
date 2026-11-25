import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/solicitudes/chip_estado.dart';

// Tarjeta de una solicitud vista por el admin: quién la pide, cuándo,
// selector Lectivo / No lectivo y, si está pendiente, botones Aprobar / Rechazar.
class SolicitudAdminCard extends StatelessWidget {
  final SolicitudAsuntoPropio solicitud;
  final ValueChanged<TipoLectivo> onCambiarTipo;
  final VoidCallback? onAprobar; // null = no se muestran los botones.
  final VoidCallback? onRechazar;

  const SolicitudAdminCard({
    super.key,
    required this.solicitud,
    required this.onCambiarTipo,
    this.onAprobar,
    this.onRechazar,
  });

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  solicitud.profesor.nombreCompleto,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              ChipEstado(estado: solicitud.estado),
            ],
          ),
          const SizedBox(height: 4),
          Text(solicitud.profesor.departamento, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.event, size: 18, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Text('${fechaLarga(solicitud.fecha)} ${solicitud.fecha.year}'),
            ],
          ),
          const SizedBox(height: 12),
          // Selector de dos opciones; la marcada es el tipo actual.
          SegmentedButton<TipoLectivo>(
            segments: [
              for (final tipo in TipoLectivo.values)
                ButtonSegment(value: tipo, label: Text(tipo.texto)),
            ],
            selected: {solicitud.tipoLectivo},
            onSelectionChanged: (seleccion) => onCambiarTipo(seleccion.first),
            showSelectedIcon: false,
          ),
          if (onAprobar != null && onRechazar != null) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onRechazar,
                    icon: const Icon(Icons.close),
                    label: const Text('Rechazar'),
                    style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onAprobar,
                    icon: const Icon(Icons.check),
                    label: const Text('Aprobar'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
