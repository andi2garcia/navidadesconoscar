package utils;

import config.Configuration;
import freemarker.template.Template;
import java.io.Writer;
import java.security.SecureRandom;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.AbstractMap.SimpleEntry;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;
import java.util.logging.Level;
import java.util.logging.Logger;
import org.apache.commons.mail.Email;
import org.apache.commons.mail.EmailException;
import org.apache.commons.mail.SimpleEmail;

public class Utils
{

    private static final String ALPHA_NUMERIC_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    public String randomAlphaNumeric(int count)
    {
        StringBuilder builder = new StringBuilder();
        Random r = new SecureRandom();

        while (count-- != 0)
        {
            int character = (int) (r.nextInt(ALPHA_NUMERIC_STRING.length()));
            builder.append(ALPHA_NUMERIC_STRING.charAt(character));
        }
        return builder.toString();
    }

    public void mandarMail(String to, String msg, String subject)
    {
        try
        {
            Email email = new SimpleEmail();

            email.setHostName(Configuration.getInstance().getSmtpServer());
            email.setSmtpPort(Integer.parseInt(Configuration.getInstance().getSmtpPort()));
            email.setAuthentication(Configuration.getInstance().getMailFrom(), Configuration.getInstance().getMailPass());
            email.setStartTLSEnabled(true);
            email.setFrom(Configuration.getInstance().getMailFrom());
            email.setSubject(subject);
            email.setContent(msg, "text/html");
            email.addTo(to);
            email.send();
        }
        catch (EmailException ex)
        {
            Logger.getLogger(Utils.class.getName()).log(Level.SEVERE, null, ex);
        }
    }

    private Object depuradorParametros(String param)
    {
        Object parsedParam = "";
        if (param != null)
        {
            parsedParam = param;
        }
        return parsedParam;
    }

    public int depurarParametroInt(String param)
    {
        try
        {
            String number = depuradorParametros(param).toString();
            return number.equals("") ? 0 : Integer.parseInt(number);
        }
        catch (NumberFormatException ex)
        {
            return 0;
        }
    }

    public double depurarParametroDouble(String param)
    {
        String number = depuradorParametros(param).toString();
        return number.equals("") ? 0 : Double.parseDouble(number);
    }

    public String depurarParametroString(String param)
    {
        return depuradorParametros(param).toString();
    }

    public boolean depurarParametroBoolean(String param)
    {
        return Boolean.parseBoolean(depuradorParametros(param).toString());
    }

    public Date depurarParametroDate(String param)
    {
        Object date = depuradorParametros(param);
        Date returned = new Date();
        if (!date.toString().equals(""))
        {
            try
            {
                returned = (Date) date;
            }
            catch (Exception e)
            {

            }
        }
        return returned;
    }

    public LocalDate depurarParametroLocalDate(String param)
    {

        Object localDate = depuradorParametros(param);
        DateTimeFormatter dtf = DateTimeFormatter.ofPattern(Constantes.FORMATO_FECHA);
        LocalDate returned = LocalDate.now();
        if (!localDate.toString().equals(""))
        {
            try
            {
                returned = LocalDate.parse(localDate.toString(), dtf);
            }
            catch (Exception e)
            {

            }
        }
        return returned;
    }

    /*
        Método para mostrar plantillas. 
        Transfiere los datos a la plantilla mediante el argumento de conveniencia,
        basándose en ls valores key => val de cada objeto, en el parámetro inyectores.
        Para agregar un inyector, el parámetro sería: new AbstractMap.SimpleEntry<>(clave, valor)
     */
    public void mostrarPlantilla(String templatePath, Writer writer, SimpleEntry... inyectores)
    {
        Template temp;
        HashMap root = new HashMap();
        for (SimpleEntry<Object, String> inyector : inyectores)
        {
            root.put(inyector.getKey(), inyector.getValue());
        }
        try
        {
            temp = Configuration.getInstance().getFreeMarker().getTemplate(templatePath);
            temp.process(root, writer);
        }
        catch (Exception ex)
        {
            Logger.getLogger(Utils.class.getName()).log(Level.SEVERE, null, ex);
        }

    }
    private static final Logger LOG = Logger.getLogger(Utils.class.getName());
}
