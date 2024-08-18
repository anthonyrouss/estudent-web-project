package com.estudent.model;

public class InstructorTeachesCourse {
	private String courseId;
	private String title;
	private String semester;
	private String lastName;
	private String firstName;
	private String afm;
	private String rank;
	
	public InstructorTeachesCourse(String courseId, String title, String semester, String lastName, String firstName, String afm, String rank) {
		this.setCourseId(courseId);
		this.setTitle(title);
		this.setSemester(semester);
		this.setLastName(lastName);
		this.setFirstName(firstName);
		this.setAfm(afm);
		this.setRank(rank);
	}
	
	/**
	 * @return the course_id
	 */
	public String getCourseId() {
		return courseId;
	}
	/**
	 * @param courseId the course_id to set
	 */
	private void setCourseId(String courseId) {
		this.courseId = courseId;
	}
	/**
	 * @return the title
	 */
	public String getTitle() {
		return title;
	}
	/**
	 * @param title the title to set
	 */
	private void setTitle(String title) {
		this.title = title;
	}
	/**
	 * @return the semester
	 */
	public String getSemester() {
		return semester;
	}
	/**
	 * @param semester the semester to set
	 */
	private void setSemester(String semester) {
		this.semester = semester;
	}
	/**
	 * @return the last_name
	 */
	public String getLastName() {
		return lastName;
	}
	/**
	 * @param lastName the last_name to set
	 */
	private void setLastName(String lastName) {
		this.lastName = lastName;
	}
	/**
	 * @return the first_name
	 */
	public String getFirstName() {
		return firstName;
	}
	/**
	 * @param firstName the first_name to set
	 */
	private void setFirstName(String firstName) {
		this.firstName = firstName;
	}
	/**
	 * @return the AFM
	 */
	public String getAfm() {
		return afm;
	}
	/**
	 * @param afm the AFM to set
	 */
	private void setAfm(String afm) {
		this.afm = afm;
	}

	public String getRank() {
		return rank;
	}

	private void setRank(String rank) {
		this.rank = rank;
	}
	
	
}
