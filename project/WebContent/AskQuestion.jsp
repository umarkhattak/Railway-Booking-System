<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Ask Question</title>
</head>
<h1>Ask Question</h1>
<body>
<%
session.removeAttribute("admin");
session.removeAttribute("rep");
if (session.getAttribute("customer") == null) {
	response.sendRedirect("CustomerLogin.jsp");
}
%>

<form method="post" action="AskRequest.jsp">
	<table>
		<tr>
			<td>Ask a question</td>
		</tr>
		<tr>
			<td><input type="text" name="question" required></td>
		</tr>
		<tr>
			
			<td>
				<input type="submit" value="Submit Question">
			</td>
		</tr>
	</table>
</form>
<table><tr><td><form method="get" action="CustomerHome.jsp"><input type="submit" value="Back"></form></td></tr></table>

</body>
</html>