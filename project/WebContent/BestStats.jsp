<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Best Stats</title>
</head>
<h1>Best Stats</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}
	
java.util.Date today = new java.util.Date();
SimpleDateFormat sqlDate = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
String username = (String)session.getAttribute("username");
SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
%>
<table>
	<tr>
	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT passenger FROM (SELECT passenger, SUM(fare) AS revenue FROM Reservation GROUP BY passenger) Query1 WHERE revenue = " +
		"(SELECT MAX(revenue) FROM (SELECT SUM(fare) as revenue FROM Reservation GROUP BY passenger) Query2)";
		PreparedStatement ps = con.prepareStatement(query);
		
		// Execute statement
		ResultSet rs = ps.executeQuery();
	%>
		<td>
			<table border=1>
				<tr><th>Top Customer(s) by Revenue</th></tr>
				<%
				while (rs.next()) {
					%><tr><td><%=rs.getString("passenger")%></td></tr><%
				}
				%>
			</table>
		</td>
	<%	
		// Write the SQL statement
		query = "SELECT passenger FROM (SELECT passenger, COUNT(reservation_num) AS reservations FROM Reservation GROUP BY passenger) Query1 WHERE reservations = " +
		"(SELECT MAX(reservations) FROM (SELECT COUNT(reservation_num) as reservations FROM Reservation GROUP BY passenger) Query2)";
		ps = con.prepareStatement(query);
	
		// Execute statement
		rs = ps.executeQuery();
	%>
		<td>
			<table border=1>
				<tr><th>Top Customer(s) by Reservation</th></tr>
				<%
				while (rs.next()) {
					%><tr><td><%=rs.getString("passenger")%></td></tr><%
				}
				%>
			</table>
		</td>
	<%	
		// Write the SQL statement
		query = "SELECT route_name, SUM(fare) as revenue FROM Reservation GROUP BY route_name ORDER BY revenue DESC LIMIT 5";
		ps = con.prepareStatement(query);
	
		// Execute statement
		rs = ps.executeQuery();
	%>
		<td>
			<table border=1>
				<tr><th>Top Routes(s) by Revenue</th></tr>
				<%
				while (rs.next()) {
					%><tr><td><%=rs.getString("route_name")%></td></tr><%
				}
				%>
			</table>
		</td>
	<%	
		
		// Write the SQL statement
		query = "SELECT route_name, COUNT(reservation_num) as reservations FROM Reservation GROUP BY route_name ORDER BY reservations DESC LIMIT 5";
		ps = con.prepareStatement(query);
	
		// Execute statement
		rs = ps.executeQuery();
	%>
		<td>
			<table border=1>
				<tr><th>Top Routes(s) by Reservation</th></tr>
				<%
				while (rs.next()) {
					%><tr><td><%=rs.getString("route_name")%></td></tr><%
				}
				%>
			</table>
		</td>
	<%
		// Close connection
		con.close();
	} catch (Exception ex) {
		out.print(ex);
	}
	%>
	</tr>
</table>
<table><tr><td><form method="get" action="AdminHome.jsp"><input type="submit" value="Back"></form></td></tr></table>

</body>
</html>