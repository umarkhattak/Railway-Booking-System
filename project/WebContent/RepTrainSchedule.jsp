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
	response.sendRedirect("RepHome.jsp");
}

java.util.Date today = new java.util.Date();
SimpleDateFormat htmlDate = new SimpleDateFormat("yyyy-MM-dd");
SimpleDateFormat sqlDate = new SimpleDateFormat("yyy-MM-dd HH:mm:ss");
SimpleDateFormat dateFormat = new SimpleDateFormat("EEEE, MMMM d, yyyy");
SimpleDateFormat timeFormat = new SimpleDateFormat("h:mm a");

//Get request information
String origin = "";
if (request.getParameter("origin") != null) {
	origin = request.getParameter("origin");
}
String destination = "";
if (request.getParameter("destination") != null) {
	destination = request.getParameter("destination");
}
String sortBy = "";
if (request.getParameter("sortBy") != null) {
	sortBy = request.getParameter("sortBy");
} else {
	sortBy = "departure_datetime";
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

<form method="post" action="RepTrainSchedule.jsp">
	<table>
		<tr>
			<td>Reservation Date</td>
			<td><input type="date" name="date" value=<%=htmlDate.format(day)%> min=<%=htmlDate.format(today)%>></td>
			<td>Sort By</td>
			<td>
				<select name="sortBy"><%
					if (sortBy.equals("arrival_datetime")) {
						%><option value="departure_datetime">Departure Time</option>
						<option selected value="arrival_datetime">Arrival Time</option>
						<option value="fare">Fare</option><%
					} else if (sortBy.equals("fare")) {
						%><option value="departure_datetime">Departure Time</option>
						<option selected value="arrival_datetime">Arrival Time</option>
						<option selected value="fare">Fare</option><%
					} else {
						%><option selected value="departure_datetime">Departure Time</option>
						<option value="arrival_datetime">Arrival Time</option>
						<option value="fare">Fare</option><%
					}
				%></select>
			</td>
		</tr>
	</table>
	<br>
	<table>
		<tr>
			<td>Origin</td>
			<td>Destination</td>
		</tr>
		<tr>
			<td><input type="text" name="origin" value="<%=origin%>"></td>
			<td><input type="text" name="destination" value="<%=destination%>"></td>
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
		<th>View Details</th>
		<th>Edit</th>
		<th>Delete</th>
	</tr>

	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT * FROM (SELECT route, trainID, stops, train, origin_name, CONCAT(name, ', ', city, ' ', state) AS destination_name, departure_datetime, arrival_datetime, fare " +
		"FROM (SELECT Schedule.route_name AS route, trainID, stops, Train.information AS train, CONCAT(name, ', ', city, ' ', state) AS origin_name, destination, departure_datetime, DATE_ADD(departure_datetime, INTERVAL travel_time MINUTE) AS arrival_datetime, fare " +
		"FROM Schedule LEFT JOIN Route ON Schedule.route_name = Route.route_name LEFT JOIN Train ON Schedule.train = Train.trainID LEFT JOIN Station ON Route.origin = Station.stationID) Query1 LEFT JOIN Station ON Query1.destination = Station.StationID) Query1 " +
		"WHERE origin_name LIKE ? AND destination_name LIKE ? AND departure_datetime > ? AND departure_datetime < ? ORDER BY " + sortBy;		
		PreparedStatement ps = con.prepareStatement(query);
		
		// Inject parameters
		if (origin != null && !origin.equals("")) {
			ps.setString(1, "%" + origin + "%");
		} else {
			ps.setString(1, "%");
		}
		if (destination != null && !destination.equals("")) {
			ps.setString(2, "%" + destination + "%");
		} else {
			ps.setString(2, "%");
		}
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
		<td>
			<form method="post" action="RouteDetails.jsp">
				<input type="hidden" name="date" value=<%=htmlDate.format(day)%>>
				<input type="hidden" name="sortBy" value="<%=sortBy%>">
				<input type="hidden" name="origin" value="<%=origin%>">
				<input type="hidden" name="destination" value="<%=destination%>">
				<input type="hidden" name="return" value="RepTrainSchedule.jsp">
				<input type="hidden" name="route_name" value="<%=rs.getString("route")%>">
				<input type="submit" value="View Details">
			</form>
		</td>
		<td>
			<form method="post" action="EditSchedule.jsp">
				<input type="hidden" name="route_name" value="<%=rs.getString("route")%>">
				<input type="hidden" name="trainID" value="<%=rs.getString("trainID")%>">
				<input type="hidden" name="departure" value="<%=sqlDate.format(rs.getTimestamp("departure_datetime"))%>">
				<input type="hidden" name="stops" value="<%=rs.getInt("stops")%>">
				<input type="submit" value="Edit">
			</form>
		</td>
		<td>
			<form method="post" action="DeleteSchedule.jsp">
				<input type="hidden" name="route_name" value="<%=rs.getString("route")%>">
				<input type="hidden" name="trainID" value="<%=rs.getString("trainID")%>">
				<input type="hidden" name="departure" value="<%=sqlDate.format(rs.getTimestamp("departure_datetime"))%>">
				<input type="hidden" name="stops" value="<%=rs.getInt("stops")%>">
				<input type="submit" value="Delete">
			</form>
		</td>
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