import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/tema_provider.dart';
import 'package:app_proyecto/theme/app_tema.dart';
import 'package:app_proyecto/screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carga los nombres de meses y días en español para intl.
  await initializeDateFormatting('es');
  runApp(
    ChangeNotifierProvider(
      create: (_) => TemaProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tema = context.watch<TemaProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'IES Marcos Zaragoza',
      theme: AppTema.claro,
      darkTheme: AppTema.oscuro,
      themeMode: tema.modo,
      home: const SplashScreen(),
    );
  }
}
