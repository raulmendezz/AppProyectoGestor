import 'package:flutter/material.dart';
import 'package:app_proyecto/utils/datos_prueba.dart';
import 'package:app_proyecto/widgets/widgets.dart';

// "Mis asuntos propios": lista de los días que ha pedido el profesor.
class SolicitudesScreen extends StatelessWidget {
  const SolicitudesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // De momento datos de prueba; en la Fase 5 vendrán de SolicitudesProvider.
    final solicitudes = solicitudesPrueba;

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 2),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Abrirá el formulario "Pedir día" (siguiente tarea).
        },
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
          Expanded(
            child: solicitudes.isEmpty
                ? const Center(
                    child: Text('Aún no has pedido ningún día.', style: TextStyle(color: Colors.grey)),
                  )
                : ListView.builder(
                    // Margen inferior para que el botón flotante no tape la última tarjeta.
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 88),
                    itemCount: solicitudes.length,
                    itemBuilder: (context, index) => SolicitudCard(solicitud: solicitudes[index]),
                  ),
          ),
        ],
      ),
    );
  }
}
