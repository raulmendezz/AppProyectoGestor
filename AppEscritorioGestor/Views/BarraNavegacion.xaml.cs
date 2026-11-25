using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class BarraNavegacion : UserControl
{
    public event EventHandler<string>? DestinoSeleccionado;

    private readonly Dictionary<string, Button> _botones;

    public BarraNavegacion()
    {
        InitializeComponent();
        _botones = new Dictionary<string, Button>
        {
            ["Inicio"] = InicioNavegacionBoton,
            ["Calendario"] = CalendarioNavegacionBoton,
            ["Permisos"] = PermisosNavegacionBoton,
            ["Perfil"] = PerfilNavegacionBoton
        };
    }

    public void Seleccionar(string destino)
    {
        foreach (var par in _botones)
        {
            par.Value.Tag = par.Key == destino ? "Activo" : null;
        }
    }

    private void NavegacionBoton_Click(object sender, RoutedEventArgs e)
    {
        var destino = _botones.First(par => par.Value == sender).Key;
        DestinoSeleccionado?.Invoke(this, destino);
    }
}
