<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Edit <%=request.getParameter("rep_lname")+", "+request.getParameter("rep_fname")%></title>
</head>
<h1>Edit <%=request.getParameter("rep_lname")+", "+request.getParameter("rep_fname")%></h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}
%>

<form action="EditRepRequest.jsp">
	<table>
		<tr>
			<td><b>Username:</b></td>
			<td><b>Password:</b></td>
		</tr>
		<tr>
			<td>
				<input type="hidden" name="username" value="<%=request.getParameter("username")%>">
				<input type="text" value="<%=request.getParameter("username")%>" disabled>
			</td>
			<td>
				<input type="hidden" name="password" value="<%=request.getParameter("password")%>">
				<input type="text" value="<%=request.getParameter("password")%>" disabled>
			</td>
		</tr>
		<tr>
			<td><b>First Name:</b></td>
			<td><b>Last Name:</b></td>
		</tr>
		<tr>
			<td><input type="text" name="fname" value="<%=request.getParameter("rep_fname")%>" required></td>
			<td><input type="text" name="lname" value="<%=request.getParameter("rep_lname")%>" required></td>
		</tr>
		<tr>
			<td><b>Email:</b></td>
			<td><b>SSN:</b></td>
		</tr>
		<tr>
			<td><input type="email" name="email" placeholder="@mail.com" value="<%=request.getParameter("email")%>" required></td>
			<td>
				<input type="text" placeholder="XXX" name="ssn1" value="<%=request.getParameter("ssn1")%>" minlength="3" maxlength="3" style="width: 3em; text-align: center" required> -
				<input type="text" placeholder="XX" name="ssn2" value="<%=request.getParameter("ssn2")%>" minlength="2" maxlength="2" style="width: 2em; text-align: center" required> -
				<input type="text" placeholder="XXXX" name="ssn3" value="<%=request.getParameter("ssn3")%>" minlength="4" maxlength="4" style="width: 4em; text-align: center" required>
			</td>			
		</tr>
		<tr>
			<td><input type="submit" value="Submit"></td>
		</tr>
		<tr>
			<td><input type="button" value="Cancel" onclick="history.back()"></td>
		</tr>
	</table>
</form>
</body>
</html>