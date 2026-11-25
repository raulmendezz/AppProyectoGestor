import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/widgets.dart';

// Solo admin: solicitudes de todos los profesores para aprobarlas o rechazarlas.
class GestionSolicitudesScreen extends StatefulWidget {
  const GestionSolicitudesScreen({super.key});

  @override
  State<GestionSolicitudesScreen> createState() => _GestionSolicitudesScreenState();
}

class _GestionSolicitudesScreenState extends State<GestionSolicitudesScreen> {
  @override
  void initState() {
    super.initState();
    // Con token de admin, la API devuelve las solicitudes de todos.
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  Future<void> _cargar() => context.read<SolicitudesProvider>().cargar();

  // Aprobar o rechazar es definitivo, así que se pide confirmación.
  Future<void> _resolver(SolicitudAsuntoPropio solicitud, EstadoSolicitud estado) async {
    final aprobar = estado == EstadoSolicitud.aprobada;
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(aprobar ? 'Aprobar solicitud' : 'Rechazar solicitud'),
        content: Text(
          '${solicitud.profesor.nombreCompleto}\n${fechaLarga(solicitud.fecha)} ${solicitud.fecha.year}\n\n'
          'Esta decisión no se puede deshacer.',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(aprobar ? 'Aprobar' : 'Rechazar'),
          ),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    final error = await context.read<SolicitudesProvider>().resolver(solicitud, estado);
    if (mounted) _avisar(error ?? (aprobar ? 'Solicitud aprobada.' : 'Solicitud rechazada.'));
  }

  Future<void> _cambiarTipo(SolicitudAsuntoPropio solicitud, TipoLectivo tipo) async {
    final error = await context.read<SolicitudesProvider>().cambiarTipoLectivo(solicitud, tipo);
    if (mounted) _avisar(error ?? 'Marcada como ${tipo.texto.toLowerCase()}.');
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController conecta las pestañas de arriba con el contenido de abajo.
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            CurvedHeader(
              height: 160,
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                        const Expanded(
                          child: Center(
                            child: Text(
                              'Solicitudes',
                              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(width: 48),
                      ],
                    ),
                    const TabBar(
                      labelColor: Colors.amber,
                      unselectedLabelColor: Colors.white70,
                      indicatorColor: Colors.amber,
                      dividerColor: Colors.transparent,
                      tabs: [Tab(text: 'Pendientes'), Tab(text: 'Resueltas')],
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: _contenido()),
          ],
        ),
      ),
    );
  }

  Widget _contenido() {
    final provider = context.watch<SolicitudesProvider>();

    switch (provider.estado) {
      case EstadoCarga.cargando:
        return const Center(child: CircularProgressIndicator());
      case EstadoCarga.error:
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.mensajeError, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _cargar, child: const Text('Reintentar')),
            ],
          ),
        );
      case EstadoCarga.vacio:
      case EstadoCarga.ok:
        final pendientes =
            provider.solicitudes.where((s) => s.estado == EstadoSolicitud.pendiente).toList();
        final resueltas =
            provider.solicitudes.where((s) => s.estado != EstadoSolicitud.pendiente).toList();
        return TabBarView(
          children: [
            _lista(pendientes, 'No hay solicitudes pendientes.', conBotones: true),
            _lista(resueltas, 'Todavía no se ha resuelto ninguna.', conBotones: false),
          ],
        );
    }
  }

  Widget _lista(List<SolicitudAsuntoPropio> solicitudes, String textoVacio, {required bool conBotones}) {
    return RefreshIndicator(
      onRefresh: _cargar,
      child: solicitudes.isEmpty
          // ListView para que también se pueda tirar hacia abajo con la lista vacía.
          ? ListView(
              children: [
                const SizedBox(height: 120),
                Center(child: Text(textoVacio, style: const TextStyle(color: Colors.grey))),
              ],
            )
          : ListView.builder(
              padding: const EdgeInsets.all(24),
              itemCount: solicitudes.length,
              itemBuilder: (context, index) {
                final solicitud = solicitudes[index];
                return SolicitudAdminCard(
                  solicitud: solicitud,
                  onCambiarTipo: (tipo) => _cambiarTipo(solicitud, tipo),
                  onAprobar: conBotones ? () => _resolver(solicitud, EstadoSolicitud.aprobada) : null,
                  onRechazar: conBotones ? () => _resolver(solicitud, EstadoSolicitud.rechazada) : null,
                );
              },
            ),
    );
  }
}
