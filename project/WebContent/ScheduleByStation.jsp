<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Train Schedule</title>
</head>
<h1>Train Schedule</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}

java.util.Date today = new java.util.Date();
SimpleDateFormat htmlDate = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sqlDate = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

//Get request information
String station = "";
if (request.getParameter("station") != null) {
	station = request.getParameter("station");
} else {
	station = "Station A, Newark NJ";
}
java.util.Date day;
if (request.getParameter("date") == null) {
	day = today;
} else {
	day = htmlDate.parse(request.getParameter("date"));
}
Calendar c = Calendar.getInstance();
c.setTime(day);
c.set(Calendar.HOUR_OF_DAY, 0);
c.set(Calendar.MINUTE, 0);
c.set(Calendar.SECOND, 0);
Calendar temp = Calendar.getInstance();
temp.setTime(today);
if ((c.get(Calendar.DAY_OF_MONTH) == temp.get(Calendar.DAY_OF_MONTH)) && (c.get(Calendar.MONTH) == temp.get(Calendar.MONTH)) && (c.get(Calendar.YEAR) == temp.get(Calendar.YEAR))) {
	day = today;
}
day = c.getTime();
c.add(Calendar.DATE, 1);
java.util.Date nextDay = c.getTime();
%>

<form method="post" action="ScheduleByStation.jsp">
	<table>
		<tr>
			<td>Date</td>
			<td>Station</td>
		</tr>
		<tr>		
			<td><input type="date" name="date" value=<%=htmlDate.format(day)%> min=<%=htmlDate.format(today)%>></td>
			<td>
				<select name="station">
					<%if (station.equals("Station A, Newark NJ")) {%>
						<option selected value="Station A, Newark NJ">Station A, Newark NJ</option>
						<option value="Station B, New Brunswick NJ">Station B, New Brunswick NJ</option>
						<option value="Station C, Atlantic City NJ">Station C, Atlantic City NJ</option>
						<option value="Station D, Camden NJ">Station D, Camden NJ</option>
						<option value="Station E, Trenton NJ">Station E, Trenton NJ</option>
					<%} else if (station.equals("Station B, New Brunswick NJ")) {%>
						<option value="Station A, Newark NJ">Station A, Newark NJ</option>
						<option selected value="Station B, New Brunswick NJ">Station B, New Brunswick NJ</option>
						<option value="Station C, Atlantic City NJ">Station C, Atlantic City NJ</option>
						<option value="Station D, Camden NJ">Station D, Camden NJ</option>
						<option value="Station E, Trenton NJ">Station E, Trenton NJ</option>
					<%} else if (station.equals("Station C, Atlantic City NJ")) {%>
						<option value="Station A, Newark NJ">Station A, Newark NJ</option>
						<option value="Station B, New Brunswick NJ">Station B, New Brunswick NJ</option>
						<option selected value="Station C, Atlantic City NJ">Station C, Atlantic City NJ</option>
						<option value="Station D, Camden NJ">Station D, Camden NJ</option>
						<option value="Station E, Trenton NJ">Station E, Trenton NJ</option>
					<%} else if (station.equals("Station D, Camden NJ")) {%>
						<option value="Station A, Newark NJ">Station A, Newark NJ</option>
						<option value="Station B, New Brunswick NJ">Station B, New Brunswick NJ</option>
						<option value="Station C, Atlantic City NJ">Station C, Atlantic City NJ</option>
						<option selected value="Station D, Camden NJ">Station D, Camden NJ</option>
						<option value="Station E, Trenton NJ">Station E, Trenton NJ</option>
					<%} else {%>
						<option value="Station A, Newark NJ">Station A, Newark NJ</option>
						<option value="Station B, New Brunswick NJ">Station B, New Brunswick NJ</option>
						<option value="Station C, Atlantic City NJ">Station C, Atlantic City NJ</option>
						<option value="Station D, Camden NJ">Station D, Camden NJ</option>
						<option selected value="Station E, Trenton NJ">Station E, Trenton NJ</option>
					<%}%>
				</select>
			</td>
			<td><input type="submit" value="Search"></td>
		</tr>
	</table>
</form>
<br>
<table border=1>
	<tr>
		<th>Route Name</th>
		<th>Train Name</th>
		<th>Origin</th>
		<th>Destination</th>
		<th>Departure</th>
		<th>Arrival</th>
		<th>Fare</th>
	</tr>

	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT * FROM (SELECT route, train, origin_name, CONCAT(name, ', ', city, ' ', state) AS destination_name, departure_datetime, arrival_datetime, fare " +
		"FROM (SELECT Schedule.route_name AS route, Train.information AS train, CONCAT(name, ', ', city, ' ', state) AS origin_name, destination, departure_datetime, DATE_ADD(departure_datetime, INTERVAL travel_time MINUTE) AS arrival_datetime, fare " +
		"FROM Schedule LEFT JOIN Route ON Schedule.route_name = Route.route_name LEFT JOIN Train ON Schedule.train = Train.trainID LEFT JOIN Station ON Route.origin = Station.stationID) Query1 LEFT JOIN Station ON Query1.destination = Station.StationID) Query1 " +
		"WHERE (origin_name = ? OR destination_name = ?) AND departure_datetime > ? AND departure_datetime < ?";		
		PreparedStatement ps = con.prepareStatement(query);
		
		// Inject parameters
		ps.setString(1, station);
		ps.setString(2, station);
		ps.setString(3, sqlDate.format(day));
		ps.setString(4, sqlDate.format(nextDay));
		
		// Execute statement
		ResultSet rs = ps.executeQuery();
		
		// Output results
		while (rs.next()) {
	%>

	<tr>
		<td><%=rs.getString("route")%></td>
		<td><%=rs.getString("train")%></td>
		<td><%=rs.getString("origin_name")%></td>
		<td><%=rs.getString("destination_name")%></td>
		<td><%=timeFormat.format(rs.getTimestamp("departure_datetime"))%></td>
		<td><%=timeFormat.format(rs.getTimestamp("arrival_datetime"))%></td>
		<td>$<%=String.format("%.02f", rs.getFloat("fare"))%></td>
		<%
		}
		
		// Close connection
		con.close();
		
	} catch (Exception ex) {
		out.print(ex);
	}
	%>
	</tr>
</table>
<table><tr>
	<td><form method="get" action="RepHome.jsp"><input type="submit" value="Back"></form></td>
	<td><form method="get" action="RepQ&A.jsp"><input type="submit" value="Q&A"></form></td>
</tr></table>
</body>
</html>