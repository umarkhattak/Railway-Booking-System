<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Revenue and Reservations</title>
</head>
<h1>Revenue and Reservations</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}

SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

//Get request information
String sortBy = "";
if (request.getParameter("sortBy") != null) {
	sortBy = request.getParameter("sortBy");
} else {
	sortBy = "route_name";
}
String sortByStr = "";
if (request.getParameter("sortByStr") != null) {
	sortByStr = request.getParameter("sortByStr");
}
String sortByText = "";
%>

<form method="post" action="RevenueAndReservations.jsp">
	<table>
		<tr>
			<td>
				<select name="sortBy"><%
					if (sortBy.equals("route_name")) {
						sortByText = "Transit Line";
						%><option selected value="route_name">Transit Line</option>
						<option value="passenger">Customer</option><%
					} else {
						sortByText = "Customer";
						%><option value="route_name">Transit Line</option>
						<option selected value="passenger">Customer</option><%
					}
				%></select>
			</td>
			<td><input type="text" name="sortByStr"></td>
			<td><input type="submit" value="Search"></td>
		</tr>
	</table>
</form>
<br>
<table>
	<tr>
		<td>Revenue: $<%
		try {
			// SQL preparation
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			Statement stmt = con.createStatement();
			
			// Write the SQL statement
			String query = "SELECT ROUND(SUM(fare), 2) as revenue FROM Reservation WHERE " + sortBy + " = ?";		
			PreparedStatement ps = con.prepareStatement(query);
				
			// Inject parameters
			ps.setString(1, sortByStr);
				
			// Execute statement
			ResultSet rs = ps.executeQuery();
				
			// Output results
			while (rs.next()) {
				out.print(String.format("%.02f", rs.getFloat("revenue")));
			
			}%>
		</td>
	</tr>
	<tr>
		<td>
			<form method="post" action="FullRevenueReport.jsp">
				<input type="hidden" name="sortReport" value="<%=sortBy%>">
				<input type="submit" name="title" value="Full Revenue Report for <%=sortByText%>s">
			</form>
		</td>
	</tr>
</table>
<br>
<table border=1>
	<tr>
		<th>Reservation #</th>
		<th>Customer</th>
		<th>Route</th>
		<th>Date</th>
		<th>Time</th>
		<th>Fare</th>
	</tr>
	<%
		// Write the SQL statement
		query = "SELECT * FROM Reservation WHERE " + sortBy + " = ?";		
		ps = con.prepareStatement(query);
		
		// Inject parameters
		ps.setString(1, sortByStr);
		
		// Execute statement
		rs = ps.executeQuery();
	
		// Output results
		while (rs.next()) {
	%>
	<tr>
		<td><%=rs.getInt("reservation_num")%></td>
		<td><%=rs.getString("passenger")%></td>
		<td><%=rs.getString("route_name")%></td>
		<td><%=dateFormat.format(rs.getTimestamp("reservation_datetime"))%></td>
		<td><%=timeFormat.format(rs.getTimestamp("reservation_datetime"))%></td>
		<td>$<%=String.format("%.02f", rs.getFloat("fare"))%></td>
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