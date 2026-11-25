import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/widgets/widgets.dart';

/// Recuadro azul del calendario. Se pliega deslizando hacia arriba
/// y se despliega deslizando hacia abajo.
class CalendarioPanel extends StatelessWidget {
  const CalendarioPanel({super.key});

  static const double _velocidadMinima = 150;

  @override
  Widget build(BuildContext context) {
    final calendario = context.read<CalendarioProvider>();

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onVerticalDragEnd: (detalles) {
        final velocidad = detalles.primaryVelocity ?? 0;
        if (velocidad < -_velocidadMinima) calendario.plegar();
        if (velocidad > _velocidadMinima) calendario.desplegar();
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF1C3A70),
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        child: const SafeArea(
          bottom: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarioCabecera(),
                CalendarioNavegacion(),
                SizedBox(height: 8),
                CalendarioDiasSemana(),
                SizedBox(height: 8),
                CalendarioCuadricula(),
                CalendarioBotonPlegar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
