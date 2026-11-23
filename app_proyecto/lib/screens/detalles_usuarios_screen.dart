import 'package:flutter/material.dart';
import 'package:app_proyecto/providers/usuarios_provider.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class DetallesUsuariosScreen extends StatelessWidget {
  const DetallesUsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = usuariosProvider.usuarioActual;

    return Scaffold(
      body: Column(
        children: [
          CurvedHeader(
            height: 320,
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
                            'Detalle de usuario',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                  const SizedBox(height: 24),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.amber,
                    child: Text(usuario.iniciales, style: const TextStyle(color: Color(0xFF1C3A70), fontSize: 32, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 16),
                  Text(usuario.nombre, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(usuario.rol, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(Icons.email_outlined, color: Color(0xFF1C3A70)),
                      title: const Text('Correo', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(usuario.correo, style: const TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.phone_outlined, color: Color(0xFF1C3A70)),
                      title: const Text('Teléfono', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(usuario.telefono, style: const TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: const Icon(Icons.person_outline, color: Color(0xFF1C3A70)),
                      title: const Text('Rol', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(usuario.rol, style: const TextStyle(fontSize: 16, color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}