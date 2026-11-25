using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace AppEscritorioGestor;

public partial class LoginView : UserControl
{
    public event EventHandler? LoginCorrecto;

    public LoginView()
    {
        InitializeComponent();
        Loaded += (_, _) => UsuarioTextBox.Focus();
    }

    private void ContrasenaPasswordBox_KeyDown(object sender, KeyEventArgs e)
    {
        if (e.Key == Key.Enter)
        {
            EntrarBoton_Click(sender, e);
        }
    }

    private async void EntrarBoton_Click(object sender, RoutedEventArgs e)
    {
        var usuario = UsuarioTextBox.Text.Trim();
        var contrasena = ContrasenaPasswordBox.Password;
        if (usuario.Length == 0 || contrasena.Length == 0)
        {
            MostrarError("Escribe tu usuario y tu contraseña.");
            return;
        }

        EntrarBoton.IsEnabled = false;
        EntrarBoton.Content = "Entrando...";
        ErrorTextBlock.Visibility = Visibility.Collapsed;
        try
        {
            await Sesion.IniciarAsync(usuario, contrasena);
            ContrasenaPasswordBox.Clear();
            LoginCorrecto?.Invoke(this, EventArgs.Empty);
        }
        catch (ApiException ex)
        {
            MostrarError(ex.Message);
            EntrarBoton.IsEnabled = true;
            EntrarBoton.Content = "Entrar";
        }
    }

    private void MostrarError(string mensaje)
    {
        ErrorTextBlock.Text = mensaje;
        ErrorTextBlock.Visibility = Visibility.Visible;
    }
}
