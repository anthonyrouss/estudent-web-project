<%@ page import=" com.estudent.model.StringCodes " %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
// removes page caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies

// if the user isn't logged in, redirect to login page
if (session.getAttribute("logged_in_user") == null) {
	session.setAttribute("login_alert", StringCodes.ERROR_LOGIN_ACCESS_DENIED);
	response.sendRedirect("login.jsp");
}

// user has logged in
String logged_in_user_role = "";
if (session.getAttribute("logged_in_user_role") != null) {
	logged_in_user_role = (String) session.getAttribute("logged_in_user_role");
}

%>
<!DOCTYPE html>
<html lang="en">
<head>
<title>Profile</title>
<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css">
<!-- End of Bootstrap CSS -->

<!-- Boxicons -->
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css'
	rel='stylesheet'>
<!-- End of Boxicons -->

<!-- Custom CSS -->
<style>
html {
	height: 100vh;
}

body {
	min-height: 100vh;
}

.progress {
	height: 15px;
	width: 500px;
}

.semester-bar {
	width: 43%;
}

.semester-top-bar {
	width: 59%; position : absolute;
	display: flex;
	top: 18px;
	left: 175px;
	position: absolute;
}

.semester-top-bar .semester {
	width: 35px;
	text-align: center;
	vertical-align: middle;
	background-color: red;
	margin-left: auto;
	margin-right: auto;
	font-size: 15px;
}

.semester-top-bar .graduation i {
	font-size: 18px;
}


</style>
<!-- End of Custom CSS -->

<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/login.css"/>
<!-- End of Custom CSS -->

</head>
<body>

	<%
	switch (logged_in_user_role) {
	case "Student":
	%>
	<jsp:include page="WEB-INF/headers-jsp/student-header.jsp" />
	<jsp:include page="WEB-INF/profiles/student-profile.jsp" />
	<%
	break;
	case "Instructor":
	%>
	<jsp:include page="WEB-INF/headers-jsp/instructor-header.jsp" />
	<jsp:include page="WEB-INF/profiles/instructor-profile.jsp" />
	<%
	break;
	case "Secretary":
	%>
	<jsp:include page="WEB-INF/headers-jsp/secretary-header.jsp" />
	<jsp:include page="WEB-INF/profiles/secretary-profile.jsp" />
	<%
	break;
	}
	%>

	


<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js"></script>

	<!-- Footer -->
	<jsp:include page="WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->

</body>
</html>