import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/widgets/widgets.dart';

/// Cuadrícula de días: mes completo o una sola semana, con animación al plegar.
class CalendarioCuadricula extends StatelessWidget {
  const CalendarioCuadricula({super.key});

  @override
  Widget build(BuildContext context) {
    final dias = context.watch<CalendarioProvider>().diasVisibles;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      alignment: Alignment.topCenter,
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
          childAspectRatio: 1.2,
        ),
        itemCount: dias.length,
        itemBuilder: (context, index) {
          final dia = dias[index];
          if (dia == null) return const SizedBox();
          return CalendarioDiaCelda(dia: dia);
        },
      ),
    );
  }
}
