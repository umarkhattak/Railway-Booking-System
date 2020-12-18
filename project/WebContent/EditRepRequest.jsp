<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Edit Customer Representative</title>
</head>
<h1>Edit Customer Representative</h1>
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

String ssn = request.getParameter("ssn1") + "-" + request.getParameter("ssn2") + "-" + request.getParameter("ssn3");
String firstName = request.getParameter("fname");
String lastName = request.getParameter("lname");
String emailAddress = request.getParameter("email");
String username = request.getParameter("username");
String password = request.getParameter("password");

try {
	
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String update = "UPDATE Representative SET ssn = ?, firstName = ?, lastName = ?, emailAddress = ? WHERE username = ? AND password = ?";
	PreparedStatement ps = con.prepareStatement(update);
			
	// Inject parameters
	ps.setString(1, ssn);
	ps.setString(2, firstName);
	ps.setString(3, lastName);
	ps.setString(4, emailAddress);
	ps.setString(5, username);
	ps.setString(6, password);
		
	// Execute statement
	ps.executeUpdate();
		
	// Close connection
	con.close();
	
	out.print("Account edited!");


} catch (Exception ex) {
	out.print("Account edit failed");
}
%>
		</td>
	</tr>
	<tr>
		<td>
			<form method="get" action="EditRep.jsp">
				<input type="submit" value="Back">
			</form>
		</td>
		<td>
			<form method="get" action="AdminHome.jsp">
				<input type="submit" value="Home">
			</form>
		</td>
	</tr>
</table>

</body>
</html>