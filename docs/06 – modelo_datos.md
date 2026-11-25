# Modelo de datos

## Diagrama entidad-relación

```
PROFESOR (1) ---- (N) GRUPO_ALUMNADO
PROFESOR (1) ---- (N) SESION_HORARIO
PROFESOR (1) ---- (N) MOSCOSO_SOLICITUD
PROFESOR (1) ---- (0..1) USUARIO
BLOQUEO_CALENDARIO        CONFIGURACION
```

## Descripción de las entidades

| Entidad (tabla) | Contenido |
|---|---|
| `profesores` | Datos personales y profesionales: nombre, apellidos, DNI, código postal, localidad, teléfono, dirección, cuerpo, especialidad y departamento |
| `grupos_alumnado` | Código de grupo y profesor asociado |
| `sesiones_horario` | Sesión de clase: grupo, profesor, día de la semana, hora de inicio y de fin |
| `moscosos_solicitudes` | Solicitud de un día: profesor, fecha, estado y tipo (lectivo o no lectivo) |
| `bloqueos_calendario` | Periodo en el que no se pueden pedir días: fecha de inicio, de fin y tipo (vacaciones, exámenes, festivo...) |
| `configuracion` | Parámetros ajustables en caliente, como `capacidad_diaria` |
| `usuarios` | Cuenta de acceso: nombre de usuario, contraseña cifrada con bcrypt, rol y profesor vinculado |

Enumerados: `EstadoSolicitud` (PENDIENTE, APROBADA, RECHAZADA), `TipoLectivo` (LECTIVO, NO_LECTIVO), `DiaSemana` (de lunes a viernes) y `Rol` (ADMIN, PROFESOR).

## Modelo relacional

La base de datos se llama `gestion_digital_permisos`. Las claves ajenas son `id_profesor` en grupos, sesiones, solicitudes y usuarios, y `cod_grupo` en sesiones. La relación entre `usuarios` y `profesores` es 1:1 opcional: el administrador no tiene profesor vinculado.

## Decisiones de diseño

- El concepto de **turnos** se descartó en el Sprint 2 porque no aplica a este dominio.
- Una solicitud siempre se crea como `PENDIENTE`; solo la dirección la pasa a aprobada o rechazada.
- La capacidad diaria es un parámetro de la tabla `configuracion` (clave `capacidad_diaria`) y se puede cambiar sin reiniciar la API.
- Reglas de negocio que aplica la API:

| Regla | Descripción |
|---|---|
| 3.1 | No se puede crear una solicitud en una fecha bloqueada |
| 3.2 | Un profesor no puede tener dos solicitudes el mismo día |
| 3.4 | Un profesor no puede tener dos sesiones de horario solapadas |
| 3.5 | No se puede aprobar si ya se alcanzó la capacidad diaria |
| 3.6 | Solo se puede resolver una solicitud pendiente |

## Justificación de los cambios

En el Sprint 3 se añadió la tabla `usuarios` para el inicio de sesión y los perfiles, vinculada de forma opcional a un profesor para poder aplicar la regla de que cada profesor solo ve sus propias solicitudes.
