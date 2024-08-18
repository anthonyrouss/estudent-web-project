<%@ page
	import="com.estudent.dao.SecretaryDAO, com.estudent.model.InstructorTeachesCourse, 
	com.estudent.model.Message, com.estudent.model.Instructor, com.estudent.model.Course, 
	com.estudent.exceptions.ForbiddenAccessException, java.util.List"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/WEB-INF/error-pages/error.jsp"%>

<%!SecretaryDAO conn = new SecretaryDAO();%>
<%
// TODO pagination to the teaches table
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
<meta charset="utf-8">
<title>eStudent - Ανάθεση Μαθήματος</title>
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
<body>
	
	<%
	// You can change this
	int numberOfRows = 6;
	
	
	int pageNo = 1;
	int limit = numberOfRows;
	int offset = limit - numberOfRows;
	
	
	List<Course> allCourses = null;
	List<Instructor> allInstructors = null;
	String[] instructorRanks = null;
	
	List<InstructorTeachesCourse> teachesList = null;
	int coursesCount = conn.getCountOfTeaches();
	
	try {
		// Select menu
		allCourses = conn.getAllCourses();
		allInstructors = conn.getAllInstructors();
		instructorRanks = Instructor.getInstructor_ranks();
		
		if (request.getParameter("pageNo") != null) {
			pageNo = Integer.parseInt(request.getParameter("pageNo"));
			pageNo = pageNo <= 0 ? 1 : pageNo;
		}

		offset = (pageNo * numberOfRows) - numberOfRows;
		
		// Table 
		teachesList = conn.getTeachesByLimiting(offset, limit);
		
	} catch (Exception e){
		e.printStackTrace();
	}

	%>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/secretary-header.jsp" />

	<div class="card container custom-container mt-3 mb-5 shadow-sm p-5 bg-body rounded">
	
		<div class="row">
			<h3><b>ΑΝΑΘΕΣΗ ΜΑΘΗΜΑΤΟΣ ΣΕ ΚΑΘΗΓΗΤΗ</b></h3>
			<p>Κάντε ανάθεση κάποιου μαθήματος σε καθηγητή</p>
		</div>
		
		<form action="<%=request.getContextPath()%>/secretary?action=set-teaches" method="POST">
		
			<div class="row mt-3">
			
				<div class="col-4">
					<label for="selected_course" class="form-label">Επιλέξτε μάθημα:</label>
						<select name="selected_course" id="selected_course" class="form-select">
							<%
							int selectCurrentSemester = 0;
							for (Course course : allCourses) {
							if(course.getSemester() != selectCurrentSemester){
							%>
							<option disabled value="null">----------- <%=course.getSemester()%>ο Εξάμηνο ------------</option>
						<%}selectCurrentSemester = course.getSemester(); %>
							<option value="<%=course.getCourseId()%>"><%=course.getTitle()%></option>
							
							<%
							}
							%>
						</select>
				</div>
				
				<div class="col-3">
					<label for="selected_instructor" class="form-label">Επιλέξτε διδάκτωρ:</label>
						<select name="selected_instructor" id="selected_instructor" class="form-select">
							<%
							for (Instructor instructor : allInstructors) {
							%>
							<option value="<%=instructor.getAfm()%>"><%=instructor.getLastName() + " " + instructor.getFirstName()%></option>
							<%
							}
							%>
						</select>
				</div>
				
				<div class="col-3">
					<label for="selected_rank" class="form-label">Επιλέξτε βαθμίδα:</label>
						<select name="selected_rank" id="selected_rank" class="form-select">
						<%
						int rankPosition = 0;
						for (String rank : instructorRanks){
						%>
							<option value="<%= rankPosition++ %>"><%= rank %></option>
						<%} %>
						</select>
				</div>
				
				<div class="col">
					<input style="margin-top:32px" class="btn btn-primary" type="submit" value="Εισαγωγή">
				</div>
		</div>		
	</form>
	
	<%
	if (session.getAttribute("course_to_instructor_alert") != null) {
		Message alert = (Message) session.getAttribute("course_to_instructor_alert");
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
	session.removeAttribute("course_to_instructor_alert");
	%>

	<div class="row mt-5">
		<table class="table table-hover">
		<thead>
    <tr>
      <th class="col-1">ΚΩΔΙΚΟΣ</th>
      <th class="col-4">ΤΙΤΛΟΣ</th>
      <th class="col-1 col-center-full">ΕΞΑΜΗΝΟ</th>
      <th class="col-3 col-center-full">ΟΝΟΜΑΤΕΠΩΝΥΜΟ</th>
      <th class="col-1 col-center-full">ΑΦΜ</th>
      <th class="col-2 col-center-full">ΒΑΘΜΙΔΑ</th>
      <th></th>
    </tr>
  </thead>
  <tbody>
  <%for(InstructorTeachesCourse teaches : teachesList){ %>
    <tr>
      <td class="col-center-vert"><%= teaches.getCourseId() %></td>
      <td class="col-center-vert"> <%= teaches.getTitle() %> </td>
      <td class="col-center-full"> <%= teaches.getSemester() %> </td>
      <td class="col-center-full"> <%= teaches.getLastName() + " " + teaches.getFirstName() %> </td>
      <td class="col-center-full"> <%= teaches.getAfm() %> </td>
	  <td class="col-center-full"> <%= teaches.getRank() %> </td>
	  <td class="col-center-full">
	  	<button type="button" class="btn btn-danger delete-btn">
			<i class='bx bxs-trash-alt'></i>
		</button>
	  </td>
    </tr>
    <%} %>
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
						href="<%=request.getContextPath()%>/secretary/courses/course-to-instructor.jsp?pageNo=<%=i%>"><%=i%></a></li>
					<%
					}
					%>

				</ul>
			</div>
			<%} %>
			<div class="col" style="text-align: right;">
				<b>Σύνολο Εγγραφών: <%=coursesCount%></b>
			</div>
		</div>
		
	</div>



	<!-- Confirm Delete Modal -->
	<div class="modal fade" id="confirmDeleteModal" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Αφαίρεση
						εγγραφής</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="<%=request.getContextPath()%>/secretary?action=delete-teaches" method="POST">
					<div class="modal-body">Θέλετε σίγουρα να αφαιρέσετε αυτή την εγγραφή;</div>
						<input type="hidden" name="instructor_afm" id="instructor_afm">
						<input type="hidden" name="course_id" id="course_id">
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
			
			$('.delete-btn').on('click', function() {
				$('#confirmDeleteModal').modal('show');

				$tr = $(this).closest('tr');

				var data = $tr.children("td").map(function() {
					return $(this).text();
				}).get();
				
				$('#instructor_afm').val(data[4]);
				$('#course_id').val(data[0])
				console.log(data);
				
			});
			
		});
	</script>
	
	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>