<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Produce Train Schedule</title>
</head>
<h1>Produce Train Schedule</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
} else if (!session.getAttribute("admin").equals("master_admin")) {
	response.sendRedirect("AdminHome.jsp");
}

SimpleDateFormat htmlDate = new SimpleDateFormat("yyyy-MM-dd");

String fromDateStr = null;
java.util.Date fromDate;
java.util.Date today = new java.util.Date();

try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();
	
	// Write the SQL statement
	String query = "SELECT DATE(departure_datetime) as date FROM Schedule ORDER BY departure_datetime DESC LIMIT 1";		
	PreparedStatement ps = con.prepareStatement(query);
	
	// Execute statement
	ResultSet rs = ps.executeQuery();
	
	while (rs.next()) {
		fromDateStr = rs.getString("date");
	}
	
} catch (Exception ex) {
	out.print(ex);
}

if (fromDateStr != null) {
	fromDate = htmlDate.parse(fromDateStr);
} else {
	fromDate = today;
}

Calendar c = Calendar.getInstance();
c.setTime(fromDate);
c.set(Calendar.HOUR_OF_DAY, 0);
c.set(Calendar.MINUTE, 0);
c.set(Calendar.SECOND, 0);
c.add(Calendar.DATE, 1);
fromDate = c.getTime();

if (request.getParameter("fromDate") != null) {
	fromDate = htmlDate.parse(request.getParameter("fromDate"));
}

java.util.Date toDate = null;
if (request.getParameter("toDate") != null) {
	toDate = htmlDate.parse(request.getParameter("toDate"));
} else {
	toDate = fromDate;
}

%>
<form method="post" action="ProduceScheduleRequest.jsp">
	<table>
		<tr>
			<td>From</td>
			<td>To</td>
		</tr>
		<tr>
			<td><input type="date" name="fromDate" value=<%=htmlDate.format(fromDate)%> min=<%=htmlDate.format(fromDate)%>></td>
			<td><input type="date" name="toDate" value=<%=htmlDate.format(toDate)%> min=<%=htmlDate.format(fromDate)%>></td>
		</tr>
		<tr>
			<td><input type="submit" value="Produce Train Schedules"></td>
		</tr>
	</table>
</form>
<br>
<form method="get" action="AdminHome.jsp">
	<table><tr><td><input type="submit" value="Back"></td></tr></table>
</form>

</body>
</html>