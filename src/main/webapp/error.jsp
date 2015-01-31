<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<link rel="stylesheet" type="text/css" href="estilos.css" />
<title>ERROR!</title>
</head>
<body>
<div>
	<h1> <%=request.getParameter("tipo") %> </h1>
	<h2> <%=request.getParameter("mensaje") %></h2>
	<%if(session.getAttribute("autenticado")!=null && session.getAttribute("autenticado").equals("si")){
	%><h3><a href= "index.jsp?opcion=menu">Menu principal</a></h3>
	<h3><a href= "acceso.jsp?opcion=salir">Cerrar sesion</a></h3>
	<%}else{
	%><h3><a href= "index.jsp?opcion=entrar">Ir al formulario de acceso</a></h3>
	<%}%>	
	</div>
</body>
</html>