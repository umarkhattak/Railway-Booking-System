<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Remove Customer Representative Account</title>
</head>
<body>
<table>
	<tr>
		<td>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}

try {

	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String update = "DELETE FROM Representative WHERE ssn = ?";
	PreparedStatement ps = con.prepareStatement(update);
		
	// Inject parameters
	ps.setString(1, request.getParameter("ssn"));
	
	// Execute statement
	int affectedRows = ps.executeUpdate();
		
	//Check success of the statement
	if (affectedRows == 1) {
		out.print("Customer Representative Deleted");
	} else if (affectedRows < 1) {
		out.print("Something went wrong: Could not delete this reservation");
	}
	
	// Close connection
	con.close();

} catch (Exception ex) {
	out.print(ex);
}
%>
		</td>
	</tr>
	<tr>
		<td>
			<form method="get" action="EditRep.jsp">
				<input type="submit" value="Back to Customer Representatives">
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<form method="get" action="AdminHome.jsp">
				<input type="submit" value="Home">
			</form>
		</td>
	</tr>
</table>

</body>
</html>