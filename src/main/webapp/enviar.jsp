<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="estilos.css" />
<title>Gestor de correo</title>
</head>
<%@ page import="paa.correo.*, almacen.*,java.util.Iterator, java.util.Date, usuarios.*" %>
<%! Usuario usu; %>
<%! SetUsuarios lista; %>
<%! AlmacenCorreo almacen; %>
<%
String destinatario = request.getParameter("destinatario");
String remitente = request.getParameter("remitente");
String asunto = request.getParameter("asunto");
String texto = request.getParameter("texto");
if(destinatario==null || remitente==null || asunto==null){
%>
	<jsp:forward page="error.jsp">
	<jsp:param name="tipo" value="Error de envio" />
	<jsp:param name="mensaje" value="Debe rellenar obligatoriamente los campos destinatario, remitente y asunto." />
	</jsp:forward>
<%
}
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
}
// Si en caso contrario es valido, se carga el almacen del usuario y a continuacion se crea el mensaje.
almacen = usu.getAlmacen();
Configuracion configuracion = usu.getConfig();
if(configuracion!=null){
	String host = configuracion.getDirServerSMTP();
	int port = configuracion.getPuertoSMTP();
	boolean ssl = configuracion.isSSL();
	String username = configuracion.getUser();
	String password = configuracion.getPass();
	boolean debug = configuracion.isDepurado();
	GestorEnvioCorreo gestorEnvio = new GestorEnvioCorreo(host, port, ssl, username, password, debug);
	MensajeCorreo m = new MensajeCorreo();
	m.setAsunto(asunto);
	m.setDestinatario(destinatario);
	m.setTexto(texto);
	m.setRemitente(remitente);
	m.setFecha(new Date());
	m.setId(String.valueOf(m.hashCode()));
	boolean  res = true;
	try{ // se intenta enviar el mensaje
		gestorEnvio.send(m);
		res = almacen.addMensaje("Enviados",m);
	}catch(CorreoException e){
%>
		<jsp:forward page="error.jsp">
		<jsp:param name="tipo" value="Error de envio" />
		<jsp:param name="mensaje" value="<%=e.getMessage()%>" />
		</jsp:forward>
<%
	}finally{
		if(res){
			Iterator<MensajeCorreo> it = almacen.getMensajes("Enviados").iterator();
			String id = "";
			while(it.hasNext()){
				MensajeCorreo aux = it.next();
				if(m.getId().equals(aux.getId())){
					id = aux.getId();
				}
			}
			if(almacen!=null)almacen.guardar();
			if(lista!=null)lista.salvarLista(ficheroDatos);
%>
			<p>El mensaje se envio correctamente, y ha sido guardado en la carpeta 'Enviados'</p>
			<p><a href= "index.jsp?opcion=menu&opcionMenu=verMensaje&id=<%=id  %>&carpeta=Enviados">Ir al mensaje</a></p>
			<p><a href= "index.jsp?opcion=menu">Menu principal</a></p>
<%
		}else{
%>
			<jsp:forward page="error.jsp">
			<jsp:param name="tipo" value="Error de envio" />
			<jsp:param name="mensaje" value="El mensaje se envio, pero no ha podido ser guardado en la carpeta 'Enviados'." />
			</jsp:forward>
<%
		}
	}
}else{
	
}
%>
</html>