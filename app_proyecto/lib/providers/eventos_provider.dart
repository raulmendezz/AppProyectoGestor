import 'package:flutter/material.dart';
import 'package:app_proyecto/models/models.dart';

class _EventosProvider {
  List<Evento> eventos = const [
    Evento(hora: '09:00', titulo: 'Reunión de departamento', estado: 'Aprobado', horario: '09:00-10:30', color: Colors.green),
    Evento(hora: '12:00', titulo: 'Claustro de profesores', estado: 'Obligatorio', horario: '12:00-14:00', color: Colors.blue),
    Evento(hora: '16:00', titulo: 'Solicitud de permiso', estado: 'Pendiente de aprobación', horario: '16:00-17:30', color: Colors.amber),
  ];
}

final eventosProvider = _EventosProvider();
