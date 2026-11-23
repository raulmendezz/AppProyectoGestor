import 'package:flutter/material.dart';
import 'package:app_proyecto/screens/screens.dart';

class UsuariosScreen extends StatelessWidget {
  const UsuariosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuarios', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1C3A70),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 4,
        itemBuilder: (context, index) {
          return Card(
            color: Colors.white,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFF1C3A70),
                child: Text('US', style: TextStyle(color: Colors.white)),
              ),
              title: const Text('Nombre Usuario', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Rol del usuario'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DetallesUsuariosScreen()),
                );
              },
            ),
          );
        },
      ),
    );
  }
}