<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Customer Home</title>
</head>
<h1>Customer Home</h1>
<body>

<%
session.removeAttribute("admin");
session.removeAttribute("rep");
if (session.getAttribute("customer") == null) {
	response.sendRedirect("CustomerLogin.jsp");
}
%>

<table>
	<tr>
		<td>
			<form method="get" action="PastReservations.jsp">
				<input type="submit" value="Past Reservations">
			</form>
		</td>
		<td>
			<form method="get" action="CurrentReservations.jsp">
				<input type="submit" value="Current Reservations">
			</form>
		</td>
		<td>
			<form method="get" action="TrainSchedule.jsp">
				<input type="submit" value="Make a Reservation">
			</form>
		</td>
	</tr>
</table>
<table><tr>
	<td><form method="get" action="CustomerQ&A.jsp"><input type="submit" value="Q&A"></form></td>
</tr></table>
<br>
<table><tr>
	<td><form method="get" action="index.jsp"><input type="submit" value="Log Out"></form></td>
</tr></table>

</body>
</html>