import 'package:intl/intl.dart';

const diasSemanaCortos = ['L', 'M', 'X', 'J', 'V', 'S', 'D'];

/// Devuelve la fecha sin la parte de la hora.
DateTime soloFecha(DateTime fecha) => DateTime(fecha.year, fecha.month, fecha.day);

bool mismoDia(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

/// Días del mes en una cuadrícula de 7 columnas (lunes a domingo).
/// Los huecos antes del día 1 y después del último día son `null`.
List<DateTime?> generarDiasMes(int anio, int mes) {
  final huecosInicio = DateTime(anio, mes, 1).weekday - 1;
  final totalDias = DateTime(anio, mes + 1, 0).day;

  final dias = <DateTime?>[];
  for (int i = 0; i < huecosInicio; i++) {
    dias.add(null);
  }
  for (int dia = 1; dia <= totalDias; dia++) {
    dias.add(DateTime(anio, mes, dia));
  }
  while (dias.length % 7 != 0) {
    dias.add(null);
  }
  return dias;
}

/// Los 7 días (lunes a domingo) de la semana que contiene [dia].
List<DateTime> generarDiasSemana(DateTime dia) {
  final lunes = DateTime(dia.year, dia.month, dia.day - (dia.weekday - 1));
  return List.generate(7, (i) => DateTime(lunes.year, lunes.month, lunes.day + i));
}

String _capitalizar(String texto) =>
    texto.isEmpty ? texto : texto[0].toUpperCase() + texto.substring(1);

/// "Noviembre"
String nombreMes(DateTime fecha) => _capitalizar(DateFormat.MMMM('es').format(fecha));

/// "Martes, 24 de noviembre"
String fechaLarga(DateTime fecha) =>
    _capitalizar(DateFormat("EEEE, d 'de' MMMM", 'es').format(fecha));
