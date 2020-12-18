<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Administrator Home</title>
</head>
<h1>Administrator Home</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}
%>

<table>
	<tr>
		<td>
			<form method="post" action="AdminTrainSchedule.jsp">
				<input type="submit" value="Train Schedule">
			</form>
		</td>
		<td>
			<form method="post" action="EditRep.jsp">
				<input type="submit" value="Edit Customer Representative Information">
			</form>
		</td>
	</tr>
</table>
<table>
	<tr>
		<td>
			<form method="post" action="MonthlySalesReport.jsp">
				<input type="submit" value="Monthly Sales Report">
			</form>
		</td>
		<td>
			<form method="post" action="RevenueAndReservations.jsp">
				<input type="submit" value="Revenue and Reservations">
			</form>
		</td>
		<td>
			<form method="post" action="BestStats.jsp">
				<input type="submit" value="Best Stats">
			</form>
		</td>
	</tr>
</table>
<br>
<table>
	<tr>
		<td>
			<b>Requires Master Admin Access</b>
			<form method="post" action="ProduceSchedule.jsp">
				<input type="submit" value="Produce Train Schedules">
			</form>
		</td>
	</tr>
</table>
<br>
<table><tr>
	<td><form method="get" action="index.jsp"><input type="submit" value="Log Out"></form></td>
</tr></table>

</body>
</html>