import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/providers/eventos_provider.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/widgets.dart';

/// Lista de eventos del día seleccionado en el calendario.
class EventosDiaLista extends StatelessWidget {
  const EventosDiaLista({super.key});

  @override
  Widget build(BuildContext context) {
    final dia = context.watch<CalendarioProvider>().diaSeleccionado;
    final eventos = eventosProvider.eventosDelDia(dia);

    return ListView(
      padding: const EdgeInsets.only(top: 16, left: 24, right: 24, bottom: 24),
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Text(
            fechaLarga(dia),
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        if (eventos.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 32),
            child: Column(
              children: [
                Icon(Icons.event_available, size: 48, color: Colors.grey),
                SizedBox(height: 8),
                Text('No hay eventos para este día', style: TextStyle(color: Colors.grey)),
              ],
            ),
          )
        else
          ...eventos.map((evento) => EventoCard(evento: evento)),
      ],
    );
  }
}
