<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Customer by Transit Line</title>
</head>
<h1>Customers by Transit Line</h1>
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
String route = "";
if (request.getParameter("route_name") != null) {
	route = request.getParameter("route_name");
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

<form method="post" action="RouteCustomers.jsp">
	<table>
		<tr>
			<td>Date</td>
			<td>Transit Line</td>
		</tr>
		<tr>		
			<td><input type="date" name="date" value=<%=htmlDate.format(day)%>></td>
			<td><input type="text" name="route_name" value="<%=route%>"></td>
			<td><input type="submit" value="Search"></td>
		</tr>
	</table>
</form>
<form method="get" action="TransitLines.jsp">
	<table>
		<tr>
			<td><input type="hidden" name="date" value=<%=htmlDate.format(day)%>></td>
			<td><input type="submit" value="View all Transit Lines"></td>
		</tr>
	</table>
</form>
<br>


<%
if (route.equals("") || route == null) {%>
	<table><tr><td>Enter a transit line to see customers</td></tr></table>
<%} else {
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT DISTINCT passenger FROM Reservation WHERE route_name = ? AND reservation_datetime > ? AND reservation_datetime < ?";		
		PreparedStatement ps = con.prepareStatement(query);
			
		// Inject parameters
		ps.setString(1, route);
		ps.setString(2, sqlDate.format(day));
		ps.setString(3, sqlDate.format(nextDay));
			
		// Execute statement
		ResultSet rs = ps.executeQuery();
			
		if (rs.isBeforeFirst()) {
%>
<table border=1>
	<tr>
		<th>Customers</th>
	</tr>
		<%	// Output results
			while (rs.next()) {
		%>
	<tr>
		<td><%=rs.getString("passenger")%></td>
	</tr>
		<%
			}%>
</table>	
		<%	
		} else {
			query = "SELECT * FROM Route WHERE route_name = ?";		
			ps = con.prepareStatement(query);
						
			// Inject parameters
			ps.setString(1, route);
			
			// Execute statement
			rs = ps.executeQuery();
			
			if (rs.isBeforeFirst()) {%>
				<table><tr><td>There are no customers for on this transit line for the given date</td></tr></table>
			<%} else {%>
				<table><tr><td>The transit line you entered does not exist</td></tr></table>
			<%}
		}
				
		// Close connection
		con.close();
			
	} catch (Exception ex) {
		out.print(ex);
	}
}
%>
<table><tr>
	<td><form method="get" action="RepHome.jsp"><input type="submit" value="Back"></form></td>
	<td><form method="get" action="RepQ&A.jsp"><input type="submit" value="Q&A"></form></td>
</tr></table>
</body>
</html>