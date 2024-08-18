
<!-- Java Classes -->
<%@ page
	import="com.estudent.dao.StudentDAO, com.estudent.model.Student, com.estudent.model.Course, 
	com.estudent.model.Grade,com.estudent.model.StringCodes, 
	com.estudent.exceptions.ForbiddenAccessException,
	java.util.List"%>
	
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="../WEB-INF/error-pages/error.jsp"%>
<%!StudentDAO conn = new StudentDAO();%>

<%
// removes page caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies

// guard branches for non direct access to this page
if(session.getAttribute("logged_in_user") == null){
	 response.sendRedirect("../index.jsp");
}
		
if(session.getAttribute("logged_in_user_role") != null){
	if(!(session.getAttribute("logged_in_user_role").equals("Student"))){
		throw new ForbiddenAccessException();
	}
}

%>

<!DOCTYPE html>
<html>
<head>
<title>eStudent - Βαθμολογία</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">


<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="css/style.css">

<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css"/>
<!-- End of Custom CSS -->

</head>
<body>
	<!-- Include header -->
	<jsp:include page="../WEB-INF/headers-jsp/student-header.jsp" />
	
	<%
	Student logged_in_student = (Student) session.getAttribute("logged_in_user");
	
	int semester_selected = 0;

	if (request.getParameter("semester") != null) {
		semester_selected = Integer.parseInt(request.getParameter("semester"));
	}

	
	%>


	<div class="card container custom-container mt-3 mb-3 shadow-sm p-5 bg-body rounded">
	
			<div class="row mb-4">
				<h3><b>ΑΝΑΛΥΤΙΚΗ ΒΑΘΜΟΛΟΓΙΑ</b></h3>
				<p>Δες την αναλυτική βαθμολογία σου παρακάτω</p>		
			</div>
			
			<% 
			for (int loop_semester = logged_in_student.getCurrentSemester(); loop_semester > 0; loop_semester--){
			List<Grade> grades = conn.returnGradesBySemester(logged_in_student.getRegistrationId(), loop_semester);
			if (grades.isEmpty()) continue;
			%>
			
			<div class="accordion accordion-flush" id="gradesAccordionFlush">
				<div class="accordion-item">
				    <h2 class="accordion-header" id="flush-headingOne">
				      <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#gradesFlush-collapse<%= loop_semester %>" aria-expanded="true" aria-controls="gradesFlush-collapse<%= loop_semester %>">
				       	<%= loop_semester %>ο Εξάμηνο
				      </button>
				    </h2>
				    <div id="gradesFlush-collapse<%= loop_semester %>" class="accordion-collapse collapse show" aria-labelledby="gradesFlush-collapse<%= loop_semester %>">
				      <div class="accordion-body">
				      	
				      	<!-- Table Content -->
				      	<table class="table table-sm">
					<thead>
						<tr>
							<th class="col-1">ΚΩΔΙΚΟΣ</th>
							<th class="col">ΤΙΤΛΟΣ</th>
							<th class="col-1 col-center-full">ΤΥΠΟΣ</th>
							<th class="col-2 col-center-full">ECTS</th>
							<th class="col-2 col-center-full">ΤΕΛΙΚΟΣ ΒΑΘΜΟΣ</th>
						</tr>
					</thead>
					<tbody>
						<%
						for (Grade grade : grades) {
						%>
						<tr>
							<td class="col-center-vert"><%=grade.getCourseCode()%></td>
							<td class="col-center-vert"><%=grade.getCourseTitle()%></td>
							<td class="col-center-full"><%=grade.getCourseType()%></td>
							<td class="col-center-full"><%=grade.getCourseEcts()%></td>
							<td class="col-center-full">
								<span style="font-size:25px;
									<%if(!grade.getFinalGrade().equals("-")){ %>
									color:<%= (Integer.parseInt(grade.getFinalGrade())) < 5 ? "red" : "green" %>
									<%} %>"
									>
									<%=grade.getFinalGrade()%>
								</span>
							</td>
						</tr>
						<%
						}
						%>
					</tbody>
				</table>
				      
				      <!-- End of Table Content -->
				      
				    </div>
			    </div>
			</div>
			</div>
			<%} %>		
	</div>
	<script
		src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.5/dist/umd/popper.min.js"></script>
<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.min.js"></script>
	<!-- Footer -->
	<jsp:include page="../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>