<%@ page
	import="com.estudent.dao.InstructorDAO, com.estudent.model.InstructorTeachesCourse, 
	com.estudent.model.Message, com.estudent.model.Instructor, com.estudent.model.Grade, 
	com.estudent.exceptions.ForbiddenAccessException, com.estudent.model.Course, java.util.List"%>

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
<title>eStudent - Καταχωρημένοι βαθμοί</title>
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
	
	// declaration
	int numberOfRows = 8;
	int limit = numberOfRows;
	int offset = limit - numberOfRows;
	int studentsCount, pageNo;
	
	String course_id;
	List<Grade> grades = null;
	
	Instructor logged_in_instructor = (Instructor) session.getAttribute("logged_in_user");

	List<Course> teachesCourses = conn.getTeachesCourses(logged_in_instructor.getAfm());
	
		// trying to get the pageNo attribute
		try {
			pageNo = Integer.parseInt(request.getParameter("pageNo"));
			pageNo = pageNo <= 0 ? 1 : pageNo;

		} catch (Exception e){
			pageNo = 1;
		}
	
		// trying to get the course_id attribute
		try {
			course_id = request.getParameter("course_id");
			
		} catch (Exception e){
			System.out.println("Error on course_id attribute");
			course_id = null;
			
		}

		studentsCount = conn.getCourseGradesCount(course_id);
		
		offset = (pageNo * numberOfRows) - numberOfRows;
		grades = conn.getCourseGradesByLimiting(course_id, offset, limit);
		
	%>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/instructor-header.jsp" />


	<div class="container mt-5">
		<div class="form-floating">
			<select
				onchange="window.location.replace('all-grades.jsp?course_id='+this.value);"
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
			if (session.getAttribute("all_grades_alert") != null) {
				Message alert = (Message) session.getAttribute("all_grades_alert");
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
			session.removeAttribute("all_grades_alert");
			%>
	
	
	
	<div class="card container custom-container mt-3 mb-5 shadow-sm p-5 bg-body rounded"
		style="height: 75vh">
		
		<%if (course_id != null){ %>
		<div class="row">
			<h3><b>ΚΑΤΑΛΟΓΟΣ ΒΑΘΜΩΝ</b></h3>
			<p>Προβάλετε τους βαθμούς των φοιτητών για το μάθημα <%= course_id %></p>
		</div>
		
		<%if (!grades.isEmpty()){ %>
		<div class="row">
		<table class="table table-hover mt-4">
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
				<%for (Grade grade : grades){ %>
				<tr>
					<td class="col-center-vert"><%= grade.getStudentsRegistrationId() %></td>
					<td class="col-center-full" style="font-size: 20px"><%= grade.getAssignmentGrade() %></td>
					<td class="col-center-full" style="font-size: 20px"><%= grade.getExamGrade() %></td>
					<td class="col-center-full" style="font-size: 20px"><%= grade.getFinalGrade() %></td>
					<td style="text-align:center;"><button class="btn btn-light edit-btn">Επεξεργασία</button></td>
				</tr>
				<%} %>
			</tbody>
		</table>
		
		<div class="row">
			<%if (studentsCount > numberOfRows){ %>
			<div class="col">
				<ul class="pagination">
					<%
					for (int i = 1; i - 1 < Math.ceil((float) studentsCount / (float) numberOfRows); i++) {
					%>
					<li class="page-item"><a
						class="page-link <%=pageNo == i ? "active" : ""%>"
						href="<%=request.getContextPath()%>/instructor/grades/all-grades.jsp?course_id=<%= course_id %>&pageNo=<%=i%>"><%=i%></a></li>
					<%
					}
					%>

				</ul>
			</div>
			<%} %>
			<div class="col" style="text-align: right;">
				<b>Σύνολο φοιτητών: <%=studentsCount%></b>
			</div>
		</div>
	
		
		<%} else{ %>
		<div class="alert alert-warning" role="alert">Δεν υπάρχουν καταχωρημένοι βαθμοί για το συγκεκριμένο μάθημα.</div>
		<%} %>
		</div>
	<%} else{ %>
		<div class="alert alert-warning" role="alert">Επιλέξτε κάποιο μάθημα για την προβολή βαθμών.</div>
	<%}%>

</div>



<!-- Edit Modal -->
	<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Επεξεργασία Βαθμού</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="<%=request.getContextPath()%>/instructor?action=update-grade" method="POST">
					<div style="padding: 35px;" class="modal-body">
					
							<input type="hidden" class="form-control" name="registration_id" id="amEdit">
							<input type="hidden" class="form-control" name="course_id" value="<%= course_id %>">

						<div class="mb-2">
							<label for="assignmentGradeEdit" class="form-label">Βαθμός εργασίας</label>
							<input type="number" id="assignmentGradeEdit" name="assignment_grade" class="form-control" value="0" min="0" max="10">
						</div>

						<div class="mb-2">
							<label for="examGradeEdit" class="form-label">Βαθμός γραπτού</label>
							<input type="number" id="examGradeEdit" name="exam_grade" class="form-control" value="0" min="0" max="10">
						</div>

						<div class="mb-2">
							<label for="finalGradeEdit" class="form-label">Τελικός βαθμός</label>
							<input type="number" id="finalGradeEdit" name="final_grade" class="form-control" value="0" min="0" max="10">
						</div>

						
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Άκυρο</button>
						<button type="submit" class="btn btn-success">Αποθήκευση</button>
					</div>
				</form>
			</div>
		</div>
	</div>
	
	
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
		<script>
		$(document).ready(function() {
			$('.edit-btn').on('click', function() {
				$('#editModal').modal('show');

				$tr = $(this).closest('tr');

				var data = $tr.children("td").map(function() {
					return $(this).text();
				}).get();
				
				$('#amEdit').val(data[0]);
				$('#assignmentGradeEdit').val(data[1]);
				$('#examGradeEdit').val(data[2]);
				$('#finalGradeEdit').val(data[3]);
				console.log(data);
			});

		});
	</script>
	
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>