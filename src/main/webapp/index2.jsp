<%@ page language="java" contentType="text/html"; charset="UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="estilos.css" />
<title>Gestor de correo</title>
</head>
<body>
<%@ page import="almacen.*" import="java.util.*" import= "usuarios.*"%>
<%! SetUsuarios lista; %>
<%! AlmacenCorreo almacen; %>
<%
//session.invalidate();
String salida = "";
// miramos si vienen parametros de una petición para tratarla
String opcion=request.getParameter("opcion");
// miramos si la sesion esta autenticada
String autenticado=(String)session.getAttribute("autenticado");
if(autenticado==null || !autenticado.equals("si")){ // no hay una sesión autenticada
	salida+= "<div>";
	salida+= "<h3> FORMULARIO DE ACCESO AL SISTEMA </h3>";
	salida+= "<form method=\"post\" action=\"acceso.jsp\">"+
	"<p>login <input type=\"text\" name=\"login\" size=\"20\"></p>"+
	"<p>clave <input type=\"password\" name=\"clave\" size=\"20\"</p>"+
	"<input type=\"hidden\" name=\"opcion\" value=\"entrar\">"+
	"<p> <input type=\"submit\" value=\"Entrar\" name=\"B1\"></p>"+
	"</form>";
	//salida+="<form method=\"post\" action=\"acceso.jsp\">"+
	//		"<p>login <input type=\"text\" name=\"login\" size=\"20\"></p>"+
	//		"<p>clave <input type=\"password\" name=\"clave\" size=\"20\"</p>"+
	//		"<input type=\"hidden\" name=\"opcion\" value=\"registrar\">"+
	//		"<p> <input type=\"submit\" value=\"Registrar\" name=\"B2\"></p>"+
	//		"</form>";
	salida+="</div>";
	salida+="<h3>No hay ninguna sesión iniciada</h3>";
	salida+="<h3> <a href= \"index.jsp?opcion=entrar\">Ir al formulario de acceso</a>";
}else{
	if(opcion!=null && opcion.equals("entrar")){ // Se produce un error si el parametro opcion es entrar, por que se esta intentando acceder a una sesión mientras hay otra abierta.
%>
		<jsp:forward page="error.jsp">
		<jsp:param name="tipo" value="Error de autenticacion" />
		<jsp:param name="mensaje" value="Ya existe otra sesión abierta" />
		</jsp:forward>
<%
	}// Fin opcion entrar
	if(opcion!=null && opcion.equals("menu")){
		// Obtenemos los datos del usuario registrado
		String ficheroDatos=getServletConfig().getServletContext().getRealPath("/")+"WEB-INF/datos.dat";
		lista= new SetUsuarios(ficheroDatos);
		Usuario usu= lista.getUsuario((String)session.getAttribute("login"));
		if(usu==null){ // Si el usuario rescatado no es valido se produce un error
%>
			<jsp:forward page="error.jsp">
			<jsp:param name="tipo" value="Error interno" />
			<jsp:param name="mensaje" value="El usuario cuya sesion esta iniciada no es válido" />
			</jsp:forward>
<%
		}else{ // Si en caso contrario es valido, se carga el almacen del usuario y a continuacion se muestra el menu principal o el de la opcion de menu escogida
			almacen = usu.getAlmacen();
			String opcionMenu = request.getParameter("opcionMenu");
			int op=0;
			if(opcionMenu!=null){
				if(opcionMenu.equals("configurar")){
					op=1;
				}else
				if(opcionMenu.equals("enviar")){
					op=2;
				}else
				if(opcionMenu.equals("verMensaje")){
					op=3;
				}else
				if(opcionMenu.equals("recibir")){
					op=4;
				}
			}
			switch( op ) {
				case 1:
%>
					<form method="post" action="configurar.jsp" >
					<fieldset>
					<legend>Información de la cuenta</legend>
					<ul>
					<li><a>Direccion del servidor SMTP:<input type="text" name="dirServerSMTP" value=<%=usu.getConfig().getDirServerSMTP()%> ></a></li>
					<li><a>Puerto del servidor SMTP:<input type="text" name="puertoSMTP" value=<%=usu.getConfig().getPuertoSMTP() %>></a></li>
					<li><a>Direccion del servidor POP:<input type="text" name="dirServerPOP" value=<%=usu.getConfig().getDirServerPOP() %>></a></li>
					<li><a>Puerto del servidor POP:<input type="text" name="puertoPOP" value=<%=usu.getConfig().getPuertoPOP() %>></a></li>
					<li><a>Usuario:<input type="text" name="user" value=<%=usu.getConfig().getUser()%>></a></li>
					<li><a>clave:<input type="password" name="pass" value=<%=usu.getConfig().getPass()%>></a></li>
					<li><a>SSL:<input type="radio" name="SSL" value="true" <%if(usu.getConfig().isSSL()){ %>checked="checked"<%} %>/>Activado
					<input type="radio" name="SSL" value="false" <%if(!usu.getConfig().isSSL()){ %>checked="checked"<%} %>/>Desactivado</a></li>
					<li><a>Mostrar mensajes de depurado:<input type="radio" name="depurado" value="true" <%if(usu.getConfig().isDepurado()){ %>checked="checked"<%} %>/>Si
					<input type="radio" name="depurado" value="false" <%if(!usu.getConfig().isDepurado()){ %>checked="checked"<%} %>/>No</a></li>
					<li><a>Criterio ordenacion mensajes por defecto:<input type="radio" name="criterioOrdenacionMensajes" value=0 <%if(usu.getConfig().getCriterioOrdenacionMensajes()==0){ %>checked="checked"<%} %> />Fecha
					<input type="radio" name="criterioOrdenacionMensajes" value=1 <%if(usu.getConfig().getCriterioOrdenacionMensajes()==1){ %>checked="checked"<%} %>/>Remitente</a></li>
					<li><input type="submit" value="Aceptar"/></li>
					</ul>
					</fieldset>
					</form>
<%
					break;
				case 2:
%>
					<form method="post" action="enviar.jsp" >
					<fieldset>
					<legend>Enviar un mensaje</legend>
					<ul>
					<li><a>Remitente:<input type="text" name="remitente" /></a></li>
					<li><a>Destinatario:<input type="text" name="destinatario" /></a></li>
					<li><a>Asunto:<input type="text" name="asunto" /></a></li>
					<a><textarea name="texto" rows="10" cols="40">Texto</textarea></a>
					<li><input type="submit" value="Enviar"/></li>
					</ul>
					</fieldset>
					</form>
<%
					break;
				case 3:
					String id = request.getParameter("id");
					String carpeta = request.getParameter("carpeta");
					Iterator<MensajeCorreo> it = almacen.getMensajes(carpeta).iterator();
					MensajeCorreo aux = new MensajeCorreo();
					boolean encontrado = false;
					while(it.hasNext()&&encontrado==false){
						aux = it.next();
						if(aux.getId().equals(id)){
							encontrado = true;
						}
					}if(encontrado = true){
%>
						<fieldset>
						<legend>Ver un mensaje</legend>
						<ul>
						<li><a>Remitente: <%=aux.getRemitente()%></a></li>
						<li><a>Destinatario: <%=aux.getDestinatario()%></a></li>
						<li><a>Asunto: <%=aux.getAsunto()%></a></li>
						</ul>
						<a><textarea name="texto" cols="40" rows="10"><%=aux.getTexto()%></textarea></a>
						<p><a href= "borrar.jsp?carpeta=<%=carpeta%>&mensaje=<%=id%>" title="Borrar el mensaje de la carpeta">Borrar </a></p>
						</fieldset>
<%
					}else{
%>
						<jsp:forward page="error.jsp">
						<jsp:param name="tipo" value="Error mostrando mensaje" />
						<jsp:param name="mensaje" value="No se pudo recuperar el mensaje especificado." />
						</jsp:forward>
<%
					}
					break;
				case 4:
%>
					<jsp:forward page="recibir.jsp" />
<%
					break;
				
				default:
					salida+= "<div>";
					salida+= "<h1><center> MENU PRINCIPAL </center></h1>";
					salida+="<h2><p align=\"right\"><a href= \"index.jsp?opcion=menu&opcionMenu=configurar\" title="+"Configuracion de la cuenta de correo electronico."+">Configurar </a></p>";
					salida+="<h2><p align=\"right\"><a href= \"index.jsp?opcion=menu&opcionMenu=enviar\" title="+"Enviar un correo"+">Enviar </a></p>";
					salida+="<h2><p align=\"right\"><a href= \"index.jsp?opcion=menu&opcionMenu=recibir\" title="+"Descargar correo del servidor"+">Recibir </a></p>";
					salida+= "<div>";
					salida+="<h3><center>Carpetas:<a href= \"index.jsp?opcion=menu&opcionMostrar=mostrarEnviados\" title="+"Muestra los mensajes de la carpeta Enviados"+"> Enviados </a><a href= \"index.jsp?opcion=menu&opcionMostrar=mostrarRecibidos\" title="+"Muestra los mensajes de la carpeta Recibidos>"+" Recibidos </a></center></h1>";
					salida+="</div>";
					SortedSet<MensajeCorreo> setMensajes = null;
					String opcionMostrar = request.getParameter("opcionMostrar");
					if(opcionMostrar==null){
						opcionMostrar = "mostrarRecibidos";
					}
					int criterio = 0;
					criterio = usu.getConfig().getCriterioOrdenacionMensajes();
					if(opcionMostrar.equals("mostrarEnviados")){
						salida+="<h2><center>Carpeta 'Enviados':</center></h2>";
						salida+="<center><table border="+"1"+">"+
								"<th>Destinatario</th>"+
								"<th>Asunto</th>"+
								"<th>Fecha</th>";
						almacen.ordenarPor("Enviados",criterio );
						setMensajes = almacen.getMensajes("Enviados");
					}else{
						salida+="<h2><center>Carpeta 'Recibidos':</center></h2>";
						salida+="<center><table border="+"1"+">"+
								"<th>Remitente</th>"+
								"<th>Asunto</th>"+
								"<th>Fecha</th>";
						almacen.ordenarPor("Enviados", criterio);
						setMensajes = almacen.getMensajes("Recibidos");
					}
					if(setMensajes!=null){
						Iterator<MensajeCorreo> it2 = setMensajes.iterator();
						while(it2.hasNext()){
							MensajeCorreo aux2 = it2.next();
							String primCol="";
							String carpeta2="";
							if(opcionMostrar.equals("mostrarEnviados")){primCol=aux2.getDestinatario();carpeta="Enviados";}else{primCol=aux2.getRemitente();carpeta="Recibidos";}
							salida+="<tr><td><a href= \"index.jsp?opcion=menu&opcionMenu=verMensaje&id="+aux2.getId()+"&carpeta="+carpeta+"\">"+primCol+"</a></td><td><a href= \"index.jsp?opcion=menu&opcionMenu=verMensaje&id="+aux2.getId()+"&carpeta="+carpeta+"\">"+aux2.getAsunto()+"</a></td><td><a href= \"index.jsp?opcion=menu&opcionMenu=verMensaje&id="+aux2.getId()+"&carpeta="+carpeta+"\">"+aux2.getFecha()+"</a></td></tr>";
						}
					}
					salida+="</table></center>";
					salida+="</div>";
				}; // Fin switch
			if(almacen!=null)almacen.guardar();
			if(lista!=null)lista.salvarLista(ficheroDatos);
		} // Fin if-else (usu==null)
	} // Fin opcion menu
	if(opcion!=null && opcion.equals("salir")){ //si la opcion es salir, se invalida la sesion actual y se vuelve a cargar la pagina
		//session.invalidate();
%>
		<jsp:forward page="index.jsp">
		<jsp:param name="opcion" value="entrar" />
		</jsp:forward>
<%
	}
	//Si la sesion actual esta autenticada, tambien se muestra la opcion de mostrar el menu de acciones
	salida+="<h3>Hay una sesión iniciada a nombre de '"+session.getAttribute("login") +"'. </h3>";
	salida+="<h3> <a href= \"index.jsp?opcion=menu\">Menu principal</a>";
	salida+="<h3> <a href= \"acceso.jsp?opcion=salir\">Cerrar sesion</a>";
}
// Por ultimo se imprime todo el codigo almacenado en salida
out.println(salida);
%>
</body>
</html>