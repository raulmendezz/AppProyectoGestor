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

  // Bloqueos para todos; las solicitudes solo hacen falta al profesor.
  Future<void> _cargar() async {
    await Future.wait([
      context.read<BloqueosProvider>().cargar(),
      if (!_esAdmin) context.read<SolicitudesProvider>().cargar(),
    ]);
  }

  // Admin: abre el formulario. Sin bloqueo = crear; con bloqueo = editar.
  // "contexto" es uno que está debajo del CalendarioProvider, para leer el día seleccionado.
  Future<void> _abrirFormulario(BuildContext contexto, {BloqueoCalendario? bloqueo}) async {
    final dia = contexto.read<CalendarioProvider>().diaSeleccionado;
    final guardado = await showModalBottomSheet<bool>(
      context: contexto,
      isScrollControlled: true, // Para que pueda subir con el teclado.
      builder: (_) => BloqueoFormSheet(bloqueo: bloqueo, diaInicial: dia),
    );
    if (guardado == true && mounted) {
      _avisar(bloqueo == null ? 'Bloqueo creado.' : 'Bloqueo actualizado.');
    }
  }

  // Admin: al tocar un bloqueo, elegir entre editarlo o borrarlo.
  Future<void> _opcionesBloqueo(BuildContext contexto, BloqueoCalendario bloqueo) async {
    final opcion = await showModalBottomSheet<String>(
      context: contexto,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit_outlined),
              title: const Text('Editar'),
              onTap: () => Navigator.pop(context, 'editar'),
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: const Text('Borrar', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context, 'borrar'),
            ),
          ],
        ),
      ),
    );
    if (!mounted || !contexto.mounted) return;
    if (opcion == 'editar') await _abrirFormulario(contexto, bloqueo: bloqueo);
    if (opcion == 'borrar') await _borrar(bloqueo);
  }

  Future<void> _borrar(BloqueoCalendario bloqueo) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Borrar bloqueo'),
        content: Text('¿Seguro que quieres borrar "${bloqueo.tipo}"?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Borrar')),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    final error = await context.read<BloqueosProvider>().eliminar(bloqueo);
    if (mounted) _avisar(error ?? 'Bloqueo borrado.');
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    final esAdmin = context.watch<AuthProvider>().usuario?.rol == RolUsuario.admin;

    // El CalendarioProvider se crea al abrir la pantalla, así siempre arranca en el día de hoy.
    return ChangeNotifierProvider(
      create: (_) => CalendarioProvider(),
      // Builder da un context que ya está debajo del CalendarioProvider.
      child: Builder(
        builder: (contexto) => Scaffold(
          bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
          floatingActionButton: esAdmin
              ? FloatingActionButton.extended(
                  onPressed: () => _abrirFormulario(contexto),
                  icon: const Icon(Icons.add),
                  label: const Text('Bloqueo'),
                )
              : null,
          body: Column(
            children: [
              const CalendarioPanel(),
              Expanded(
                child: EventosDiaLista(
                  onTocarBloqueo: esAdmin ? (bloqueo) => _opcionesBloqueo(contexto, bloqueo) : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
