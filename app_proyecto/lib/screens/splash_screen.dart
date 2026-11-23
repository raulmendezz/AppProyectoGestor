import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C3A70),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              clipBehavior: Clip.hardEdge, // Para que la imagen respete los bordes redondeados
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),
            const Text('IES Marcos Zaragoza', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('Días de libre disposición', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 80),
            const CircularProgressIndicator(color: Colors.amber),
          ],
        ),
      ),
    );
  }
}