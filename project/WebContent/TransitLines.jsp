<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Transit Lines</title>
</head>
<h1>Transit Lines</h1>
<body>

<%
if (session.getAttribute("customer") == null && session.getAttribute("admin") == null && session.getAttribute("rep") == null) {
	response.sendRedirect("index.jsp");
}

java.util.Date today = new java.util.Date();
SimpleDateFormat htmlDate = new SimpleDateFormat("yyyy-MM-dd");
java.util.Date day;
if (request.getParameter("date") == null) {
	day = today;
} else {
	day = htmlDate.parse(request.getParameter("date"));
}

//Get request information
String returnPage = request.getParameter("return");
%>
<table border=1>
	<tr>
		<th>Transit Line</th>
		<th>Origin</th>
		<th>Destination</th>
		<th># of Stops</th>
		<th>Travel Time</th>
		<th>View Details</th>
		<th>Select Transit Line</th>
	</tr>
	
	<%
	// Get Session Info
	String username = (String)session.getAttribute("username");
	
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT route_name, origin_name, CONCAT(name, ', ', city, ' ', state) AS destination_name, stops, travel_time, fare FROM " +
		"(SELECT route_name, CONCAT(name, ', ', city, ' ', state) AS origin_name, destination, stops, travel_time, fare FROM Route LEFT JOIN Station ON Route.origin = Station.stationID) Query1 " +
				"LEFT JOIN Station ON Query1.destination = Station.stationID";
		PreparedStatement ps = con.prepareStatement(query);
		
		// Execute statement
		ResultSet rs = ps.executeQuery();

		while (rs.next()) {
	%>
	<tr>
		<td><%=rs.getString("route_name")%></td>
		<td><%=rs.getString("origin_name")%></td>
		<td><%=rs.getString("destination_name")%></td>
		<td><%=rs.getInt("stops")%></td>
		<td><%=rs.getInt("travel_time")%> minutes</td>
		<td>
			<form method="post" action="RouteDetails.jsp">
				<input type="hidden" name="date" value=<%=htmlDate.format(day)%>>
				<input type="hidden" name="return" value="TransitLines.jsp">
				<input type="hidden" name="route_name" value="<%=rs.getString("route_name")%>">
				
				<input type="submit" value="View Details">
			</form>
		</td>
		<td>
			<form method="post" action="RouteCustomers.jsp">
				<input type="hidden" name="date" value=<%=htmlDate.format(day)%>>
				<input type="hidden" name="route_name" value="<%=rs.getString("route_name")%>">
				<input type="submit" value="Select Transit Line">
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
<table><tr><td>
	<form method="post" action="RouteCustomers.jsp">
		<input type="hidden" name="date" value=<%=htmlDate.format(day)%>>
		<input type="submit" value="Back">
	</form>
</td></tr></table>

</body>
</html>