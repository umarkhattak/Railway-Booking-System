<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Edit Schedule</title>
</head>
<h1>Edit Schedule</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}

SimpleDateFormat htmlDate = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sqlDate = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");
htmlDate.setTimeZone(TimeZone.getTimeZone("EST"));
sqlDate.setTimeZone(TimeZone.getTimeZone("EST"));
dateFormat.setTimeZone(TimeZone.getTimeZone("EST"));
timeFormat.setTimeZone(TimeZone.getTimeZone("EST"));

java.util.Date departure = htmlDate.parse(request.getParameter("departureDay"));
if (request.getParameter("departureTime") != null) {
	String time = request.getParameter("departureTime");
	Calendar c = Calendar.getInstance();
	c.setTime(departure);
	c.set(Calendar.HOUR_OF_DAY, Integer.parseInt(time.substring(0, 2)));
	c.set(Calendar.MINUTE, Integer.parseInt(time.substring(3, 5)));
	departure = c.getTime();
} else {
	response.sendRedirect("EditSchedue.jsp");
}

int edited = 0;

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

	while (rs.next()) {
	
		// Write the SQL statement
		String update = "UPDATE Schedule SET departure_datetime = ? WHERE route_name = ? AND train = ? AND departure_datetime = ?";
		ps = con.prepareStatement(update);
		
		// Inject parameters
		ps.setString(1, sqlDate.format(departure));
		ps.setString(2, rs.getString("route_name"));
		ps.setInt(3, Integer.parseInt(request.getParameter("trainID")));
		ps.setString(4, request.getParameter("departure"));
		
		// Execute statement
		edited += ps.executeUpdate();
	}
	
	// Close connection
	con.close();
	
} catch (Exception ex) {
	out.print(ex);
}
%>

<table><tr>
		<td><%=edited%> train schedules were edited</td>
</tr></table>
<form method="post" action="RepTrainSchedule.jsp">
	<table><tr><td><input type="submit" value="Back"></td></tr></table>
</form>

</body>
</html>