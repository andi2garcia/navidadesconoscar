<!DOCTYPE html>
<html>
    <head>
        <title>Asignar asignaturas a alumno</title>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"  media="screen,projection"/>
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
        <link type="text/css" rel="stylesheet" href="//cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css"  media="screen,projection"/>
        <script src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <style>
            .dataTables_filter {
                display: none; 
            }
            .dataTables_length {
                display: none
            }
        </style>
        </head>
    <body>
        <header>
            <nav>
                <div class="nav-wrapper blue lighten-1">
                    <a href="#" class="brand-logo"><img alt="Logo" src="https://image.ibb.co/fXxOcG/logo.png" style="height: 50px"/></a>
                    <ul id="nav-mobile" class="right">
                        <li><a href="/panel/administrador/usuarios">Control de usuarios</a></li>
                        <li><a href="/panel/administrador/asignaturas">Control de asignaturas</a></li>
                        <li class="active"><a href="/panel/administrador/asignaturas_alumnos">Asignar asignatura a alumno</a></li>
                        <li><a href="/panel/administrador/asignaturas_profesores">Asignar asignatura a profesor</a></li>
                        <li><a href="/panel/cambiar_clave">Cambiar contraseña</a></li>
                        <li><a href="/desconectar">Desconectar</a></li>
                        </ul>
                    </div>
                </nav>
            </header>
        <div class="parallax-container">
            <div class="parallax"><img src="http://blogs.aljazeera.net/File/GetImageCustom/85463f0a-dae9-4669-96c6-65eb4747db8e/1600/533"></div>
        </div>
        <div class="row" style="margin-top: 2em">
            <div class="col s12 center-align">
                Mostrando registros desde <span id="from">0</span> hasta <span id="to">0</span>
            </div>
            <div class="col s6 center-align">
                <a class="waves-effect waves-light btn" onclick="mostrarAnteriores()"><i class="material-icons left">arrow_back</i>Anterior</a>
            </div>
            <div class="col s6 center-align">
                <a class="waves-effect waves-light btn" onclick="mostrarSiguientes()"><i class="material-icons right">arrow_forward</i>Siguiente</a>
            </div>
        </div>
        <div class="container" style="margin-top: 2em">
            <div class="row">
                <div class="col s12">
                    <table class="bordered" id="asignaturas_alumnos">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Email</th>
                                <th>Activo</th>
                                <th>Asignaturas</th>
                                <th></th>
                                </tr>
                            </thead>
                        <tbody>
                        </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <!-- Marcar como activas las asignaturas que ya estén asignadas al alumno correspondiente -->

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
        <script>
            /* está hecho a mano ya que datatable no funcionaba y se quedaba stuckeada al cargar otra página, mientras el ajax funcionaba bien */
            var actualIndex = 0, length = 5, totalRecords = 0;
            $(document).ready(function () {
                $('.parallax').parallax();
                $('.carousel').carousel();
                $('select').material_select();
                $('.modal').modal({
                    dismissible: false
                });
                paginacion(0,length,false);
            });
            function mostrarAnteriores()
            {
                if(actualIndex-length > 0)
                {
                    actualIndex = actualIndex-length;
                    if(actualIndex < 0)
                    {
                        actualIndex = 0;
                    }
                    paginacion(actualIndex,length,true);
                }
                else if(actualIndex != 0)
                {
                    actualIndex = actualIndex-length;
                    if(actualIndex < 0)
                    {
                        actualIndex = 0;
                    }
                    paginacion(actualIndex,length,true);
                }
            }
            function mostrarSiguientes()
            {
                if(actualIndex+length < totalRecords)
                {
                    actualIndex = actualIndex+length;
                    paginacion(actualIndex,length,true);
                }
            }
            function paginacion(start,length,mostrarMensajes = true)
            {
                $.ajax({
                    data: "accion=getalumnos&start=" + start + "&length=" + length,
                    url: '/panel/administrador/asignaturas_alumnos',
                    type: 'post',
                    beforeSend: function () {
                        if(mostrarMensajes)
                        {
                            $('#loading').modal('open');
                        }
                    },
                    success: function (data) {
                        var info = JSON.parse(data);
                            console.log(info);
                        totalRecords = info["recordsTotal"];
                        $("#asignaturas_alumnos").find("tbody").html("");
                        for(var actualRow in info["data"])
                        {
                            var actual = info["data"][actualRow],
                                id = actual[0],
                                nombre = actual[1],
                                email = actual[2],
                                activo = actual[3];
                            $("#asignaturas_alumnos").find("tbody").append('<tr id="alumno_'+id+'"><td>' + id + '</td><td>' + nombre + '</td><td>' + email + '</td><td>' + activo + '</td><td><select name="asignaturas" multiple><option value="" disabled selected>Seleccionar asignaturas</option><#list asignaturas as asignatura><option value="${asignatura.getId()}">${asignatura.getNombre()}</option></#list></select><label>Seleccionar asignaturas</label></td><td><a class="waves-effect waves-light btn" onclick="asignAsig('+id+')">Guardar</a></td></tr>');
                        }
                        if(mostrarMensajes)
                        {
                            Materialize.toast("Paginado correctamente.", 4000);    
                        }
                        $("#from").text(actualIndex);
                        $("#to").text(actualIndex+length);
                        <#list asignaturas_alumnos as asignatura_alumno>
                        $('#alumno_${asignatura_alumno.id_alumno} select[name="asignaturas"] option[value="${asignatura_alumno.id_asignatura}"]').attr('selected','selected');
                        </#list>
                        $('select').material_select();
                    },
                    error: function(e)
                    {
                        if(mostrarMensajes)
                        {
                            Materialize.toast("Ha ocurrido un error al procesar la petición.", 4000);    
                        }
                    },
                    complete: function(c)
                    {
                        if(mostrarMensajes)
                        {
                            $('#loading').modal('close');
                        }
                    }
                });
            }
            function asignAsig(id_alumno)
            {
                $.ajax({
                    data: "accion=asignar&id=" + id_alumno + "&asignaturas=" + $("#alumno_" + id_alumno + " select[name='asignaturas']").val().toString(),
                    url: '/panel/administrador/asignaturas_alumnos',
                    type: 'post',
                    beforeSend: function () {
                        $('#loading').modal('open');
                    },
                    success: function (data) {
                        var info = JSON.parse(data);
                        if (info['success'])
                        {
                            Materialize.toast('<span>Asignaturas asignadas correctamente.</span>', 5000, 'rounded');
                        }
                        else
                        {
                            Materialize.toast('<span>Ha ocurrido un error al asignar las asignaturas: ' + info["reason"] + '</span>', 5000, 'rounded');
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