using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class PerfilView : UserControl
{
    public event EventHandler? VolverInicioSolicitado;

    public PerfilView()
    {
        InitializeComponent();
        var usuario = Sesion.Usuario!;
        var profesor = usuario.Profesor;
        InicialesTextBlock.Text = usuario.Iniciales;
        NombreTextBlock.Text = usuario.Nombre;
        RolCabeceraTextBlock.Text = usuario.RolTexto;
        DepartamentoTextBlock.Text = Valor(profesor?.Departamento);
        EspecialidadTextBlock.Text = Valor(profesor?.Especialidad);
        TelefonoTextBlock.Text = Valor(profesor?.Telefono);
        RolTextBlock.Text = usuario.RolTexto;
    }

    private static string Valor(string? texto) => string.IsNullOrWhiteSpace(texto) ? "-" : texto;

    private void VolverInicioBoton_Click(object sender, RoutedEventArgs e)
    {
        VolverInicioSolicitado?.Invoke(this, EventArgs.Empty);
    }
}
