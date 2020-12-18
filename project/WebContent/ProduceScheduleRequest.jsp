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

java.util.Date fromDate = null;
if (request.getParameter("fromDate") == null) {
	response.sendRedirect("AdminHome.jsp");
} else {
	fromDate = htmlDate.parse(request.getParameter("fromDate"));
}

java.util.Date toDate = null;
if (request.getParameter("toDate") == null) {
	response.sendRedirect("AdminHome.jsp");
} else {
	toDate = htmlDate.parse(request.getParameter("toDate"));
}

int affectedRows = 0;

try {
	
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();
	
	// Write the SQL statement
	String query = "SELECT DISTINCT route_name FROM Route";		
	PreparedStatement qps = con.prepareStatement(query);
	
	while (fromDate.before(toDate) || fromDate.equals(toDate)) {
		
		// Execute statement
		ResultSet rs = qps.executeQuery();
		
		int trainID = 1;
		int trainUses = 0;
		while (rs.next()) {
			
			// Write the SQL statement
			String update = "INSERT INTO Schedule (route_name, train, departure_datetime) VALUES (?, ?, ?), (?, ?, ?)";
			PreparedStatement ups = con.prepareStatement(update);
			
			if (trainUses == 5) {
				trainID += 1;
				trainUses = 0;
			}
			
			// Inject parameters
			ups.setString(1, rs.getString("route_name"));
			ups.setInt(2, trainID);
			ups.setString(3, htmlDate.format(fromDate) + " 6:30:00");
			ups.setString(4, rs.getString("route_name"));
			ups.setInt(5, trainID);
			ups.setString(6, htmlDate.format(fromDate) + " 17:30:00");
			
			// Execute statement
			affectedRows += ups.executeUpdate();
			
			trainUses += 1;
		}
		
		Calendar c = Calendar.getInstance();
        c.setTime(fromDate);
        c.add(Calendar.DATE, 1);
        fromDate = c.getTime();
	}
	
} catch (Exception ex) {
	out.print(ex);
}
%>
<table><tr><td><%=affectedRows%> train schedules were added to the database</td></tr></table>
<form method="get" action="AdminHome.jsp">
	<table><tr><td><input type="submit" value="Back"></td></tr></table>
</form>

</body>
</html>