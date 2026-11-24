import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:app_proyecto/models/models.dart';

// Tarjeta de un periodo bloqueado. Si se pasa onTap (admin), se puede tocar para editarlo o borrarlo.
class BloqueoCard extends StatelessWidget {
  final BloqueoCalendario bloqueo;
  final VoidCallback? onTap;

  const BloqueoCard({super.key, required this.bloqueo, this.onTap});

  @override
  Widget build(BuildContext context) {
    final formato = DateFormat('d MMM yyyy', 'es');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: const Border(left: BorderSide(color: Colors.redAccent, width: 4)),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.block, color: Colors.redAccent),
        title: Text(bloqueo.tipo, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('Del ${formato.format(bloqueo.fechaInicio)} al ${formato.format(bloqueo.fechaFin)}'),
        trailing: onTap != null ? const Icon(Icons.more_vert) : null,
      ),
    );
  }
}
