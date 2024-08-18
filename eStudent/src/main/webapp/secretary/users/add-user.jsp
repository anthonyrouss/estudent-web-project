<%@page import="com.estudent.exceptions.ForbiddenAccessException"%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" errorPage="/WEB-INF/error-pages/error.jsp"%>

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
<meta charset="UTF-8">
<title>eStudent - Προσθήκη χρήστη</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

<meta charset="utf-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<!-- Bootstrap CSS -->
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css">
<!-- End of Bootstrap CSS -->

<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/style.css"/>
<!-- End of Custom CSS -->

</head>
<body>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/secretary-header.jsp" />

	<%
	String role = "";

	if (request.getParameter("role") != null) {
		role = request.getParameter("role");
	}
	%>


	<div class="container mt-5">
			<div class="form-floating">
				<select onchange="window.location.replace('add-user.jsp?role='+this.value);" class="form-select w-50" id="floatingSelect"
					aria-label="Floating label select example">
					<option selected disabled value="">Επιλέξτε ρόλο...</option>
					<option value="Student"
						<%if (role.equalsIgnoreCase("Student")) out.print("selected");%>>Φοιτητής</option>
					<option value="Instructor"
						<%if (role.equalsIgnoreCase("Instructor")) out.print("selected");%>>Καθηγητής</option>
					<option value="Secretary"
						<%if (role.equalsIgnoreCase("Secretary")) out.print("selected");%>>Γραμματέας</option>
				</select> 
				<label for="floatingSelect">ΚΑΤΗΓΟΡΙΑ ΧΡΗΣΤΗ</label>
		</div>
	</div>

	<div class="card container custom-container mt-3 mb-3 shadow-sm p-5 bg-body rounded">
		<%
		if (role.equalsIgnoreCase("Student")) {
		%>
		<jsp:include page="../../WEB-INF/forms/student-form.jsp" />
		<%
		} else if (role.equalsIgnoreCase("Instructor")) {
		%>
		<jsp:include page="../../WEB-INF/forms/instructor-form.jsp" />
		<%
		} else if (role.equalsIgnoreCase("Secretary")) {
		%>
		<jsp:include page="../../WEB-INF/forms/secretary-form.jsp" />
		<%
		} else {
		%>
		<div class="alert alert-warning" role="alert">Επιλέξτε κάποιο
			ρόλο για να ξεκινήσετε την εισαγωγή.</div>
		<%
		}
		%>

	</div>






	<script>
	// Example starter JavaScript for disabling form submissions if there are invalid fields
	(() => {
	  'use strict'

	  // Fetch all the forms we want to apply custom Bootstrap validation styles to
	  const forms = document.querySelectorAll('.needs-validation')

	  // Loop over them and prevent submission
	  Array.from(forms).forEach(form => {
	    form.addEventListener('submit', event => {
	      if (!form.checkValidity()) {
	        event.preventDefault()
	        event.stopPropagation()
	      }

	      form.classList.add('was-validated')
	    }, false)
	  })
	})()
	
	</script>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>

	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->

</body>
</html>