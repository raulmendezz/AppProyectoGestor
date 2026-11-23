List<String> generarDiasMes(int anio, int mes) {
  final huecosInicio = DateTime(anio, mes, 1).weekday - 1;
  final totalDias = DateTime(anio, mes + 1, 0).day;

  final dias = <String>[];
  for (int i = 0; i < huecosInicio; i++) {
    dias.add('');
  }
  for (int dia = 1; dia <= totalDias; dia++) {
    dias.add('$dia');
  }
  while (dias.length % 7 != 0) {
    dias.add('');
  }
  return dias;
}
