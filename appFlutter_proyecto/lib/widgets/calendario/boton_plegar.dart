import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';

/// Barrita inferior del panel: indica que se puede arrastrar y al tocarla pliega/despliega.
class CalendarioBotonPlegar extends StatelessWidget {
  const CalendarioBotonPlegar({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: context.read<CalendarioProvider>().alternarPlegado,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Center(
          child: Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white54,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ),
    );
  }
}
