import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/providers/bloqueos_provider.dart';
import 'package:app_proyecto/utils/utils.dart';

// Formulario (desde abajo) para crear o editar un bloqueo. Solo admin.
// Devuelve true al cerrarse si se guardó bien.
class BloqueoFormSheet extends StatefulWidget {
  final BloqueoCalendario? bloqueo; // null = crear uno nuevo.
  final DateTime diaInicial; // Día seleccionado en el calendario.

  const BloqueoFormSheet({super.key, this.bloqueo, required this.diaInicial});

  @override
  State<BloqueoFormSheet> createState() => _BloqueoFormSheetState();
}

class _BloqueoFormSheetState extends State<BloqueoFormSheet> {
  static const _tiposFijos = ['Vacaciones', 'Exámenes', 'Festivo', 'Evaluación'];
  static const _otro = 'Otro';

  late DateTime _inicio;
  late DateTime _fin;
  late String _tipoElegido;
  final _otroController = TextEditingController();
  bool _guardando = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    final bloqueo = widget.bloqueo;
    _inicio = bloqueo?.fechaInicio ?? soloFecha(widget.diaInicial);
    _fin = bloqueo?.fechaFin ?? _inicio;

    // Si el tipo guardado coincide con uno de la lista (sin mirar mayúsculas) se marca ese;
    // si no, se marca "Otro" con el texto escrito.
    _tipoElegido = _otro;
    if (bloqueo != null) {
      for (final tipo in _tiposFijos) {
        if (tipo.toLowerCase() == bloqueo.tipo.toLowerCase()) _tipoElegido = tipo;
      }
      if (_tipoElegido == _otro) _otroController.text = bloqueo.tipo;
    } else {
      _tipoElegido = _tiposFijos.first;
    }
  }

  @override
  void dispose() {
    _otroController.dispose();
    super.dispose();
  }

  Future<void> _elegirFecha({required bool esInicio}) async {
    final elegida = await showDatePicker(
      context: context,
      initialDate: esInicio ? _inicio : _fin,
      // La fecha de fin no puede ser anterior a la de inicio.
      firstDate: esInicio ? DateTime(2020) : _inicio,
      lastDate: DateTime(2035),
    );
    if (elegida == null) return;
    setState(() {
      if (esInicio) {
        _inicio = elegida;
        if (_fin.isBefore(_inicio)) _fin = _inicio; // Mueve el fin si se queda antes.
      } else {
        _fin = elegida;
      }
    });
  }

  Future<void> _guardar() async {
    final tipo = _tipoElegido == _otro ? _otroController.text.trim() : _tipoElegido;
    if (tipo.isEmpty) {
      setState(() => _error = 'Escribe el tipo de bloqueo.');
      return;
    }

    setState(() {
      _guardando = true;
      _error = null;
    });

    final bloqueo = BloqueoCalendario(
      id: widget.bloqueo?.id, // Con id se actualiza; sin id se crea.
      fechaInicio: _inicio,
      fechaFin: _fin,
      tipo: tipo,
    );
    final error = await context.read<BloqueosProvider>().guardar(bloqueo);

    if (!mounted) return;
    if (error == null) {
      Navigator.pop(context, true);
    } else {
      setState(() {
        _error = error;
        _guardando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      // Sube el formulario cuando aparece el teclado (campo "Otro").
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                widget.bloqueo == null ? 'Nuevo bloqueo' : 'Editar bloqueo',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: _botonFecha('Desde', _inicio, esInicio: true)),
                  const SizedBox(width: 12),
                  Expanded(child: _botonFecha('Hasta', _fin, esInicio: false)),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _tipoElegido,
                decoration: const InputDecoration(labelText: 'Tipo', border: OutlineInputBorder()),
                items: [
                  for (final tipo in [..._tiposFijos, _otro]) DropdownMenuItem(value: tipo, child: Text(tipo)),
                ],
                onChanged: _guardando ? null : (valor) => setState(() => _tipoElegido = valor!),
              ),
              if (_tipoElegido == _otro) ...[
                const SizedBox(height: 16),
                TextField(
                  controller: _otroController,
                  maxLength: 60, // Mismo límite que la columna de la base de datos.
                  decoration: const InputDecoration(labelText: 'Escribe el tipo', border: OutlineInputBorder()),
                ),
              ],
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _guardando ? null : _guardar,
                child: _guardando
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonFecha(String texto, DateTime fecha, {required bool esInicio}) {
    return OutlinedButton(
      onPressed: _guardando ? null : () => _elegirFecha(esInicio: esInicio),
      style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
      child: Column(
        children: [
          Text(texto, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text('${fecha.day}/${fecha.month}/${fecha.year}', style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
