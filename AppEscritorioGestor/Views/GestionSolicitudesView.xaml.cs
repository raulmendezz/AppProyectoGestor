using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace AppEscritorioGestor;

public partial class GestionSolicitudesView : UserControl
{
    private bool _verPendientes = true;

    public event EventHandler? VolverInicioSolicitado;

    public GestionSolicitudesView()
    {
        InitializeComponent();
        Loaded += async (_, _) => await CargarAsync();
    }

    private async Task CargarAsync()
    {
        MostrarEstado("Cargando solicitudes...", false);
        try
        {
            await Sesion.CargarSolicitudesAsync();
        }
        catch (ApiException ex)
        {
            MostrarEstado(ex.Message, true);
            return;
        }
        Pintar();
    }

    private void Pintar()
    {
        var pendientes = Sesion.Solicitudes.Where(s => s.Estado == EstadoSolicitud.Pendiente).OrderBy(s => s.Fecha).ToList();
        var resueltas = Sesion.Solicitudes.Where(s => s.Estado != EstadoSolicitud.Pendiente).OrderByDescending(s => s.Fecha).ToList();

        PendientesBoton.Content = $"Pendientes ({pendientes.Count})";
        ResueltasBoton.Content = $"Resueltas ({resueltas.Count})";
        EstiloPestana(PendientesBoton, _verPendientes);
        EstiloPestana(ResueltasBoton, !_verPendientes);

        ListaPanel.Children.Clear();
        var lista = _verPendientes ? pendientes : resueltas;
        foreach (var solicitud in lista)
        {
            var tarjeta = new SolicitudAdminTarjeta(solicitud);
            tarjeta.TipoCambiado += async (_, tipo) => await CambiarTipoAsync(solicitud, tipo);
            tarjeta.Resuelta += async (_, estado) => await ResolverAsync(solicitud, estado);
            ListaPanel.Children.Add(tarjeta);
        }

        if (lista.Count == 0)
        {
            MostrarEstado(_verPendientes ? "No hay solicitudes pendientes." : "Todavía no hay solicitudes resueltas.", false);
        }
        else
        {
            EstadoPanel.Visibility = Visibility.Collapsed;
        }
    }

    private void EstiloPestana(Button boton, bool activa)
    {
        boton.Style = (Style)FindResource(activa ? "BotonDoradoEstilo" : "BotonSecundarioEstilo");
        boton.Height = 40;
        boton.FontSize = 14;
        boton.Foreground = activa ? (Brush)FindResource("AzulPincel") : Brushes.White;
        boton.BorderBrush = activa ? Brushes.Transparent : new SolidColorBrush(Color.FromArgb(0x99, 255, 255, 255));
    }

    private void MostrarEstado(string mensaje, bool conReintento)
    {
        ListaPanel.Children.Clear();
        EstadoTextBlock.Text = mensaje;
        EstadoTextBlock.Foreground = (Brush)FindResource(conReintento ? "ErrorPincel" : "TextoSecundarioPincel");
        ReintentarBoton.Visibility = conReintento ? Visibility.Visible : Visibility.Collapsed;
        EstadoPanel.Visibility = Visibility.Visible;
    }

    private void MostrarMensaje(string mensaje, bool error)
    {
        MensajeTextBlock.Text = mensaje;
        MensajeBorder.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString(error ? "#FDECEA" : "#E8F5E9"));
        MensajeTextBlock.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString(error ? "#C62828" : "#2E7D32"));
        MensajeBorder.Visibility = Visibility.Visible;
    }

    private async Task ResolverAsync(SolicitudPermiso solicitud, EstadoSolicitud estado)
    {
        var aprobar = estado == EstadoSolicitud.Aprobada;
        var texto = $"{solicitud.ProfesorTexto}\n{solicitud.FechaLargaTexto}\n\nEsta decisión no se puede deshacer.";
        var respuesta = MessageBox.Show(texto, aprobar ? "Aprobar solicitud" : "Rechazar solicitud", MessageBoxButton.YesNo, MessageBoxImage.Question);
        if (respuesta != MessageBoxResult.Yes)
        {
            return;
        }
        try
        {
            await ApiCliente.CambiarEstadoAsync(solicitud.Id, estado);
            await Sesion.CargarSolicitudesAsync();
            Pintar();
            MostrarMensaje(aprobar ? "Solicitud aprobada." : "Solicitud rechazada.", false);
        }
        catch (ApiException ex)
        {
            MostrarMensaje(ex.Message, true);
        }
    }

    private async Task CambiarTipoAsync(SolicitudPermiso solicitud, TipoLectivo tipo)
    {
        try
        {
            await ApiCliente.CambiarTipoAsync(solicitud, tipo);
            await Sesion.CargarSolicitudesAsync();
            Pintar();
            MostrarMensaje($"Marcada como {(tipo == TipoLectivo.Lectivo ? "lectivo" : "no lectivo")}.", false);
        }
        catch (ApiException ex)
        {
            MostrarMensaje(ex.Message, true);
        }
    }

    private void PestanaBoton_Click(object sender, RoutedEventArgs e)
    {
        _verPendientes = sender == PendientesBoton;
        MensajeBorder.Visibility = Visibility.Collapsed;
        Pintar();
    }

    private async void ActualizarBoton_Click(object sender, RoutedEventArgs e)
    {
        MensajeBorder.Visibility = Visibility.Collapsed;
        await CargarAsync();
    }

    private void VolverInicioBoton_Click(object sender, RoutedEventArgs e)
    {
        VolverInicioSolicitado?.Invoke(this, EventArgs.Empty);
    }
}
