import 'package:flutter/material.dart';
import 'package:app_proyecto/providers/sesion_provider.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usuario = sesionProvider.usuarioActual;
    final profesor = usuario.profesor;

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
                            'Mi perfil',
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
                  Text(usuario.rol.texto, style: const TextStyle(color: Colors.white70, fontSize: 14)),
                ],
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
                  ]
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Si es admin sin profesor, se muestra un guion.
                    ListTile(
                      leading: Icon(Icons.apartment_outlined, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Departamento', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(profesor?.departamento ?? '-', style: const TextStyle(fontSize: 16)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.school_outlined, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Especialidad', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(profesor?.especialidad ?? '-', style: const TextStyle(fontSize: 16)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.phone_outlined, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Teléfono', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(profesor?.telefono ?? '-', style: const TextStyle(fontSize: 16)),
                    ),
                    const Divider(height: 1, indent: 16, endIndent: 16),
                    ListTile(
                      leading: Icon(Icons.person_outline, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Rol', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      subtitle: Text(usuario.rol.texto, style: const TextStyle(fontSize: 16)),
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