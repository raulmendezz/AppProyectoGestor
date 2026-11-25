using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;

namespace AppEscritorioGestor;

public class ApiException : Exception
{
    public int? Codigo { get; }

    public ApiException(string mensaje, int? codigo = null) : base(mensaje)
    {
        Codigo = codigo;
    }
}

public static class ApiCliente
{
    public const string UrlBase = "http://localhost:8080";

    private static readonly HttpClient Http = new() { BaseAddress = new Uri(UrlBase), Timeout = TimeSpan.FromSeconds(10) };

    public static string? Token { get; set; }

    private static async Task<JsonElement?> EnviarAsync(HttpMethod metodo, string ruta, object? cuerpo = null)
    {
        var peticion = new HttpRequestMessage(metodo, ruta);
        if (Token != null)
        {
            peticion.Headers.Authorization = new AuthenticationHeaderValue("Bearer", Token);
        }
        if (cuerpo != null)
        {
            peticion.Content = new StringContent(JsonSerializer.Serialize(cuerpo), Encoding.UTF8, "application/json");
        }

        HttpResponseMessage respuesta;
        try
        {
            respuesta = await Http.SendAsync(peticion);
        }
        catch (TaskCanceledException)
        {
            throw new ApiException("El servidor tarda demasiado en responder.");
        }
        catch (HttpRequestException)
        {
            throw new ApiException("No se puede conectar con el servidor.");
        }

        var texto = await respuesta.Content.ReadAsStringAsync();
        if (respuesta.IsSuccessStatusCode)
        {
            return string.IsNullOrWhiteSpace(texto) ? null : JsonDocument.Parse(texto).RootElement.Clone();
        }

        var mensaje = $"Error {(int)respuesta.StatusCode}";
        try
        {
            var json = JsonDocument.Parse(texto).RootElement;
            if (json.TryGetProperty("message", out var m) && m.ValueKind == JsonValueKind.String && !string.IsNullOrWhiteSpace(m.GetString()))
            {
                mensaje = m.GetString()!;
            }
        }
        catch (JsonException)
        {
        }
        throw new ApiException(mensaje, (int)respuesta.StatusCode);
    }

    public static async Task LoginAsync(string usuario, string contrasena)
    {
        var json = await EnviarAsync(HttpMethod.Post, "/api/auth/login", new { username = usuario, password = contrasena });
        Token = json!.Value.GetProperty("token").GetString();
    }

    public static async Task<Usuario> ObtenerUsuarioAsync()
    {
        var json = await EnviarAsync(HttpMethod.Get, "/api/auth/me");
        return Usuario.DesdeJson(json!.Value);
    }

    public static async Task<List<BloqueoCalendario>> ObtenerBloqueosAsync()
    {
        var json = await EnviarAsync(HttpMethod.Get, "/api/bloqueos-calendario");
        return json!.Value.EnumerateArray().Select(BloqueoCalendario.DesdeJson).ToList();
    }

    private static object CuerpoBloqueo(BloqueoCalendario bloqueo) => new
    {
        fechaInicio = ConversorApi.FechaAApi(bloqueo.FechaInicio),
        fechaFin = ConversorApi.FechaAApi(bloqueo.FechaFin),
        tipo = bloqueo.Tipo
    };

    public static async Task<BloqueoCalendario> CrearBloqueoAsync(BloqueoCalendario bloqueo)
    {
        var json = await EnviarAsync(HttpMethod.Post, "/api/bloqueos-calendario", CuerpoBloqueo(bloqueo));
        return BloqueoCalendario.DesdeJson(json!.Value);
    }

    public static async Task<BloqueoCalendario> ActualizarBloqueoAsync(BloqueoCalendario bloqueo)
    {
        var json = await EnviarAsync(HttpMethod.Put, $"/api/bloqueos-calendario/{bloqueo.Id}", CuerpoBloqueo(bloqueo));
        return BloqueoCalendario.DesdeJson(json!.Value);
    }

    public static async Task EliminarBloqueoAsync(int id)
    {
        await EnviarAsync(HttpMethod.Delete, $"/api/bloqueos-calendario/{id}");
    }

    public static async Task<int> ObtenerCapacidadDiariaAsync()
    {
        var json = await EnviarAsync(HttpMethod.Get, "/api/configuracion/capacidad_diaria");
        return int.TryParse(json!.Value.GetProperty("valor").GetString(), out var capacidad) ? capacidad : 0;
    }

    public static async Task<List<SolicitudPermiso>> ObtenerSolicitudesAsync()
    {
        var json = await EnviarAsync(HttpMethod.Get, "/api/moscosos-solicitudes");
        return json!.Value.EnumerateArray().Select(SolicitudPermiso.DesdeJson).ToList();
    }

    public static async Task<SolicitudPermiso> CrearSolicitudAsync(DateTime fecha, TipoLectivo tipo, int idProfesor)
    {
        var json = await EnviarAsync(HttpMethod.Post, "/api/moscosos-solicitudes", new
        {
            fecha = ConversorApi.FechaAApi(fecha),
            estado = "PENDIENTE",
            tipoLectivo = ConversorApi.TipoAApi(tipo),
            profesor = new { idProfesor }
        });
        return SolicitudPermiso.DesdeJson(json!.Value);
    }

    public static async Task<SolicitudPermiso> CambiarEstadoAsync(int id, EstadoSolicitud estado)
    {
        var json = await EnviarAsync(HttpMethod.Patch, $"/api/moscosos-solicitudes/{id}/estado", new { estado = ConversorApi.EstadoAApi(estado) });
        return SolicitudPermiso.DesdeJson(json!.Value);
    }

    public static async Task<SolicitudPermiso> CambiarTipoAsync(SolicitudPermiso solicitud, TipoLectivo tipo)
    {
        var json = await EnviarAsync(HttpMethod.Put, $"/api/moscosos-solicitudes/{solicitud.Id}", new
        {
            fecha = ConversorApi.FechaAApi(solicitud.Fecha),
            estado = ConversorApi.EstadoAApi(solicitud.Estado),
            tipoLectivo = ConversorApi.TipoAApi(tipo)
        });
        return SolicitudPermiso.DesdeJson(json!.Value);
    }

    public static async Task EliminarSolicitudAsync(int id)
    {
        await EnviarAsync(HttpMethod.Delete, $"/api/moscosos-solicitudes/{id}");
    }
}
