package com.estudent.model;


public class Instructor extends User {
	private String afm;
    private String department;
    private String office;
    private String website;
    private static final String[] INSTRUCTOR_RANKS = {"ΛΕΚΤΟΡΑΣ", "ΕΠΙΚΟΥΡΟΣ", "ΑΝΑΠΛΗΡΩΤΗΣ ΚΑΘΗΓΗΤΗΣ", "ΚΑΘΗΓΗΤΗΣ"};
    
    public Instructor(String afm, String username, String first_name, String last_name, String phone, String gender, String email, String department, String office, String website) {
        super(username, first_name, last_name, phone, gender, email);
        this.setAfm(afm);
        this.setDepartment(department);
        this.setOffice(office);
        this.setWebsite(website);
    }
    
    public Instructor(String afm, String username, String first_name, String last_name, String phone, String gender, String role, String email, String department, String office, String website, String salt, String password) {
        super(username, first_name, last_name, phone, gender, role, email, salt, password);
        this.setAfm(afm);
        this.setDepartment(department);
        this.setOffice(office);
        this.setWebsite(website);
    }

    public String getDepartment() {
        return this.department;
    }

    private void setDepartment(String department) {
        this.department = department;
    }

    public String getOffice() {
        return this.office;
    }

    private void setOffice(String office) {
        this.office = office;
    }

    public String getWebsite() {
        return this.website;
    }

    private void setWebsite(String website) {
        this.website = website;
    }

	public String getAfm() {
		return afm;
	}

	private void setAfm(String afm) {
		this.afm = afm;
	}

	public static String[] getInstructor_ranks() {
		return INSTRUCTOR_RANKS;
	}
}
