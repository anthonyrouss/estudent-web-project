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
<title>eStudent - Λίστες Βαθμολόγησης</title>
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
	
	int numberOfRows = 6;
	int pageNo = 1;
	int limit = numberOfRows;
	int offset = limit - numberOfRows;

	int coursesCount = conn.getCountOfEnrolledCourses();

	try {

		if (request.getParameter("pageNo") != null) {
			pageNo = Integer.parseInt(request.getParameter("pageNo"));
			pageNo = pageNo <= 0 ? 1 : pageNo;
		}

		offset = (pageNo * numberOfRows) - numberOfRows;
		
	} catch (Exception e) {
		e.printStackTrace();
	}

	List<Course> enrolledCourses = conn.getEnrolledCoursesByLimiting(offset, limit);

	%>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/secretary-header.jsp" />

	<div class="card container custom-container mt-3 mb-3 shadow-sm p-5 bg-body rounded">
	
		<div class="row">
			<h3><b>ΔΙΑΘΕΣΙΜΕΣ ΛΙΣΤΕΣ ΒΑΘΜΟΛΟΓΗΣΗΣ</b></h3>
			<p>Επιλέξτε τα μαθήματα που επιθυμείτε να θέσετε προς βαθμολόγηση</p>
		</div>
		
		<div class="row">
			<%
			if (session.getAttribute("new_listing_alert") != null) {
				Message alert = (Message) session.getAttribute("new_listing_alert");
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
			session.removeAttribute("new_listing_alert");
			%>

			<table class="table table-hover mt-4">
				<thead>
					<tr>
						<th class="col-1">ΚΩΔΙΚΟΣ</th>
						<th class="col-6">ΤΙΤΛΟΣ</th>
						<th class="col-1 col-center-full">ΕΞΑΜΗΝΟ</th>
						<th class="col-1 col-center-full">ΤΥΠΟΣ</th>
						<th class="col-3 col-center-full">ΕΓΓΕΓΡΑΜΜΕΝΟΙ ΦΟΙΤΗΤΕΣ</th>
						<th class="col"></th>
					</tr>
				</thead>
				<tbody>
				<%for (Course course : enrolledCourses){ %>
					<tr>
						<td class="col-center-vert"><%= course.getCourseId() %></td>
						<td class="col-center-vert"><%= course.getTitle() %></td>
						<td class="col-center-full"><%= course.getSemester() %></td>
						<td class="col-center-full"><%= course.getType() %></td>
						<td class="col-center-full"><%= course.getCountOfEnrolledStudents() %></td>
						<td style="padding-right: 5px;">
							<a class="btn btn-light listing-icon" href="<%= request.getContextPath() %>/secretary?action=set-listing&course_id=<%= course.getCourseId() %>">
							<i class='bx bx-list-plus'></i></a>
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
						href="<%=request.getContextPath()%>/secretary/grades/grade-listings.jsp?pageNo=<%=i%>"><%=i%></a></li>
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



	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
	<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
	
	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>