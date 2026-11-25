using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class SolicitudPermisoView : UserControl
{
    private const int LongitudMaximaMotivo = 200;

    public event EventHandler? VolverSolicitado;
    public event EventHandler? VolverInicioSolicitado;
    public event EventHandler<SolicitudPermiso>? SolicitudEnviada;

    public SolicitudPermisoView()
    {
        InitializeComponent();

        var profesor = Sesion.Usuario!.Profesor;
        ProfesorTextBox.Text = profesor?.NombreCompleto ?? Sesion.Usuario.Nombre;
        DepartamentoTextBox.Text = profesor?.Departamento ?? "";

        TipoLectivoComboBox.ItemsSource = new[] { "Lectivo", "No lectivo" };
        TipoLectivoComboBox.SelectedIndex = 0;

        ActualizarBotonEnviar();
        Loaded += async (_, _) => await PrepararCalendarioAsync();
    }

    private async Task PrepararCalendarioAsync()
    {
        try
        {
            await Task.WhenAll(Sesion.CargarBloqueosAsync(), Sesion.CargarSolicitudesAsync());
        }
        catch (ApiException ex)
        {
            MostrarError(ex.Message);
            return;
        }
        ConfigurarCalendario();
    }

    private void ConfigurarCalendario()
    {
        var hoy = DateTime.Today;
        var limite = hoy.AddYears(1);
        FechaPermisoDatePicker.BlackoutDates.Clear();
        FechaPermisoDatePicker.DisplayDateStart = hoy;
        FechaPermisoDatePicker.DisplayDateEnd = limite;
        for (var dia = hoy; dia <= limite; dia = dia.AddDays(1))
        {
            if (Sesion.EstaNoDisponible(dia))
            {
                FechaPermisoDatePicker.BlackoutDates.Add(new CalendarDateRange(dia));
            }
        }
    }

    private void ActualizarBotonEnviar()
    {
        EnviarSolicitudBoton.IsEnabled = FechaPermisoDatePicker.SelectedDate != null && DeclaracionCheckBox.IsChecked == true;
    }

    private void MostrarError(string mensaje)
    {
        ErrorTextBlock.Text = mensaje;
        ErrorTextBlock.Visibility = Visibility.Visible;
    }

    private void OcultarError()
    {
        ErrorTextBlock.Visibility = Visibility.Collapsed;
    }

    private void FechaPermisoDatePicker_SelectedDateChanged(object? sender, SelectionChangedEventArgs e)
    {
        OcultarError();
        ActualizarBotonEnviar();
    }

    private void DeclaracionCheckBox_Cambiado(object sender, RoutedEventArgs e)
    {
        ActualizarBotonEnviar();
    }

    private void MotivoTextBox_TextChanged(object sender, TextChangedEventArgs e)
    {
        MotivoContadorTextBlock.Text = $"{MotivoTextBox.Text.Length}/{LongitudMaximaMotivo}";
    }

    private async void EnviarSolicitudBoton_Click(object sender, RoutedEventArgs e)
    {
        var fecha = FechaPermisoDatePicker.SelectedDate;
        var profesor = Sesion.Usuario?.Profesor;
        if (fecha == null)
        {
            MostrarError("Elige la fecha del permiso.");
            return;
        }
        if (profesor == null)
        {
            MostrarError("Tu usuario no tiene un profesor asociado.");
            return;
        }

        EnviarSolicitudBoton.IsEnabled = false;
        EnviarSolicitudBoton.Content = "Enviando...";
        OcultarError();
        try
        {
            var tipo = TipoLectivoComboBox.SelectedIndex == 0 ? TipoLectivo.Lectivo : TipoLectivo.NoLectivo;
            var solicitud = await ApiCliente.CrearSolicitudAsync(fecha.Value, tipo, profesor.Id);
            SolicitudEnviada?.Invoke(this, solicitud);
        }
        catch (ApiException ex)
        {
            MostrarError(ex.Message);
            EnviarSolicitudBoton.Content = "Enviar solicitud";
            ActualizarBotonEnviar();
        }
    }

    private void LimpiarFormularioBoton_Click(object sender, RoutedEventArgs e)
    {
        FechaPermisoDatePicker.SelectedDate = null;
        TipoLectivoComboBox.SelectedIndex = 0;
        MotivoTextBox.Clear();
        DeclaracionCheckBox.IsChecked = false;
        OcultarError();
        ActualizarBotonEnviar();
    }

    private void VolverSolicitudesBoton_Click(object sender, RoutedEventArgs e)
    {
        VolverSolicitado?.Invoke(this, EventArgs.Empty);
    }

    private void VolverInicioBoton_Click(object sender, RoutedEventArgs e)
    {
        VolverInicioSolicitado?.Invoke(this, EventArgs.Empty);
    }
}
