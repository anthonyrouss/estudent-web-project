<%@ page import="com.estudent.model.Message"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
//removes page caching
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); //HTTP 1.1
response.setHeader("Pragma", "no-cache"); //HTTP 1.0
response.setDateHeader("Expires", 0); // Proxies

if (session.getAttribute("logged_in_user") != null)
	response.sendRedirect("index.jsp");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>eStudent - Login</title>
<link rel="icon" type="image/x-icon" href="<%= request.getContextPath() %>/assets/img/eStudent-favicon.ico">

<!-- Bootstrap CSS -->
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/css/bootstrap.min.css"
	rel="stylesheet">
<!-- End of Bootstrap CSS -->

<!-- Custom CSS -->
<link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/css/login.css"/>
<!-- End of Custom CSS -->

<style>

</style>
</head>
<body>
	<section class="vh-100 gradient-background-login">

		<div class="container py-5 h-100">
			<%
			if (session.getAttribute("login_alert") != null) {
				Message login_alert = (Message) session.getAttribute("login_alert");
			%>
			<div class="alert <%=login_alert.getType()%> login-alert"
				role="alert"><%=login_alert.getText()%></div>
			<%
			}
			session.removeAttribute("login_alert");
			%>
			<div
				class="row d-flex justify-content-center align-items-center h-100">
				<div class="col-12 col-md-8 col-lg-6 col-xl-5">
					<div class="card bg-dark text-white" style="border-radius: 1rem;">
						<form action="Login" method="post">
							<div class="card-body p-5 text-center">
								<div class="mb-md-2 mt-md-1 mb-5">
									<h2 class="fw-bold mb-2 text-uppercase">LOGIN</h2>
									<p class="text-white-50 mb-5">Εισάγετε τα στοιχεία σας για να συνδεθείτε!</p>


									<div class="form-outline form-white mb-3">
										<input type="text" id="typeEmailX"
											class="form-control form-control-lg" name="uname" /> <label
											class="form-label" for="typeEmailX">Username</label>
									</div>

									<div class="form-outline form-white mb-3">
										<input type="password" id="typePasswordX"
											class="form-control form-control-lg" name="upass" /> <label
											class="form-label" for="typePasswordX">Password</label>
									</div>
								</div>
								<p class="small mb-5 pb-lg-2">
									<a class="text-white-50" href="#!">Ξεχάσατε τον κωδικό σας;</a>
								</p>

								<button class="btn btn-outline-light btn-lg px-5" type="submit">Login</button>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>

	</section>
	<script
		src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0-beta1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>