<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Customer Representative Home</title>
</head>
<h1>Customer Representative Home</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}
%>

<table>
	<tr>
		<td>
			<form method="post" action="RepTrainSchedule.jsp">
				<input type="submit" value="Train Schedule">
			</form>
		</td>
		<td>
			<form method="get" action="ScheduleByStation.jsp">
				<input type="submit" value="Schedule by Station">
			</form>
		</td>
		<td>
			<form method="get" action="RouteCustomers.jsp">
				<input type="submit" value="Customers by Transit Line">
			</form>
		</td>
	</tr>
</table>
<table><tr>
	<td><form method="get" action="RepQ&A.jsp"><input type="submit" value="Q&A"></form></td>
</tr></table>
<br>
<table><tr>
	<td><form method="get" action="index.jsp"><input type="submit" value="Log Out"></form></td>
</tr></table>

</body>
</html>