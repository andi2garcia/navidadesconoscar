<!DOCTYPE html>
<html>
    <head>
        <title>Recuperar contraseña: Paso 1</title>
        <!--Import Google Icon Font-->
        <link href="https://fonts.googleapis.com/icon?family=Material+Icons" rel="stylesheet">
        <!--Import materialize.css-->
        <link type="text/css" rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/css/materialize.min.css"  media="screen,projection"/>

        <!--Let browser know website is optimized for mobile-->
        <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
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
        <canvas id='snow'></canvas>

        <div class="navbar-fixed">
            <nav>
                <div class="nav-wrapper blue lighten-1">
                    <a href="" class="brand-logo center"><img alt="Logo" src="https://image.ibb.co/fXxOcG/logo.png" style="height: 50px"/></a>
                    </div>
                </nav>
            </div>
        <div class="parallax-container valign-wrapper" style="height: 100vh;">
            <div class="parallax"><img alt="Fondo" src="https://preview.ibb.co/jdvn4w/bg.jpg"/></div>
            <div class="row center-align" style="width: 50%; z-index: 2">
                <div class="col s12 card-panel blue-grey lighten-5" style="padding: 20px; ">
                    <form id="formRecover">
                        <div class="row">
                            <div class="input-field col s12">
                                <input name="email" placeholder="Email de la cuenta a recuperar" type="email" class="validate">
                                <label for="email">Email</label>
                                </div>
                            </div>
                        <div class="row">
                            <div class="input-field col s12">
                                <a class="light-blue accent-2 waves-effect waves-light btn col s6"  href="/conectar"><i class="material-icons left">arrow_back</i>Volver al formulario de conexión</a>
                                <a class="blue accent-1 waves-effect waves-light btn col s6" style="padding-right: 20px" id="recoverTrigger"><i class="material-icons right">question_answer</i>Enviar instrucciones al email</a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <footer class="page-footer cyan accent-4">
            <div class="container">
                <div class="row">
                    <div class="col l6 s12">
                        <h5 class="white-text">Navidad con oscar</h5>
                        <p class="grey-text text-lighten-4">Realizado por Andrei García Cuadra y Miguel Ángel Díaz.</p>
                        </div>
                    </div>
                </div>
            <div class="footer-copyright">
                <div class="container">
                    © 2018 Óscar nos jode las vacaciones
                    </div>
                </div>
            </footer>
          <!-- Modal Structure -->
        <div id="loadingRecover" class="modal">
            <div class="modal-content">
                <h1 class="center-align">Cargando...</h1>
                <div class="progress">
                    <div class="indeterminate"></div>
                    </div>
                </div>
            </div>
                          <!--Import jQuery before materialize.js-->
        <script type="text/javascript" src="https://code.jquery.com/jquery-3.2.1.min.js"></script>
        <script type="text/javascript" src="http://yourjavascript.com/3762087112/snow.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/materialize/0.100.2/js/materialize.min.js"></script>
        <script>
            $(document).ready(function () {
                $('.parallax').parallax();
                $('.modal').modal({
                    dismissible: false
                });
            });
            $("#recoverTrigger").click(function () {
                $.ajax({
                    data: "accion=mandarmail&" + $("#formRecover").serialize(),
                    url: '/recuperarclave/paso1',
                    type: 'post',
                    beforeSend: function () {
                        $('#loadingRecover').modal('open');
                    },
                    success: function (data) {
                        var info = JSON.parse(data);
                        if (info['success'])
                        {
                            Materialize.toast('<span>Email enviado correctamente.</span>', 5000, 'rounded');
                            window.setTimeout(function () {
                                close();
                            }, 3000);
                        }
                        else
                        {
                            Materialize.toast('<span>Ha ocurrido un error al recuperar la cuenta: ' + info["reason"] + '</span>', 5000, 'rounded');
                        }
                    },
                    error: function(e)
                    {
                        Materialize.toast("Ha ocurrido un error al procesar la petición", 4000);
                    },
                    complete: function(c)
                    {
                        $('#loadingRecover').modal('close');
                    }
                });
            });
        </script>
        </body>
    </html>