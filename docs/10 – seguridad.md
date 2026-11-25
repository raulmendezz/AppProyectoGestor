# Seguridad y protección de datos

## Datos que se recogen

Del profesorado: nombre, apellidos, DNI, código postal, localidad, teléfono, dirección, cuerpo, especialidad y departamento. De cada solicitud: profesor, fecha, tipo de día y estado. De cada cuenta: nombre de usuario, contraseña cifrada y rol.

## Perfiles y permisos

| Rol | Permisos |
|---|---|
| Administrador | Lectura y escritura en todos los recursos, resolver solicitudes y gestionar bloqueos y configuración |
| Profesor | Ver bloqueos y configuración; ver, crear y anular únicamente sus propias solicitudes pendientes |

Todos los endpoints exigen un token JWT, salvo el inicio de sesión. Si no hay token la API responde 401 y si el rol no tiene permiso responde 403.

## Protección de datos personales

- Las contraseñas se guardan cifradas con bcrypt; nunca en texto plano.
- El token JWT está firmado y caduca (60 minutos por defecto, configurable).
- Ningún secreto está en el código: la conexión a la base de datos, la clave del token y las contraseñas iniciales se definen con variables de entorno.
- Cada profesor solo puede ver y modificar sus propias solicitudes.

## Datos de prueba

Todos los datos de prueba son ficticios.
