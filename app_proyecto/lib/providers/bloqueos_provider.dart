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

  // Devuelve el bloqueo que incluye ese día, o null si el día está libre.
  BloqueoCalendario? bloqueoDelDia(DateTime dia) {
    final fecha = soloFecha(dia);
    for (final bloqueo in _bloqueos) {
      // El día cuenta si está entre el inicio y el fin, ambos incluidos.
      if (!fecha.isBefore(bloqueo.fechaInicio) && !fecha.isAfter(bloqueo.fechaFin)) {
        return bloqueo;
      }
    }
    return null;
  }

  bool estaBloqueado(DateTime dia) => bloqueoDelDia(dia) != null;
}
