using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class SolicitudAdminTarjeta : UserControl
{
    private readonly SolicitudPermiso _solicitud;

    public event EventHandler<TipoLectivo>? TipoCambiado;
    public event EventHandler<EstadoSolicitud>? Resuelta;

    public SolicitudAdminTarjeta(SolicitudPermiso solicitud)
    {
        InitializeComponent();
        _solicitud = solicitud;
        DataContext = solicitud;
        ResolverGrid.Visibility = solicitud.Estado == EstadoSolicitud.Pendiente ? Visibility.Visible : Visibility.Collapsed;
        MarcarTipo(solicitud.TipoLectivo);
    }

    private void MarcarTipo(TipoLectivo tipo)
    {
        Aplicar(LectivoBoton, tipo == TipoLectivo.Lectivo);
        Aplicar(NoLectivoBoton, tipo == TipoLectivo.NoLectivo);
    }

    private void Aplicar(Button boton, bool activo)
    {
        boton.Style = (Style)FindResource(activo ? "BotonPrimarioEstilo" : "BotonSecundarioEstilo");
        boton.FontSize = 13;
    }

    private void TipoBoton_Click(object sender, RoutedEventArgs e)
    {
        var tipo = sender == LectivoBoton ? TipoLectivo.Lectivo : TipoLectivo.NoLectivo;
        if (tipo == _solicitud.TipoLectivo)
        {
            return;
        }
        TipoCambiado?.Invoke(this, tipo);
    }

    private void AprobarBoton_Click(object sender, RoutedEventArgs e)
    {
        Resuelta?.Invoke(this, EstadoSolicitud.Aprobada);
    }

    private void RechazarBoton_Click(object sender, RoutedEventArgs e)
    {
        Resuelta?.Invoke(this, EstadoSolicitud.Rechazada);
    }
}
