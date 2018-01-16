package servicios;

import ajax.AjaxMaker;
import ajax.AjaxResponse;
import dao.AdminDAO;
import dao.ProfeDAO;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.ZoneOffset;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import model.Asignatura;
import model.Nota;
import model.Tarea;
import model.User;
import utils.Constantes;
import utils.Parametros;

public class ProfeServicios
{

    private final AjaxMaker ajax = new AjaxMaker();

    public List<Nota> getAllNotas(String email)
    {
        ProfeDAO dao = new ProfeDAO();
        User profe = new User();
        profe.setEmail(email);
        
        int id = dao.getId(profe);
        profe.setId(id);
        
        return dao.getAllNotas(profe);
    }

    public List<Nota> getAllNotasCursosAlumnos(String email)
    {
        ProfeDAO dao = new ProfeDAO();
        User profe = new User();
        profe.setEmail(email);
        
        int id = dao.getId(profe);
        profe.setId(id);
        
        return dao.getAllNotasCursosAlumnos(profe);
    }

    public AjaxResponse modNota(int id_alumno,int id_asignatura,double notaNumber)
    {
        ProfeDAO dao = new ProfeDAO();
        AjaxResponse returnme = ajax.errorResponse(16);
        
        Nota nota = new Nota();
        nota.getAlumno().setId(id_alumno);
        nota.getAsignatura().setId(id_asignatura);
        nota.setNota(notaNumber);

        if (dao.modificarNota(nota))
        {
            HashMap<String, String> datos = new HashMap<>();
            datos.put(Parametros.NOTA, String.valueOf(nota.getNota()));
            returnme = ajax.successResponse(datos);
        }

        return returnme;
    }

    public List<Nota> getAllNotasCursos(String email)
    {
        ProfeDAO dao = new ProfeDAO();
        
        User profe = new User();
        profe.setEmail(email);
        
        int id = dao.getId(profe);
        profe.setId(id);
        
        return dao.getAllNotasCursos(profe);
    }

    public List<Asignatura> getAllAsignaturas()
    {
        AdminDAO dao = new AdminDAO();
        return dao.getAllAsignaturas();
    }

    /* por aqui */
    /* TAREAS */
    public AjaxResponse agregarTarea(int id_asignatura, LocalDate fecha_entrega, String nombre_tarea, int id_tarea, String email)
    {
        Tarea tarea = new Tarea();
        tarea.getAsignatura().setId(id_asignatura);
        tarea.setId_tarea(id_tarea);
        tarea.setNombre_tarea(nombre_tarea);
        tarea.setFecha_entrega(Date.from(fecha_entrega.atStartOfDay().toInstant(ZoneOffset.UTC)));
        tarea.setId_tarea(id_tarea);

        ProfeDAO dao = new ProfeDAO();
        AjaxResponse returnme;
        List<Integer> idAlumnos = dao.getIdAlumnos(tarea.getAsignatura());

        if (idAlumnos.size() > 0)
        {
            tarea = dao.addTarea(tarea, idAlumnos, email);

            if (tarea != null)
            {
                DateFormat df = new SimpleDateFormat(Constantes.FORMATO_FECHA);
                HashMap<String, String> datos = new HashMap<>();
                datos.put(Parametros.ID_TAREA, String.valueOf(tarea.getId_tarea()));
                datos.put(Parametros.ID_ASIGNATURA, String.valueOf(tarea.getAsignatura().getId()));
                datos.put(Parametros.NOMBRE_TAREA, tarea.getNombre_tarea());
                datos.put(Parametros.NOMBRE_ASIGNATURA, dao.getNombreAsignatura(tarea.getAsignatura().getId()));
                datos.put(Parametros.FECHA_ENTREGA, df.format(tarea.getFecha_entrega()));
                returnme = ajax.successResponse(datos);
            }
            else
            {
                returnme = ajax.errorResponse(21);
            }
        }
        else
        {
            returnme = ajax.errorResponse(23);
        }

        return returnme;
    }

    public AjaxResponse modTarea(int id_tarea, String nombre_tarea, Date fecha_entrega, int id_asignatura)
    {
        ProfeDAO dao = new ProfeDAO();
        AjaxResponse returnme;

        Tarea t = new Tarea();
        t.setNombre_tarea(nombre_tarea);
        t.setFecha_entrega(fecha_entrega);
        t.setId_tarea(id_tarea);
        t.getAsignatura().setId(id_asignatura);
        t = dao.modTarea(t);

        if (t != null)
        {
            DateFormat df = new SimpleDateFormat(Constantes.FORMATO_FECHA);
            HashMap<String, String> datos = new HashMap<>();
            datos.put(Parametros.ID_TAREA, String.valueOf(t.getId_tarea()));
            datos.put(Parametros.ID_ASIGNATURA, String.valueOf(t.getAsignatura().getId()));
            datos.put(Parametros.NOMBRE_TAREA, t.getNombre_tarea());
            datos.put(Parametros.FECHA_ENTREGA, df.format(t.getFecha_entrega()));
            datos.put(Parametros.NOMBRE_ASIGNATURA, dao.getNombreAsignatura(t.getAsignatura().getId()));
            returnme = ajax.successResponse(datos);
        }
        else
        {
            returnme = ajax.errorResponse(22);
        }
        return returnme;
    }

    public AjaxResponse delTarea(int id_tarea)
    {
        ProfeDAO dao = new ProfeDAO();
        AjaxResponse returnme;
        Tarea t = new Tarea();
        t.setId_tarea(id_tarea);
        boolean eliminado = dao.delTarea(t);

        if (eliminado)
        {
            returnme = ajax.successResponse();
        }
        else
        {
            returnme = ajax.errorResponse(26);
        }
        return returnme;
    }

    public List<Tarea> getAllTareas(String email)
    {
        ProfeDAO dao = new ProfeDAO();
        User profe = new User();
        profe.setEmail(email);
        return dao.getAllTareas(profe);
    }
}
