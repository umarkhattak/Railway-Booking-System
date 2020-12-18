<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Create Customer Representative Account</title>
</head>
<h1>Create Customer Representative Account</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
session.removeAttribute("rep");
%>

<form method="post" action="RepAccountRequest.jsp">
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
			<td><b>SSN:</b></td>
		</tr>
		<tr>
			<td><input type="email" placeholder="Email Address" name="emailAddress" required></td>
			<td>
				<input type="text" placeholder="XXX" name="ssn1" minlength="3" maxlength="3" style="width: 3em; text-align: center" required> -
				<input type="text" placeholder="XX" name="ssn2" minlength="2" maxlength="2" style="width: 2em; text-align: center" required> -
				<input type="text" placeholder="XXXX" name="ssn3" minlength="4" maxlength="4" style="width: 4em; text-align: center" required>
			</td>
		</tr>
		<tr>
			<td><input type="submit" value="Create New Account"></td>
		</tr>
	</table>
</form>
<br>
<form method="get" action="RepLogin.jsp">
	<table><tr><td><input type="submit" value="Back to Login Page"></td></tr></table>
</form>

</body>
</html>