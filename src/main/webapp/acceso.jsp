<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import="java.util.*" import= "usuarios.*" import="java.io.*"%>

<%
// miramos si vienen parametros de una petición para tratarla
String opcion = request.getParameter("opcion");
// obtenemos la ruta del fichero de datos
String ficheroDatos = getServletConfig().getServletContext().getRealPath("/")+"WEB-INF/datos.dat";
// obtenemos el login y la clave del usuario que intenta acceder y que vienen como parametros de la peticion
String login = (String)request.getParameter("login");
String clave = (String)request.getParameter("clave");
// la opcion entrar comprueba lso datos de login y constraseña introducidos comparandolos con la lista de usuarios que hay guardada en disco
if(opcion!=null && opcion.equals("entrar")){
	if(login!=null && clave!=null){
		SetUsuarios lista = new SetUsuarios(ficheroDatos);
		Usuario usu= lista.getUsuario(login);
		// Si el usuario es valido, se establecen como atributos de sesion su login y su id, y se airma el atributo autenticado. Al final se envía de vuelta a index.jsp
		if (usu!=null && usu.getLogin().equals(login) && usu.getClave().equals(clave)){
			session.setAttribute("login",login);
			session.setAttribute("id", usu.hashCode());
			session.setAttribute("autenticado","si");
%>
			<jsp:forward page="index.jsp">
			<jsp:param name="opcion" value="menu" />
			</jsp:forward>
<%
		}else{ // Si el usuario no es valido se muestra un error de acceso mediante un forwrd a error.jsp
%>
			<jsp:forward page="error.jsp">
			<jsp:param name="tipo" value="Error de acceso" />
			<jsp:param name="mensaje" value="El usuario o contraseña introducidos no son válidos" />
			</jsp:forward>
<%
		}
	}
}
// la opcion salir se limita a poner una negativa en el atributo de sesion autenticado 
if(opcion!=null && opcion.equals("salir")){ 
	session.setAttribute("autenticado", "no");
}
// la opcion registrar existe para, en el caso de descomentar las lineas de index.jsp que muestran un formulario de registro, procesar dichos registros cuando se quiera dar de alta usuarios nuevos de la aplicacion
if(opcion!=null && opcion.equals("registrar")){
	SetUsuarios lista = new SetUsuarios(ficheroDatos);
	Iterator<Usuario> it = lista.getUsuarios();
	boolean repetido = false;
	while(it.hasNext() && repetido==false){
		if(it.next().getLogin().equals(login)){
			repetido=true;
		}
	}
	if(repetido==false){
		Usuario usu = new Usuario(clave,login);
		lista.addUsuario(usu);
		lista.salvarLista(ficheroDatos);
%>
		<jsp:forward page="index.jsp">
		<jsp:param name="opcion" value="entrar" />
		<jsp:param name="login" value="<%=login%>" />
		<jsp:param name="clave" value="<%=clave%>" />
		</jsp:forward>
<%
	}
%>
	<jsp:forward page="error.jsp">
	<jsp:param name="tipo" value="Error de acceso" />
	<jsp:param name="mensaje" value="El usuario ya existe" />
	</jsp:forward>
<%
	
}
%>
<jsp:forward page="index.jsp" />
