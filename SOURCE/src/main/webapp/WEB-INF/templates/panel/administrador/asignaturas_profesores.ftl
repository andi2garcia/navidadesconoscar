<!DOCTYPE html>
<html>
    <head>
        <title>Asignar asignaturas a profesor</title>
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"  media="screen,projection"/>
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
        <link type="text/css" rel="stylesheet" href="//cdn.datatables.net/1.10.16/css/jquery.dataTables.min.css"  media="screen,projection"/>
        <script src="//cdn.datatables.net/1.10.16/js/jquery.dataTables.min.js"></script>
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        </head>

    <body>
        <header>
            <nav>
                <div class="nav-wrapper blue lighten-1">
                    <a href="#" class="brand-logo"><img alt="Logo" src="https://image.ibb.co/fXxOcG/logo.png" style="height: 50px"/></a>
                    <ul id="nav-mobile" class="right">
                        <li><a href="/panel/administrador/usuarios">Control de usuarios</a></li>
                        <li><a href="/panel/administrador/asignaturas">Control de asignaturas</a></li>
                        <li><a href="/panel/administrador/asignaturas_alumnos">Asignar asignatura a alumno</a></li>
                        <li class="active"><a href="/panel/administrador/asignaturas_profesores">Asignar asignatura a profesor</a></li>
                        <li><a href="/panel/cambiar_clave">Cambiar contraseña</a></li>
                        <li><a href="/desconectar">Desconectar</a></li>
                        </ul>
                    </div>
                </nav>
            </header>
        <div class="parallax-container">
            <div class="parallax"><img src="https://www.dsc.cl/wp-content/uploads/photo-gallery/Equipamiento/Sala%20de%20Profesores/saladeprofesores1.jpg"></div>
            </div>
        <div class="container" style="margin-top: 2em">
            <div class="row">
                <div class="col s12">
                    <table class="responsive-table centered highlight bordered scrollspy initdatatable" id="asignaturas_profesores">
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
                            <#list profesores as profesor>
                            <tr id="profesor_${profesor.getId()}">
                                <td>${profesor.getId()}</td>
                                <td>${profesor.getNombre()}</th>
                                <td>${profesor.getEmail()}</td>
                                <td>${profesor.getActivo()?string('Si', 'No')}</td>
                                <td>
                                    <select name="asignaturas" multiple>
                                        <option value="" disabled selected>Seleccionar asignaturas</option>
                                    <#list asignaturas as asignatura>
                                        <option value="${asignatura.getId()}">${asignatura.getNombre()}</option>
                                    </#list>
                                    </select>
                                    <label>Seleccionar asignaturas</label>
                                </td>
                                <td><a class="waves-effect waves-light btn" onclick="asignAsig(${profesor.getId()})">Guardar</a></td>
                            </tr>
                        </#list>
                        
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
        <!-- Marcar como activas las asignaturas que ya estén asignadas al profesor correspondiente -->
        <#list asignaturas_profesores as asignatura_profesor>
            <script>
                $('#profesor_${asignatura_profesor.id_profesor} select[name="asignaturas"] option[value="${asignatura_profesor.id_asignatura}"]').attr('selected','selected');
            </script>
        </#list>
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
            $(document).ready(function () {
                $('#asignaturas_profesores').DataTable({
                    "language": {
                        "url": "//cdn.datatables.net/plug-ins/1.10.16/i18n/Spanish.json"
                    }
                });
                $('.parallax').parallax();
                $('.carousel').carousel();
                $('select').material_select();
                $('.modal').modal({
                    dismissible: false
                });
            });
            function asignAsig(id_profesor)
            {
                $.ajax({
                    data: "accion=asignar&id=" + id_profesor + "&asignaturas=" + $("#profesor_" + id_profesor + " select[name='asignaturas']").val().toString(),
                    url: '/panel/administrador/asignaturas_profesores',
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