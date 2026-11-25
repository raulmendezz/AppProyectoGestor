using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class BloqueoFormWindow : Window
{
    private static readonly string[] TiposFijos = { "Vacaciones", "Exámenes", "Festivo", "Evaluación" };
    private const string Otro = "Otro";

    private readonly BloqueoCalendario? _bloqueo;

    public BloqueoFormWindow(BloqueoCalendario? bloqueo, DateTime diaInicial)
    {
        InitializeComponent();
        _bloqueo = bloqueo;
        Title = bloqueo == null ? "Nuevo bloqueo" : "Editar bloqueo";
        TituloTextBlock.Text = Title;

        TipoComboBox.ItemsSource = TiposFijos.Append(Otro).ToList();
        DesdeDatePicker.SelectedDate = bloqueo?.FechaInicio ?? diaInicial.Date;
        HastaDatePicker.SelectedDate = bloqueo?.FechaFin ?? diaInicial.Date;

        if (bloqueo == null)
        {
            TipoComboBox.SelectedIndex = 0;
            return;
        }
        var coincidencia = TiposFijos.FirstOrDefault(t => t.Equals(bloqueo.Tipo, StringComparison.OrdinalIgnoreCase));
        if (coincidencia != null)
        {
            TipoComboBox.SelectedItem = coincidencia;
        }
        else
        {
            TipoComboBox.SelectedItem = Otro;
            OtroTextBox.Text = bloqueo.Tipo;
        }
    }

    private void MostrarError(string mensaje)
    {
        ErrorTextBlock.Text = mensaje;
        ErrorTextBlock.Visibility = Visibility.Visible;
    }

    private void DesdeDatePicker_SelectedDateChanged(object? sender, SelectionChangedEventArgs e)
    {
        if (DesdeDatePicker.SelectedDate is DateTime desde)
        {
            HastaDatePicker.DisplayDateStart = desde;
            if (HastaDatePicker.SelectedDate is DateTime hasta && hasta < desde)
            {
                HastaDatePicker.SelectedDate = desde;
            }
        }
    }

    private void TipoComboBox_SelectionChanged(object sender, SelectionChangedEventArgs e)
    {
        OtroPanel.Visibility = (string?)TipoComboBox.SelectedItem == Otro ? Visibility.Visible : Visibility.Collapsed;
    }

    private async void GuardarBoton_Click(object sender, RoutedEventArgs e)
    {
        var tipo = (string?)TipoComboBox.SelectedItem == Otro ? OtroTextBox.Text.Trim() : (string?)TipoComboBox.SelectedItem;
        if (DesdeDatePicker.SelectedDate == null || HastaDatePicker.SelectedDate == null)
        {
            MostrarError("Elige las fechas de inicio y de fin.");
            return;
        }
        if (string.IsNullOrWhiteSpace(tipo))
        {
            MostrarError("Escribe el tipo de bloqueo.");
            return;
        }

        var bloqueo = new BloqueoCalendario
        {
            Id = _bloqueo?.Id,
            FechaInicio = DesdeDatePicker.SelectedDate.Value,
            FechaFin = HastaDatePicker.SelectedDate.Value,
            Tipo = tipo
        };

        GuardarBoton.IsEnabled = false;
        GuardarBoton.Content = "Guardando...";
        ErrorTextBlock.Visibility = Visibility.Collapsed;
        try
        {
            if (bloqueo.Id == null)
            {
                await ApiCliente.CrearBloqueoAsync(bloqueo);
            }
            else
            {
                await ApiCliente.ActualizarBloqueoAsync(bloqueo);
            }
            DialogResult = true;
        }
        catch (ApiException ex)
        {
            MostrarError(ex.Message);
            GuardarBoton.IsEnabled = true;
            GuardarBoton.Content = "Guardar";
        }
    }
}
