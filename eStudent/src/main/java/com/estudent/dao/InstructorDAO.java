package com.estudent.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import com.estudent.exceptions.InvalidInputException;
import com.estudent.model.Course;
import com.estudent.model.Grade;

import static com.estudent.dao.CommonValues.*;

public class InstructorDAO {

	private static final String SELECT_TEACHES_TITLES_BY_AFM = "SELECT c.course_id, title FROM teaches t JOIN courses c ON t.course_id = c.course_id WHERE \"instructors_AFM\" = ? ORDER BY title";
	private static final String SELECT_NEW_GRADES_BY_COURSE = "SELECT students_registration_id FROM enrolled_courses WHERE course_id = ? AND status = 'pending' "
			+ "ORDER BY students_registration_id";
	private static final String INSERT_NEW_COURSE = "UPDATE enrolled_courses SET status = 'finished', assignment_grade = ?, exam_grade = ?, final_grade = ? WHERE students_registration_id = ? AND course_id = ?";
	private static final String UPDATE_COURSE = "UPDATE enrolled_courses SET assignment_grade = ?, exam_grade = ?, final_grade = ? WHERE students_registration_id = ? AND course_id = ?";
	private static final String SELECT_COURSE_GRADES_LIMIT = "SELECT students_registration_id, assignment_grade, exam_grade, final_grade FROM enrolled_courses WHERE final_grade IS NOT NULL AND course_id = ? "
			+ "ORDER BY students_registration_id DESC OFFSET ? LIMIT ?";
	private static final String SELECT_COUNT_COURSE_GRADES = "SELECT count(students_registration_id) FROM enrolled_courses WHERE final_grade IS NOT NULL AND course_id = ?";
	
	//todo inform instructor for new grades
	public List<Course> getTeachesCourses(String afm) {
		List<Course> titles = new ArrayList<Course>();

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_TEACHES_TITLES_BY_AFM);
			preparedStatement.setString(1, afm);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String courseId = rs.getString("courseId");
				String title = rs.getString("title");

				titles.add(new Course(courseId, title));
			}

			return titles;

		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}

	}

	public List<String> getNewGradeStudents(String courseId) {
		List<String> students = new ArrayList<String>();
		
		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_NEW_GRADES_BY_COURSE);
			preparedStatement.setString(1, courseId);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String student = String.valueOf(rs.getInt("students_registration_id"));

				students.add(student);
			}

			return students;

		} catch (SQLException | ClassNotFoundException e) {
			e.printStackTrace();
			return null;
		}

	}

	public List<Grade> getCourseGradesByLimiting(String courseId, int offset, int limit){
		List<Grade> grades = new ArrayList<Grade>();

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSE_GRADES_LIMIT);
			preparedStatement.setString(1, courseId);
			preparedStatement.setInt(2, offset);
			preparedStatement.setInt(3, limit);
			
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				int studentsRegistrationId = rs.getInt("studentsRegistrationId");
				int assignmentGrade = rs.getInt("assignmentGrade");
				int examGrade = rs.getInt("examGrade");
				String finalGrade = rs.getString("finalGrade");
				
				grades.add(new Grade(courseId, studentsRegistrationId, assignmentGrade, examGrade, finalGrade));

			}

			return grades;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public int getCourseGradesCount(String courseId) {
		int studentsCount = 0;

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COUNT_COURSE_GRADES);
			preparedStatement.setString(1, courseId);
			
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			if (rs.next()) {
				studentsCount = rs.getInt("count");

			}
			
			return studentsCount;
			
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}

	}
	
	public void insertGrade(int registrationId, String courseId, int assignmentGrade, int examGrade, int finalGrade) throws InvalidInputException, ClassNotFoundException, SQLException {
		
		if (!gradesAreValid(assignmentGrade, examGrade, finalGrade)) throw new InvalidInputException("<strong>Σφάλμα!</strong> Λάθος στοιχεία εισαγωγής. Προσπαθήστε ξανά.");
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_NEW_COURSE);
		preparedStatement.setInt(1, assignmentGrade);
		preparedStatement.setInt(2, examGrade);
		preparedStatement.setInt(3, finalGrade);
		preparedStatement.setInt(4, registrationId);
		preparedStatement.setString(5, courseId);

		preparedStatement.executeUpdate();

		System.out.println("Grade has been updated.");

		connection.close();
		
	}
	
	public void updateGrade(int registrationId, String courseId, int assignmentGrade, int examGrade, int finalGrade) throws InvalidInputException, ClassNotFoundException, SQLException {
		
		if (!gradesAreValid(assignmentGrade, examGrade, finalGrade)) throw new InvalidInputException("<strong>Σφάλμα!</strong> Λάθος στοιχεία εισαγωγής. Προσπαθήστε ξανά.");
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_COURSE);
		preparedStatement.setInt(1, assignmentGrade);
		preparedStatement.setInt(2, examGrade);
		preparedStatement.setInt(3, finalGrade);
		preparedStatement.setInt(4, registrationId);
		preparedStatement.setString(5, courseId);

		preparedStatement.executeUpdate();

		System.out.println("Grade has been updated.");

		connection.close();
		
	}
	
	private boolean gradesAreValid(int assignmentGrade, int examGrade, int finalGrade) {
		
		if (finalGrade < 0 || finalGrade > 10) return false;
		
		if (assignmentGrade < 0 || assignmentGrade > 10) return false;

        return examGrade >= 0 && examGrade <= 10;

    }
	
}
