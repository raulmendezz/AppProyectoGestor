import 'package:flutter/material.dart';
import 'package:app_proyecto/utils/utils.dart';

class CalendarioDiasSemana extends StatelessWidget {
  const CalendarioDiasSemana({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: diasSemanaCortos
          .map((dia) => Expanded(
                child: Center(
                  child: Text(dia, style: const TextStyle(color: Colors.white70, fontWeight: FontWeight.bold)),
                ),
              ))
          .toList(),
    );
  }
}
