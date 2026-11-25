using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class SolicitudTarjeta : UserControl
{
    public SolicitudTarjeta(SolicitudPermiso solicitud, bool mostrarProfesor)
    {
        InitializeComponent();
        DataContext = solicitud;
        TituloTextBlock.Text = mostrarProfesor ? solicitud.ProfesorTexto : solicitud.FechaLargaTexto;
        SubtituloTextBlock.Text = mostrarProfesor ? $"{solicitud.DepartamentoTexto} · {solicitud.TipoTexto}" : solicitud.TipoTexto;
    }
}
