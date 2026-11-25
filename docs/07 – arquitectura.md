# Arquitectura y tecnologías

## Arquitectura general

```
 App móvil (Flutter)  ─┐
                       ├── HTTP + JSON + token JWT ──>  API REST (Spring Boot)  ──>  MySQL / MariaDB
 App escritorio (WPF) ─┘
```

La API concentra las reglas de negocio y la seguridad. Los dos clientes no acceden a la base de datos: solo hablan con la API.

## Tecnologías utilizadas

| Tecnología | Uso |
|---|---|
| Java 17 | Lenguaje de la API |
| Spring Boot 4.1 | API REST |
| Spring Security y JWT | Autenticación y autorización por roles |
| Spring Data JPA (Hibernate) | Acceso a la base de datos |
| MySQL 8 (también probado con MariaDB 10.4) | Base de datos |
| Maven (mvnw) | Gestión de dependencias y arranque |
| Swagger / OpenAPI | Documentación interactiva de la API |
| Flutter y Dart | Aplicación móvil |
| C#, .NET 10 y WPF | Aplicación de escritorio |
| GitHub Projects | Planificación y control de versiones |
| MkDocs (Material) | Documentación |

## Arquitectura en capas

**API (Spring Boot):** `controller` (endpoints REST), `service` (reglas de negocio), `repository` (acceso a datos), `model` (entidades JPA), `dto` (objetos de entrada y salida), `exception` (errores con formato único), `security` (JWT y configuración de seguridad) y `config` (datos iniciales y OpenAPI).

**Aplicación de escritorio (WPF):**

| Carpeta | Contenido |
|---|---|
| `Views` | Pantallas (UserControl) y ventana del formulario de bloqueos |
| `Models` | Profesor, usuario, solicitud, bloqueo y utilidades de fechas |
| `Services` | `ApiCliente`, que realiza todas las llamadas a la API |
| `Data` | `Sesion`, con el usuario conectado y los datos cargados |
