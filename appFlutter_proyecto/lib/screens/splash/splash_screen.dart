import 'dart:async';
import 'package:flutter/material.dart';
import 'package:app_proyecto/screens/screens.dart';
import 'package:app_proyecto/theme/app_tema.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class SplashScreen extends StatefulWidget {
  final Duration duracion;

  const SplashScreen({super.key, this.duracion = const Duration(seconds: 3)});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _temporizador;

  @override
  void initState() {
    super.initState();
    _temporizador = Timer(widget.duracion, _irAlLogin);
  }

  void _irAlLogin() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (_, _, _) => const LoginScreen(),
        transitionsBuilder: (_, animacion, _, child) => FadeTransition(opacity: animacion, child: child),
        transitionDuration: const Duration(milliseconds: 450),
      ),
    );
  }

  @override
  void dispose() {
    _temporizador?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColores.splashArriba, AppColores.splashAbajo],
          ),
        ),
        child: const SafeArea(
          child: Column(
            children: [
              Spacer(flex: 3),
              SplashLogo(),
              Spacer(flex: 2),
              SplashCargando(),
              SizedBox(height: 56),
            ],
          ),
        ),
      ),
    );
  }
}
