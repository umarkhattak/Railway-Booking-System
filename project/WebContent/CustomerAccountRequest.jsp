<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
	<title>Create Customer Account</title>
</head>
<h1>Create Customer Account</h1>
<body>
<table>
	<tr>
		<td>

<%
session.removeAttribute("customer");
session.removeAttribute("admin");
session.removeAttribute("rep");

//Get parameters from the HTML form at the index.jsp
String firstName = request.getParameter("firstName");
String lastName = request.getParameter("lastName");
String emailAddress = request.getParameter("emailAddress");
String username = request.getParameter("username");
String password = request.getParameter("password");
int age = Integer.parseInt(request.getParameter("age"));
boolean disabled = false;
if (request.getParameter("disabled") != null) {
	disabled = true;
}
	
try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();	
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String update = "INSERT INTO Customer(firstName, lastName, emailAddress, username, password, age, disabled)"
			+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
	PreparedStatement ps = con.prepareStatement(update);

	// Inject parameters
	ps.setString(1, firstName);
	ps.setString(2, lastName);
	ps.setString(3, emailAddress);
	ps.setString(4, username);
	ps.setString(5, password);
	ps.setInt(6, age);
	ps.setBoolean(7, disabled);
	
	// Execute statement
	ps.executeUpdate();
	
	// Close connection
	con.close();
	
	out.print("Account created!");
	
} catch (Exception ex) {
	out.print("Account creation failed");
}
%>
		</td>
	</tr>
	<tr>
		<td>
			<form method="get" action="CreateCustomerAccount.jsp">
				<input type="submit" value="Back to Account Creation">
			</form>
		</td>
		<td>
			<form method="get" action="CustomerLogin.jsp">
				<input type="submit" value="Back to Login Page">
			</form>
		</td>
	</tr>
</table>

</body>
</html>