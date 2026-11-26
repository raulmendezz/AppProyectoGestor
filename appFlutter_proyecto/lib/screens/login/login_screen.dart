import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/config/api_config.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/screens/screens.dart';
import 'package:app_proyecto/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Guardan lo que el usuario escribe en cada campo.
  final _usuarioController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _errorCampos; // Error antes de llamar a la API (campos vacíos).

  @override
  void dispose() {
    _usuarioController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _entrar() async {
    final usuario = _usuarioController.text.trim();
    final password = _passwordController.text;

    if (usuario.isEmpty || password.isEmpty) {
      setState(() => _errorCampos = 'Escribe tu usuario y tu contraseña.');
      return;
    }
    setState(() => _errorCampos = null);

    final correcto = await context.read<AuthProvider>().login(usuario, password);

    // Tras un await la pantalla podría haberse cerrado: comprobamos que sigue.
    if (!mounted) return;
    if (correcto) {
      _passwordController.clear();
      // pushReplacement: con "atrás" no se vuelve al login.
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuScreen()));
    }
  }

  void _mostrarConfiguracionServidor(BuildContext context) {
    final controller = TextEditingController(text: ApiConfig.urlBase);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('URL del servidor'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Introduce la dirección del servidor al que conectarse.',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'http://192.168.1.X:8080',
                labelText: 'Dirección del servidor',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.url,
              autocorrect: false,
              enableSuggestions: false,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              final url = controller.text.trim();
              if (url.isNotEmpty) {
                await ApiConfig.guardarUrl(url);
              }
              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final cargando = auth.estado == EstadoCarga.cargando;
    // Primero el error de campos vacíos; si no, el que devolvió la API.
    final error = _errorCampos ?? (auth.estado == EstadoCarga.error ? auth.mensajeError : null);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                        controller: _usuarioController,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person_outline),
                          hintText: 'Usuario',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Theme.of(context).cardColor,
                          filled: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => cargando ? null : _entrar(), // "Intro" del teclado = ENTRAR.
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.lock_outline),
                          hintText: 'Contraseña',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          fillColor: Theme.of(context).cardColor,
                          filled: true,
                        ),
                      ),
                      if (error != null) ...[
                        const SizedBox(height: 16),
                        Text(error, style: const TextStyle(color: Colors.red)),
                      ],
                      const SizedBox(height: 24),
                      ElevatedButton(
                        // null desactiva el botón mientras se espera a la API.
                        onPressed: cargando ? null : _entrar,
                        child: cargando
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('ENTRAR'),
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
          // Botón de ajustes del servidor (arriba a la derecha, sobre el header).
          Positioned(
            top: MediaQuery.of(context).padding.top + 4,
            right: 4,
            child: IconButton(
              icon: const Icon(Icons.settings_outlined, color: Colors.white70),
              tooltip: 'Configurar servidor',
              onPressed: () => _mostrarConfiguracionServidor(context),
            ),
          ),
        ],
      ),
    );
  }
}
