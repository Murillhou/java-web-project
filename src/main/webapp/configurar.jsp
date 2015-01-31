<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ page import= "usuarios.*"%>
<%! SetUsuarios lista; %>
<%
// comprobamos que vienen todos los parametros necesarios para configurar la cuenta

String puertoSMTP = request.getParameter("puertoSMTP");
String puertoPOP = request.getParameter("puertoPOP");
String dirServerSMTP = request.getParameter("dirServerSMTP");
String dirServerPOP = request.getParameter("dirServerPOP");
String user = request.getParameter("user");
String pass = request.getParameter("pass");
String criterioOrdenacionMensajes = request.getParameter("criterioOrdenacionMensajes");
String SSL = request.getParameter("SSL");
String depurado = request.getParameter("depurado");
if(puertoSMTP!=null&&puertoPOP!=null&&dirServerSMTP!=null&&dirServerPOP!=null&&user!=null&&pass!=null&&criterioOrdenacionMensajes!=null){
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
			}else{
				usu.configurar(Integer.parseInt(criterioOrdenacionMensajes), Integer.parseInt(puertoSMTP), Integer.parseInt(puertoPOP), dirServerSMTP, dirServerPOP, user, pass, Boolean.parseBoolean(SSL), Boolean.parseBoolean(depurado));
				lista.salvarLista(ficheroDatos);
			}
	
}
%>
	<jsp:forward page="index.jsp">
	<jsp:param name="opcion" value="menu" />
	</jsp:forward>