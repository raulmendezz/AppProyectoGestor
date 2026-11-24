import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/auth_provider.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/providers/solicitudes_provider.dart';
import 'package:app_proyecto/utils/utils.dart';

// Ventana que sube desde abajo para pedir un día de asuntos propios.
// Devuelve true al cerrarse si la solicitud se envió bien.
class PedirDiaSheet extends StatefulWidget {
  const PedirDiaSheet({super.key});

  @override
  State<PedirDiaSheet> createState() => _PedirDiaSheetState();
}

class _PedirDiaSheetState extends State<PedirDiaSheet> {
  DateTime? _fecha;
  bool _enviando = false;
  String? _error;

  // Días que no se pueden elegir: fines de semana, bloqueados y ya pedidos.
  bool _sePuedeElegir(DateTime dia) {
    if (dia.weekday == DateTime.saturday || dia.weekday == DateTime.sunday) return false;
    if (context.read<BloqueosProvider>().estaBloqueado(dia)) return false;
    if (context.read<SolicitudesProvider>().solicitudesDelDia(dia).isNotEmpty) return false;
    return true;
  }

  Future<void> _elegirFecha() async {
    final hoy = soloFecha(DateTime.now());
    final limite = DateTime(hoy.year + 1, hoy.month, hoy.day);

    // El selector exige que el día que abre se pueda elegir: buscamos el primero libre.
    var inicial = _fecha ?? hoy;
    while (!_sePuedeElegir(inicial)) {
      inicial = DateTime(inicial.year, inicial.month, inicial.day + 1);
      if (inicial.isAfter(limite)) {
        setState(() => _error = 'No hay ningún día disponible en el próximo año.');
        return;
      }
    }

    final elegida = await showDatePicker(
      context: context,
      initialDate: inicial,
      firstDate: hoy,
      lastDate: limite,
      selectableDayPredicate: _sePuedeElegir,
      helpText: 'Elige el día',
    );
    if (elegida != null) {
      setState(() {
        _fecha = elegida;
        _error = null;
      });
    }
  }

  Future<void> _enviar() async {
    setState(() {
      _enviando = true;
      _error = null;
    });

    final profesor = context.read<AuthProvider>().usuario!.profesor!;
    // El profesor no elige el tipo: siempre se pide como lectivo y el admin lo cambia si hace falta.
    final error = await context.read<SolicitudesProvider>().crear(_fecha!, TipoLectivo.lectivo, profesor);

    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _error = error;
        _enviando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Solo ocupa lo que necesita.
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Pedir un día', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text(
              'La solicitud quedará pendiente hasta que la apruebe el administrador.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: _enviando ? null : _elegirFecha,
              icon: const Icon(Icons.calendar_today),
              label: Text(_fecha == null ? 'Elegir fecha' : '${fechaLarga(_fecha!)} ${_fecha!.year}'),
              style: OutlinedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
            ),
            if (_error != null) ...[
              const SizedBox(height: 16),
              Text(_error!, style: const TextStyle(color: Colors.red)),
            ],
            const SizedBox(height: 16),
            ElevatedButton(
              // Desactivado hasta elegir fecha y mientras se envía.
              onPressed: _fecha == null || _enviando ? null : _enviar,
              child: _enviando
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Enviar solicitud'),
            ),
          ],
        ),
      ),
    );
  }
}
