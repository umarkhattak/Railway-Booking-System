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

//Get request information
java.util.Date departure = sqlDate.parse(request.getParameter("departure"));
Calendar c = Calendar.getInstance();
c.setTime(departure);
c.set(Calendar.HOUR_OF_DAY, 0);
c.set(Calendar.MINUTE, 0);
c.set(Calendar.SECOND, 0);
Calendar temp = Calendar.getInstance();
java.util.Date day = c.getTime();
c.add(Calendar.DATE, 1);
java.util.Date nextDay = c.getTime();

int edited = 0;
java.util.Date restrictStart = null;
java.util.Date restrictEnd = null;

try {
	
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();
	
	// Write the SQL statement
	String query = "SELECT DATE_SUB(departure_datetime, INTERVAL 300 MINUTE) AS start, departure_datetime, DATE_ADD(departure_datetime, INTERVAL 300 MINUTE) AS end FROM Schedule WHERE route_name = ? AND train = ? AND departure_datetime > ? AND departure_datetime < ? AND departure_datetime != ?";
	PreparedStatement ps = con.prepareStatement(query);
	
	// Inject parameters
	ps.setString(1, request.getParameter("route_name"));
	ps.setInt(2, Integer.parseInt(request.getParameter("trainID")));
	ps.setString(3, sqlDate.format(day));
	ps.setString(4, sqlDate.format(nextDay));
	ps.setString(5, sqlDate.format(departure));
		
	// Execute statement
	ResultSet rs = ps.executeQuery();
	
	while(rs.next()) {
		restrictStart = sqlDate.parse(sqlDate.format(rs.getTimestamp("start")));
		restrictEnd = sqlDate.parse(sqlDate.format(rs.getTimestamp("end")));
	}
	
	// Close connection
	con.close();
	
} catch (Exception ex) {
	out.print(ex);
}
%>

<form method="post" action="EditScheduleRequest.jsp">
	<table>
		<tr>
			<td>
				<%if (restrictStart != null && restrictEnd != null) {%>
					<b>Select a new departure time before <%=timeFormat.format(restrictStart)%> or after <%=timeFormat.format(restrictEnd)%></b>
				<%} else {%>
				<b>Select a new departure time</b>
				<%}%>
			</td>
		</tr>
		<tr>
			<td>
				<input type="time" name="departureTime" required>
			</td>
		</tr>
		<tr>
			<td>
			<input type="hidden" name="route_name" value="<%=request.getParameter("route_name")%>">
				<input type="hidden" name="trainID" value="<%=request.getParameter("trainID")%>">
				<input type="hidden" name="departure" value="<%=request.getParameter("departure")%>">
				<input type="hidden" name="stops" value="<%=request.getParameter("stops")%>">
				<input type="hidden" name="departureDay" value="<%=htmlDate.format(day)%>">
				<input type="submit" value="Edit Schedule">
			</td>
		</tr>
	</table>
</form>

<form method="post" action="DeleteSchedule.jsp">
	<table><tr><td>
		<input type="hidden" name="route_name" value="<%=request.getParameter("route_name")%>">
		<input type="hidden" name="trainID" value="<%=request.getParameter("trainID")%>">
		<input type="hidden" name="departure" value="<%=request.getParameter("departure")%>">
		<input type="hidden" name="stops" value="<%=request.getParameter("stops")%>">
		<input type="submit" value="Delete Schedule">
	</td></tr></table>
</form>

<form method="post" action="RepTrainSchedule.jsp">
	<table><tr><td><input type="submit" value="Back"></td></tr></table>
</form>

</body>
</html>