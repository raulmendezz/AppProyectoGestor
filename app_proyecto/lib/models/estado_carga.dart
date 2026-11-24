// Estado de una carga de datos de la API. Lo usan los providers
// para que la pantalla sepa qué mostrar.
enum EstadoCarga {
  cargando, // Esperando a la API: se muestra un indicador de carga.
  ok, // Hay datos.
  vacio, // La API respondió bien pero no hay nada que mostrar.
  error, // Algo falló: se muestra el mensaje de error.
}
