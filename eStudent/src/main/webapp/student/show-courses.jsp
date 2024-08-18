
<!-- Java Classes -->
<%@ page
	import="com.estudent.dao.StudentDAO, com.estudent.model.Course, com.estudent.model.StringCodes, 
	java.util.List, java.util.ArrayList, com.estudent.model.Student, com.estudent.exceptions.ForbiddenAccessException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="../WEB-INF/error-pages/error.jsp"%>
<%!StudentDAO conn = new StudentDAO();%>

<%
// removes page caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies

// guard branches for non direct access to this page
if (session.getAttribute("logged_in_user") == null) {
	response.sendRedirect("../index.jsp");
}

if (session.getAttribute("logged_in_user_role") != null) {
	if (!(session.getAttribute("logged_in_user_role").equals("Student"))) {
		throw new ForbiddenAccessException();
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>eStudent - Δήλωση μαθημάτων</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">


<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css">

<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css"/>
<!-- End of Custom CSS -->

</head>
<body>

	<!-- Include header -->
	<jsp:include page="../WEB-INF/headers-jsp/student-header.jsp" />

	<%
	int semester = 1;
	boolean notEnrollmentPeriod = true;
	Student logged_in_student = (Student) session.getAttribute("logged_in_user");
	int id = logged_in_student.getRegistrationId();
	
	if (request.getParameter("semester") != null) {
		semester = Integer.parseInt(request.getParameter("semester"));
	}
	
	List<Course> courses = new ArrayList<>();
	try{
	courses = conn.getCoursesForEnrollement(id, semester);
	}
	catch(Exception e){
		e.printStackTrace();
	}
	%>
	<% if(notEnrollmentPeriod){ %>
	<div class="container mt-2">
	<div class="alert alert-warning mb-3" role="alert">
		<strong>Προσοχή!</strong> Η δήλωση μαθημάτων δεν είναι διαθέσιμη αυτή
		την περίοδο. Για περαιτέρω πληροφορίες, απευθυνθείτε στην γραμματεία.
	</div>
	</div>
	<%} %>
	<div class="card container custom-container mt-3 mb-3 shadow-sm p-5 bg-body rounded">
		<div class="row mb-4">

			<h3><b>ΔΗΛΩΣΗ ΜΑΘΗΜΑΤΩΝ</b></h3>
			<p>Κάνε τη δήλωση του μαθήματος που επιθυμείς παρακάτω</p>
			
		</div>
		
		<div class="row">
		
			<h5>Επίλεξε βάσει εξαμήνου</h5>
			
			<select
				onchange="window.location.replace('show-courses.jsp?semester='+this.value);"
				style="width: 300px; margin-left: 10px" name="semester"
				class="form-select" aria-label="Default select example">
				<option value="1" <%if (semester == 1)
	out.print("selected");%>>1ο
					Εξάμηνο</option>
				<option value="2" <%if (semester == 2)
	out.print("selected");%>>2ο
					Εξάμηνο</option>
				<option value="3" <%if (semester == 3)
	out.print("selected");%>>3ο
					Εξάμηνο</option>
				<option value="4" <%if (semester == 4)
	out.print("selected");%>>4ο
					Εξάμηνο</option>
				<option value="5" <%if (semester == 5)
	out.print("selected");%>>5ο
					Εξάμηνο</option>
				<option value="6" <%if (semester == 6)
	out.print("selected");%>>6ο
					Εξάμηνο</option>
				<option value="7" <%if (semester == 7)
	out.print("selected");%>>7ο
					Εξάμηνο</option>
				<option value="8" <%if (semester == 8)
	out.print("selected");%>>8ο
					Εξάμηνο</option>
			</select>
	</div>
			<form action="../student/assign-student-to-courses" method="POST">
				<table class="table table-stripped mt-5">
					<thead>
						<tr>
							<th class="col">ΤΙΤΛΟΣ</th>
							<th class="col-2 col-center-full">ΕΞΑΜΗΝΟ</th>
							<th class="col-1 col-center-full">ΤΥΠΟΣ</th>
							<th class="col-2 col-center-full">ECTS</th>
							<th class="col-1 col-center-full">ΔΗΛΩΣΗ</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (Course course : courses) {
						%>
						<tr>
							<td><%=course.getTitle()%></td>
							<td class="col-center-full"><%=course.getSemester()%></td>
							<td class="col-center-full"><%=course.getType()%></td>
							<td class="col-center-full"><%=course.getEcts()%></td>
							<td class="col-center-full">
								<input class="form-check-input" type="checkbox" name="selected"
                                       value="<%=course.getCourseId()%>" id="flexCheckDefault"
								<%if(course.isEnrolled() || notEnrollmentPeriod){%> disabled <%} %>>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>

				<input type="submit" class="btn btn-primary" value="Δήλωση" disabled>

			</form>
		</div>


	<script>
		function update() {
			var select = document.getElementById('semester');

			window.location
					.replace("show-courses.jsp?semester=" + select.value);
		}
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js"></script>
	<!-- Footer -->
	<jsp:include page="../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>