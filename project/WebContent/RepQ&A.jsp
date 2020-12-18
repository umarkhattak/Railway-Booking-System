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
session.removeAttribute("customer");
session.removeAttribute("admin");
if (session.getAttribute("rep") == null) {
	response.sendRedirect("RepLogin.jsp");
}

//Get request information
String question = "";
if (request.getParameter("question") != null) {
	question = request.getParameter("question");
}
%>

<form method="post" action="RepQ&A.jsp">
	<table>
		<tr>
			<td>Search for Questions</td>
		</tr>
		<tr>
			<td><input type="text" name="question" value="<%=question%>"></td>
			<td><input type="submit" value="Search"></td>
		</tr>
	</table>
</form>
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
			<td><form method="post" action="AnswerQuestion.jsp">
				<input type="hidden" name="questionID" value=<%=rs.getInt("questionID")%>>
				<input type="hidden" name="question" value="<%=rs.getString("question")%>">
				<input type="hidden" name="return" value="TrainSchedule.jsp">
				<input type="submit" value="Answer Question">
			</form></td>
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
<table><tr>
	<td><form method="get" action="RepHome.jsp"><input type="submit" value="Home"></form></td>
</tr></table>

</body>
</html>