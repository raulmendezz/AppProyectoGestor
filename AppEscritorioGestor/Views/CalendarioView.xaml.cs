using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Shapes;

namespace AppEscritorioGestor;

public partial class CalendarioView : UserControl
{
    private static readonly Brush Ambar = new SolidColorBrush(Color.FromRgb(0xFF, 0xC1, 0x07));
    private static readonly Brush RojoSuave = new SolidColorBrush(Color.FromArgb(0x66, 0xFF, 0x52, 0x52));
    private static readonly Brush TextoApagado = new SolidColorBrush(Color.FromArgb(0x66, 255, 255, 255));
    private static readonly Brush AzulTexto = new SolidColorBrush(Color.FromRgb(0x1C, 0x3A, 0x70));

    private DateTime _diaSeleccionado = DateTime.Today;
    private DateTime _mesVisible = new(DateTime.Today.Year, DateTime.Today.Month, 1);
    private bool _plegado;
    private int _capacidadDiaria;

    public event EventHandler? VolverInicioSolicitado;

    public CalendarioView()
    {
        InitializeComponent();
        NuevoBloqueoBoton.Visibility = Sesion.EsAdmin ? Visibility.Visible : Visibility.Collapsed;
        Pintar();
        Loaded += async (_, _) => await CargarAsync();
    }

    private async Task CargarAsync()
    {
        try
        {
            var tareas = new List<Task> { Sesion.CargarBloqueosAsync(), Sesion.CargarSolicitudesAsync() };
            await Task.WhenAll(tareas);
            if (Sesion.EsAdmin)
            {
                _capacidadDiaria = await ApiCliente.ObtenerCapacidadDiariaAsync();
            }
        }
        catch (ApiException ex)
        {
            MostrarErrorDeCarga(ex.Message);
            return;
        }
        Pintar();
    }

    private void MostrarErrorDeCarga(string mensaje)
    {
        EventosPanel.Children.Clear();
        EventosPanel.Children.Add(new TextBlock { Text = mensaje, Foreground = (Brush)FindResource("ErrorPincel"), TextWrapping = TextWrapping.Wrap, Margin = new Thickness(0, 0, 0, 12) });
        var reintentar = new Button { Content = "Reintentar", Style = (Style)FindResource("BotonPrimarioEstilo"), Width = 160, HorizontalAlignment = HorizontalAlignment.Left };
        reintentar.Click += async (_, _) => await CargarAsync();
        EventosPanel.Children.Add(reintentar);
    }

    private void Pintar()
    {
        MesTextBlock.Text = Utilidades.NombreMes(_mesVisible);
        var glifo = _plegado ? "" : "";
        PlegarGlifoTextBlock.Text = glifo;
        PlegarBoton.Content = glifo;
        PintarCuadricula();
        PintarEventos();
    }

    private void PintarCuadricula()
    {
        CuadriculaUniformGrid.Children.Clear();
        var dias = _plegado ? Utilidades.DiasDeLaSemana(_diaSeleccionado) : Utilidades.DiasDelMes(_mesVisible.Year, _mesVisible.Month);
        foreach (var dia in dias)
        {
            CuadriculaUniformGrid.Children.Add(CrearCelda(dia));
        }
    }

    private Button CrearCelda(DateTime dia)
    {
        var seleccionado = dia.Date == _diaSeleccionado.Date;
        var esHoy = dia.Date == DateTime.Today;
        var delMes = dia.Month == _mesVisible.Month;
        var bloqueado = Sesion.EstaBloqueado(dia);

        var circulo = new Ellipse
        {
            Width = 36,
            Height = 36,
            Fill = seleccionado ? Ambar : bloqueado ? RojoSuave : Brushes.Transparent,
            Stroke = esHoy && !seleccionado ? Ambar : null,
            StrokeThickness = 1.5
        };
        var numero = new TextBlock
        {
            Text = dia.Day.ToString(),
            FontSize = 14,
            FontWeight = seleccionado || esHoy ? FontWeights.Bold : FontWeights.Normal,
            Foreground = seleccionado ? AzulTexto : delMes ? Brushes.White : TextoApagado,
            HorizontalAlignment = HorizontalAlignment.Center,
            VerticalAlignment = VerticalAlignment.Center
        };
        var contenido = new Grid { Width = 42, Height = 42 };
        contenido.Children.Add(circulo);
        contenido.Children.Add(numero);

        var estado = EstadoDelDia(dia);
        if (estado != null)
        {
            contenido.Children.Add(new Ellipse
            {
                Width = 7,
                Height = 7,
                Fill = new SolidColorBrush(SolicitudPermiso.ColorEstado(estado.Value)),
                Stroke = Brushes.White,
                StrokeThickness = 1,
                HorizontalAlignment = HorizontalAlignment.Center,
                VerticalAlignment = VerticalAlignment.Bottom,
                Margin = new Thickness(0, 0, 0, 2)
            });
        }

        var boton = new Button { Style = (Style)FindResource("BotonDiaEstilo"), Content = contenido, Tag = dia };
        boton.Click += CeldaBoton_Click;
        return boton;
    }

