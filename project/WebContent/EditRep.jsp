<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>View Customer Representative Information</title>
</head>
<h1>Customer Representative Information</h1>
<body>

<%
session.removeAttribute("customer");
session.removeAttribute("rep");
if (session.getAttribute("admin") == null) {
	response.sendRedirect("AdminLogin.jsp");
}
%>

<table border="1">
	<tr>
		<th>Last Name</th>
		<th>First Name</th>
		<th>Email</th>
		<th>Username</th>
		<th>Password</th>
		<th>SSN</th>
		<th>Edit</th>
		<th>Delete</th>
	</tr>
	<%
	try {

		// SQL preparation
		ApplicationDB db = new ApplicationDB();
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();

		// Write the SQL statement
		String query = "SELECT * FROM Representative";
		PreparedStatement ps = con.prepareStatement(query);

		// Execute statement
		ResultSet rs = ps.executeQuery();

		// Output results
		while (rs.next()) {
	%>
	<tr>
		<td><%=rs.getString("lastName")%></td>
		<td><%=rs.getString("firstName")%></td>
		<td><%=rs.getString("emailAddress")%></td>
		<td><%=rs.getString("username")%></td>
		<td><%=rs.getString("password")%></td>
		<td><%=rs.getString("ssn")%></td>
		<td>
			<form method="post" action="EditCustomerRep.jsp">
				<input type="hidden" name="rep_lname" value="<%=rs.getString("lastName")%>">
				<input type="hidden" name="rep_fname" value="<%=rs.getString("firstName")%>">
				<input type="hidden" name="email" value="<%=rs.getString("emailAddress")%>">
				<input type="hidden" name="ssn" value="<%=rs.getString("ssn")%>">
				<input type="hidden" name="ssn1" value="<%=rs.getString("ssn").substring(0, 3)%>">
				<input type="hidden" name="ssn2" value="<%=rs.getString("ssn").substring(4, 6)%>">
				<input type="hidden" name="ssn3" value="<%=rs.getString("ssn").substring(7, 11)%>">
				<input type="hidden" name="username" value="<%=rs.getString("username")%>">
				<input type="hidden" name="password" value="<%=rs.getString("password")%>">
				<input type="submit" value="Edit">
			</form>
		</td>
		<td>
			<form method="post" action="DeleteCustomerRep.jsp">
				<input type="hidden" name="ssn" value="<%=rs.getString("ssn")%>">
				<input type="submit" value="Delete">
			</form>
		</td>
	<%
		}

		// Close connection
		con.close();

	} catch (Exception ex) {
		out.print(ex);
	}
	%>
	</tr>
</table>

<form method="post" action="CreateRepAccountAsAdmin.jsp">
	<table><tr><td><input type="submit" value="Create New Account"></td></tr></table>
</form>
<table>
	<tr>
		<td><form method="get" action="AdminHome.jsp"><input type="submit" value="Back"></form></td>
	</tr>
</table>

</body>
</html>