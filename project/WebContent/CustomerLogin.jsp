<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Customer Login</title>
</head>
<h1>Customer Login</h1>
<body>

<%
if (session.getAttribute("customer") != null) {
	response.sendRedirect("CustomerHome.jsp");
} else {
	session.removeAttribute("customer");
}
session.removeAttribute("admin");
session.removeAttribute("rep");
%>

<form method="post" action="CustomerLoginRequest.jsp">
	<table>
		<tr>
			<td><b>Username</b></td>
			<td><input type="text" placeholder="Username" name="username" required></td>
		</tr>
		<tr>
			<td><b>Password</b></td>
			<td><input type="password" placeholder="Password" name="password" required></td>
		</tr>
		<tr>
			<td><input type="submit" value="Login"></td>
		</tr>
	</table>
</form>

<form method="post" action="CreateCustomerAccount.jsp">
	<table><tr><td><input type="submit" value="Create New Account"></td></tr></table>
</form>

<table><tr><td><form method="get" action="index.jsp"><input type="submit" value="Back"></form></td></tr></table>

</body>
</html>