import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/widgets.dart';

/// Lo que hay el día seleccionado: bloqueos y (para el profesor) su solicitud.
class EventosDiaLista extends StatelessWidget {
  // Si se pasa (admin), al tocar un bloqueo se llama a esta función.
  final ValueChanged<BloqueoCalendario>? onTocarBloqueo;

  const EventosDiaLista({super.key, this.onTocarBloqueo});

  @override
  Widget build(BuildContext context) {
    final dia = context.watch<CalendarioProvider>().diaSeleccionado;
    final bloqueos = context.watch<BloqueosProvider>().bloqueosDelDia(dia);
    final esAdmin = context.watch<AuthProvider>().usuario?.rol == RolUsuario.admin;
    final solicitudes =
        esAdmin ? <SolicitudAsuntoPropio>[] : context.watch<SolicitudesProvider>().solicitudesDelDia(dia);
    final vacio = bloqueos.isEmpty && solicitudes.isEmpty;

    return ListView(
      // Margen inferior para que el botón flotante del admin no tape la última tarjeta.
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 88),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            '${fechaLarga(dia)} ${dia.year}',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        if (vacio)
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Column(
              children: [
                Icon(Icons.event_available, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('Día libre', style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ...bloqueos.map((bloqueo) => BloqueoCard(
              bloqueo: bloqueo,
              onTap: onTocarBloqueo == null ? null : () => onTocarBloqueo!(bloqueo),
            )),
        ...solicitudes.map((solicitud) => SolicitudCard(solicitud: solicitud)),
      ],
    );
  }
}
