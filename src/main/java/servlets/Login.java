package servlets;

import ajax.AjaxMaker;
import ajax.AjaxResponse;
import config.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.User;
import servicios.LoginServicios;

@WebServlet(name = "Login", urlPatterns =
{
    "/login"
})
public class Login extends HttpServlet
{

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {

        String accion = request.getParameter("accion");
        if (accion == null)
        {
            accion = "";
        }
        LoginServicios ls = new LoginServicios();
        AjaxMaker ajax = new AjaxMaker(); //asistente para ayudar
        switch (accion)
        {
            case "login":

                String mail = request.getParameter("mail");
                String pass = request.getParameter("password");
                AjaxResponse login = ls.login(mail, pass);
                if (login.isSuccess())
                {
                    User u = ls.getUser(mail);
                    request.getSession().setAttribute("nombreUsuario", mail);

                }
                else
                {
                    String objeto_json = ajax.parseResponse(login);
                    response.getWriter().print(objeto_json);
                }
                break;

            default: //CARGAR VISTA LOGIN
                /* estas de abajo son para cuando cargamos plantillas. el JSON no necesita plantillas */
                Template temp = Configuration.getInstance().getFreeMarker().getTemplate("login.ftl");

                try
                {
                    temp.process(null, response.getWriter());
                }
                catch (TemplateException ex)
                {
                    Logger.getLogger(Login.class.getName()).log(Level.SEVERE, null, ex);
                }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo()
    {
        return "Short description";
    }// </editor-fold>

}