    private static EstadoSolicitud? EstadoDelDia(DateTime dia)
    {
        var solicitudes = Sesion.SolicitudesDelDia(dia);
        if (solicitudes.Count == 0)
        {
            return null;
        }
        if (solicitudes.Any(s => s.Estado == EstadoSolicitud.Pendiente))
        {
            return EstadoSolicitud.Pendiente;
        }
        return solicitudes.Any(s => s.Estado == EstadoSolicitud.Aprobada) ? EstadoSolicitud.Aprobada : EstadoSolicitud.Rechazada;
    }

    private void PintarEventos()
    {
        FechaSeleccionadaTextBlock.Text = $"{Utilidades.FechaLarga(_diaSeleccionado)} {_diaSeleccionado.Year}";
        EventosPanel.Children.Clear();

        var bloqueos = Sesion.BloqueosDelDia(_diaSeleccionado);
        var solicitudes = Sesion.SolicitudesDelDia(_diaSeleccionado);

        if (bloqueos.Count == 0 && solicitudes.Count == 0)
        {
            var vacio = new StackPanel { Margin = new Thickness(0, 28, 0, 0), HorizontalAlignment = HorizontalAlignment.Center };
            vacio.Children.Add(new TextBlock { Text = "", FontFamily = new FontFamily("Segoe MDL2 Assets"), FontSize = 40, Foreground = Brushes.Gray, HorizontalAlignment = HorizontalAlignment.Center });
            vacio.Children.Add(new TextBlock { Text = "Día libre", Foreground = Brushes.Gray, Margin = new Thickness(0, 8, 0, 0), HorizontalAlignment = HorizontalAlignment.Center });
            EventosPanel.Children.Add(vacio);
            return;
        }

        foreach (var bloqueo in bloqueos)
        {
            EventosPanel.Children.Add(CrearTarjetaBloqueo(bloqueo));
        }

        if (Sesion.EsAdmin && solicitudes.Count > 0)
        {
            var aprobadas = solicitudes.Count(s => s.Estado == EstadoSolicitud.Aprobada);
            var capacidad = _capacidadDiaria > 0 ? $" de {_capacidadDiaria}" : "";
            EventosPanel.Children.Add(new TextBlock
            {
                Text = $"Solicitudes del día · {aprobadas}{capacidad} aprobadas",
                FontWeight = FontWeights.SemiBold,
                Foreground = (Brush)FindResource("TextoSecundarioPincel"),
                Margin = new Thickness(0, 4, 0, 10)
            });
        }

        foreach (var solicitud in solicitudes)
        {
            EventosPanel.Children.Add(new SolicitudTarjeta(solicitud, Sesion.EsAdmin));
        }
    }

