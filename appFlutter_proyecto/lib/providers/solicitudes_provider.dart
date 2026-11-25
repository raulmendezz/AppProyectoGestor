import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/services/solicitudes_service.dart';
import 'package:app_proyecto/utils/utils.dart';

// Solicitudes de asuntos propios del profesor logueado.
class SolicitudesProvider extends ChangeNotifier {
  List<SolicitudAsuntoPropio> _solicitudes = [];
  EstadoCarga _estado = EstadoCarga.cargando;
  String _mensajeError = '';

  List<SolicitudAsuntoPropio> get solicitudes => _solicitudes;
  EstadoCarga get estado => _estado;
  String get mensajeError => _mensajeError;

  Future<void> cargar() async {
    _estado = EstadoCarga.cargando;
    notifyListeners();

    try {
      _solicitudes = await SolicitudesService.obtenerSolicitudes();
      _ordenar();
      _estado = _solicitudes.isEmpty ? EstadoCarga.vacio : EstadoCarga.ok;
    } catch (e) {
      _mensajeError = e.toString();
      _estado = EstadoCarga.error;
    }
    notifyListeners();
  }

  // Pide un día nuevo. Devuelve null si fue bien, o el mensaje de error
  // (día bloqueado, ya pedido, cupo lleno...) para enseñarlo en pantalla.
  // Si falla, la lista que ya se veía no se toca.
  Future<String?> crear(DateTime fecha, TipoLectivo tipoLectivo, Profesor profesor) async {
    final nueva = SolicitudAsuntoPropio(
      fecha: fecha,
      estado: EstadoSolicitud.pendiente, // Toda solicitud nueva empieza pendiente.
      tipoLectivo: tipoLectivo,
      profesor: profesor,
    );

    try {
      final guardada = await SolicitudesService.crearSolicitud(nueva);
      _solicitudes.add(guardada);
      _ordenar();
      _estado = EstadoCarga.ok;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Anula (borra) una solicitud pendiente. Devuelve null si fue bien o el mensaje de error.
  Future<String?> anular(SolicitudAsuntoPropio solicitud) async {
    try {
      await SolicitudesService.eliminarSolicitud(solicitud.id!);
      _solicitudes.remove(solicitud);
      if (_solicitudes.isEmpty) _estado = EstadoCarga.vacio;
      notifyListeners();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Admin: aprueba o rechaza. Devuelve null si fue bien o el mensaje de error.
  Future<String?> resolver(SolicitudAsuntoPropio solicitud, EstadoSolicitud estado) async {
    try {
      final actualizada = await SolicitudesService.cambiarEstado(solicitud.id!, estado);
      _reemplazar(solicitud, actualizada);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Admin: cambia Lectivo / No lectivo. Devuelve null si fue bien o el mensaje de error.
  Future<String?> cambiarTipoLectivo(SolicitudAsuntoPropio solicitud, TipoLectivo tipo) async {
    try {
      final actualizada = await SolicitudesService.cambiarTipoLectivo(solicitud, tipo);
      _reemplazar(solicitud, actualizada);
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // Cambia en la lista la solicitud vieja por la que ha devuelto la API.
  void _reemplazar(SolicitudAsuntoPropio vieja, SolicitudAsuntoPropio nueva) {
    final posicion = _solicitudes.indexOf(vieja);
    if (posicion != -1) _solicitudes[posicion] = nueva;
    notifyListeners();
  }

  List<SolicitudAsuntoPropio> solicitudesDelDia(DateTime dia) {
    return _solicitudes.where((s) => mismoDia(s.fecha, dia)).toList();
  }

  // Al cerrar sesión, para que el siguiente usuario no vea las de este.
  void limpiar() {
    _solicitudes = [];
    _estado = EstadoCarga.cargando;
    notifyListeners();
  }

  // De la fecha más cercana a la más lejana.
  void _ordenar() {
    _solicitudes.sort((a, b) => a.fecha.compareTo(b.fecha));
  }
}
