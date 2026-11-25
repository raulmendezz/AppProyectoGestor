# Desarrollo e implementación

## Estructura del proyecto

```
proyecto/
├── apiProyecto/proyecto-moscoso     API REST (Spring Boot)
├── AppProyectoGestor-main/
│   └── appFlutter_proyecto          Aplicación móvil (Flutter)
└── AppEscritorioGestor              Aplicación de escritorio (WPF)
```

## Desarrollo por sprints

| Sprint | Resultado |
|---|---|
| 2 | Entidades principales, bloqueo de calendario y reglas de negocio 3.1 a 3.6 |
| 3 | Usuarios y perfiles (administrador y profesor), inicio de sesión con JWT y permisos por rol |
| Cliente | Aplicación móvil y aplicación de escritorio conectadas a la API |

### Aplicación de escritorio (WPF)

Implementa las mismas pantallas y el mismo estilo que la aplicación móvil y consume la API real.

| Pantalla | Función |
|---|---|
| Inicio de sesión | Login contra la API; muestra el error si las credenciales no son válidas |
| Inicio | Menú en tarjetas según el rol (profesor o administrador) |
| Mis asuntos propios (profesor) | Lista de sus solicitudes con su estado y anulación de las pendientes |
| Solicitud de permiso (profesor) | Formulario con selector de fecha que bloquea los días no disponibles |
| Solicitudes (administrador) | Pestañas Pendientes y Resueltas, cambio entre lectivo y no lectivo, aprobar y rechazar con confirmación |
| Calendario | Ver el mes o la semana, bloqueos y solicitudes del día; el administrador crea, edita y borra bloqueos |
| Mi perfil | Datos del usuario conectado |

**Calendario.** La cuadrícula se construye a partir de los bloqueos y solicitudes que devuelve la API. Se puede cambiar de mes, volver a hoy y plegar el mes a la semana del día seleccionado. Los bloqueos se marcan en rojo y un punto de color indica el estado de las solicitudes de cada día. Al administrador se le muestran además las solicitudes de todos los profesores del día seleccionado y cuántas están aprobadas frente a la capacidad diaria.

**Organización del código.** Cada pantalla es un `UserControl` independiente que avisa de lo que quiere hacer con eventos propios; la ventana principal decide qué pantalla mostrar. Las llamadas a la API están centralizadas en `ApiCliente` y los errores de la API se muestran al usuario con el mensaje que devuelve el servidor. Los controles siguen la nomenclatura Nombre + Tipo (por ejemplo `EnviarSolicitudBoton` o `FechaPermisoDatePicker`).

## Control de versiones

El código y la documentación se versionan con Git y se alojan en GitHub. La documentación se publica con GitHub Pages.

## Importación de datos

Pendiente de implementar según la planificación (Sprint 4: importación de profesores desde XML). Mientras tanto, los datos de prueba se cargan con el volcado SQL de `database/gestion_digital_permisos.sql`.
