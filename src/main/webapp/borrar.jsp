<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="estilos.css" />
<title>Gestor de correo</title>
</head>
<%@ page import="paa.correo.*, almacen.*, java.util.Iterator, usuarios.*"%>
<%! AlmacenCorreo almacen; %>
<%! MensajeCorreo m; %>
<%
String carpeta = request.getParameter("carpeta");
String id = request.getParameter("mensaje");

String ficheroDatos=getServletConfig().getServletContext().getRealPath("/")+"WEB-INF/datos.dat";
SetUsuarios lista= new SetUsuarios(ficheroDatos);
Usuario usu= lista.getUsuario((String)session.getAttribute("login"));
almacen = usu.getAlmacen();
Iterator<MensajeCorreo> it = almacen.getMensajes(carpeta).iterator();
MensajeCorreo aux = new MensajeCorreo();
boolean encontrado = false;
int indice = 0;
while(it.hasNext()&&encontrado==false){
	aux = it.next();
	indice++;
	if(aux.getId().equals(id)){
		encontrado = true;
	}
}
boolean res = false;
if(encontrado = true){
	res = almacen.delMensaje(carpeta, indice);
}else{
%>
	<jsp:forward page="error.jsp">
	<jsp:param name="tipo" value="Error borrando mensaje" />
	<jsp:param name="mensaje" value="No se pudo recuperar el mensaje especificado." />
	</jsp:forward>
<%
}
if(res){
%>
	<p>El mensaje se elimino correctamente.</p>
	<p><a href= "index.jsp?opcion=menu">Menu principal</a></p>
<%
}
if(almacen!=null)almacen.guardar();
if(lista!=null)lista.salvarLista(ficheroDatos);
%>
</html>
