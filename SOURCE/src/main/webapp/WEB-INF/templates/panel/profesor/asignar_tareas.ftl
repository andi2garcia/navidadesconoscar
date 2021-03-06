<!DOCTYPE html>
<html>
    <head>
        <title>Control de tareas</title>
        <!--Import Google Icon Font-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!--Import materialize.css-->
        <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"  media="screen,projection"/>
        <link type="text/css" rel="stylesheet" href="//cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css"  media="screen,projection"/>

        <!--Let browser know website is optimized for mobile-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
        <script src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        </head>

    <body>
        <header>
            <nav>
                <div class="nav-wrapper blue lighten-1">
                    <a href="#" class="brand-logo"><img alt="Logo" src="https://image.ibb.co/fXxOcG/logo.png" style="height: 50px"/></a>
                    <ul id="nav-mobile" class="right">
                        <li class="active"><a href="/panel/profesor/asignar_tarea">Asignar tarea</a></li>
                        <li><a href="/panel/profesor/notas_curso">Ver notas mis cursos</a></li>
                        <li><a href="/panel/profesor/notas_alumnado">Ver notas de mis alumnos</a></li>
                        <li><a href="/panel/profesor/modificar_notas">Cambiar notas</a></li>
                        <li><a href="/panel/cambiar_clave">Cambiar contraseña</a></li>
                        <li><a href="/desconectar">Desconectar</a></li>
                        </ul>
                    </div>
                </nav>
            </header>
        <div class="parallax-container">
            <div class="parallax"><img src="http://elmanana.com.mx/imgs/noticias/original/bc588fb75c25eef_3fb2db6cccf4a23383383394b28b2b31"></div>
            </div>
        <div class="container" style="margin-top: 2em">
            <div class="row">
                <div class="col s12">
                    <a class="waves-effect waves-light btn right" onclick="addView()"><i class="material-icons right">library_books</i>Agregar tarea</a>
                </div>
                <div class="col s12">

                    <table class="responsive-table centered highlight bordered scrollspy initdatatable" id="crud_usuarios">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Asignatura</th>
                                <th>Fecha de entrega</th>
                                <th></th>
                            </tr>
                        </thead>

                        <tbody>
                            <#list tareas as tarea>
                                <tr id="tarea-${tarea.getId_tarea()}">
                                    <td>${tarea.getId_tarea()}</td>
                                    <td>${tarea.getNombre_tarea()}</td>
                                    <td data-id="${tarea.getAsignatura().getId()}">${tarea.getAsignatura().getNombre()}</td>
                                    <td>${tarea.getFecha_entrega()?datetime?string('dd-MM-yyyy')}</td>
                                    <td><a class='dropdown-button btn' href='#' onclick="markActualTask(${tarea.getId_tarea()})" data-activates='dropdown-${tarea.getId_tarea()}'>Acciones</a><ul id='dropdown-${tarea.getId_tarea()}' class='dropdown-content'><li><a onclick="editView()">Editar</a></li><li><a onclick="deleteConfirm()">Eliminar</a></li></ul></td>
                                </tr>
                            </#list>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <footer class="page-footer cyan accent-4">
            <div class="container">
                <div class="row">
                    <div class="col l6 s12">
                        <h5 class="white-text">CRUD Alumnos, asignaturas y notas</h5>
                        <p class="grey-text text-lighten-4">Creado para el IES Tierno Galván, Madrid.</p>
                        </div>
                    </div>
                </div>
            <div class="footer-copyright">
                <div class="container">
                    © 2017 Andrei García Cuadra
                    </div>
                </div>
            </footer>
        <div id="loading" class="modal">
            <div class="modal-content">
                <h1 class="center-align">Cargando...</h1>
                <div class="progress">
                    <div class="indeterminate"></div>
                    </div>
                </div>
        </div>
        <div id="manage" class="modal">
            <div class="modal-content">
              <h4>Tarea</h4>
                <div class="row">
                    <form class="col s12">
                        <input name="id" type="hidden">
                      <div class="row">
                        <div class="input-field col s6">
                          <textarea name="nombre" class="materialize-textarea"></textarea>
                          <label>Nombre de la tarea</label>
                        </div>
                        <div class="input-field col s6">
                          <input name="fecha" type="text" class="datepicker">
                          <label>Fecha de entrega</label>
                        </div>
                      </div>
                        <div class="input-field col s12">
                          <select name="asignatura">
                              <option value="" disabled selected>Selecciona una asignatura</option>
                              <#list asignaturas as asignatura>
                              <option value="${asignatura.getId()}">${asignatura.getNombre()}</option>
                              </#list>
                          </select>
                          <label>Asignatura</label>
                        </div>
                      
                      </div>
                    </form>
            </div>
            <div class="modal-footer">
              <a onclick="closeView()" class="waves-effect waves-green btn-flat">Cancelar</a>
              <a onclick="action()" class="waves-effect waves-green btn-flat">Confirmar</a>
            </div>
        </div>
        <div id="deleteConfirm" class="modal">
            <div class="modal-content">
              <h4>Eliminar tarea</h4>
              <p>¿Seguro que deseas eliminar la tarea?</p>
            </div>
            <div class="modal-footer">
              <a class="modal-action modal-close waves-effect waves-green btn-flat">No</a>
              <a onclick="del()" class="waves-effect waves-green btn-flat">Si</a>
            </div>
        </div>
        <script>
            var actualTask, $dataTable,actualAction, $datePicker;
            $(document).ready(function () {
                $dataTable = $('#crud_usuarios').DataTable({
                    "language": {
                        "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Spanish.json"
                    },
                    "drawCallback": function() {
                        $('.dropdown-button').dropdown();
                    }
                });
                $('.carousel').carousel();
                $('.parallax').parallax();
                $('select').material_select();
                $('.modal').modal({
                    dismissible: false
                });
                $datePicker = $('.datepicker').pickadate({
                    selectMonths: true, // Creates a dropdown to control month
                    selectYears: 15, // Creates a dropdown of 15 years to control year,
                    today: 'Hoy',
                    clear: 'Limpiar',
                    close: 'Aceptar',
                    closeOnSelect: false,
                    format: 'dd-mm-yyyy'
                  });
            });
            function action()
            {
                if(actualAction == "edit")
                {
                    return edit();
                }
                else if(actualAction == "add")
                {
                    return add();
                }
                else
                {
                    console.error("action not found: " + actualAction);
                }
            }
            function markActualTask(taskId)
            {
                actualTask = taskId;
            }
            /* ADD */
            function addView()
            {
                actualAction = "add";
                $("#manage").modal("open");
            }
            function closeView()
            {
                $("#manage input").each(
                    function( index, element ){
                        $(element).val("");
                    }
                );
                $("#manage textarea").each(
                    function( index, element ){
                        $(element).val("");
                    }
                );
                $("#manage select").each(
                    function( index, element ){
                        $(element).val("");
                        $(element).material_select();
                    }
                );
                $("#manage .validate").each(
                    function( index, element ){
                        $(element).removeClass("valid").removeClass("invalid");
                    }
                );
                Materialize.updateTextFields();
                $("#manage").modal("close");
            }
            function add()
            {
                var nombre = $("#manage").find("textarea[name='nombre']").val(),
                    fecha = $("#manage").find("input[name='fecha']").val(),
                    asignatura = $("#manage").find("select[name='asignatura']").val();
                if(nombre == "" || fecha == "" || asignatura == "" || nombre == null || fecha == null || asignatura == null)
                {
                    Materialize.toast('<span>Por favor, rellena todos los campos.</span>', 5000, 'rounded');
                }
                else
                {
                    $.ajax({
                        data: "accion=insertar&id_asignatura=" + asignatura + "&nombre_tarea=" + nombre + "&fecha_entrega=" + fecha ,
                        url: '/panel/profesor/asignar_tarea',
                        type: 'post',
                        beforeSend: function () {
                            $('#manage').modal('close');
                            $('#loading').modal('open');
                        },
                        success: function (data) {
                            var info = JSON.parse(data);
                            if (info['success'])
                            {
                                Materialize.toast('<span>Tarea añadida correctamente</span>', 5000, 'rounded');
                                var uinfo = info["data"];
                                var newCell = $dataTable.row.add( [
                                    uinfo["id_tarea"],
                                    uinfo["nombre_tarea"],
                                    uinfo["nombre_asignatura"],
                                    uinfo["fecha_entrega"],
                                    "<a class='dropdown-button btn' href='#' onclick='markActualTask(" + uinfo["id_tarea"] + ")' data-activates='dropdown-" + uinfo["id_tarea"] + "'>Acciones</a><ul id='dropdown-" + uinfo["id_tarea"] + "' class='dropdown-content'><li><a onclick='editView()'>Editar</a></li><li><a onclick='deleteConfirm()'>Eliminar</a></li></ul>"
                                    ] ).draw().node();
                                $(newCell).attr("id","tarea-" + info["id"]);
                            }
                            else
                            {
                                Materialize.toast('<span>Ha ocurrido un error al añadir la tarea: ' + info["reason"] + '</span>', 5000, 'rounded');
                            }
                        },
                        error: function(e)
                        {
                            Materialize.toast("Ha ocurrido un error al procesar la petición.", 4000);
                        },
                        complete: function(c)
                        {
                            $('#loading').modal('close');
                            closeView();
                        }
                    });
                }
            }
            /* EDIT */
            function editView()
            {
                actualAction = "edit";
                var nombre = $('#tarea-' + actualTask).children().eq(1).text(),
                fecha = $('#tarea-' + actualTask).children().eq(3).text(),
                id = $('#tarea-' + actualTask).children().eq(0).text(),
                asignatura = $('#tarea-' + actualTask).children().eq(2).attr("data-id");
                $("#manage").find("textarea[name='nombre']").val(nombre);
                $("#manage").find("input[name='fecha']").val(fecha);
                $("#manage").find("input[name='id']").val(id);
                $("#manage").find("select[name='asignatura']").find('option[value="' + asignatura + '"]').attr('selected', 'selected');
                $("#manage").find("select[name='asignatura']").material_select();
                Materialize.updateTextFields();
                $("#manage").modal("open");
                        
                        
            }
            function edit()
            {
                var nombre = $("#manage").find("textarea[name='nombre']").val(),
                    fecha = $("#manage").find("input[name='fecha']").val(),
                    id = $("#manage").find("input[name='id']").val(),
                    asignatura = $("#manage").find("select[name='asignatura']").val();
                if(nombre == "" || fecha == "" || id == "" || asignatura == ""|| nombre == null || fecha == null || id == null || asignatura == null)
                {
                    Materialize.toast('<span>Por favor, rellena todos los campos.</span>', 5000, 'rounded');
                }
                else
                {
                    $.ajax({
                        data: "accion=modificar&id_tarea=" + id + "&nombre_tarea=" + nombre + "&fecha_entrega=" + fecha + "&id_asignatura=" + asignatura,
                        url: '/panel/profesor/asignar_tarea',
                        type: 'post',
                        beforeSend: function () {
                            $('#manage').modal('close');
                            $('#loading').modal('open');
                        },
                        success: function (data) {
                            var info = JSON.parse(data);
                                console.log(info);
                            if (info['success'])
                            {
                                Materialize.toast('<span>Tarea modificada correctamente</span>', 5000, 'rounded');
                                var uinfo = info["data"];
                                $dataTable.row('#tarea-' + uinfo["id_tarea"]).remove();
                                var newCell = $dataTable.row.add( [
                                    uinfo["id_tarea"],
                                    uinfo["nombre_tarea"],
                                    uinfo["nombre_asignatura"],
                                    uinfo["fecha_entrega"],
                                    "<a class='dropdown-button btn' href='#' onclick='markActualTask(" + uinfo["id_tarea"] + ")' data-activates='dropdown-" + uinfo["id_tarea"] + "'>Acciones</a><ul id='dropdown-" + uinfo["id_tarea"] + "' class='dropdown-content'><li><a onclick='editView()'>Editar</a></li><li><a onclick='deleteConfirm()'>Eliminar</a></li></ul>"
                                    ] ).draw().node();
                                $(newCell).attr("id","tarea-" + info["id_tarea"]);
                            }
                            else
                            {
                                Materialize.toast('<span>Ha ocurrido un error al modificar la tarea: ' + info["reason"] + '</span>', 5000, 'rounded');
                            }
                        },
                        error: function(e)
                        {
                            Materialize.toast("Ha ocurrido un error al procesar la petición.", 4000);
                        },
                        complete: function(c)
                        {
                            $('#loading').modal('close');
                            closeView();
                        }
                    });
                }
            }
            /* DELETE */
            function deleteConfirm()
            {
                $("#deleteConfirm").modal("open");
            }
            function del()
            {
                $.ajax({
                    data: "accion=eliminar&id_tarea=" + actualTask,
                    url: '/panel/profesor/asignar_tarea',
                    type: 'post',
                    beforeSend: function () {
                        $('#deleteConfirm').modal('close');
                        $('#loading').modal('open');
                    },
                    success: function (data) {
                        var info = JSON.parse(data);
                        if (info['success'])
                        {
                            Materialize.toast('<span>Tarea eliminada correctamente</span>', 5000, 'rounded');
                            $dataTable.row('#tarea-' + actualTask).remove().draw();
                        }
                        else
                        {
                            Materialize.toast('<span>Ha ocurrido un error al eliminar la tarea: ' + info["reason"] + '</span>', 5000, 'rounded');
                        }
                    },
                    error: function(e)
                    {
                        Materialize.toast("Ha ocurrido un error al procesar la petición.", 4000);
                    },
                    complete: function(c)
                    {
                        $('#loading').modal('close');
                    }
                });
            }
        </script>
    </html>