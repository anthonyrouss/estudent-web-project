package com.estudent.model;

public class Student extends User {
	private int registrationId;
    private String permanentResidence;
    private String temporaryResidence;
    private String classTitle;
    private int currentSemester;
    private String wayOfEntry;
    private int yearOfEntry;
    private int ects;
    private boolean foodClubAccess;

    public Student(int registrationId, String username, String first_name, String last_name, String phone, String gender, String email, String permanentResidence, String temporaryResidence, String classTitle, int currentSemester, String wayOfEntry, int yearOfEntry, int ects, boolean foodClubAccess) {
    	super(username, first_name, last_name, phone, gender, email);
    	this.setRegistrationId(registrationId);
        this.setPermanentResidence(permanentResidence);
        this.setTemporaryResidence(temporaryResidence);
        this.setClassTitle(classTitle);
        this.setCurrentSemester(currentSemester);
        this.setWayOfEntry(wayOfEntry);
        this.setYearOfEntry(yearOfEntry);
        this.setEcts(ects);
        this.setFoodClubAccess(foodClubAccess);
    }
    
    public Student(int registrationId, String username, String first_name, String last_name, String phone, String gender, String email, String permanentResidence, String temporaryResidence, String classTitle, int currentSemester, String wayOfEntry, int yearOfEntry, int ects, boolean foodClubAccess, String salt, String password)  {
    	super(username, first_name, last_name, phone, gender, "Student", email, salt, password);
    	this.setRegistrationId(registrationId);
        this.setPermanentResidence(permanentResidence);
        this.setTemporaryResidence(temporaryResidence);
        this.setClassTitle(classTitle);
        this.setCurrentSemester(currentSemester);
        this.setWayOfEntry(wayOfEntry);
        this.setYearOfEntry(yearOfEntry);
        this.setEcts(ects);
        this.setFoodClubAccess(foodClubAccess);
    }
    
    public String getPermanentResidence() {
        return this.permanentResidence;
    }

    private void setPermanentResidence(String permanentResidence) {
        this.permanentResidence = permanentResidence;
    }

    public String getTemporaryResidence() {
        return this.temporaryResidence;
    }

    private void setTemporaryResidence(String temporaryResidence) {
        this.temporaryResidence = temporaryResidence;
    }

    public String getClassTitle() {
        return this.classTitle;
    }

    private void setClassTitle(String classTitle) {
        this.classTitle = classTitle;
    }

    public int getCurrentSemester() {
        return this.currentSemester;
    }

    private void setCurrentSemester(int currentSemester) {
        this.currentSemester = currentSemester;
    }

    public String getWayOfEntry() {
        return this.wayOfEntry;
    }

    private void setWayOfEntry(String wayOfEntry) {
        this.wayOfEntry = wayOfEntry;
    }

    public int getYearOfEntry() {
        return this.yearOfEntry;
    }

    private void setYearOfEntry(int yearOfEntry) {
        this.yearOfEntry = yearOfEntry;
    }
    public int getEcts() {
        return this.ects;
    }

    private void setEcts(int ects) {
        this.ects = ects;
    }
    public boolean isFoodClubAccess() {
        return this.foodClubAccess;
    }

    private void setFoodClubAccess(boolean foodClubAccess) {
        this.foodClubAccess = foodClubAccess;
    }

	public int getRegistrationId() {
		return registrationId;
	}

	private void setRegistrationId(int registrationId) {
		this.registrationId = registrationId;
	}
}
