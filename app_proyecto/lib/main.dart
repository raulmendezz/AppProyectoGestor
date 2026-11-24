import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/providers/tema_provider.dart';
import 'package:app_proyecto/theme/app_tema.dart';
import 'package:app_proyecto/screens/screens.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Carga los nombres de meses y días en español para intl.
  await initializeDateFormatting('es');
  // Providers globales: se pueden usar desde cualquier pantalla.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TemaProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BloqueosProvider()),
        ChangeNotifierProvider(create: (_) => SolicitudesProvider()),
      ],
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
      // Textos de Flutter (selector de fecha, botones Aceptar/Cancelar...) en español.
      locale: const Locale('es'),
      supportedLocales: const [Locale('es')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      home: const SplashScreen(),
    );
  }
}
