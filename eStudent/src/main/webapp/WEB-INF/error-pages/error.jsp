<%@ page import="com.estudent.exceptions.ForbiddenAccessException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isErrorPage="true"%>

<%
// removes page caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Error</title>

<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet">

<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css'
	rel='stylesheet'>

</head>
<body>

<%if(exception instanceof ForbiddenAccessException){ %>
	<div class="container mt-5" style="text-align: center;">
		<i style="font-size: 50px" class='bx bxs-lock-alt'></i>
		<h1>Access Denied</h1>
		<p><%=exception.getMessage()%></p>
		<a href="<%= request.getContextPath() %>/index.jsp" class="link-secondary">Πίσω στην αρχική</a>
	</div>
<%}else if(exception instanceof Exception){ %>
<div class="container mt-5" style="text-align: center;">
		<h1>Sorry, an Error occurred.</h1>
		<p><%=exception.getMessage()%></p>
		<a href="../index.jsp" class="link-secondary">Πίσω στην αρχική</a>
	</div>
<%}else{ %>
<div class="container mt-5" style="text-align: center;">
		<i style="font-size: 50px" class='bx bxs-sad'></i>
		<h1>Error 404</h1>
		<p>Η σελίδα αυτή δεν υπάρχει.<br>Πιστεύετε συνέβη κάποιο λάθος; Αν ναι, παρακαλούμε ενημερώστε μας.</p>
		<a href="<%= request.getContextPath() %>/index.jsp" class="link-secondary">Πίσω στην αρχική</a>
	</div>
<%} %>
</body>
</html>