    private Border CrearTarjetaBloqueo(BloqueoCalendario bloqueo)
    {
        var rojo = Color.FromRgb(0xFF, 0x52, 0x52);
        var cuadro = new Border
        {
            Background = Brushes.White,
            CornerRadius = new CornerRadius(12),
            BorderBrush = new SolidColorBrush(rojo),
            BorderThickness = new Thickness(4, 0, 0, 0),
            Margin = new Thickness(0, 0, 0, 12),
            Padding = new Thickness(16, 12, 12, 12),
            Effect = (System.Windows.Media.Effects.Effect)FindResource("SombraTarjeta")
        };

        var fila = new Grid();
        fila.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });
        fila.ColumnDefinitions.Add(new ColumnDefinition { Width = new GridLength(1, GridUnitType.Star) });
        fila.ColumnDefinitions.Add(new ColumnDefinition { Width = GridLength.Auto });

        fila.Children.Add(new TextBlock { Text = "", FontFamily = new FontFamily("Segoe MDL2 Assets"), FontSize = 20, Foreground = new SolidColorBrush(rojo), VerticalAlignment = VerticalAlignment.Center });
        var textos = new StackPanel { Margin = new Thickness(14, 0, 0, 0), VerticalAlignment = VerticalAlignment.Center };
        textos.Children.Add(new TextBlock { Text = bloqueo.Tipo, FontWeight = FontWeights.Bold, FontSize = 15 });
        textos.Children.Add(new TextBlock { Text = bloqueo.RangoTexto, FontSize = 12, Foreground = (Brush)FindResource("TextoSecundarioPincel"), Margin = new Thickness(0, 3, 0, 0) });
        Grid.SetColumn(textos, 1);
        fila.Children.Add(textos);

        if (Sesion.EsAdmin)
        {
            var acciones = new StackPanel { Orientation = Orientation.Horizontal, VerticalAlignment = VerticalAlignment.Center };
            var editar = CrearBotonAccion("", "Editar", (Brush)FindResource("AzulPincel"));
            editar.Click += async (_, _) => await EditarBloqueoAsync(bloqueo);
            var borrar = CrearBotonAccion("", "Borrar", (Brush)FindResource("ErrorPincel"));
            borrar.Click += async (_, _) => await BorrarBloqueoAsync(bloqueo);
            acciones.Children.Add(editar);
            acciones.Children.Add(borrar);
            Grid.SetColumn(acciones, 2);
            fila.Children.Add(acciones);
        }

        cuadro.Child = fila;
        return cuadro;
    }

    private Button CrearBotonAccion(string glifo, string ayuda, Brush color)
    {
        return new Button { Style = (Style)FindResource("BotonIconoEstilo"), Content = glifo, ToolTip = ayuda, Foreground = color, Margin = new Thickness(4, 0, 0, 0) };
    }

    private void MostrarMensaje(string mensaje, bool error)
    {
        MensajeTextBlock.Text = mensaje;
        MensajeBorder.Background = new SolidColorBrush((Color)ColorConverter.ConvertFromString(error ? "#FDECEA" : "#E8F5E9"));
        MensajeTextBlock.Foreground = new SolidColorBrush((Color)ColorConverter.ConvertFromString(error ? "#C62828" : "#2E7D32"));
        MensajeBorder.Visibility = Visibility.Visible;
    }

    private void SeleccionarDia(DateTime dia)
    {
        _diaSeleccionado = dia.Date;
        _mesVisible = new DateTime(dia.Year, dia.Month, 1);
        MensajeBorder.Visibility = Visibility.Collapsed;
        Pintar();
    }

    private void Desplazar(int sentido)
    {
        if (_plegado)
        {
            SeleccionarDia(_diaSeleccionado.AddDays(7 * sentido));
            return;
        }
        var mes = _mesVisible.AddMonths(sentido);
        SeleccionarDia(mes.Year == DateTime.Today.Year && mes.Month == DateTime.Today.Month ? DateTime.Today : mes);
    }

    private void CeldaBoton_Click(object sender, RoutedEventArgs e)
    {
        SeleccionarDia((DateTime)((Button)sender).Tag);
    }

    private void MesAnteriorBoton_Click(object sender, RoutedEventArgs e)
    {
        Desplazar(-1);
    }

    private void MesSiguienteBoton_Click(object sender, RoutedEventArgs e)
    {
        Desplazar(1);
    }

    private void HoyBoton_Click(object sender, RoutedEventArgs e)
    {
        SeleccionarDia(DateTime.Today);
    }

    private void PlegarBoton_Click(object sender, RoutedEventArgs e)
    {
        _plegado = !_plegado;
        Pintar();
    }

    private void VolverInicioBoton_Click(object sender, RoutedEventArgs e)
    {
        VolverInicioSolicitado?.Invoke(this, EventArgs.Empty);
    }

    private async void NuevoBloqueoBoton_Click(object sender, RoutedEventArgs e)
    {
        await AbrirFormularioAsync(null);
    }

    private async Task EditarBloqueoAsync(BloqueoCalendario bloqueo)
    {
        await AbrirFormularioAsync(bloqueo);
    }

    private async Task AbrirFormularioAsync(BloqueoCalendario? bloqueo)
    {
        var ventana = new BloqueoFormWindow(bloqueo, _diaSeleccionado) { Owner = Window.GetWindow(this) };
        if (ventana.ShowDialog() != true)
        {
            return;
        }
        try
        {
            await Sesion.CargarBloqueosAsync();
            Pintar();
            MostrarMensaje(bloqueo == null ? "Bloqueo creado." : "Bloqueo actualizado.", false);
        }
        catch (ApiException ex)
        {
            MostrarMensaje(ex.Message, true);
        }
    }

    private async Task BorrarBloqueoAsync(BloqueoCalendario bloqueo)
    {
        var respuesta = MessageBox.Show($"¿Seguro que quieres borrar \"{bloqueo.Tipo}\"?", "Borrar bloqueo", MessageBoxButton.YesNo, MessageBoxImage.Question);
        if (respuesta != MessageBoxResult.Yes)
        {
            return;
        }
        try
        {
            await ApiCliente.EliminarBloqueoAsync(bloqueo.Id!.Value);
            await Sesion.CargarBloqueosAsync();
            Pintar();
            MostrarMensaje("Bloqueo borrado.", false);
        }
        catch (ApiException ex)
        {
            MostrarMensaje(ex.Message, true);
        }
    }
}
