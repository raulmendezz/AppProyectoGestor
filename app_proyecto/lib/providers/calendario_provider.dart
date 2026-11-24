import 'package:flutter/material.dart';
import 'package:app_proyecto/utils/utils.dart';

class CalendarioProvider extends ChangeNotifier {
  CalendarioProvider() {
    final hoy = soloFecha(DateTime.now());
    _diaSeleccionado = hoy;
    _mesVisible = DateTime(hoy.year, hoy.month);
  }

  late DateTime _diaSeleccionado;
  late DateTime _mesVisible;
  bool _plegado = false;

  DateTime get hoy => soloFecha(DateTime.now());
  DateTime get diaSeleccionado => _diaSeleccionado;
  DateTime get mesVisible => _mesVisible;
  bool get plegado => _plegado;

  /// Días a pintar: el mes completo, o solo la semana del día seleccionado si está plegado.
  List<DateTime?> get diasVisibles => _plegado
      ? generarDiasSemana(_diaSeleccionado)
      : generarDiasMes(_mesVisible.year, _mesVisible.month);

  void seleccionarDia(DateTime dia) {
    _diaSeleccionado = soloFecha(dia);
    _mesVisible = DateTime(dia.year, dia.month);
    notifyListeners();
  }

  void irAHoy() => seleccionarDia(hoy);

  /// Desplegado avanza un mes; plegado avanza una semana.
  void siguiente() => _desplazar(1);

  /// Desplegado retrocede un mes; plegado retrocede una semana.
  void anterior() => _desplazar(-1);

  void _desplazar(int sentido) {
    if (_plegado) {
      final d = _diaSeleccionado;
      seleccionarDia(DateTime(d.year, d.month, d.day + 7 * sentido));
      return;
    }
    final mes = DateTime(_mesVisible.year, _mesVisible.month + sentido);
    // Al cambiar de mes se selecciona hoy si es el mes actual, si no el día 1.
    seleccionarDia(mes.year == hoy.year && mes.month == hoy.month ? hoy : mes);
  }

  void plegar() => _setPlegado(true);
  void desplegar() => _setPlegado(false);
  void alternarPlegado() => _setPlegado(!_plegado);

  void _setPlegado(bool valor) {
    if (_plegado == valor) return;
    _plegado = valor;
    notifyListeners();
  }
}
