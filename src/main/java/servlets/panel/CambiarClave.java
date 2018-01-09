package servlets.panel;

import ajax.AjaxMaker;
import ajax.AjaxResponse;
import config.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;
import java.io.IOException;
import java.util.HashMap;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import servicios.UsersServicios;
import utils.Constantes;

@WebServlet(name = "CambiarClave", urlPatterns
        =
        {
            "/panel/cambiar_clave"
        })
public class CambiarClave extends HttpServlet
{

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException
    {

        Template temp = Configuration.getInstance().getFreeMarker().getTemplate("/panel/cambiar_clave.ftl");
        HashMap root = new HashMap();
        root.put("rango", request.getSession().getAttribute(Constantes.SESSION_RANGO_USUARIO));

        UsersServicios us = new UsersServicios();
        AjaxMaker ajax = new AjaxMaker();

        String accion = request.getParameter("accion");
        if (accion == null)
        {
            accion = "";
        }

        switch (accion)
        {
            case "cambiarpass":
                String passActual = request.getParameter("passactual");
                String nuevaPass = request.getParameter("nuevapass");
                String email = (String) request.getSession().getAttribute(Constantes.SESSION_NOMBRE_USUARIO);
                AjaxResponse cambiarPass = us.cambiarPass(passActual, nuevaPass, email);
                String objeto_json = ajax.parseResponse(cambiarPass);
                response.getWriter().print(objeto_json);
                break;

            default:
                try
                {
                    temp.process(root, response.getWriter());
                }
                catch (TemplateException ex)
                {
                    Logger.getLogger(CambiarClave.class.getName()).log(Level.SEVERE, null, ex);
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