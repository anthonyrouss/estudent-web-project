package com.estudent.model;

public class Course {
    private String courseId;
    private String title;
    private int semester;
    private String type;
    private int ects;
    private boolean requiresFinalExams;
    private int countOfEnrolledStudents;
    private boolean isEnrolled;

    public Course(String course_id, String title) {
    	this.setCourseId(course_id);
    	this.setTitle(title);
    }
    
    public Course(String course_id, String title, int semester, String type, int countOfEnrolledStudents) {
    	this.setCourseId(course_id);
    	this.setTitle(title);
    	this.setSemester(semester);
    	this.setType(type);
    	this.setCountOfEnrolledStudents(countOfEnrolledStudents);
    }
    
    public Course(String course_id, String title, int semester, String type, int ects, boolean requiresFinalExams) {
        this.setCourseId(course_id);
        this.setTitle(title);
        this.setSemester(semester);
        this.setType(type);
        this.setEcts(ects);
        this.setRequiresFinalExams(requiresFinalExams);
    }
    
    public Course(String course_id, String title, int semester, String type, int ects, boolean requiresFinalExams, boolean isEnrolled) {
        this.setCourseId(course_id);
        this.setTitle(title);
        this.setSemester(semester);
        this.setType(type);
        this.setEcts(ects);
        this.setRequiresFinalExams(requiresFinalExams);
        this.setEnrolled(isEnrolled);
    }

    public String getCourseId() {
        return this.courseId;
    }

    private void setCourseId(String courseId) {
        this.courseId = courseId;
    }

    public String getTitle() {
        return this.title;
    }

    private void setTitle(String title) {
        this.title = title;
    }

    public int getSemester() {
        return this.semester;
    }

    private void setSemester(int semester) {
        this.semester = semester;
    }

    public String getType() {
        return this.type;
    }

    private void setType(String type) {
        this.type = type;
    }

    public int getEcts() {
        return this.ects;
    }

    private void setEcts(int ects) {
        this.ects = ects;
    }

    public boolean doesRequireFinalExams() {
        return this.requiresFinalExams;
    }

    private void setRequiresFinalExams(boolean requiresFinalExams) {
        this.requiresFinalExams = requiresFinalExams;
    }

	public boolean isEnrolled() {
		return isEnrolled;
	}

	private void setEnrolled(boolean isEnrolled) {
		this.isEnrolled = isEnrolled;
	}

	public int getCountOfEnrolledStudents() {
		return countOfEnrolledStudents;
	}

	private void setCountOfEnrolledStudents(int countOfEnrolledStudents) {
		this.countOfEnrolledStudents = countOfEnrolledStudents;
	}
}
