package com.estudent.model;

public class Grade {
    private String courseCode;
    private String courseTitle;
    private String courseType;
    private String courseSemester;
    private int studentsRegistrationId;
    private int courseEcts;
    private String finalGrade;
    private int assignmentGrade;
    private int examGrade;

    public Grade(String courseCode, String courseTitle, String courseType, int courseEcts, String finalGrade) {
        this.setCourseCode(courseCode);
        this.setCourseTitle(courseTitle);
        this.setCourseType(courseType);
        this.setCourseEcts(courseEcts);
        this.setFinalGrade(finalGrade);
    }
    
    public Grade(String course_id, int studentsRegistrationId, int assignmentGrade, int examGrade, String finalGrade) {
    	this.setCourseCode(course_id);
    	this.setStudentsRegistrationId(studentsRegistrationId);
    	this.setAssignmentGrade(assignmentGrade);
    	this.setExamGrade(examGrade);
    	this.setFinalGrade(finalGrade);
    }

    public String getCourseCode() {
        return this.courseCode;
    }

    private void setCourseCode(String courseCode) {
        this.courseCode = courseCode;
    }

    public String getCourseTitle() {
        return this.courseTitle;
    }

    private void setCourseTitle(String courseTitle) {
        this.courseTitle = courseTitle;
    }

    public String getCourseType() {
        return this.courseType;
    }

    private void setCourseType(String courseType) {
        this.courseType = courseType;
    }

    public int getCourseEcts() {
        return this.courseEcts;
    }

    private void setCourseEcts(int courseEcts) {
        this.courseEcts = courseEcts;
    }

    public String getFinalGrade() {
        return this.finalGrade;
    }

    private void setFinalGrade(String finalGrade) {
        if (finalGrade.equals("0")) {
            this.finalGrade = "-";
        } else {
            this.finalGrade = finalGrade;
        }

    }

    public int getAssignmentGrade() {
        return this.assignmentGrade;
    }

    private void setAssignmentGrade(int assignmentGrade) {
        this.assignmentGrade = assignmentGrade;
    }

    public int getExamGrade() {
        return this.examGrade;
    }

    private void setExamGrade(int examGrade) {
        this.examGrade = examGrade;
    }

	public String getCourseSemester() {
		return courseSemester;
	}

	private void setCourseSemester(String courseSemester) {
		this.courseSemester = courseSemester;
	}

	public int getStudentsRegistrationId() {
		return studentsRegistrationId;
	}

	private void setStudentsRegistrationId(int studentsRegistrationId) {
		this.studentsRegistrationId = studentsRegistrationId;
	}
}
