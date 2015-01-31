<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="estilos.css" />
<title>Gestor de correo</title>
</head>
<%@ page import="paa.correo.*, almacen.*,java.util.Iterator,usuarios.*" %>
<%! Usuario usu; %>
<%! SetUsuarios lista; %>
<%! AlmacenCorreo almacen; %>
<%! MensajeCorreo m; %>
<%! GestorLecturaCorreo gestorLectura; %>
<%
String ficheroDatos=getServletConfig().getServletContext().getRealPath("/")+"WEB-INF/datos.dat";
lista= new SetUsuarios(ficheroDatos);
usu = lista.getUsuario((String)session.getAttribute("login"));
if(usu==null){ // Si el usuario rescatado no es valido se produce un error
%>
	<jsp:forward page="error.jsp">
	<jsp:param name="tipo" value="Error interno" />
	<jsp:param name="mensaje" value="El usuario cuya sesion esta iniciada no es válido" />
	</jsp:forward>
<%
}else{// Si en caso contrario es valido, se carga el almacen del usuario y a continuacion se descargan los mensajes
	almacen = usu.getAlmacen();
	Configuracion configuracion = usu.getConfig();
	if(configuracion!=null){
		String host = configuracion.getDirServerPOP();
		int port = configuracion.getPuertoPOP();
		boolean ssl = configuracion.isSSL();
		String username = configuracion.getUser();
		String password = configuracion.getPass();
		boolean debug = configuracion.isDepurado();
		gestorLectura = new GestorLecturaCorreo(host, port, ssl, username, password, debug);
		try{
			int numMensajes = gestorLectura.open();
			boolean res = true;
			for(int i=1;i<=numMensajes;i++){
				MensajeCorreo m  = new MensajeCorreo();
				gestorLectura.get(i,m);	
				res = res&&(almacen.addMensaje("Recibidos", m));
			}
			if(!res){
	%>
				<jsp:forward page="error.jsp">
				<jsp:param name="tipo" value="Error de descarga" />
				<jsp:param name="mensaje" value="No se han descargado correctamente todos los mensajes nuevos" />
	