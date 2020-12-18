<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title><%=request.getParameter("route_name")%></title>
</head>
<h1><%=request.getParameter("route_name")%></h1>
<body>

<%
if (session.getAttribute("customer") == null && session.getAttribute("admin") == null && session.getAttribute("rep") == null) {
	response.sendRedirect("index.jsp");
}

//Get request information
String returnPage = request.getParameter("return");
	
try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();
	
	// Write the SQL statement
	String query = "SELECT origin, destination, stops, clockwise FROM Route WHERE route_name = ?";
	PreparedStatement ps = con.prepareStatement(query);
		
	// Inject parameters
	ps.setString(1, request.getParameter("route_name"));
		
	// Execute statement
	ResultSet rs = ps.executeQuery();

	rs.next();
	int origin = rs.getInt("origin");
	int destination = rs.getInt("destination");
	int iterator;
	if(rs.getBoolean("clockwise")) {
		iterator = 1;
	} else {
		iterator = -1;
	}
	int i = origin;
	int stops = rs.getInt("stops");
	if (origin == destination) {
%>
<table><tr><th>Round Trip</th></tr></table>
	<%}%>
<table border=1>
	<tr>
		<th>Origin</th>
		<th>Destination</th>
		<th>Travel Time</th>
	</tr>
	<%
	while (i != destination || stops > 0) {
		int j = i + iterator;
		if (j < 1) {
			j = 5;
		} else if (j > 5) {
			j = 1;
		}
		query = "SELECT origin_name, CONCAT(name, ', ', city, ' ', state) as destination_name, travel_time FROM " +
		"(SELECT CONCAT(name, ', ', city, ' ', state) as origin_name, destination, travel_time FROM " + 
		"Stops LEFT JOIN Station ON Stops.origin = Station.stationID WHERE origin = ? AND destination = ?) Query1 " +
		"LEFT JOIN Station ON Query1.destination = Station.stationID";
		ps = con.prepareStatement(query);
		ps.setInt(1, i);
		ps.setInt(2, j);
		rs = ps.executeQuery();
		rs.next();
		i = j;
		stops--;
	%>
	<tr>
		<td><%=rs.getString("origin_name")%></td>
		<td><%=rs.getString("destination_name")%></td>
		<td><%=rs.getInt("travel_time")%> minutes</td>
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
	<% if (returnPage.contains("TrainSchedule.jsp") || returnPage.equals("TransitLines.jsp")) { 
			String originStr = request.getParameter("origin");
			String destinationStr = request.getParameter("destination");
			String sortBy = request.getParameter("sortBy");
			SimpleDateFormat htmlDate = new SimpleDateFormat("yyyy-MM-dd");
			java.util.Date day = htmlDate.parse(request.getParameter("date"));%>
		<form method="post" action="<%=returnPage%>">
			<input type="hidden" name="date" value=<%=htmlDate.format(day)%>>
			<input type="hidden" name="sortBy" value="<%=sortBy%>">
			<input type="hidden" name="origin" value="<%=originStr%>">
			<input type="hidden" name="destination" value="<%=destinationStr%>">
			<input type="submit" value="Back">
		</form>
	<% } else { %>
		<form method="get" action="<%=returnPage%>">
			<input type="submit" value="Back">
		</form>
	<% } %>
</td></tr></table>

</body>
</html>