import 'package:flutter/material.dart';
import 'package:app_proyecto/screens/screens.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomCenter,
              children: [
                const CurvedHeader(
                  height: 300,
                  child: SizedBox(), 
                ),
                Transform.translate(
                  offset: const Offset(0, 50),
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        )
                      ],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Iniciar sesión', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Accede con tu cuenta del centro', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 30),
                  TextField(
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.email_outlined),
                      hintText: 'Correo electrónico',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      hintText: 'Contraseña',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Theme.of(context).cardColor,
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
                    },
                    child: const Text('ENTRAR'),
                  ),
                  const SizedBox(height: 16),
                  const Center(
                    child: Text('¿Has olvidado tu contraseña?', style: TextStyle(color: Colors.blue)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}