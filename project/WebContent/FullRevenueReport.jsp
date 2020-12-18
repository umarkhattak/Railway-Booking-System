<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title><%=request.getParameter("title")%></title>
</head>
<h1><%=request.getParameter("title")%></h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}

//Get request information
String sortBy = request.getParameter("sortReport");
String otherSort = "";
String otherSortText = "";
if (sortBy.equals("route_name")) {
	otherSort = "passenger";
	otherSortText = "Customer";
} else {
	otherSort = "route_name";
	otherSortText = "Transit Line";
}
%>

<table>
	<tr>
		<td>
			<form method="post" action="FullRevenueReport.jsp">
				<input type="hidden" name="sortReport" value="<%=otherSort%>">
				<input type="submit" name="title" value="Full Revenue Report for <%=otherSortText%>s">
			</form>
		</td>
	</tr>
</table>
<br>
<table border=1>
	<tr>
		<% if (sortBy.equals("route_name")) { %>
			<th>Route</th>
		<% } else { %>
			<th>Customer</th>
		<% } %>
		<th>Revenue</th>
	</tr>
	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT " + sortBy + ", ROUND(SUM(fare), 2) as revenue FROM Reservation GROUP BY " + sortBy;
		PreparedStatement ps = con.prepareStatement(query);

		// Execute statement
		ResultSet rs = ps.executeQuery();
		
		// Output results
		while (rs.next()) {
	%>
	<tr>
		<% if (sortBy.equals("route_name")) { %>
			<td><%=rs.getString("route_name")%></td>
		<% } else { %>
			<td><%=rs.getString("passenger")%></td>
		<% } %>
		<td>$<%=String.format("%.02f", rs.getFloat("revenue"))%></td>
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
<table><tr><td><form method="get" action="RevenueAndReservations.jsp"><input type="submit" value="Back"></form></td></tr></table>

</body>
</html>