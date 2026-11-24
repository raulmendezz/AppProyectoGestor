import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/providers/eventos_provider.dart';
import 'package:app_proyecto/utils/utils.dart';

class CalendarioDiaCelda extends StatelessWidget {
  final DateTime dia;

  const CalendarioDiaCelda({super.key, required this.dia});

  static const _azul = Color(0xFF1C3A70);

  @override
  Widget build(BuildContext context) {
    final calendario = context.watch<CalendarioProvider>();
    final seleccionado = mismoDia(dia, calendario.diaSeleccionado);
    final esHoy = mismoDia(dia, calendario.hoy);
    final delMesVisible = dia.month == calendario.mesVisible.month;
    final tieneEventos = eventosProvider.tieneEventos(dia);

    final colorTexto = seleccionado
        ? _azul
        : delMesVisible
            ? Colors.white
            : Colors.white38;

    return Center(
      child: InkResponse(
        onTap: () => calendario.seleccionarDia(dia),
        radius: 20,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: seleccionado ? Colors.amber : Colors.transparent,
            shape: BoxShape.circle,
            border: esHoy && !seleccionado ? Border.all(color: Colors.amber, width: 1.5) : null,
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                '${dia.day}',
                style: TextStyle(
                  color: colorTexto,
                  fontWeight: seleccionado || esHoy ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              if (tieneEventos)
                Positioned(
                  bottom: 4,
                  child: Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      color: seleccionado ? _azul : Colors.redAccent,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
