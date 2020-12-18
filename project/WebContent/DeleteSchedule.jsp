<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Delete Schedule</title>
</head>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}

int deleted = 0;

try {
	
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();
	
	// Write the SQL statement
	String query = "SELECT Schedule.route_name FROM Schedule LEFT JOIN Route ON Schedule.route_name = Route.route_name WHERE train = ? AND departure_datetime = ? ORDER BY travel_time DESC";		
	PreparedStatement ps = con.prepareStatement(query);
	
	// Inject parameters
	ps.setInt(1, Integer.parseInt(request.getParameter("trainID")));
	ps.setString(2, request.getParameter("departure"));
		
	// Execute statement
	ResultSet rs = ps.executeQuery();
	
	int stops = 6 - Integer.parseInt(request.getParameter("stops"));

	while (rs.next() && deleted < stops) {
	
		// Write the SQL statement
		String update = "DELETE FROM Schedule WHERE route_name = ? AND train = ? AND departure_datetime = ?";
		ps = con.prepareStatement(update);
		
		// Inject parameters
		ps.setString(1, rs.getString("route_name"));
		ps.setInt(2, Integer.parseInt(request.getParameter("trainID")));
		ps.setString(3, request.getParameter("departure"));
		
		// Execute statement
		deleted += ps.executeUpdate();
	}
	
	// Close connection
	con.close();
	
} catch (Exception ex) {
	out.print(ex);
}
%>

<table><tr>
	<%if (deleted == 1) {%>
		<td> 1 train schedule was deleted</td>
	<%} else {%>
		<td><%=deleted%> train schedules were deleted</td>
	<%}%>
</tr></table>
<form method="post" action="RepTrainSchedule.jsp">
	<table><tr><td><input type="submit" value="Back"></td></tr></table>
</form>

</body>
</html>