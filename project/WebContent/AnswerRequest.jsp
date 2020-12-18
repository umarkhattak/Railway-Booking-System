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
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}

int questionID = Integer.parseInt(request.getParameter("questionID"));
String answer = request.getParameter("answer");

try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String update = "UPDATE Questions SET answer = ?, response = TRUE WHERE questionID = ?";
	PreparedStatement ps = con.prepareStatement(update);
	
	// Inject parameters
	ps.setString(1, answer);
	ps.setInt(2, questionID);
	
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
			<form method="get" action="RepQ&A.jsp">
				<input type="submit" value="Back to Customer Questions">
			</form>
		</td>
		<td>
			<form method="get" action="RepHome.jsp">
				<input type="submit" value="Back to Home">
			</form>
		</td>
	</tr>
</table>

</body>
</html>