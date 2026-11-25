import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/providers/menu_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/screens/screens.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().usuario;
    // Al cerrar sesión, durante la animación de salida ya no hay usuario.
    if (usuario == null) return const Scaffold();

    // "Permisos" (pedir días) es solo del profesor y "Solicitudes" (aprobar) solo del admin.
    final esAdmin = usuario.rol == RolUsuario.admin;
    final menuItems = menuProvider.opciones.where((opcion) {
      if (opcion.titulo == 'Permisos') return !esAdmin;
      if (opcion.titulo == 'Solicitudes') return esAdmin;
      return true;
    }).toList();

    return Scaffold(
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 0),
      body: Column(
        children: [
          CurvedHeader(
            height: 180,
            child: Padding(
              padding: const EdgeInsets.only(top: 60, left: 24, right: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Bienvenido/a', style: TextStyle(color: Colors.white70)),
                      Text('Hola, ${usuario.primerNombre}', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      const Text('¿Qué quieres hacer hoy?', style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                  Row(
                    children: [
                      const BotonModoNoche(),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PerfilScreen()),
                          );
                        },
                        child: CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.amber,
                          child: Text(usuario.iniciales, style: const TextStyle(color: Color(0xFF1C3A70), fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(24),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.1,
              ),
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return GestureDetector(
                  onTap: () {
                    final Widget? destino = switch (item.titulo) {
                      'Permisos' => const SolicitudesScreen(),
                      'Solicitudes' => const GestionSolicitudesScreen(),
                      'Calendario' => const CalendarioScreen(),
                      'Mi perfil' => const PerfilScreen(),
                      _ => null,
                    };
                    if (destino != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => destino));
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icono, color: Theme.of(context).colorScheme.primary, size: 32),
                        const SizedBox(height: 12),
                        Text(item.titulo, style: const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Text(item.subtitulo, style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: OutlinedButton(
              onPressed: () {
                // Borra el token y las solicitudes para que el siguiente usuario no las vea.
                context.read<AuthProvider>().cerrarSesion();
                context.read<SolicitudesProvider>().limpiar();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: Theme.of(context).colorScheme.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: Text('Cerrar sesión', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
            ),
          )
        ],
      ),
    );
  }
}