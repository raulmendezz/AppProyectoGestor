# Manual de usuario y administración

## Manual del profesorado

1. **Entrar.** Escribe tu usuario y tu contraseña y pulsa Entrar.
2. **Pedir un día.** En el inicio pulsa Permisos y después Pedir día. Elige la fecha en el selector (los días no disponibles aparecen tachados), marca la declaración y pulsa Enviar solicitud. Queda Pendiente hasta que la dirección la resuelva.
3. **Ver tus solicitudes.** En Permisos aparecen todas, con su estado. Las pendientes se pueden anular con la cruz.
4. **Calendario.** Muestra los bloqueos en rojo y un punto de color en los días con solicitud (ámbar pendiente, verde aprobada, rojo rechazada). Pulsa un día para ver el detalle. La flecha de arriba pliega el mes a una semana y el icono de calendario vuelve a hoy.

## Manual de dirección

1. **Resolver solicitudes.** En Solicitudes, la pestaña Pendientes muestra las de todo el profesorado. Si hace falta, cambia el día entre Lectivo y No lectivo y pulsa Aprobar o Rechazar; la decisión pide confirmación y no se puede deshacer.
2. **Consultar el histórico.** La pestaña Resueltas lista las aprobadas y rechazadas.
3. **Gestionar bloqueos.** En Calendario, pulsa Bloqueo para crear un periodo (desde, hasta y tipo). Con los iconos de cada bloqueo se edita o se borra. En esas fechas el profesorado no podrá pedir días.
4. **Comprobar la ocupación.** Al seleccionar un día se ven las solicitudes de ese día y cuántas están aprobadas frente a la capacidad diaria.

## Manual de administración del sistema

- La capacidad diaria se cambia con `PUT /api/configuracion/capacidad_diaria`, con un cuerpo como `{ "clave": "capacidad_diaria", "valor": "6" }`.
- Los usuarios iniciales se definen con las variables de entorno `ADMIN1_*` y `USER1_*`.
- Si el servidor no responde, los clientes muestran un aviso con la opción de reintentar.

## Manual de instalación para desarrolladores

1. Clonar el repositorio y crear la base de datos.
2. Definir las variables de entorno (ver Despliegue y puesta en marcha).
3. Arrancar la API con `./mvnw spring-boot:run` y comprobar `http://localhost:8080/swagger-ui.html`.
4. Abrir `AppEscritorioGestor/AppEscritorioGestor.slnx` en Visual Studio o ejecutar `dotnet run`.
