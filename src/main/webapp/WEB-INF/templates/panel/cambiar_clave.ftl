<!DOCTYPE html>
<html>
    <head>
        <title>Cambiar contraseña</title>
        <!--Import Google Icon Font-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!--Import materialize.css-->
        <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"  media="screen,projection"/>

        <!--Let browser know website is optimized for mobile-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
        <meta charset="UTF-8">
        <style>
            canvas {
                position: absolute;
                top: 0;
                left: 0;
                z-index: 1;
            }
            </style>
        </head>

    <body>
        <header>
            <nav>
                <div class="nav-wrapper blue lighten-1">
                    <a href="#" class="brand-logo"><img alt="Logo" src="https://image.ibb.co/fXxOcG/logo.png" style="height: 50px"/></a>
                    <ul id="nav-mobile" class="right hide-on-med-and-down">
                        <#if rango == "administrador">
                        <li><a href="/panel/administrador/usuarios">Control de usuarios</a></li>
                        <li><a href="/panel/administrador/asignaturas">Control de asignaturas</a></li>
                        <li><a href="/panel/administrador/asignaturas_usuarios">Asignar asignatura a alumno</a></li>
                        <li><a href="panel/administrador/asignaturas_profesores">Asignar asignatura a profesor</a></li>
                        </#if>
                        <#if rango == "profesor">
                        <li><a href="/panel/profesor/modificar_notas">Notas de alumnos</a></li>
                        </#if>
                        <#if rango == "usuario">
                        <li><a href="/panel/usuario/notas">Mis notas</a></li>
                        </#if>
                        <li class="active"><a href="/panel/cambiar_clave">Cambiar contraseña</a></li>
                        <li><a href="/desconectar">Desconectar</a></li>
                        </ul>
                    </div>
                </nav>
            </header>
        <div class="parallax-container">
            <div class="parallax"><img src="https://www.esan.edu.pe/conectar/actualidad/2017/04/10/principal-seguridad-informatica.jpg"></div>
            </div>
        <div class="container" style="margin-top: 2em">
            <div class="row">
                <form class="col s12 center-align">
                    <div class="row">
                        <div class="input-field col s12">
                            <input placeholder="**********" name="old_pass" type="password" class="validate">
                            <label for="first_name">Contraseña actual</label>
                            </div>
                        <div class="input-field col s6">
                            <input placeholder="**********" name="new_pass1" type="password" class="validate">
                            <label for="first_name">Contraseña nueva</label>
                            </div>
                        <div class="input-field col s6">
                            <input placeholder="**********" name="new_pass2" type="password" class="validate">
                            <label for="first_name">Repite la nueva contraseña</label>
                            </div>
                        <a class="waves-effect waves-light btn" id="changePassTrigger"><i class="material-icons right">arrow_forward</i>Cambiar contraseña</a>
                    </form>
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
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
    <script src="/assets/js/panel_start.js"></script>
    <script>
        $(document).ready(function () {
            $('.carousel').carousel();
            $('select').material_select();
            $('.parallax').parallax();
            $('.modal').modal({
                dismissible: false
            });
        });
        $("#changePassTrigger").click(function () {
            var oldPass = $("input[name='old_pass']").val(),
                newpass1 = $("input[name='new_pass1']").val(),
                newpass2 = $("input[name='new_pass2']").val();

            if(oldPass === "" || newpass1 === "")
            {
                Materialize.toast("Debes introducir una contraseña.", 4000);
            }
            else if(newpass1 !== newpass2)
            {
                Materialize.toast("Las nuevas contraseñas no coinciden.", 4000);
            }
            else
            {
                $("input[name='old_pass']").val("");
                $("input[name='new_pass1']").val("");
                $("input[name='new_pass2']").val("");
                $.ajax({
                    data: "accion=cambiarpass&passactual=" + oldPass + "&nuevapass=" + newpass1,
                    url: '/panel/cambiar_clave',
                    type: 'post',
                    beforeSend: function () {
                        $('#loading').modal('open');
                    },
                    success: function (data) {
                        var info = JSON.parse(data);
                        if (info['success'])
                        {
                            Materialize.toast('<span>Contraseña cambiada correctamente.</span>', 5000, 'rounded');
                            window.setTimeout(function () {
                                close();
                            }, 3000);
                        }
                        else
                        {
                            Materialize.toast('<span>Se ha producido un error al cambiar la contraseña: ' + info["reason"] + '</span>', 5000, 'rounded');
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
        });
        </script>
</html>