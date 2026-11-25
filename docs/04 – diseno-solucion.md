# Diseño de la solución

## Propuesta de solución

Sistema cliente-servidor con una API REST central que aplica las reglas de negocio y dos clientes que la consumen: una aplicación móvil (Flutter) y una aplicación de escritorio (C# y WPF). Los dos clientes comparten el mismo diseño y las mismas funciones, de modo que el profesorado y la dirección pueden usar el que prefieran.

## Flujo principal

Solicitud, validaciones y avisos, revisión humana, autorización o denegación motivada, actualización del estado e histórico.

1. El profesor inicia sesión y elige un día en el calendario, que no deja elegir fines de semana, días bloqueados ni días ya solicitados.
2. La API valida las reglas y guarda la solicitud con el estado **Pendiente**.
3. La dirección revisa las solicitudes pendientes, puede marcar el día como lectivo o no lectivo y las aprueba o las rechaza.
4. El profesor ve el nuevo estado en su lista y en el calendario.

## Diseño de la interfaz

Se ha mantenido el mismo estilo visual en la aplicación móvil y en la de escritorio.

| Elemento | Diseño |
|---|---|
| Colores | Azul `#1C3A70` y dorado `#E9BC3C` (amarillo del logo del centro) |
| Cabecera | Banda azul con la parte inferior curvada |
| Contenido | Tarjetas blancas con esquinas redondeadas y sombra suave |
| Estados | Pendiente en ámbar, Aprobada en verde y Rechazada en rojo |
| Navegación | Barra inferior: Inicio, Calendario, Permisos y Perfil |

Pantallas: inicio de sesión, inicio (menú en tarjetas), mis asuntos propios, solicitud de permiso, gestión de solicitudes (dirección), calendario y perfil.

El **calendario** muestra el mes completo (se puede plegar a una semana). Los días bloqueados se marcan en rojo, el día seleccionado en dorado y un punto de color indica el estado de las solicitudes de ese día. Debajo se listan los bloqueos y las solicitudes del día elegido. La dirección puede crear, editar y borrar bloqueos desde esta pantalla.

## Diagramas
