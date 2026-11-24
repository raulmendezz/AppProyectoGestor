import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/tema_provider.dart';

class BotonModoNoche extends StatelessWidget {
  const BotonModoNoche({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = context.watch<TemaProvider>();

    return IconButton(
      tooltip: tema.esOscuro ? 'Modo día' : 'Modo noche',
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animacion) => RotationTransition(
          turns: Tween<double>(begin: 0.75, end: 1).animate(animacion),
          child: FadeTransition(opacity: animacion, child: child),
        ),
        child: Icon(
          tema.esOscuro ? Icons.light_mode : Icons.dark_mode,
          key: ValueKey(tema.esOscuro),
          color: Colors.white,
        ),
      ),
      onPressed: tema.alternar,
    );
  }
}
