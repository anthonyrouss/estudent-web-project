<%@ page import="com.estudent.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<nav class="navbar navbar-expand-lg sticky-top bg-light" style="padding-left: 50px;padding-right: 50px;">
  <div class="container-fluid">
    <span class="navbar-brand mb-0 h1">eStudent</span>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="<%= request.getContextPath() %>/index.jsp">Αρχική</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Διαχείριση χρηστών
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/secretary/users/show-users.jsp">Προβολή όλων</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/secretary/users/add-user.jsp">Εισαγωγή νέου χρήστη</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Διαχείριση μαθημάτων
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/secretary/courses/show-courses.jsp">Προβολή όλων</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/secretary/courses/course-to-instructor.jsp">Ανάθεση σε καθηγητή</a></li>
          </ul>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Λίστες βαθμολόγησης
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/secretary/grades/grade-listings.jsp">Προβολή όλων</a></li>
          </ul>
        </li>
      </ul>
    </div>
    
     <% 
	if (session.getAttribute("logged_in_user") != null){
		User logged_in_secretary = (User) session.getAttribute("logged_in_user");%>
		<div class="dropdown">
    <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
     <%= logged_in_secretary.getLastName() + " " + logged_in_secretary.getFirstName() + " (" + logged_in_secretary.getUsername() + ") " %>
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile.jsp">Προβολή προφίλ</a></li>
    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/LogoutServlet">Έξοδος</a></li>
  </ul>
  </div>
	<%} %>
    
  </div>
</nav>