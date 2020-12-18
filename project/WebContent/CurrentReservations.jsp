<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Current Reservations</title>
</head>
<h1>Current Reservations</h1>
<body>

<%
session.removeAttribute("admin");
session.removeAttribute("rep");
if (session.getAttribute("customer") == null) {
	response.sendRedirect("CustomerLogin.jsp");
}

java.util.Date today = new java.util.Date();
SimpleDateFormat sqlDate = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
String customer = (String)session.getAttribute("customer");
SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
%>

<table border=1>
	<tr>
		<th>Reservation #</th>
		<th>Route</th>
		<th>Date</th>
		<th>Time</th>
		<th>Fare</th>
		<th>Stops</th>
		<th>Cancel Reservation</th>
	</tr>
	
	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

		// Write the SQL statement
		String query = "SELECT reservation_num, route_name, reservation_datetime, fare FROM " +
		"Reservation WHERE passenger = ? AND reservation_datetime > ? ORDER BY reservation_datetime";
		PreparedStatement ps = con.prepareStatement(query);

		// Inject parameters
		ps.setString(1, customer);
		ps.setString(2, sqlDate.format(today));
		
		// Execute statement
		ResultSet rs = ps.executeQuery();
		
		// Output results
		while (rs.next()) {
	%>
	<tr>
		<td><%=rs.getInt("reservation_num")%></td>
		<td><%=rs.getString("route_name")%></td>
		<td><%=dateFormat.format(rs.getTimestamp("reservation_datetime"))%></td>
		<td><%=timeFormat.format(rs.getTimestamp("reservation_datetime"))%></td>	
		<td>$<%=String.format("%.02f", rs.getFloat("fare"))%></td>
		<td>
			<form method="post" action="RouteDetails.jsp">
				<input type="hidden" name="return" value="CurrentReservations.jsp">
				<input type="hidden" name="route_name" value="<%=rs.getString("route_name")%>">
				<input type="submit" value="View Details">
			</form>
		</td>
		<td>
			<form method="post" action="CancelReservation.jsp">
				<input type="hidden" name="reservation" value="<%=rs.getInt("reservation_num")%>">
				<input type="submit" value="Cancel Reservation">
			</form>
		</td>
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
<table><tr>
	<td><form method="get" action="CustomerHome.jsp"><input type="submit" value="Back"></form></td>
	<td><form method="get" action="CustomerQ&A.jsp"><input type="submit" value="Q&A"></form></td>
</tr></table>

</body>
</html>