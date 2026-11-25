# Análisis de requisitos

## Requisitos funcionales

- Gestionar usuarios, roles y datos del profesorado.
- Consultar días asignados, disponibles, solicitados, autorizados y disfrutados, distinguiendo periodo lectivo y no lectivo.
- Registrar solicitudes con fecha de disfrute, fecha de presentación, curso y estado.
- Aplicar las comprobaciones de plazos, cupos, fechas restringidas, consecutividad y simultaneidad, mostrando el motivo de cada aviso o bloqueo.
- Permitir que la dirección resuelva cada solicitud y registre la motivación de una denegación.
- Mantener la trazabilidad de cambios de estado, resoluciones y anulaciones.
- Configurar calendarios lectivos, evaluaciones, Navidad y Pascua, fiestas locales, turnos y criterios sin fijar fechas en el código.
- Ofrecer consultas e informes por fecha, estado, turno, saldo y límites diarios.
- Importar datos de profesorado, grupos y horarios desde ficheros externos (XML), validando estructura, duplicados y errores.

## Requisitos no funcionales

- Proteger los datos: recoger solo los necesarios y aplicar permisos por perfil.
- Usar datos de prueba ficticios, sin información personal real.

## Perfiles de usuario

| Perfil | Funciones |
|---|---|
| Profesorado | Consultar saldo, preparar solicitudes, consultar estado e histórico propio |
| Dirección o perfil gestor | Revisar comprobaciones, valorar necesidades del servicio, resolver y consultar la situación del centro |
| Administración del sistema | Gestionar calendario, curso, turnos, datos importados, usuarios y parámetros |

## Reglas de negocio

## Casos de uso

## Criterios de aceptación
