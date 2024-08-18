<%@ page
	import="com.estudent.dao.SecretaryDAO, com.estudent.model.Message, com.estudent.model.User, com.estudent.exceptions.ForbiddenAccessException, java.util.List"%>

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
<title>eStudent - Προβολή Χρηστών</title>
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
	// TODO Add a search by username field
	
	int numberOfRows = 10;
	int pageNo = 1;
	int limit = numberOfRows;
	int offset = limit - numberOfRows;

	int usersCount = conn.getCountOfUsers();

	try {

		if (request.getParameter("pageNo") != null) {
			pageNo = Integer.parseInt(request.getParameter("pageNo"));
			pageNo = pageNo <= 0 ? 1 : pageNo;
		}

		offset = (pageNo * numberOfRows) - numberOfRows;
		
	} catch (Exception e) {
		e.printStackTrace();
	}

	List<User> users = conn.getUsersByLimiting(offset, limit);

	%>

	<!-- Include Secretary's header -->
	<jsp:include page="../../WEB-INF/headers-jsp/secretary-header.jsp" />

	<div class="card container custom-container mt-3 mb-3 shadow-sm p-5 bg-body rounded">
		<div class="row">
			<h3><b>ΚΑΤΑΛΟΓΟΣ ΧΡΗΣΤΩΝ</b></h3>
			<p>Διαχειριστείτε όλα τα δεδομένα των χρηστών</p>
			
			<a type="button" class="btn btn-primary"
				style="width: 150px;margin-left:1vh" href="<%=request.getContextPath()%>/secretary/users/add-user.jsp">Προσθήκη νέου</a>

			<%
			if (session.getAttribute("all_users_alert") != null) {
				Message alert = (Message) session.getAttribute("all_users_alert");
			%>
			<div
				class="alert <%=alert.getType()%> alert-dismissible fade show mt-3"
				role="alert">
				<%=alert.getText()%>
				<button type="button" class="btn-close" data-bs-dismiss="alert"
					aria-label="Close"></button>
			</div>
			</div>
			
			<div class="row">

			<%
			}
			session.removeAttribute("all_users_alert");
			%>

			<table class="table table-hover mt-4">
				<thead>
					<tr>
						<th class="col">USERNAME</th>
						<th class="col">ΟΝΟΜΑ</th>
						<th class="col col-center-vert">ΕΠΩΝΥΜΟ</th>
						<th class="col col-center-full">ΤΗΛΕΦΩΝΟ</th>
						<th class="col col-center-full">EMAIL</th>
						<th class="col col-center-full">ROLE</th>
						<th class="col col-center-full" colspan="3">ΕΠΕΞΕΡΓΑΣΙΑ</th>
					</tr>
				</thead>
				<tbody>
					<%
					for (User user : users) {
					%>
					<tr>
						<td class="col-center-vert"><%=user.getUsername()%></td>
						<td class="col-center-vert"><%=user.getFirstName()%></td>
						<td class="col-center-vert"><%=user.getLastName()%></td>
						<td class="col-center-full"><%=user.getPhone()%></td>
						<td class="col-center-full"><%=user.getEmail()%></td>
						<td class="col-center-full"><%=user.getRole()%></td>
						<td class="col-center-full" style="padding: 10px 0"><a href="<%= request.getContextPath() %>/secretary?action=fetch-user&username=<%=user.getUsername()%>&role=<%=user.getRole()%>&pageNo=<%=request.getParameter("pageNo")%>"
								class="btn btn-secondary edit-btn">
								<i class='bx bxs-folder-open'></i>
							</a></td>
						<td class="col-center-full" style="padding: 10px 0">
						<button type="button"
								class="btn btn-danger delete-btn">
								<i class='bx bxs-trash-alt'></i>
							</button>
						</td>
					</tr>
					<%
					}
					%>
				</tbody>
			</table>
		</div>
		<div class="row">
			<div class="col">
				<ul class="pagination">
					<%
					for (int i = 1; i - 1 < Math.ceil((float) usersCount / (float) numberOfRows); i++) {
					%>
					<li class="page-item"><a
						class="page-link <%=pageNo == i ? "active" : ""%>"
						href="<%=request.getContextPath()%>/secretary/users/show-users.jsp?pageNo=<%=i%>"><%=i%></a></li>
					<%
					}
					%>

				</ul>
			</div>
			<div class="col" style="text-align: right;">
				<b>Σύνολο Χρηστών: <%=usersCount%></b>
			</div>
		</div>
	</div>




	<!-- Confirm Delete Modal -->
	<div class="modal fade" id="confirmDeleteModal" tabindex="-1"
		aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Διαγραφή χρήστη</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<form action="<%=request.getContextPath()%>/secretary?action=delete-user" method="POST">
					<div class="modal-body">Θέλετε σίγουρα να διαγράψετε τον
						χρήστη;</div>
					<input type="hidden" name="username" id="usernameID">
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

				$('#usernameID').val(data[0]);

			});

		});
	</script> 
	
	<%if (request.getParameter("username") != null){ %>

	<!-- Show User Modal -->
	
	<div class="modal fade" id="showUserModal" tabindex="-1" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title">Προβολή καρτέλας χρήστη</h5>
					<button type="button" class="btn-close" onclick="window.history.go(-1); return false;"></button>
				</div>

					<div style="padding: 35px;" class="modal-body">
						<!-- TODO input check -->
								<input type="hidden" class="form-control" name="course_id" id="codeEditForm">

						<div class="mb-2">
							Username: <%= request.getAttribute("username") %>
						</div>
						<div class="mb-2">
							Όνομα: <%= request.getAttribute("first_name") %>
						</div>
						<div class="mb-2">
							Επίθετο: <%= request.getAttribute("last_name") %>
						</div>
						<div class="mb-2">
							Τηλέφωνο: <%= request.getAttribute("phone") %>
						</div>
						<div class="mb-2">
							Φύλο: <%= request.getAttribute("gender") %>
						</div>
						<div class="mb-2">
							Email: <%= request.getAttribute("email") %>
						</div>
						
						<!-- Student's Extra Info -->
						<%if(request.getParameter("role").equals("Student")){ %>
						<div class="mb-2">
							Μόνιμη κατοικία: <%= request.getAttribute("p_residence") %>
						</div>
						<div class="mb-2">
							Προσωρινή κατοικία: <%= request.getAttribute("t_residence") %>
						</div>
						<div class="mb-2">
							Τμήμα: <%= request.getAttribute("class_title") %>
						</div>
						<div class="mb-2">
							Τρέχον εξάμηνο: <%= request.getAttribute("current_semester") %>
						</div>
						<div class="mb-2">
							Τρόπος εισαγωγής: <%= request.getAttribute("way_of_entry") %>
						</div>
						<div class="mb-2">
							Έτος εισαγωγής: <%= request.getAttribute("year_of_entry") %>
						</div>
						<div class="mb-2">
							Ects: <%= request.getAttribute("ects") %>
						</div>
						<div class="mb-2">
							Δωρεάν πρόσβαση σε σίτηση: <%= request.getAttribute("food_club_access") %>
						</div>
						<%} %>
						
						<!-- Instructor's Extra Info -->
						<%if(request.getParameter("role").equals("Instructor")){ %>
						<div class="mb-2">
							ΑΦΜ: <%= request.getAttribute("afm") %>
						</div>
						<div class="mb-2">
							Κτήριο: <%= request.getAttribute("department") %>
						</div>
						<div class="mb-2">
							Γραφείο: <%= request.getAttribute("office") %>
						</div>
						<div class="mb-2">
							Website: <%= request.getAttribute("website") %>
						</div>
						<%} %>
						
			</div>
		</div>
	</div>
	</div>
	
	<script>
	$(document).ready(function() {
		$('#showUserModal').modal({
		    backdrop: 'static',
		    keyboard: false  // to prevent closing with Esc button 
		})
	$('#showUserModal').modal('show'); 
		
	});

	</script>
	
	<%} // End of Modal if %>
	
	<!-- Footer -->
	<jsp:include page="../../WEB-INF/footers/general-footer.html" />
	<!-- End of Footer -->
</body>
</html>