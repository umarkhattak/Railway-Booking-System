<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Customer Representative Login</title>
</head>
<h1>Customer Representative Login</h1>
<body>
<table>
	<tr>
		<td>

<%
if (session.getAttribute("rep") != null) {
	response.sendRedirect("RepHome.jsp");
} else {
	session.removeAttribute("rep");
}
session.removeAttribute("customer");
session.removeAttribute("admin");

String username = request.getParameter("username");
String password = request.getParameter("password");

try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String query = "SELECT * FROM Representative WHERE username = ? AND password = ?";
	PreparedStatement ps = con.prepareStatement(query);

	// Inject parameters
	ps.setString(1, username);
	ps.setString(2, password);
		
	// Execute statement
	ResultSet rs = ps.executeQuery();
	
	boolean loggedIn = false;
	while(rs.next()) {
		loggedIn = !rs.wasNull();
	}
	if (loggedIn) {
		session.setAttribute("rep", username);
		response.sendRedirect("RepHome.jsp");
	} else {
		out.print("Login failed");
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
			<form method="get" action="RepLogin.jsp">
				<input type="submit" value="Back to Login Page">
			</form>
		</td>
	</tr>
</table>

</body>
</html>