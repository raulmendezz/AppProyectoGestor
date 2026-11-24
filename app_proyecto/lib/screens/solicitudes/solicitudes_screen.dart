import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/utils/utils.dart';
import 'package:app_proyecto/widgets/widgets.dart';

// "Mis asuntos propios": lista de los días que ha pedido el profesor.
class SolicitudesScreen extends StatefulWidget {
  const SolicitudesScreen({super.key});

  @override
  State<SolicitudesScreen> createState() => _SolicitudesScreenState();
}

class _SolicitudesScreenState extends State<SolicitudesScreen> {
  @override
  void initState() {
    super.initState();
    // Se pide después del primer dibujado, porque cargar() avisa a los widgets que escuchan.
    WidgetsBinding.instance.addPostFrameCallback((_) => _cargar());
  }

  // Solicitudes para la lista y bloqueos para desactivar esos días al pedir.
  Future<void> _cargar() async {
    await Future.wait([
      context.read<SolicitudesProvider>().cargar(),
      context.read<BloqueosProvider>().cargar(),
    ]);
  }

  Future<void> _pedirDia() async {
    final enviada = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const PedirDiaSheet(),
    );
    if (enviada == true && mounted) {
      _avisar('Solicitud enviada. Queda pendiente de aprobar.');
    }
  }

  Future<void> _anular(SolicitudAsuntoPropio solicitud) async {
    final confirmado = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Anular solicitud'),
        content: Text('¿Seguro que quieres anular el ${fechaLarga(solicitud.fecha)}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('No')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Sí, anular')),
        ],
      ),
    );
    if (confirmado != true || !mounted) return;

    final error = await context.read<SolicitudesProvider>().anular(solicitud);
    if (mounted) _avisar(error ?? 'Solicitud anulada.');
  }

  void _avisar(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _pedirDia,
        icon: const Icon(Icons.add),
        label: const Text('Pedir día'),
      ),
      body: Column(
        children: [
          CurvedHeader(
            height: 120,
            child: SafeArea(
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Mis asuntos propios',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 48), // Equilibra el hueco de la flecha.
                ],
              ),
            ),
          ),
          Expanded(child: _contenido()),
        ],
      ),
    );
  }

  // Lo que se ve debajo de la cabecera según el estado de la carga.
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
        return const Center(
          child: Text('Aún no has pedido ningún día.', style: TextStyle(color: Colors.grey)),
        );
      case EstadoCarga.ok:
        // Tirando hacia abajo se vuelve a cargar (por si el admin ha resuelto alguna).
        return RefreshIndicator(
          onRefresh: _cargar,
          child: ListView.builder(
            // Margen inferior para que el botón flotante no tape la última tarjeta.
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 88),
            itemCount: provider.solicitudes.length,
            itemBuilder: (context, index) {
              final solicitud = provider.solicitudes[index];
              return SolicitudCard(
                solicitud: solicitud,
                // Solo las pendientes se pueden anular.
                onAnular: solicitud.estado == EstadoSolicitud.pendiente ? () => _anular(solicitud) : null,
              );
            },
          ),
        );
    }
  }
}
