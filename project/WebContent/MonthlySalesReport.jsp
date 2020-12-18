<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Monthly Sales Report</title>
</head>
<h1>Monthly Sales Report</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}

java.util.Date today = new java.util.Date();
String username = (String)session.getAttribute("username");
SimpleDateFormat sqlDate = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
%>

<table border=1>
	<tr>
		<th>Month</th>
		<th># of Reservations</th>
		<th># of Customers</th>
		<th>Revenue</th>
	</tr>
	
	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

		// Write the SQL statement
		String query = "SELECT CONCAT(month, ', ', year) as date, COUNT(DISTINCT(route_name)) AS routes, COUNT(DISTINCT(passenger)) AS passengers, COUNT(reservation_num) AS reservations, ROUND(SUM(fare), 2) AS revenue " + 
		"FROM (SELECT reservation_num, passenger, route_name, fare, MONTHNAME(reservation_datetime) AS month, EXTRACT(YEAR FROM reservation_datetime) as year FROM Reservation) Query1 GROUP BY month, year;";
		PreparedStatement ps = con.prepareStatement(query);
		
		// Execute statement
		ResultSet rs = ps.executeQuery();
		
		// Output results
		while (rs.next()) {
	%>
	<tr>
		<td><%=rs.getString("date")%></td>
		<td><%=rs.getString("reservations")%></td>
		<td><%=rs.getString("passengers")%></td>
		<td>$<%=String.format("%.02f", rs.getFloat("revenue"))%></td>
	</tr>
	<%
		}
		
		// Close connection
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
	%>
</table>
<table><tr><td><form method="get" action="AdminHome.jsp"><input type="submit" value="Back"></form></td></tr></table>

</body>
</html>