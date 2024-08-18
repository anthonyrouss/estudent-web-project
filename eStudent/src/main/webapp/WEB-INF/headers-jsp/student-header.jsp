<%@ page import="com.estudent.model.Student" %>
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
        <li class="nav-item">
          <a class="nav-link" href="<%= request.getContextPath() %>/student/show-courses.jsp">Δηλώσεις</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%= request.getContextPath() %>/student/show-grades.jsp">Βαθμολογία</a>
        </li>
      </ul>
      
    </div>
    <% 
	if (session.getAttribute("logged_in_user") != null){
		Student logged_in_student = (Student) session.getAttribute("logged_in_user");%>
		<div class="dropdown">
    <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
     <%= logged_in_student.getLastName() + " " + logged_in_student.getFirstName() + " (" + logged_in_student.getUsername() + ") " %>
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile.jsp">Προβολή προφίλ</a></li>
    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/LogoutServlet">Έξοδος</a></li>
  </ul>
  </div>
	<%} %>
    
  </div>
</nav>