namespace AppEscritorioGestor;

public static class Sesion
{
    public static Usuario? Usuario { get; private set; }
    public static List<BloqueoCalendario> Bloqueos { get; private set; } = new();
    public static List<SolicitudPermiso> Solicitudes { get; private set; } = new();

    public static bool EsAdmin => Usuario?.Rol == RolUsuario.Admin;

    public static async Task IniciarAsync(string usuario, string contrasena)
    {
        await ApiCliente.LoginAsync(usuario, contrasena);
        try
        {
            Usuario = await ApiCliente.ObtenerUsuarioAsync();
        }
        catch
        {
            ApiCliente.Token = null;
            throw;
        }
    }

    public static void Cerrar()
    {
        ApiCliente.Token = null;
        Usuario = null;
        Bloqueos = new List<BloqueoCalendario>();
        Solicitudes = new List<SolicitudPermiso>();
    }

    public static async Task CargarBloqueosAsync()
    {
        Bloqueos = (await ApiCliente.ObtenerBloqueosAsync()).OrderBy(b => b.FechaInicio).ToList();
    }

    public static async Task CargarSolicitudesAsync()
    {
        Solicitudes = (await ApiCliente.ObtenerSolicitudesAsync()).OrderByDescending(s => s.Fecha).ToList();
    }

    public static List<BloqueoCalendario> BloqueosDelDia(DateTime dia) => Bloqueos.Where(b => b.Incluye(dia)).ToList();

    public static bool EstaBloqueado(DateTime dia) => Bloqueos.Any(b => b.Incluye(dia));

    public static List<SolicitudPermiso> SolicitudesDelDia(DateTime dia) => Solicitudes.Where(s => s.Fecha.Date == dia.Date).ToList();

    public static bool YaSolicitado(DateTime dia) => Solicitudes.Any(s => s.Fecha.Date == dia.Date);

    public static bool EsFinDeSemana(DateTime dia) => dia.DayOfWeek == DayOfWeek.Saturday || dia.DayOfWeek == DayOfWeek.Sunday;

    public static bool EstaNoDisponible(DateTime dia) => EsFinDeSemana(dia) || EstaBloqueado(dia) || YaSolicitado(dia);
}
