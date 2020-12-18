<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Answer Question</title>
</head>
<body>
<%
session.removeAttribute("admin");
session.removeAttribute("rep");
if (session.getAttribute("customer") == null) {
	response.sendRedirect("CustomerLogin.jsp");
}

String question = request.getParameter("question");

try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String update = "INSERT INTO Questions (question) VALUES (?)";
	PreparedStatement ps = con.prepareStatement(update);
	
	// Inject parameters
	ps.setString(1, question);
	
	// Execute statement
	ps.executeUpdate();
	
	// Close connection
	con.close();
	
} catch (Exception ex) {
	out.print(ex);
}
%>
<table>
	<tr>
		<td>
			<form method="get" action="CustomerQ&A.jsp">
				<input type="submit" value="Back to Questions">
			</form>
		</td>
		<td>
			<form method="get" action="CustomerHome.jsp">
				<input type="submit" value="Back to Home">
			</form>
		</td>
	</tr>
</table>

</body>
</html>