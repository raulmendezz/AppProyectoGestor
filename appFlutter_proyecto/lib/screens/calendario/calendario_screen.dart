import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/providers/calendario_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class CalendarioScreen extends StatefulWidget {
  const CalendarioScreen({super.key});

  @override
  State<CalendarioScreen> createState() => _CalendarioScreenState();
}

class _CalendarioScreenState extends State<CalendarioScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  bool get _esAdmin => context.read<AuthProvider>().usuario?.rol == RolUsuario.admin;

  // Bloqueos para todos; las solicitudes solo hacen falta al profesor
  // (al admin la API le devolvería las de todos y no las pintamos).
  Future<void> _cargar() async {
    await Future.wait([
      context.read<BloqueosProvider>().cargar(),
      if (!_esAdmin) context.read<SolicitudesProvider>().cargar(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    // El CalendarioProvider se crea al abrir la pantalla, así siempre arranca en el día de hoy.
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
