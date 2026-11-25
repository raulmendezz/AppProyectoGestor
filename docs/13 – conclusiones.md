# Conclusiones y mejoras futuras

## Resultados obtenidos

- API REST completa con las reglas de negocio 3.1 a 3.6, usuarios con roles y seguridad con JWT.
- Aplicación de escritorio funcional, conectada a la API, con inicio de sesión, solicitudes del profesorado, gestión de solicitudes por la dirección y calendario con gestión de bloqueos.
- Aplicación móvil con las mismas funciones y el mismo diseño.
- Diseño visual unificado entre las dos aplicaciones.

## Limitaciones conocidas

- El campo «Motivo» del formulario de escritorio no se guarda: la API todavía no tiene ese dato en la solicitud.
- La opción Ajustes no está implementada.
- Los clientes apuntan a `localhost`; para usarlos desde otro equipo hay que cambiar la dirección de la API.
- No hay importación de profesores desde XML.

## Mejoras futuras

- Guardar el motivo de la solicitud y mostrarlo a la dirección.
- Importación de profesores desde XML (Sprint 4).
- Informes finales e histórico exportable.
- Despliegue de la API en un servidor del centro.
