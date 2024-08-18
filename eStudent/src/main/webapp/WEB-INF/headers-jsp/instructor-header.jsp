<%@ page import="com.estudent.model.Instructor" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% %>
<nav class="navbar navbar-expand-lg sticky-top bg-light" style="padding-left: 50px;padding-right: 50px;">
  <div class="container-fluid">
    <span class="navbar-brand mb-0 h1">eStudent</span>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarSupportedContent" aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarSupportedContent">
      <ul class="navbar-nav me-auto mb-2 mb-lg-0">
        <li class="nav-item">
          <a class="nav-link" aria-current="page" href="<%=request.getContextPath()%>">Αρχική</a>
        </li>
        <li class="nav-item dropdown">
          <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            Βαθμολογία
          </a>
          <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
            <li><a class="dropdown-item" href="<%= request.getContextPath() %>/instructor/grades/all-grades.jsp">Προβολή καταχωρημένων</a></li>
            <li><hr class="dropdown-divider"></li>
            <li><a class="dropdown-item" href="<%=request.getContextPath()%>/instructor/grades/new-grades.jsp">Εισαγωγή νέων βαθμών</a></li>
          </ul>
        </li>
      </ul>
    </div>
    
    <% 
	if (session.getAttribute("logged_in_user") != null){
		Instructor logged_in_instructor = (Instructor) session.getAttribute("logged_in_user");%>
		<div class="dropdown">
    <button class="btn btn-primary dropdown-toggle" type="button" id="dropdownMenuButton1" data-bs-toggle="dropdown" aria-expanded="false">
     <%= logged_in_instructor.getLastName() + " " + logged_in_instructor.getFirstName() + " (" + logged_in_instructor.getUsername() + ") " %>
  </button>
  <ul class="dropdown-menu" aria-labelledby="dropdownMenuButton1">
    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/profile.jsp">Προβολή προφίλ</a></li>
    <li><a class="dropdown-item" href="<%= request.getContextPath() %>/LogoutServlet">Έξοδος</a></li>
  </ul>
  </div>
	<%} %>
    
  </div>
</nav>


<!-- 
  <div class="toast-container top-0 end-0 p-3">
<div class="toast" role="alert" aria-live="assertive" aria-atomic="true">
  <div class="toast-header">
    <strong class="me-auto">eStudent</strong>
    <small>μόλις τώρα</small>
    <button type="button" class="btn-close" data-bs-dismiss="toast" aria-label="Close"></button>
  </div>
  <div class="toast-body">
    Έχετε νέους φοιτητές προς βαθμολόγηση.
  </div>
</div>
</div>
 -->