using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class SolicitudesView : UserControl
{
    private readonly string? _mensajeInicial;

    public event EventHandler? PedirDiaSolicitado;
    public event EventHandler? VolverInicioSolicitado;

    public SolicitudesView(string? mensaje = null)
    {
        InitializeComponent();
        _mensajeInicial = mensaje;
        Loaded += async (_, _) => await CargarAsync();
    }

    private async Task CargarAsync()
    {
        PedirDiaBoton.IsEnabled = false;
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
        PedirDiaBoton.IsEnabled = true;
        MostrarLista();
        if (_mensajeInicial != null && MensajeBorder.Visibility != Visibility.Visible)
        {
            MostrarMensaje(_mensajeInicial);
        }
    }

    private void MostrarLista()
    {
        SolicitudesItemsControl.ItemsSource = null;
        SolicitudesItemsControl.ItemsSource = Sesion.Solicitudes;
        if (Sesion.Solicitudes.Count == 0)
        {
            MostrarEstado("Aún no has pedido ningún día.", false);
        }
        else
        {
            EstadoPanel.Visibility = Visibility.Collapsed;
        }
    }

    private void MostrarEstado(string mensaje, bool conReintento)
    {
        SolicitudesItemsControl.ItemsSource = null;
        EstadoTextBlock.Text = mensaje;
        EstadoTextBlock.Foreground = conReintento ? (System.Windows.Media.Brush)FindResource("ErrorPincel") : (System.Windows.Media.Brush)FindResource("TextoSecundarioPincel");
        ReintentarBoton.Visibility = conReintento ? Visibility.Visible : Visibility.Collapsed;
        EstadoPanel.Visibility = Visibility.Visible;
    }

    private void MostrarMensaje(string mensaje, bool error = false)
    {
        MensajeTextBlock.Text = mensaje;
        MensajeBorder.Background = (System.Windows.Media.Brush)new System.Windows.Media.BrushConverter().ConvertFromString(error ? "#FDECEA" : "#E8F5E9")!;
        MensajeTextBlock.Foreground = (System.Windows.Media.Brush)new System.Windows.Media.BrushConverter().ConvertFromString(error ? "#C62828" : "#2E7D32")!;
        MensajeBorder.Visibility = Visibility.Visible;
    }

    private async void ReintentarBoton_Click(object sender, RoutedEventArgs e)
    {
        await CargarAsync();
    }

    private void PedirDiaBoton_Click(object sender, RoutedEventArgs e)
    {
        PedirDiaSolicitado?.Invoke(this, EventArgs.Empty);
    }

    private void VolverInicioBoton_Click(object sender, RoutedEventArgs e)
    {
        VolverInicioSolicitado?.Invoke(this, EventArgs.Empty);
    }

    private async void AnularSolicitudBoton_Click(object sender, RoutedEventArgs e)
    {
        var solicitud = (SolicitudPermiso)((Button)sender).DataContext;
        var respuesta = MessageBox.Show($"¿Seguro que quieres anular el {solicitud.FechaLargaTexto}?", "Anular solicitud", MessageBoxButton.YesNo, MessageBoxImage.Question);
        if (respuesta != MessageBoxResult.Yes)
        {
            return;
        }
        try
        {
            await ApiCliente.EliminarSolicitudAsync(solicitud.Id);
            await Sesion.CargarSolicitudesAsync();
            MostrarLista();
            MostrarMensaje("Solicitud anulada.");
        }
        catch (ApiException ex)
        {
            MostrarMensaje(ex.Message, true);
        }
    }
}
