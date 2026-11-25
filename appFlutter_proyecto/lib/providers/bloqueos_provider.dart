import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/bloqueos_service.dart';
import 'package:app_proyecto/utils/utils.dart';

// Periodos bloqueados del calendario (vacaciones, exámenes...). Son iguales para todos.
class BloqueosProvider extends ChangeNotifier {
  List<BloqueoCalendario> _bloqueos = [];
  EstadoCarga _estado = EstadoCarga.cargando;
  String _mensajeError = '';

  List<BloqueoCalendario> get bloqueos => _bloqueos;
  EstadoCarga get estado => _estado;
  String get mensajeError => _mensajeError;

  Future<void> cargar() async {
    _estado = EstadoCarga.cargando;
    notifyListeners();

    try {
      _bloqueos = await BloqueosService.obtenerBloqueos();
      _estado = _bloqueos.isEmpty ? EstadoCarga.vacio : EstadoCarga.ok;
    } catch (e) {
      _mensajeError = e.toString();
      _estado = EstadoCarga.error;
    }
    notifyListeners();
  }

  // Admin: crea el bloqueo si es nuevo (sin id) o lo actualiza si ya existe.
  // Devuelve null si fue bien o el mensaje de error.
  Future<String?> guardar(BloqueoCalendario bloqueo) async {
    try {
      if (bloqueo.id == null) {
        _bloqueos.add(await BloqueosService.crearBloqueo(bloqueo));
      } else {
        final actualizado = await BloqueosService.actualizarBloqueo(bloqueo);
        // Se cambia en la lista el que tenga el mismo id.
        _bloqueos = _bloqueos.map((b) => b.id == actualizado.id ? actualizado : b).toList();
      }
      _estado = EstadoCarga.ok;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Admin: borra un bloqueo. Devuelve null si fue bien o el mensaje de error.
  Future<String?> eliminar(BloqueoCalendario bloqueo) async {
    try {
      await BloqueosService.eliminarBloqueo(bloqueo.id!);
      _bloqueos.removeWhere((b) => b.id == bloqueo.id);
      if (_bloqueos.isEmpty) _estado = EstadoCarga.vacio;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Todos los bloqueos que incluyen ese día (puede haber varios a la vez).
  List<BloqueoCalendario> bloqueosDelDia(DateTime dia) {
    final fecha = soloFecha(dia);
    // El día cuenta si está entre el inicio y el fin, ambos incluidos.
    return _bloqueos
        .where((b) => !fecha.isBefore(b.fechaInicio) && !fecha.isAfter(b.fechaFin))
        .toList();
  }

  bool estaBloqueado(DateTime dia) => bloqueosDelDia(dia).isNotEmpty;
}
