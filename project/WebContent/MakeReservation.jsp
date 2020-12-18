<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.text.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
<head>
	<meta charset="ISO-8859-1">
	<title>Make Reservation</title>
</head>
<body>
<table>
	<tr>
		<td>
<%
session.removeAttribute("admin");
session.removeAttribute("rep");
if (session.getAttribute("customer") == null) {
	response.sendRedirect("CustomerLogin.jsp");
}

String customer = (String)session.getAttribute("customer");
float fare = Float.parseFloat(request.getParameter("fare"));
	
try {
	// SQL preparation
	ApplicationDB db = new ApplicationDB();
	Connection con = db.getConnection();
	Statement stmt = con.createStatement();

	// Write the SQL statement
	String query = "SELECT reservation_num, route_name, reservation_datetime, fare FROM " +
	"Reservation WHERE passenger = ? AND reservation_datetime = ?";
	PreparedStatement ps = con.prepareStatement(query);

	// Inject parameters
	ps.setString(1, customer);
	ps.setString(2, request.getParameter("departure_datetime"));
		
	// Execute statement
	ResultSet rs = ps.executeQuery();
	
	boolean reservationExists = false;
	while(rs.next()) {
		reservationExists = !rs.wasNull();
	}
	if (!reservationExists) {
		// Write the SQL statement
		query = "SELECT age, disabled FROM Customer WHERE username = ?";
		ps = con.prepareStatement(query);
		
		// Inject parameters
		ps.setString(1, customer);
		
		// Execute statement
		rs = ps.executeQuery();
		
		int age = 18;
		boolean disabled = false;
		while(rs.next()) {
			age = rs.getInt("age");
			disabled = rs.getBoolean("disabled");
		}
		
		float discount = 1;
		if (disabled) {
			discount -= 0.50;
		} else {
			if (age < 18) {
				discount -= 0.25;
			} else if (age > 65) {
				discount -= 0.35;
			}
		}
		
		// Write the SQL statement
		String update = "INSERT INTO Reservation (passenger, route_name, reservation_datetime, fare) VALUES (?, ?, ?, ?)";
		ps = con.prepareStatement(update);
			
		// Inject parameters
		ps.setString(1, customer);
		ps.setString(2, request.getParameter("route_name"));
		ps.setString(3, request.getParameter("departure_datetime"));
		ps.setFloat(4, (fare * discount));
			
		// Execute statement
		int affectedRows = ps.executeUpdate();
			
		//Check success of the statement
		if (affectedRows == 1) {
			out.print("Reservation Made");
		} else if (affectedRows < 1) {
			out.print("Something went wrong: Unable to create reservation");
		} else {
			out.print("Something went wrong: Contact an administrator");
		}
	} else {
		out.print("This reservation was already made");
	}
	
	// Close connection
	con.close();
	
} catch (Exception ex) {
	out.print(ex);
}
%>
		</td>
	</tr>
</table>
<table>
	<tr>
		<td>
			<form method="post" action="TrainSchedule.jsp">
				<input type="submit" value="Back to Train Schedule">
			</form>
		</td>
		<td>
			<form method="get" action="CustomerHome.jsp">
				<input type="submit" value="Back to Home">
			</form>
		</td>
		<td>
			<form method="get" action="CustomerQ&A.jsp">
				<input type="submit" value="Q&A">
			</form>
		</td>
	</tr>
</table>

</body>
</html>