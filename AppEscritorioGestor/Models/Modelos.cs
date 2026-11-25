using System.Globalization;
using System.Text.Json;
using System.Windows;
using System.Windows.Media;

namespace AppEscritorioGestor;

public enum EstadoSolicitud
{
    Pendiente,
    Aprobada,
    Rechazada
}

public enum TipoLectivo
{
    Lectivo,
    NoLectivo
}

public enum RolUsuario
{
    Admin,
    Profesor
}

public static class ConversorApi
{
    public static string EstadoAApi(EstadoSolicitud estado) => estado.ToString().ToUpperInvariant();

    public static EstadoSolicitud EstadoDesdeApi(string valor) => valor switch
    {
        "APROBADA" => EstadoSolicitud.Aprobada,
        "RECHAZADA" => EstadoSolicitud.Rechazada,
        _ => EstadoSolicitud.Pendiente
    };

    public static string TipoAApi(TipoLectivo tipo) => tipo == TipoLectivo.Lectivo ? "LECTIVO" : "NO_LECTIVO";

    public static TipoLectivo TipoDesdeApi(string valor) => valor == "NO_LECTIVO" ? TipoLectivo.NoLectivo : TipoLectivo.Lectivo;

    public static string FechaAApi(DateTime fecha) => fecha.ToString("yyyy-MM-dd", CultureInfo.InvariantCulture);

    public static DateTime FechaDesdeApi(string valor) => DateTime.ParseExact(valor, "yyyy-MM-dd", CultureInfo.InvariantCulture);
}

public class Profesor
{
    public int Id { get; set; }
    public string Nombre { get; set; } = "";
    public string Apellidos { get; set; } = "";
    public string Departamento { get; set; } = "";
    public string Especialidad { get; set; } = "";
    public string Telefono { get; set; } = "";

    public string NombreCompleto => $"{Nombre} {Apellidos}".Trim();
    public string Iniciales => $"{Nombre.FirstOrDefault()}{Apellidos.FirstOrDefault()}".ToUpper();

    public static Profesor DesdeJson(JsonElement json)
    {
        return new Profesor
        {
            Id = json.TryGetProperty("idProfesor", out var id) ? id.GetInt32() : json.GetProperty("id").GetInt32(),
            Nombre = Texto(json, "nombre"),
            Apellidos = Texto(json, "apellidos"),
            Departamento = Texto(json, "departamento"),
            Especialidad = Texto(json, "especialidad"),
            Telefono = Texto(json, "telefono")
        };
    }

    private static string Texto(JsonElement json, string propiedad)
    {
        return json.TryGetProperty(propiedad, out var valor) && valor.ValueKind == JsonValueKind.String ? valor.GetString() ?? "" : "";
    }
}

public class Usuario
{
    public string Username { get; set; } = "";
    public RolUsuario Rol { get; set; }
    public Profesor? Profesor { get; set; }

    public string Nombre => Profesor?.NombreCompleto ?? Username;
    public string PrimerNombre => Profesor?.Nombre ?? Username;
    public string Iniciales => Profesor?.Iniciales ?? Username.Substring(0, Math.Min(2, Username.Length)).ToUpper();
    public string RolTexto => Rol == RolUsuario.Admin ? "Administrador" : "Profesor";

    public static Usuario DesdeJson(JsonElement json)
    {
        var usuario = new Usuario
        {
            Username = json.GetProperty("username").GetString() ?? "",
            Rol = json.GetProperty("rol").GetString() == "ADMIN" ? RolUsuario.Admin : RolUsuario.Profesor
        };
        if (json.TryGetProperty("profesor", out var profesor) && profesor.ValueKind == JsonValueKind.Object)
        {
            usuario.Profesor = Profesor.DesdeJson(profesor);
        }
        return usuario;
    }
}

public class BloqueoCalendario
{
    public int? Id { get; set; }
    public DateTime FechaInicio { get; set; }
    public DateTime FechaFin { get; set; }
    public string Tipo { get; set; } = "";

    public string RangoTexto => $"Del {Utilidades.FechaCorta(FechaInicio)} al {Utilidades.FechaCorta(FechaFin)}";

    public bool Incluye(DateTime dia) => dia.Date >= FechaInicio.Date && dia.Date <= FechaFin.Date;

    public static BloqueoCalendario DesdeJson(JsonElement json)
    {
        return new BloqueoCalendario
        {
            Id = json.GetProperty("id").GetInt32(),
            FechaInicio = ConversorApi.FechaDesdeApi(json.GetProperty("fechaInicio").GetString()!),
            FechaFin = ConversorApi.FechaDesdeApi(json.GetProperty("fechaFin").GetString()!),
            Tipo = json.GetProperty("tipo").GetString() ?? ""
        };
    }
}

public class SolicitudPermiso
{
    public int Id { get; set; }
    public DateTime Fecha { get; set; }
    public EstadoSolicitud Estado { get; set; } = EstadoSolicitud.Pendiente;
    public TipoLectivo TipoLectivo { get; set; } = TipoLectivo.Lectivo;
    public Profesor Profesor { get; set; } = new();

    public string DiaTexto => Fecha.Day.ToString();
    public string MesTexto => Utilidades.MesCorto(Fecha);
    public string FechaLargaTexto => $"{Utilidades.FechaLarga(Fecha)} {Fecha.Year}";
    public string TipoTexto => TipoLectivo == TipoLectivo.Lectivo ? "Lectivo" : "No lectivo";
    public string EstadoTexto => Estado.ToString();
    public string ProfesorTexto => Profesor.NombreCompleto;
    public string DepartamentoTexto => Profesor.Departamento;
    public Visibility PuedeAnularVisibilidad => Estado == EstadoSolicitud.Pendiente ? Visibility.Visible : Visibility.Collapsed;

    public Brush EstadoPincel => new SolidColorBrush(ColorEstado(Estado));
    public Brush EstadoFondoPincel
    {
        get
        {
            var c = ColorEstado(Estado);
            return new SolidColorBrush(Color.FromArgb(0x26, c.R, c.G, c.B));
        }
    }

    public static Color ColorEstado(EstadoSolicitud estado) => estado switch
    {
        EstadoSolicitud.Pendiente => Color.FromRgb(0xFF, 0xA0, 0x00),
        EstadoSolicitud.Aprobada => Color.FromRgb(0x4C, 0xAF, 0x50),
        _ => Color.FromRgb(0xF4, 0x43, 0x36)
    };

    public static SolicitudPermiso DesdeJson(JsonElement json)
    {
        return new SolicitudPermiso
        {
            Id = json.GetProperty("idSolicitud").GetInt32(),
            Fecha = ConversorApi.FechaDesdeApi(json.GetProperty("fecha").GetString()!),
            Estado = ConversorApi.EstadoDesdeApi(json.GetProperty("estado").GetString() ?? ""),
            TipoLectivo = ConversorApi.TipoDesdeApi(json.GetProperty("tipoLectivo").GetString() ?? ""),
            Profesor = Profesor.DesdeJson(json.GetProperty("profesor"))
        };
    }
}
