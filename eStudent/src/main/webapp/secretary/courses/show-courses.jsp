<%@ page
	import="com.estudent.dao.SecretaryDAO, com.estudent.model.Message, com.estudent.model.Course, com.estudent.exceptions.ForbiddenAccessException, java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/WEB-INF/error-pages/error.jsp"%>

<%!SecretaryDAO conn = new SecretaryDAO();%>

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
	if (!(session.getAttribute("logged_in_user_role").equals("Secretary"))) {
		throw new ForbiddenAccessException();
	}
}
%>

<!DOCTYPE html>
<html>
<head>
<title>eStudent - Κατάλογος Μαθημάτων</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

<meta charset="utf-8">
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
<body>

	<%
	// TODO Add a search by course_id field
	
	int numberOfRows = 10;
	int pageNo = 1;
	int limit = numberOfRows;
	int offset = limit - numberOfRows;

	int coursesCount = conn.getCountOfCourses();

	try {

		if (request.getParameter("pageNo") != null) {
			pageNo = Integer.parseInt(request.getParameter("pageNo"));
			pageNo = pageNo <= 0 ? 1 : pageNo;
		}

		offset = (pageNo * numberOfRows) - numberOfRows;
		
	} catch (Exception e) {
		e.printStackTrace();
	}

	List<Course> courses = conn.getCoursesByLimiting(offset, limit);

	%>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/secretary-header.jsp" />

	<div class="card container custom-container mt-3 mb-3 shadow-sm p-5 bg-body rounded">
	
		<div class="row">
			<h3><b>ΚΑΤΑΛΟΓΟΣ ΜΑΘΗΜΑΤΩΝ</b></h3>
			<p>Διαχειριστείτε όλα τα δεδομένα των μαθημάτων</p>
			
			<button type="button" class="btn btn-primary new-course-btn"
				style="width: 150px;margin-left:1vh">Προσθήκη νέου</button>
		</div>
		
		<div class="row">
			<%
			if (session.getAttribute("all_courses_alert") != null) {
				Message alert = (Message) session.getAttribute("all_courses_alert");
			%>
			<div
				class="alert <%=alert.getType()%> alert-dismissible fade show mt-3"
				role="alert">
				<%=alert.getText()%>
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>

			<%
			}
			session.removeAttribute("all_courses_alert");
			%>

			<table class="table table-hover mt-4">
				<thead>
					<tr>
						<th class="col-1">ΚΩΔΙΚΟΣ</th>
						<th class="col-5">ΤΙΤΛΟΣ</th>
						<th class="col-1 col-center-full">ΕΞΑΜΗΝΟ</th>
						<th class="col-1 col-center-full">ΤΥΠΟΣ</th>
						<th class="col-1 col-center-full">ECTS</th>
						<th class="col-2 col-center-full">ΤΕΛΙΚΗ ΕΞΕΤΑΣΗ</th>
						<th class="col-1 col-center-full" colspan="2">ΕΠΕΞΕΡΓΑΣΙΑ</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (Course course : courses) {
					%>
					<tr>
						<td class="col-center-vert"><%=course.getCourseId()%></td>
						<td class="col-center-vert"><%=course.getTitle()%></td>
						<td class="col-center-full"><%=course.getSemester()%></td>
						<td class="col-center-full"><%=course.getType()%></td>
						<td class="col-center-full"><%=course.getEcts()%></td>
						<td class="col-center-full"><%=course.doesRequireFinalExams() == true ? "Γραπτή εξέταση" : "Απαλλακτική εργασία"%></td>
						<td style="padding-left:10px"><button type="button"
								class="btn btn-secondary edit-btn">
								<i class='bx bxs-edit-alt'></i>
							</button></td>
						<td ><button type="button"
								class="btn btn-danger delete-btn">
								<i class='bx bxs-trash-alt'></i>
							</button></td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<div class="row">
			<%if (coursesCount > numberOfRows){ %>
			<div class="col">
				<ul class="pagination">
					<%
					for (int i = 1; i - 1 < Math.ceil((float) coursesCount / (float) numberOfRows); i++) {
					%>
					<li class="page-item"><a
						class="page-link <%=pageNo == i ? "active" : ""%>"
						href="<%=request.getContextPath()%>/secretary/courses/show-courses.jsp?pageNo=<%=i%>"><%=i%></a></li>
					<%
					}
					%>

				</ul>
			</div>
			<%} %>
			<div class="col" style="text-align: right;">
				<b>Σύνολο Μαθημάτων: <%=coursesCount%></b>
			</div>
		</div>
	</div>





	<!-- New Course Modal -->
	<div class="modal fade" id="newCourseModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Προσθήκη νέου μαθήματος</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="<%=request.getContextPath()%>/secretary?action=new-course" method="POST">
					<div style="padding: 35px;" class="modal-body">
						
						<div class="mb-3">
							<label for="codeNewForm" class="form-label">Κωδικός</label> 
								<input type="text" class="form-control" name="course_id" id="codeNewForm">
						</div>

						<div class="mb-2">
							<label for="titleNewForm" class="form-label">Τίτλος</label> <input
								type="text" class="form-control" name="title" id="titleNewForm">
						</div>


						<div class="mb-2">
							<label for="semesterNewForm" class="form-label">Εξάμηνο</label>
							<select name="semester" id="semesterNewForm" class="form-select"
								aria-label="Default select example">
								<option value="1">1ο εξάμηνο</option>
								<option value="2">2ο εξάμηνο</option>
								<option value="3">3ο εξάμηνο</option>
								<option value="4">4ο εξάμηνο</option>
								<option value="5">5ο εξάμηνο</option>
								<option value="6">6ο εξάμηνο</option>
								<option value="7">7ο εξάμηνο</option>
								<option value="8">8ο εξάμηνο</option>
							</select>
						</div>

						<div class="mb-2">
							<label for="typeNewForm" class="form-label">Τύπος</label> <select
								 name="type" id="typeNewForm" class="form-select"
								aria-label="Default select example">
								<option value="Υ">Υποχρεωτικό</option>
								<option value="Ε">Επιλογής</option>
								<option value="ΥΚ">Υποχρεωτικό Κ</option>
							</select>
						</div>

						<div class="mb-2">
							<label for="ectsNewForm" class="form-label">ECTS</label> <input
								type="number" class="form-control" name="ects" id="ectsNewForm">
						</div>

						<div class="mb-2">
							<label for="examsNewForm" class="form-label">Τρόπος
								εξέτασης</label> <select name="exams" id="examsNewForm" class="form-select"
								aria-label="Default select example">
								<option value="true">Γραπτή εξέταση</option>
								<option value="false">Απαλλακτική εργασία</option>
							</select>
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






	<!-- Edit Modal -->
	<div class="modal fade" id="editModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Επεξεργασία Μαθήματος</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="<%=request.getContextPath()%>/secretary?action=update-course" method="POST">
					<div style="padding: 35px;" class="modal-body">
						<!-- TODO input check -->
								<input type="hidden" class="form-control" name="course_id" id="codeEditForm">

						<div class="mb-2">
							<label for="titleEditForm" class="form-label">Τίτλος</label> <input
								type="text" class="form-control" name="title" id="titleEditForm">
						</div>


						<div class="mb-2">
							<label for="semesterEditForm" class="form-label">Εξάμηνο</label>
							<select name="semester" id="semesterEditForm" class="form-select"
								aria-label="Default select example">
								<option value="1">1ο εξάμηνο</option>
								<option value="2">2ο εξάμηνο</option>
								<option value="3">3ο εξάμηνο</option>
								<option value="4">4ο εξάμηνο</option>
								<option value="5">5ο εξάμηνο</option>
								<option value="6">6ο εξάμηνο</option>
								<option value="7">7ο εξάμηνο</option>
								<option value="8">8ο εξάμηνο</option>
							</select>
						</div>

						<div class="mb-2">
							<label for="typeEditForm" class="form-label">Τύπος</label> <select
								 name="type" id="typeEditForm" class="form-select"
								aria-label="Default select example">
								<option value="Υ">Υποχρεωτικό</option>
								<option value="Ε">Επιλογής</option>
								<option value="ΥΚ">Υποχρεωτικό Κ</option>
							</select>
						</div>

						<div class="mb-2">
							<label for="ectsEditForm" class="form-label">ECTS</label> <input
								type="number" class="form-control" name="ects" id="ectsEditForm">
						</div>

						<div class="mb-2">
							<label for="examsEditForm" class="form-label">Τρόπος
								εξέτασης</label> <select name="exams" id="examsEditForm" class="form-select"
								aria-label="Default select example">
								<option value="Γραπτή εξέταση">Γραπτή εξέταση</option>
								<option value="Απαλλακτική εργασία">Απαλλακτική εργασία</option>
							</select>
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






	<!-- Confirm Delete Modal -->
	<div class="modal fade" id="confirmDeleteModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Διαγραφή Μαθήματος</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="<%=request.getContextPath()%>/secretary?action=delete-course" method="POST">
					<div class="modal-body">Θέλετε σίγουρα να διαγράψετε το
						μάθημα;</div>
					<input type="hidden" name="course_id" id="deleteId">
					<div class="modal-footer">
						<button type="button" class="btn btn-secondary"
							data-bs-dismiss="modal">Άκυρο</button>
						<button type="submit" class="btn btn-danger">Διαγραφή</button>
					</div>
				</form>
			</div>
		</div>
	</div>





	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	<script>
		$(document).ready(function() {
			$('.edit-btn').on('click', function() {
				$('#editModal').modal('show');

				$tr = $(this).closest('tr');

				var data = $tr.children("td").map(function() {
					return $(this).text();
				}).get();

				$('#codeEditForm').val(data[0])
				$('#titleEditForm').val(data[1]);
				$('#semesterEditForm').val(data[2]);
				$('#typeEditForm').val(data[3]);
				$('#ectsEditForm').val(data[4]);
				$('#examsEditForm').val(data[5]);
				console.log(data);

			});

			$('.delete-btn').on('click', function() {
				$('#confirmDeleteModal').modal('show');

				$tr = $(this).closest('tr');

				var data = $tr.children("td").map(function() {
					return $(this).text();
				}).get();

				$('#deleteId').val(data[0]);

			});

			$('.new-course-btn').on('click', function() {
				$('#newCourseModal').modal('show');

				$tr = $(this).closest('tr');

				var data = $tr.children("td").map(function() {
					return $(this).text();
				}).get();

			});

		});
	</script>
	
	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>