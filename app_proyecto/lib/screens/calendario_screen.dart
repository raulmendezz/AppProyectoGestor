import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class CalendarioScreen extends StatelessWidget {
  const CalendarioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Se crea al abrir la pantalla, así siempre arranca en el día de hoy.
    return ChangeNotifierProvider(
      create: (_) => CalendarioProvider(),
      child: const Scaffold(
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
        body: Column(
          children: [
            CalendarioPanel(),
            Expanded(child: EventosDiaLista()),
          ],
        ),
      ),
    );
  }
}
