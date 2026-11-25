using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace AppEscritorioGestor;

public partial class MainWindow : Window
{
    public MainWindow()
    {
        InitializeComponent();
        BarraNavegacionPrincipal.DestinoSeleccionado += (_, destino) => Navegar(destino);
        MostrarLogin();
    }

    private void Navegar(string destino)
    {
        switch (destino)
        {
            case "Inicio":
                MostrarInicio();
                break;
            case "Permisos":
                if (Sesion.EsAdmin)
                {
                    MostrarGestionSolicitudes();
                }
                else
                {
                    MostrarMisSolicitudes(null);
                }
                break;
            case "NuevaSolicitud":
                MostrarFormularioSolicitud();
                break;
            case "Calendario":
                MostrarCalendario();
                break;
            case "Perfil":
                MostrarPerfil();
                break;
            default:
                MessageBox.Show($"La pantalla de {destino} se implementará en un próximo sprint.", "Gestión de permisos", MessageBoxButton.OK, MessageBoxImage.Information);
                break;
        }
    }

    private void Mostrar(UserControl vista, string seccionActiva)
    {
        ContenidoPrincipalContentControl.Content = vista;
        BarraNavegacionPrincipal.Visibility = Visibility.Visible;
        BarraNavegacionPrincipal.Seleccionar(seccionActiva);
    }

    private void MostrarLogin()
    {
        var vista = new LoginView();
        vista.LoginCorrecto += (_, _) => MostrarInicio();
        ContenidoPrincipalContentControl.Content = vista;
        BarraNavegacionPrincipal.Visibility = Visibility.Collapsed;
    }

    private void MostrarInicio()
    {
        var vista = new HomeView();
        vista.DestinoSolicitado += (_, destino) => Navegar(destino);
        vista.SalirSolicitado += (_, _) => CerrarSesion();
        Mostrar(vista, "Inicio");
    }

    private void MostrarMisSolicitudes(string? mensaje)
    {
        var vista = new SolicitudesView(mensaje);
        vista.PedirDiaSolicitado += (_, _) => Navegar("NuevaSolicitud");
        vista.VolverInicioSolicitado += (_, _) => Navegar("Inicio");
        Mostrar(vista, "Permisos");
    }

    private void MostrarGestionSolicitudes()
    {
        var vista = new GestionSolicitudesView();
        vista.VolverInicioSolicitado += (_, _) => Navegar("Inicio");
        Mostrar(vista, "Permisos");
    }

    private void MostrarFormularioSolicitud()
    {
        var vista = new SolicitudPermisoView();
        vista.VolverSolicitado += (_, _) => Navegar("Permisos");
        vista.VolverInicioSolicitado += (_, _) => Navegar("Inicio");
        vista.SolicitudEnviada += (_, _) => MostrarMisSolicitudes("Solicitud enviada. Queda pendiente de aprobar.");
        Mostrar(vista, "Permisos");
    }

    private void MostrarCalendario()
    {
        var vista = new CalendarioView();
        vista.VolverInicioSolicitado += (_, _) => Navegar("Inicio");
        Mostrar(vista, "Calendario");
    }

    private void MostrarPerfil()
    {
        var vista = new PerfilView();
        vista.VolverInicioSolicitado += (_, _) => Navegar("Inicio");
        Mostrar(vista, "Perfil");
    }

    private void CerrarSesion()
    {
        var respuesta = MessageBox.Show("¿Seguro que quieres cerrar la sesión?", "Cerrar sesión", MessageBoxButton.YesNo, MessageBoxImage.Question);
        if (respuesta != MessageBoxResult.Yes)
        {
            return;
        }
        Sesion.Cerrar();
        MostrarLogin();
    }

    private void MainWindow_Closing(object? sender, CancelEventArgs e)
    {
        var respuesta = MessageBox.Show("¿Seguro que quieres salir de la aplicación?", "Salir", MessageBoxButton.YesNo, MessageBoxImage.Question);
        if (respuesta != MessageBoxResult.Yes)
        {
            e.Cancel = true;
        }
    }
}
