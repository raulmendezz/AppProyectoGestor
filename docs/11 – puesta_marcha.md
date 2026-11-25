# Despliegue y puesta en marcha

## Requisitos de instalación

| Componente | Requisito |
|---|---|
| API | JDK 17 o superior y Maven (se usa el wrapper `mvnw` incluido) |
| Base de datos | MySQL 8 o MariaDB |
| Aplicación de escritorio | Windows y SDK de .NET 10 |
| Aplicación móvil | SDK de Flutter y un móvil Android con depuración por USB |

## Instalación en servidor local del centro

1. Crear la base de datos `gestion_digital_permisos` e importar el volcado `database/gestion_digital_permisos.sql` (o dejar que la API cree las tablas al arrancar).
2. Definir las variables de entorno de la API.
3. Arrancar la API desde `apiProyecto/proyecto-moscoso` con `./mvnw spring-boot:run`. Queda en `http://localhost:8080`, con la documentación interactiva en `/swagger-ui.html`.
4. Arrancar el cliente: la aplicación de escritorio con `dotnet run` en la carpeta `AppEscritorioGestor` (o abriendo la solución en Visual Studio), y la aplicación móvil con `flutter run` y `adb reverse tcp:8080 tcp:8080`.

## Configuración inicial

| Variable | Descripción |
|---|---|
| `DB_URL`, `DB_USERNAME`, `DB_PASSWORD` | Conexión a la base de datos |
| `JWT_SECRET` | Clave de firma del token (mínimo 32 caracteres) |
| `JWT_EXPIRACION_MINUTOS` | Duración del token (por defecto, 60) |
| `ADMIN1_USERNAME`, `ADMIN1_PASSWORD` | Administrador inicial |
| `USER1_USERNAME`, `USER1_PASSWORD` | Profesor inicial, vinculado al profesor 1 |

Al arrancar, la API crea los dos usuarios si no existen. La capacidad diaria se cambia sin reiniciar con `PUT /api/configuracion/capacidad_diaria`.

## Pruebas con profesorado voluntario

Pendiente de realizar.
