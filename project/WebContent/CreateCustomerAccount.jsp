<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Create Customer Account</title>
</head>
<h1>Create Customer Account</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
session.removeAttribute("rep");
%>

<form method="post" action="CustomerAccountRequest.jsp">
	<table>
		<tr>
			<td><b>Username</b></td>
			<td><b>Password</b></td>
		</tr>
		<tr>
			<td><input type="text" placeholder="Username" name="username" required></td>
			<td><input type="password" placeholder="Password" name="password" required></td>
		</tr>
		<tr>
			<td><b>First Name</b></td>
			<td><b>Last Name</b></td>
		</tr>
		<tr>
			<td><input type="text" placeholder="First Name" name="firstName" required></td>
			<td><input type="text" placeholder="Last Name" name="lastName" required></td>
		</tr>
		<tr>
			<td><b>Email Address</b></td>
			<td><b>Age</b></td>
		</tr>
		<tr>
			<td><input type="email" placeholder="Email Address" name="emailAddress" required></td>
			<td><input type="number" placeholder="Age" name="age" required></td>
		</tr>
		<tr>
			<td>Disability<input type="checkbox" name="disabled" value="disabled"/></td>
		</tr>
		<tr>
			<td><input type="submit" value="Create New Account"></td>
		</tr>
	</table>
</form>
<br>
<form method="get" action="CustomerLogin.jsp">
	<table><tr><td><input type="submit" value="Back to Login Page"></td></tr></table>
</form>

</body>
</html>