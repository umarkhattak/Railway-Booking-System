<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Answer Question</title>
</head>
<h1>Answer Question</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}

//Get request information
String question = "";
if (request.getParameter("question") != null) {
	question = request.getParameter("question");
}
%>

<form method="post" action="AnswerRequest.jsp">
	<table>
		<tr>
			<td><%=question%></td>
		</tr>
		<tr>
			<td><input type="text" name="answer" required></td>
		</tr>
		<tr>
			
			<td>
				<input type="hidden" name="questionID" value="<%=request.getParameter("questionID")%>">
				<input type="submit" value="Submit Answer">
			</td>
		</tr>
	</table>
</form>

<table><tr><td><form method="get" action="RepQ&A.jsp"><input type="submit" value="Back"></form></td></tr></table>

</body>
</html>