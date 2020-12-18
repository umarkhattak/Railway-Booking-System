<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Questions and Answers</title>
</head>
<h1>Questions and Answers</h1>
<body>

<%
session.removeAttribute("admin");
session.removeAttribute("rep");
if (session.getAttribute("customer") == null) {
	response.sendRedirect("CustomerLogin.jsp");
}

//Get request information
String question = "";
if (request.getParameter("question") != null) {
	question = request.getParameter("question");
}
%>

<table>
	<tr>
		<td>Search for Questions</td>
	</tr>
	<tr>
		<form method="post" action="CustomerQ&A.jsp">
			<td><input type="text" name="question" value="<%=question%>"></td>
			<td><input type="submit" value="Search"></td>
		</form>
		<form method="post" action="AskQuestion.jsp">
			<td><input type="submit" value="Ask a Question"></td>
		</form>
	</tr>
</table>
<br>
<table border=1>
	<tr>
		<th>Question</th>
		<th>Answer</th>
	</tr>

	<%
	try {
		// SQL preparation
		ApplicationDB db = new ApplicationDB();	
		Connection con = db.getConnection();
		Statement stmt = con.createStatement();
		
		// Write the SQL statement
		String query = "SELECT * FROM Questions WHERE question LIKE ? ORDER BY questionID DESC";		
		PreparedStatement ps = con.prepareStatement(query);
		
		// Inject parameters
		if (question != null && !question.equals("")) {
			ps.setString(1, "%" + question + "%");
		} else {
			ps.setString(1, "%");
		}
		
		// Execute statement
		ResultSet rs = ps.executeQuery();
		
		// Output results
		while (rs.next()) {
	%>

	<tr>
		<td><%=rs.getString("question")%></td>
		<%if (rs.getBoolean("response")) {%>
			<td><%=rs.getString("answer")%></td>
		<%} else {%>
			<td>This question has not been answered</td>
		<%}%>
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
<table><tr><td><form method="get" action="CustomerHome.jsp"><input type="submit" value="Home"></form></td></tr></table>

</body>
</html>