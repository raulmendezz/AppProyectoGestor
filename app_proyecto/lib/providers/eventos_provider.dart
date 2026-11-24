import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';
import 'package:app_proyecto/utils/utils.dart';

class _EventosProvider {
  final List<Evento> eventos = [
    Evento(fecha: DateTime(2026, 11, 24), hora: '09:00', titulo: 'Reunión de departamento', estado: 'Aprobado', horario: '09:00-10:30', color: Colors.green),
    Evento(fecha: DateTime(2026, 11, 24), hora: '12:00', titulo: 'Claustro de profesores', estado: 'Obligatorio', horario: '12:00-14:00', color: Colors.blue),
    Evento(fecha: DateTime(2026, 11, 27), hora: '16:00', titulo: 'Solicitud de permiso', estado: 'Pendiente de aprobación', horario: '16:00-17:30', color: Colors.amber),
  ];

  List<Evento> eventosDelDia(DateTime dia) =>
      eventos.where((e) => mismoDia(e.fecha, dia)).toList()
        ..sort((a, b) => a.hora.compareTo(b.hora));

  bool tieneEventos(DateTime dia) => eventos.any((e) => mismoDia(e.fecha, dia));
}

final eventosProvider = _EventosProvider();
