<%@page
	import="com.estudent.model.StringCodes, com.estudent.model.Secretary"%>
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
<!doctype html>
<html lang="en">
<head>
<title>eStudent - Αρχική</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

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
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css"/>
<!-- End of Custom CSS -->

</head>
<body>
	<%
	switch (logged_in_user_role) {
	case "Student":
	%>
	<jsp:include page="WEB-INF/headers-jsp/student-header.jsp" />
	<%
	break;
	case "Instructor":
	%>
	<jsp:include page="WEB-INF/headers-jsp/instructor-header.jsp" />
	<%
	break;
	case "Secretary":
	%>
	<jsp:include page="WEB-INF/headers-jsp/secretary-header.jsp" />
	<%
	break;
	}
	%>

	<div class="container custom-container mt-5 shadow p-5 mb-5 bg-body rounded">
	<div class="row text-center mb-5">
	<h2> Καλώς ορίσατε στην πλατφόρμα <strong style="color:#0d6efd">eStudent</strong>! </h2>
	</div>
		<div class="row">
			<div class="col">
				<div class="card mb-3" style="width: 18rem;">
					<div class="card-body">
						<h5 class="card-title">Παραστάσεις της θεατρικής ομάδας του
							Πανεπιστημίου Πειραιώς</h5>
						<p class="card-text">Η παράσταση της Διδώς Σωτηρίου σε
							σκηνοθεσία Αποστόλη Ψαρρού θα παρουσιαστεί...</p>
						<a href="#" class="btn btn-primary">Περισσότερα</a>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="card" style="width: 18rem;">
					<div class="card-body">
						<h5 class="card-title">Ορκωμοσία Αποφοίτων Τμήματος
							Πληροφορικής</h5>
						<p class="card-text">Γίνεται γνωστό ότι η ορκωμοσία των
							αποφοίτων του Τμήματος Πληροφορικής της Σχολής Τεχνολογιών
							Πληροφορικής...</p>
						<a href="#" class="btn btn-primary">Περισσότερα</a>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="card" style="width: 18rem;">
					<div class="card-body">
						<h5 class="card-title">Εκδήλωση AIESEC Πανεπιστημίου Πειραιώς</h5>
						<p class="card-text">Το πάθος, η καινοτομία, η κριτική σκέψη
							και πολλά άλλα θα συζητηθούν στο Event από τους ομιλητές μας...</p>
						<a href="#" class="btn btn-primary">Περισσότερα</a>
					</div>
				</div>
			</div>
			<div class="col">
				<div class="card" style="width: 18rem;">
					<div class="card-body">
						<h5 class="card-title">Ημερίδα Ενημέρωσης για το Erasmus+ για
							Σπουδές</h5>
						<p class="card-text">Παρακαλούνται οι φοιτητές όλων των
							Τμημάτων οι οποίοι ενδιαφέρονται να ενημερωθούν για το Πρόγραμμα
							Erasmus +...</p>
						<a href="#" class="btn btn-primary">Περισσότερα</a>
					</div>
				</div>
			</div>
		</div>
	</div>

	
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js"></script>

	<!-- Footer -->
	<jsp:include page="WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>