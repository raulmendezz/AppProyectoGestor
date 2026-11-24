import 'package:flutter/material.dart';
import 'package:app_proyecto/theme/app_tema.dart';

class SplashCargando extends StatelessWidget {
  const SplashCargando({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 44,
          height: 44,
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: AppColores.dorado,
            backgroundColor: Colors.white12,
          ),
        ),
        SizedBox(height: 20),
        Text('Cargando...', style: TextStyle(color: Colors.white70, fontSize: 15)),
      ],
    );
  }
}
