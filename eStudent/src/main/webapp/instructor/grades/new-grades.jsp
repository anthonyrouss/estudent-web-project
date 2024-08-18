<%@ page
	import="com.estudent.dao.InstructorDAO, com.estudent.model.InstructorTeachesCourse, 
	com.estudent.model.Message, com.estudent.model.Instructor, com.estudent.model.Course, 
	com.estudent.exceptions.ForbiddenAccessException, java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/WEB-INF/error-pages/error.jsp"%>

<%!InstructorDAO conn = new InstructorDAO();%>

<%
// removes page caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies

// guard branches for non direct access to this page
if (session.getAttribute("logged_in_user") == null) {
	response.sendRedirect(request.getContextPath() + "/index.jsp");
}

if (session.getAttribute("logged_in_user_role") != null) {
	if (!(session.getAttribute("logged_in_user_role").equals("Instructor"))) {
		throw new ForbiddenAccessException();
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>eStudent - Λίστες προς βαθμολόγηση</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css">
<link href='https://unpkg.com/boxicons@2.1.2/css/boxicons.min.css'
	rel='stylesheet'>
	
<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css"/>
<!-- End of Custom CSS -->

</head>
<body style="height: 100vh">
	<%
	Instructor logged_in_instructor = (Instructor) session.getAttribute("logged_in_user");

	List<Course> teachesCourses = conn.getTeachesCourses(logged_in_instructor.getAfm());
	List<String> students = null;
	
	String course_id;

	try {
		course_id = request.getParameter("course_id");
		students = conn.getNewGradeStudents(course_id);
		
		
	} catch (Exception e) {
		course_id = "";
		System.out.println("Exception");
	}
	%>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/instructor-header.jsp" />


	<div class="container mt-5">
		<div class="form-floating">
			<select
				onchange="window.location.replace('new-grades.jsp?course_id='+this.value);"
				class="form-select w-50" id="floatingSelect"
				aria-label="Floating label select example">
				<option selected disabled value="">Επιλέξτε ένα μάθημα που διδάσκετε...</option>

				<%
				for (Course course : teachesCourses) {
				%>
				<option value="<%=course.getCourseId()%>"
					<%if (course.getCourseId().equalsIgnoreCase(course_id)) out.print("selected");%>><%=course.getTitle()%></option>
				<%
				}
				%>

			</select> <label for="floatingSelect">ΜΑΘΗΜΑ</label>
		</div>
		
		
	</div>
	
	
	
		<%
			if (session.getAttribute("insert_grade_alert") != null) {
				Message alert = (Message) session.getAttribute("insert_grade_alert");
			%>
			<div class="position-absolute bottom-0 end-0" style="z-index: 2;">
				<div
					class="alert <%=alert.getType()%> alert-dismissible fade show mt-3"
					role="alert">
					<%=alert.getText()%>
					<button type="button" class="btn-close" data-bs-dismiss="alert"
						aria-label="Close"></button>
				</div>
			</div>
			<%
			}
			session.removeAttribute("insert_grade_alert");
			%>
	
	
	
	<div class="card container custom-container mt-3 mb-5 shadow-sm p-5 bg-body rounded">
		
		<%if (course_id != null){ %>
		<div class="row">
			<h3><b>ΕΙΣΑΓΩΓΗ ΒΑΘΜΩΝ</b></h3>
			<p>Εισάγετε βαθμούς στους παρακάτω φοιτητές για το μάθημα <%= course_id %></p>
		</div>
		
		
		<%if (!students.isEmpty()){ %>
		<div class="row">
		<table class="table mt-4">
			<thead>
				<tr>
					<th class="col-2">ΑΜ Φοιτητή</th>
					<th class="col col-center-full">Βαθμός εργασίας</th>
					<th class="col col-center-full">Βαθμός γραπτού</th>
					<th class="col col-center-full">Τελικός βαθμός</th>
					<th class="col col-center-full"></th>
				</tr>
			</thead>
			<tbody>
				<%for (String student : students){ %>
				<form action="<%= request.getContextPath() %>/instructor?action=insert-grade" method="POST">
				<tr>
					<th><%= student %>
					<input type="hidden" name="registration_id" value="<%= student %>">
					<input type="hidden" name="course_id" value="<%= course_id %>">
					</th>
					<td class="col-center-vert"><input type="number" name="assignment_grade" value="0" class="form-control grade-input" min="0" max="10"></td>
					<td><input type="number" name="exam_grade" class="form-control grade-input" value="0" min="0" max="10"></td>
					<td><input type="number" name="final_grade" class="form-control grade-input" value="0" min="0" max="10"></td>
					<td style="text-align:center;"><input type="submit" class="btn btn-success" value="Εισαγωγή"></td>
				</tr>
				</form>
				<%} %>
			</tbody>
		</table>
		<%} else{ %>
		<div class="alert alert-warning" role="alert">Δεν υπάρχουν νέες καταχωρήσεις για το συγκεκριμένο μάθημα.</div>
		<%} %>
		</div>
	<%} else{ %>
		<div class="alert alert-warning" role="alert">Επιλέξτε κάποιο μάθημα για την εισαγωγή βαθμών.</div>
	<%}%>
	
	</div>




  
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>