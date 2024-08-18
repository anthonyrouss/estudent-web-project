<%@ page import="java.util.Calendar" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<div class="row mb-3">
		<h3>Εισαγωγή Στοιχείων Φοιτητή</h3>
	</div>
	 <form class="row g-3 needs-validation" action="<%=request.getContextPath()%>/secretary?action=new-student" method="POST" novalidate>
	 
		  <div class="col-md-5">
		    <label for="validationName" class="form-label">Όνομα</label>
		    <input type="text" class="form-control" id="validationName" name="first_name" required>
		  </div>
		  
		  <div class="col-md-5">
		    <label for="validationLName" class="form-label">Επίθετο</label>
		    <input type="text" class="form-control" id="validationLName" name="last_name" required>
		  </div>
		  
		  <div class="col-md-2">
		    <label for="validationGender" class="form-label">Φύλο</label>
		    <select class="form-select" id="validationGender" name="gender" required>
		      <option selected disabled value="">Επιλέξτε...</option>
		      <option value="Male">Άρρεν</option>
		      <option value="Female">Θήλυ</option>
		      <option value="Other">Άλλο</option>
		    </select>
		  </div>
		  
		  <div class="col-md-2">
		    <label for="validationUsername" class="form-label">Username (ΑΜ)</label>
		    <div class="input-group has-validation">
		      <span class="input-group-text">p</span>
		      <input type="text" class="form-control" id="validationUsername" name="username" aria-describedby="inputGroupPrepend" required>
		    </div>
		    
		  </div>
		  <div class="col-md-3">
		    <label for="validationPassword" class="form-label">Password</label>
		    <input type="text" class="form-control" id="validationPassword" name="password" required>
		  </div>
		  
		  <div class="col-md-4">
		    <label for="validationEmail" class="form-label">Email</label>
		    <input type="email" class="form-control" id="validationEmail" name="email" required>
		  </div>
		  
		  <div class="col-md-3">
		    <label for="validationPhone" class="form-label">Κινητό τηλέφωνο</label>
		    <input type="text" class="form-control" id="validationPhone" name="phone" placeholder="+30 ..."required>
		  </div>
		 
		  <hr class="mt-5 mb-5">
		  
		  <div class="col-md-6">
		    <label for="validationPRes" class="form-label">Μόνιμη κατοικία</label>
		    <input type="text" class="form-control" id="validationPRes" name="p_residence" required>
		  </div>
		  
		  <div class="col-md-6">
		    <label for="validationTRes" class="form-label">Προσωρινή κατοικία</label>
		    <input type="text" class="form-control" id="validationTRes" name="t_residence" placeholder="Αν υπάρχει.">
		  </div>
		  
		  <div class="col-md-4">
		    <label for="validationWOE" class="form-label">Τρόπος εισαγωγής</label>
		    <select class="form-select" id="validationWOE" name="way_of_entry" required>
		      <option selected disabled value="">Επιλέξτε...</option>
		      <option value="ΠΑΝΕΛΛΗΝΙΕΣ">ΠΑΝΕΛΛΗΝΙΕΣ</option>
		      <option value="ΜΕΤΕΓΓΡΑΦΉ">ΜΕΤΕΓΓΡΑΦΗ</option>
		      <option value="ΕΙΣΑΚΤΕΟΣ 10%">ΕΙΣΑΚΤΕΟΣ 10%</option> <!-- ? -->
		    </select>
		  </div>
		  
		<div class="col-md-2">
		    <label for="validationYOE" class="form-label">Έτος εισαγωγής</label>
		    <select class="form-select" id="validationYOE" name="year_of_entry" required>
		      <option selected disabled value="">Επιλέξτε...</option>
		      <% 
		      		int year = Calendar.getInstance().get(Calendar.YEAR);
		    		for(int i = 0; i <= 10; i++){
		      %>
		      <option value="<%= year %>"><%= year-- %></option>
		      <%} %>
		    </select>
		  </div>
		  
		  <div class="col-md-3">
		    <label for="validationClass" class="form-label">Τμήμα Εισαγωγής</label>
		    <select class="form-select" id="validationClass" name="class" required>
		      <option selected disabled value="">Επιλέξτε...</option>
		      <option value="ΠΛΗΡΟΦΟΡΙΚΗ">ΠΛΗΡΟΦΟΡΙΚΗ</option>
		    </select>
		  </div>
		  
		  <div class="form-check">
		  <input class="form-check-input" type="checkbox" id="foodClubAccessCheck" name="food_club_access">
		  <label class="form-check-label" for="foodClubAccessCheck">
		    Έγκριση για να έχει ο φοιτητής πρόσβαση στη σίτηση.
		  </label>
		</div>
		  
	  	  <div class="col-12 text-end">
	    <button class="btn btn-danger" type="reset">Καθαρισμός</button>
	    <button class="btn btn-primary" type="submit">Εισαγωγή</button>
	  </div>
		</form>