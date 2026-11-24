import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/utils/utils.dart';

/// Flechas para pasar de mes (o de semana cuando el calendario está plegado).
class CalendarioNavegacion extends StatelessWidget {
  const CalendarioNavegacion({super.key});

  @override
  Widget build(BuildContext context) {
    final calendario = context.watch<CalendarioProvider>();
    final mes = calendario.mesVisible;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white),
          onPressed: calendario.anterior,
        ),
        Text(
          '${nombreMes(mes)} ${mes.year}',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right, color: Colors.white),
          onPressed: calendario.siguiente,
        ),
      ],
    );
  }
}
