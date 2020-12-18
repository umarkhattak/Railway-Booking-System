<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Railway Booking System Login Page</title>
</head>
<h1>Railway Booking System Login Page</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
session.removeAttribute("rep");
%>
<table>
	<tr>
		<td>
			<form method="get" action="CustomerLogin.jsp">
				<input type="submit" value="Customer Login">
			</form>
		</td>
		<td>
			<form method="get" action="AdminLogin.jsp">
				<input type="submit" value="Administrator Login">
			</form>
		</td>
		<td>
			<form method="get" action="RepLogin.jsp">
				<input type="submit" value="Customer Representative Login">
			</form>
		</td>
	</tr>
</table>

</body>
</html>