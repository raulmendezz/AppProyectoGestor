using System.Globalization;

namespace AppEscritorioGestor;

public static class Utilidades
{
    private static readonly CultureInfo Espanol = new("es-ES");

    public static string FechaLarga(DateTime fecha)
    {
        var texto = fecha.ToString("dddd, d 'de' MMMM", Espanol);
        return char.ToUpper(texto[0]) + texto[1..];
    }

    public static string MesCorto(DateTime fecha)
    {
        return fecha.ToString("MMM", Espanol).Replace(".", "").ToUpper();
    }

    public static string FechaCorta(DateTime fecha)
    {
        return fecha.ToString("d MMM yyyy", Espanol).Replace(".", "");
    }

    public static string NombreMes(DateTime fecha)
    {
        var texto = fecha.ToString("MMMM yyyy", Espanol);
        return char.ToUpper(texto[0]) + texto[1..];
    }

    public static DateTime LunesDeLaSemana(DateTime dia)
    {
        var retroceso = ((int)dia.DayOfWeek + 6) % 7;
        return dia.Date.AddDays(-retroceso);
    }

    public static List<DateTime> DiasDelMes(int anio, int mes)
    {
        var primero = new DateTime(anio, mes, 1);
        var inicio = LunesDeLaSemana(primero);
        var ultimo = primero.AddMonths(1).AddDays(-1);
        var fin = LunesDeLaSemana(ultimo).AddDays(6);
        var dias = new List<DateTime>();
        for (var dia = inicio; dia <= fin; dia = dia.AddDays(1))
        {
            dias.Add(dia);
        }
        return dias;
    }

    public static List<DateTime> DiasDeLaSemana(DateTime dia)
    {
        var lunes = LunesDeLaSemana(dia);
        return Enumerable.Range(0, 7).Select(i => lunes.AddDays(i)).ToList();
    }
}
