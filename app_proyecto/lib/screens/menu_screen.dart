import 'package:flutter/material.dart';
import 'package:app_proyecto/providers/menu_provider.dart';
import 'package:app_proyecto/providers/usuarios_provider.dart';
import 'package:app_proyecto/screens/screens.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuItems = menuProvider.opciones;
    final usuario = usuariosProvider.usuarioActual;

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
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const DetallesUsuariosScreen()),
                      );
                    },
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.amber,
                      child: Text(usuario.iniciales, style: const TextStyle(color: Color(0xFF1C3A70), fontWeight: FontWeight.bold)),
                    ),
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
                    if (item.titulo == 'Calendario') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const CalendarioScreen()),
                      );
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))
                      ]
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(item.icono, color: const Color(0xFF1C3A70), size: 32),
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
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: const BorderSide(color: Color(0xFF1C3A70)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Cerrar sesión', style: TextStyle(color: Color(0xFF1C3A70))),
            ),
          )
        ],
      ),
    );
  }
}