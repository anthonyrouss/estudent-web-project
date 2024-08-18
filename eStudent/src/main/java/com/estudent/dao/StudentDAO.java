package com.estudent.dao;

import com.estudent.model.Course;
import com.estudent.model.Grade;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import static com.estudent.dao.CommonValues.*;

public class StudentDAO {

	private static final String SELECT_BY_SEMESTER = "SELECT * FROM courses WHERE semester = ?";
	private static final String SELECT_GRADES_BY_ID = "SELECT c.course_id AS code, c.title, c.type, c.semester, c.ects, ec.final_grade FROM enrolled_courses ec "
			+ "JOIN courses c ON ec.course_id = c.course_id WHERE students_registration_id = ?";
	private static final String SELECT_GRADES_BY_SEMESTER = "SELECT c.course_id AS code, c.title, c.type, c.semester, c.ects, ec.final_grade FROM enrolled_courses ec "
			+ "JOIN courses c ON ec.course_id = c.course_id WHERE students_registration_id = ? AND semester = ? ORDER BY title";
	private static final String SELECT_ENROLLED_COURSES_BY_SEMESTER_ID = "SELECT c.course_id, title, semester, type, ects, requires_final_exams, status FROM courses c "
			+ "LEFT JOIN (SELECT * FROM enrolled_courses WHERE students_registration_id = ?) ec ON "
			+ "ec.course_id = c.course_id WHERE c.semester = ?";


	public List<Course> getCoursesForEnrollement(int studentId, int semester) throws ClassNotFoundException, SQLException {
		ArrayList<Course> list = new ArrayList<>();

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ENROLLED_COURSES_BY_SEMESTER_ID);
		preparedStatement.setInt(1, studentId);
		preparedStatement.setInt(2, semester);
		
		ResultSet rs = preparedStatement.executeQuery();
		connection.close();

		while (rs.next()) {
			String courseId = rs.getString("course_id");
			String title = rs.getString("title");
			int cSemester = rs.getInt("semester");
			String type = rs.getString("type");
			int ects = rs.getInt("ects");
			boolean isEnrolled = (rs.getString("status") == null) ? false : true;
			boolean requiresFinalExams = rs.getBoolean("requiresFinalExams");

			list.add(new Course(courseId, title, cSemester, type, ects, requiresFinalExams, isEnrolled));
		}

		return list;

	}
	
	
	public List<Grade> returnGradesBySemester(int id, int semester) throws ClassNotFoundException, SQLException {
		ArrayList<Grade> list = new ArrayList<>();

		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_GRADES_BY_SEMESTER);
		preparedStatement.setInt(1, id);
		preparedStatement.setInt(2, semester);
		ResultSet rs = preparedStatement.executeQuery();
		connection.close();

		while (rs.next()) {
			String code = rs.getString("code");
			String title = rs.getString("title");
			String type = rs.getString("type");
			int ects = rs.getInt("ects");
			String finalGrade = String.valueOf(rs.getInt("finalGrade"));

			list.add(new Grade(code, title, type, ects, finalGrade));
		}

		return list;

	}

	
}
