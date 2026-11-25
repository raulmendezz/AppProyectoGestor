using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class HomeView : UserControl
{
    public event EventHandler<string>? DestinoSolicitado;
    public event EventHandler? SalirSolicitado;

    public HomeView()
    {
        InitializeComponent();
        var usuario = Sesion.Usuario!;
        SaludoTextBlock.Text = $"Hola, {usuario.PrimerNombre}";
        AvatarBoton.Content = usuario.Iniciales;
        if (Sesion.EsAdmin)
        {
            PermisosTituloTextBlock.Text = "Solicitudes";
            PermisosSubtituloTextBlock.Text = "Aprobar o rechazar";
        }
    }

    private void TarjetaBoton_Click(object sender, RoutedEventArgs e)
    {
        var destino = (string)((Button)sender).Tag;
        DestinoSolicitado?.Invoke(this, destino);
    }

    private void SalirBoton_Click(object sender, RoutedEventArgs e)
    {
        SalirSolicitado?.Invoke(this, EventArgs.Empty);
    }
}
