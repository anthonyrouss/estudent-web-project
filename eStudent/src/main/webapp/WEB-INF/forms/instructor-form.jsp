<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<div class="row mb-3">
		<h3>Εισαγωγή Στοιχείων Καθηγητή</h3>
	</div>
	 <form class="row g-3 needs-validation" action="<%=request.getContextPath()%>/secretary?action=new-instructor" method="POST" novalidate>
	 
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
		      <option selected disabled value="">Specify...</option>
		      <option value="Male">Άρρεν</option>
		      <option value="Female">Θήλυ</option>
		      <option value="Other">Άλλο</option>
		    </select>
		  </div>
		  
		  <div class="col-md-2">
		    <label for="validationUsername" class="form-label">Username</label>
		      <input type="text" class="form-control" id="validationUsername" name="username" aria-describedby="inputGroupPrepend" required>
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
		  
		  <div class="col-md-3">
		    <label for="validationAFM" class="form-label">Αριθμός Φορολογικού Μητρώου</label>
		    <input type="text" class="form-control" id="validationAFM" name="afm" required>
		  </div>
		  
		  <div class="col-md-2">
		    <label for="validationDepartment" class="form-label">Τμήμα</label>
		    <input type="text" class="form-control" id="validationDepartment" name="department" required>
		  </div>
		  
		  <div class="col-md-2">
		    <label for="validationOffice" class="form-label">Γραφείο</label>
		    <input type="text" class="form-control" id="validationOffice" name="office" required>
		  </div>
		  
		  <div class="col-md-4">
		    <label for="validationTRes" class="form-label">Website</label>
		    <input type="text" class="form-control" id="validationTRes" name="website" placeholder="Αν υπάρχει.">
		  </div>
		  
		  
		  
	  	  <div class="col-12 text-end">
	    <button class="btn btn-danger" type="reset">Καθαρισμός</button>
	    <button class="btn btn-primary" type="submit">Εισαγωγή</button>
	  </div>
</form>
