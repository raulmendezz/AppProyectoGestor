# Pruebas y validación

## Plan de pruebas

Pruebas funcionales manuales de extremo a extremo: aplicación de escritorio, API y base de datos funcionando a la vez, con un usuario de cada rol.

## Pruebas de reglas y casos límite

| Prueba | Resultado esperado | Resultado |
|---|---|---|
| Inicio de sesión con credenciales correctas | Entra y muestra el inicio según el rol | Correcto |
| Inicio de sesión con contraseña errónea | Mensaje «Credenciales inválidas.» | Correcto |
| Profesor abre el calendario | Ve los bloqueos y sus solicitudes, con punto de color por estado | Correcto |
| Profesor cambia de mes y selecciona un día | Se muestran el bloqueo y la solicitud de ese día | Correcto |
| Profesor abre el formulario | Fines de semana, bloqueos y días ya pedidos aparecen tachados y no se pueden elegir | Correcto |
| Profesor envía una solicitud | Se crea en estado Pendiente y aparece en su lista | Correcto |
| Administrador abre Solicitudes | Ve las solicitudes de todos los profesores, separadas en pendientes y resueltas | Correcto |
| Administrador aprueba una solicitud | Pide confirmación, pasa a Aprobada y sale de Pendientes | Correcto |
| Administrador crea un bloqueo desde el calendario | Aparece en el calendario y en el día seleccionado | Correcto |
| Administrador borra el bloqueo | Desaparece del calendario | Correcto |

## Resultados

Las funciones probadas se comportan como se espera y los datos se guardan y se leen correctamente en la base de datos. Los datos creados durante las pruebas se eliminaron después.

## Errores detectados y correcciones

- Al arrancar la API con Maven, la descarga de dependencias fallaba por un certificado, porque el antivirus intercepta las conexiones HTTPS. Se solucionó indicando a Maven el almacén de certificados de confianza con `MAVEN_OPTS`.
- Los usuarios incluidos en el volcado de la base de datos tenían contraseñas desconocidas. Se eliminaron de la copia de trabajo para que la API los vuelva a crear con las contraseñas definidas en las variables de entorno.
