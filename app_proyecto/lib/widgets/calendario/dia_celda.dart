import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/solicitudes/chip_estado.dart';

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

    final bloqueado = context.watch<BloqueosProvider>().estaBloqueado(dia);
    // Las solicitudes solo se pintan para el profesor (el admin solo ve bloqueos).
    final esAdmin = context.watch<AuthProvider>().usuario?.rol == RolUsuario.admin;
    final solicitudes = esAdmin ? <SolicitudAsuntoPropio>[] : context.watch<SolicitudesProvider>().solicitudesDelDia(dia);

    final colorTexto = seleccionado
        ? _azul
        : delMesVisible
            ? Colors.white
            : Colors.white38;

    // Seleccionado: ámbar. Bloqueado: rojo suave. Resto: sin fondo.
    final colorFondo = seleccionado
        ? Colors.amber
        : bloqueado
            ? Colors.redAccent.withValues(alpha: 0.35)
            : Colors.transparent;

    return Center(
      child: InkResponse(
        onTap: () => calendario.seleccionarDia(dia),
        radius: 20,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: colorFondo,
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
              // Puntito con el color del estado de la solicitud de ese día.
              if (solicitudes.isNotEmpty)
                Positioned(
                  bottom: 3,
                  child: Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: ChipEstado.colorDe(solicitudes.first.estado),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
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
