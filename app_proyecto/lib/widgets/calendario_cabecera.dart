import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/utils/utils.dart';

class CalendarioCabecera extends StatelessWidget {
  const CalendarioCabecera({super.key});

  @override
  Widget build(BuildContext context) {
    final calendario = context.watch<CalendarioProvider>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: calendario.alternarPlegado,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                Text(
                  nombreMes(calendario.mesVisible),
                  style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Icon(
                  calendario.plegado ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        Row(
          children: [
            IconButton(
              tooltip: 'Hoy',
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.today, color: Colors.white),
              onPressed: calendario.irAHoy,
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.search, color: Colors.white),
              onPressed: () {},
            ),
            IconButton(
              visualDensity: VisualDensity.compact,
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
