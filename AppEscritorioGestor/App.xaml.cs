using System.Windows;
using System.Windows.Markup;

namespace AppEscritorioGestor;

public partial class App : Application
{
    protected override void OnStartup(StartupEventArgs e)
    {
        FrameworkElement.LanguageProperty.OverrideMetadata(
            typeof(FrameworkElement),
            new FrameworkPropertyMetadata(XmlLanguage.GetLanguage("es-ES")));
        base.OnStartup(e);
    }
}
