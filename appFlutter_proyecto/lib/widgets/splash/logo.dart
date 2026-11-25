import 'package:flutter/material.dart';
import 'package:app_proyecto/theme/app_tema.dart';

/// Logo M&Z con animación de entrada (aparece y crece) y un pulso suave continuo.
class SplashLogo extends StatefulWidget {
  const SplashLogo({super.key});

  @override
  State<SplashLogo> createState() => _SplashLogoState();
}

class _SplashLogoState extends State<SplashLogo> with TickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..forward();

  late final AnimationController _pulso = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  late final Animation<double> _opacidad = CurvedAnimation(parent: _entrada, curve: Curves.easeOutCubic);
  late final Animation<double> _escalaEntrada = Tween<double>(begin: 0.85, end: 1)
      .animate(CurvedAnimation(parent: _entrada, curve: Curves.easeOutBack));
  late final Animation<double> _escalaPulso = Tween<double>(begin: 0.96, end: 1.04)
      .animate(CurvedAnimation(parent: _pulso, curve: Curves.easeInOut));

  @override
  void dispose() {
    _entrada.dispose();
    _pulso.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacidad,
      child: ScaleTransition(
        scale: _escalaEntrada,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _escalaPulso,
              child: Container(
                width: 170,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: AppColores.dorado.withValues(alpha: 0.25),
                      blurRadius: 40,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset('assets/images/icono_app.png', fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'M&Z SOLUTIONS',
              style: TextStyle(
                color: AppColores.dorado,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.2,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'INNOVATIVE DESIGN',
              style: TextStyle(
                color: Colors.white60,
                fontSize: 13,
                fontWeight: FontWeight.w500,
                letterSpacing: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
