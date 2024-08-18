
package com.estudent.dao;

import com.estudent.exceptions.InvalidInputException;
import com.estudent.model.Course;
import com.estudent.model.Instructor;
import com.estudent.model.InstructorTeachesCourse;
import com.estudent.model.Student;
import com.estudent.model.User;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import static com.estudent.dao.CommonValues.*;

public class SecretaryDAO {
	
	private static final String SELECT_USER_BY_USERNAME = "SELECT * FROM users WHERE username = ?";
	private static final String SELECT_STUDENT_BY_USERNAME = "SELECT * FROM users JOIN students ON username = users_username WHERE username = ?";
	private static final String SELECT_INSTRUCTOR_BY_USERNAME = "SELECT * FROM users JOIN instructors ON username = users_username WHERE username = ?";
	
	private static final String SELECT_COURSES_OFFSET_LIMIT = "SELECT * FROM courses ORDER BY semester, title OFFSET ? LIMIT ?";
	private static final String SELECT_USERS_OFFSET_LIMIT = "SELECT username, first_name, last_name, phone, email, role FROM users ORDER BY role OFFSET ? LIMIT ?";
	private static final String SELECT_COUNT_OF_COURSES = "SELECT count(*) AS count FROM courses";
	private static final String SELECT_COUNT_OF_USERS = "SELECT count(*) AS count FROM users";
	private static final String SELECT_COUNT_OF_TEACHES = "SELECT count(*) AS count FROM teaches";
	private static final String SELECT_COUNT_OF_ENROLLED_COURSES = "SELECT count(*) FROM (SELECT DISTINCT course_id FROM enrolled_courses WHERE status = 'enrolled') AS courses;";
	private static final String SELECT_ENROLLED_COURSES_COUNT_OFFSET_LIMIT = "SELECT DISTINCT course_id, title, semester, type, count(students_registration_id) "
			+ "FROM enrolled_courses NATURAL JOIN courses WHERE status = 'enrolled' GROUP BY course_id, title, semester, type "
			+ "ORDER BY semester, title OFFSET ? LIMIT ?";
	private static final String SELECT_ALL_COURSES = "SELECT * FROM courses ORDER BY semester";
	private static final String SELECT_COURSE_BY_ID = "SELECT * FROM courses WHERE course_id = ?";
	private static final String SELECT_ALL_INSTRUCTORS = "SELECT * FROM users u JOIN instructors i ON username = users_username";
	private static final String SELECT_TEACHES = "SELECT * FROM teaches WHERE \"instructors_AFM\" = ? AND course_id = ?";
	private static final String SELECT_TEACHES_OFFSET_LIMIT = "SELECT c.course_id, c.title, c.semester, u.last_name, u.first_name, \"AFM\", rank FROM teaches t "
			+ "JOIN instructors i ON \"AFM\" = \"instructors_AFM\" JOIN users u ON username = users_username "
			+ "JOIN courses c ON c.course_id = t.course_id ORDER BY semester, title OFFSET ? LIMIT ?";
	
	
	private static final String SELECT_USER = "SELECT * FROM users WHERE username = ?";
	private static final String SELECT_INSTRUCTOR = "SELECT * FROM instructors WHERE \"AFM\" = ?";
	private static final String INSERT_STUDENT = "INSERT INTO students VALUES (?, ?, ?, ?, ?, 1, ?, ?, 0, ?)";
	
	private static final String INSERT_TEACHES = "INSERT INTO teaches VALUES (?, ?, ?)";
	private static final String INSERT_COURSE = "INSERT INTO courses VALUES (?, ?, ?, ?, ?, ?)";
	private static final String SET_NEW_LISTING = "UPDATE enrolled_courses SET status = 'pending' WHERE course_id = ?";
	private static final String DELETE_TEACHES = "DELETE FROM teaches WHERE \"instructors_AFM\" = ? AND course_id = ?";
	private static final String DELETE_COURSE = "DELETE FROM courses WHERE course_id = ?";
	private static final String UPDATE_COURSE = "UPDATE courses SET title = ?, semester = ?, type = ?, ects = ?, requires_final_exams = ? WHERE course_id = ?";
	private static final String DELETE_USER = "DELETE FROM users WHERE username = ?";
	
	private static final String INSERT_USER = "INSERT INTO users VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
	private static final String INSERT_INSTRUCTOR = "INSERT INTO instructors VALUES (?, ?, ?, ?, ?)";

	
	public SecretaryDAO() {
	}

	public List<Course> getCoursesByLimiting(int offset, int limit) {
		List<Course> list = new ArrayList<>();

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSES_OFFSET_LIMIT);
			preparedStatement.setInt(1, offset);
			preparedStatement.setInt(2, limit);
			
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String courseId = rs.getString("courseId");
				String title = rs.getString("title");
				int cSemester = rs.getInt("semester");
				String type = rs.getString("type");
				int ects = rs.getInt("ects");
				boolean requiresFinalExams = rs.getBoolean("requiresFinalExams");
				list.add(new Course(courseId, title, cSemester, type, ects, requiresFinalExams));
			}

			return list;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	public List<InstructorTeachesCourse> getTeachesByLimiting(int offset, int limit) {
		List<InstructorTeachesCourse> teachesList = new ArrayList<>();

		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_TEACHES_OFFSET_LIMIT);
			preparedStatement.setInt(1, offset);
			preparedStatement.setInt(2, limit);
			
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String courseId = rs.getString("courseId");
				String title = rs.getString("title");
				String semester = String.valueOf(rs.getInt("semester"));
				String lastName = rs.getString("lastName");
				String firstName = rs.getString("firstName");
				String afm = String.valueOf(rs.getInt("afm"));
				String rank = rs.getString("rank");

				teachesList.add(new InstructorTeachesCourse(courseId, title, semester, lastName, firstName, afm, rank));
			}
			
			return teachesList;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public List<Course> getAllCourses() {
		List<Course> allCourses = new ArrayList<>();

		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_COURSES);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String courseId = rs.getString("courseId");
				String title = rs.getString("title");
				int semester = rs.getInt("semester");
				String type = rs.getString("type");
				int ects = rs.getInt("ects");
				boolean requiresFinalExams = rs.getBoolean("requiresFinalExams");

				allCourses.add(new Course(courseId, title, semester, type, ects, requiresFinalExams));
			}

			return allCourses;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}

	public List<Instructor> getAllInstructors() {
		List<Instructor> instructorsList = new ArrayList<>();

		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ALL_INSTRUCTORS);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String afm = rs.getString("AFM");
				String username = rs.getString("username");
				String firstName = rs.getString("firstName");
				String lastName = rs.getString("lastName");
				String phone = rs.getString("phone");
				String gender = rs.getString("gender");
				String email = rs.getString("email");
				String department = rs.getString("department");
				String office = rs.getString("office");
				String website = rs.getString("website");

				instructorsList.add(new Instructor(afm, username, firstName, lastName, phone, gender, email,
						department, office, website));
			}

			return instructorsList;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}
	
	public List<Course> getEnrolledCoursesByLimiting(int offset, int limit){
		List<Course> enrolledCourses = new ArrayList<>();

		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_ENROLLED_COURSES_COUNT_OFFSET_LIMIT);
			preparedStatement.setInt(1, offset);
			preparedStatement.setInt(2, limit);
			
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String courseId = rs.getString("courseId");
				String title = rs.getString("title");
				int semester = rs.getInt("semester");
				String type = rs.getString("type");
				int count = rs.getInt("count");

				enrolledCourses.add(new Course(courseId, title, semester, type, count));
			}

			return enrolledCourses;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}


	}
	
	public List<User> getUsersByLimiting(int offset, int limit){
		List<User> usersList = new ArrayList<>();

		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USERS_OFFSET_LIMIT);
			preparedStatement.setInt(1, offset);
			preparedStatement.setInt(2, limit);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String username = rs.getString("username");
				String firstName = rs.getString("firstName");
				String lastName = rs.getString("lastName");
				String phone = rs.getString("phone");
				String email = rs.getString("email");
				String role = rs.getString("role");
				
				usersList.add(new User(username, firstName, lastName, phone, email, role));
			
			}

			return usersList;

		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}
	
	public void setUserAttributesToRequest(String username, String role, HttpServletRequest request) {

		switch (role) {
		case "Secretary":
			setSecretaryAttributes(username, request);
		case "Instructor":
			setInstructorAttributes(username, request);
			break;
		case "Student":
			setStudentAttributes(username, request);
			break;
			
		}
		
	}
	
	private void setSecretaryAttributes(String givenUsername, HttpServletRequest request) {

		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_BY_USERNAME);
			preparedStatement.setString(1, givenUsername);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String sUsername = rs.getString("username");
				String firstName = rs.getString("firstName");
				String lastName = rs.getString("lastName");
				String phone = rs.getString("phone");
				String gender = rs.getString("gender");
				String email = rs.getString("email");
				
				request.setAttribute("username", sUsername);
				request.setAttribute("firstName", firstName);
				request.setAttribute("lastName", lastName);
				request.setAttribute("phone", phone);
				request.setAttribute("gender", gender);
				request.setAttribute("email", email);
				
			}

			

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	private void setInstructorAttributes(String givenUsername, HttpServletRequest request) {
		
		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_INSTRUCTOR_BY_USERNAME);
			preparedStatement.setString(1, givenUsername);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String sUsername = rs.getString("username");
				String firstName = rs.getString("firstName");
				String lastName = rs.getString("lastName");
				String phone = rs.getString("phone");
				String gender = rs.getString("gender");
				String email = rs.getString("email");
				
				String afm = rs.getString("AFM");
				String department = rs.getString("department");
				String office = rs.getString("office");
				String website = rs.getString("website");
				
				request.setAttribute("username", sUsername);
				request.setAttribute("firstName", firstName);
				request.setAttribute("lastName", lastName);
				request.setAttribute("phone", phone);
				request.setAttribute("gender", gender);
				request.setAttribute("email", email);
				
				request.setAttribute("afm", afm);
				request.setAttribute("department", department);
				request.setAttribute("office", office);
				request.setAttribute("website", website);
				
			}

			

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	private void setStudentAttributes(String givenUsername, HttpServletRequest request) {
		
		try {

			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_STUDENT_BY_USERNAME);
			preparedStatement.setString(1, givenUsername);

			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			while (rs.next()) {
				String sUsername = rs.getString("username");
				String firstName = rs.getString("firstName");
				String lastName = rs.getString("lastName");
				String phone = rs.getString("phone");
				String gender = rs.getString("gender");
				String email = rs.getString("email");
				
				String pResidence = rs.getString("permanent_residence");
				String tResidence = rs.getString("temporary_residence");
				String classTitle = rs.getString("classTitle");
				int currentSemester = rs.getInt("currentSemester");
				String wayOfEntry = rs.getString("wayOfEntry");
				int yearOfEntry = rs.getInt("yearOfEntry");
				int ects = rs.getInt("ects");
				boolean foodClubAccess = rs.getBoolean("foodClubAccess");
				
				request.setAttribute("username", sUsername);
				request.setAttribute("firstName", firstName);
				request.setAttribute("lastName", lastName);
				request.setAttribute("phone", phone);
				request.setAttribute("gender", gender);
				request.setAttribute("email", email);
				
				request.setAttribute("pResidence", pResidence);
				request.setAttribute("tResidence", tResidence);
				request.setAttribute("classTitle", classTitle);
				request.setAttribute("currentSemester", currentSemester);
				request.setAttribute("wayOfEntry", wayOfEntry);
				request.setAttribute("yearOfEntry", yearOfEntry);
				request.setAttribute("ects", ects);
				request.setAttribute("foodClubAccess", foodClubAccess);
				
			}

			

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	public void insertNewCourse(String courseId, String title, int semester, String type, int ects,
			boolean requiresFinalExams) throws ClassNotFoundException, SQLException {

		if (!courseInputsAreValid(courseId))
			throw new InvalidInputException("Λάθος κωδικός μαθήματος");

		if (existsCourse(courseId))
			throw new InvalidInputException("Ο κωδικός του μαθήματος υπάρχει ήδη.");

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_COURSE);
		preparedStatement.setString(1, courseId);
		preparedStatement.setString(2, title);
		preparedStatement.setInt(3, semester);
		preparedStatement.setString(4, type);
		preparedStatement.setInt(5, ects);
		preparedStatement.setBoolean(6, requiresFinalExams);

		preparedStatement.executeUpdate();

		System.out.println("Course has been added.");

		connection.close();

	}

	
	
	public void insertNewInstructor (Instructor newInstructor) throws ClassNotFoundException, SQLException, InvalidInputException {
		
		checkUserFields(newInstructor.getFirstName(), newInstructor.getLastName(), newInstructor.getGender(), newInstructor.getUsername(), newInstructor.getPassword(), newInstructor.getEmail(), newInstructor.getPhone(), newInstructor.getRole());
		checkInstructorFields(newInstructor.getAfm(), newInstructor.getDepartment(), newInstructor.getOffice(), newInstructor.getWebsite());
		
		// if the inputs are correct
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER);
		preparedStatement.setString(1, newInstructor.getUsername());
		preparedStatement.setString(2, newInstructor.getSalt());
		preparedStatement.setString(3, newInstructor.getPassword());
		preparedStatement.setString(4, newInstructor.getFirstName());
		preparedStatement.setString(5, newInstructor.getLastName());
		preparedStatement.setString(6, newInstructor.getPhone());
		preparedStatement.setString(7, newInstructor.getGender());
		preparedStatement.setString(8, newInstructor.getEmail());
		preparedStatement.setString(9, newInstructor.getRole());
		

		PreparedStatement preparedStatement1 = connection.prepareStatement(INSERT_INSTRUCTOR);
		preparedStatement1.setString(1, newInstructor.getAfm());
		preparedStatement1.setString(2, newInstructor.getUsername());
		preparedStatement1.setString(3, newInstructor.getDepartment());
		preparedStatement1.setString(4, newInstructor.getOffice());
		preparedStatement1.setString(5, newInstructor.getWebsite());
		

		preparedStatement.executeUpdate();
		preparedStatement1.executeUpdate();

		connection.close();
		
	}
	
	public void insertNewStudent(Student newStudent) throws ClassNotFoundException, SQLException {
		
		checkUserFields(newStudent.getFirstName(), newStudent.getLastName(), newStudent.getGender(), newStudent.getUsername(), newStudent.getPassword(), newStudent.getEmail(), newStudent.getPhone(), newStudent.getRole());
		
		if (!validBasicField(newStudent.getPermanentResidence())) throw new InvalidInputException("Μη έγκυρη μόνιμη κατοικία");

		if (!validTresidence(newStudent.getTemporaryResidence())) throw new InvalidInputException("Μη έγκυρη προσωρινή κατοικία");

		if (!validBasicField(newStudent.getClassTitle())) throw new InvalidInputException("Μη έγκυρο τμήμα εισαγωγής");
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER);
		preparedStatement.setString(1, newStudent.getUsername());
		preparedStatement.setString(2, newStudent.getSalt());
		preparedStatement.setString(3, newStudent.getPassword());
		preparedStatement.setString(4, newStudent.getFirstName());
		preparedStatement.setString(5, newStudent.getLastName());
		preparedStatement.setString(6, newStudent.getPhone());
		preparedStatement.setString(7, newStudent.getGender());
		preparedStatement.setString(8, newStudent.getEmail());
		preparedStatement.setString(9, newStudent.getRole());
		
		PreparedStatement preparedStatement1 = connection.prepareStatement(INSERT_STUDENT);
		preparedStatement1.setInt(1, newStudent.getRegistrationId());
		preparedStatement1.setString(2, newStudent.getUsername());
		preparedStatement1.setString(3, newStudent.getPermanentResidence());
		preparedStatement1.setString(4, newStudent.getTemporaryResidence());
		preparedStatement1.setString(5, newStudent.getClassTitle());
		preparedStatement1.setString(6, newStudent.getWayOfEntry());
		preparedStatement1.setInt(7, newStudent.getYearOfEntry());
		preparedStatement1.setBoolean(8, newStudent.isFoodClubAccess());
		
		preparedStatement.executeUpdate();
		preparedStatement1.executeUpdate();
		
		connection.close();
		
	}
	
	public void insertNewSecretary(User newSecretary) throws ClassNotFoundException, InvalidInputException, SQLException {
		
		checkUserFields(newSecretary.getFirstName(), newSecretary.getLastName(), newSecretary.getGender(), newSecretary.getUsername(), newSecretary.getPassword(), newSecretary.getEmail(), newSecretary.getPhone(), newSecretary.getRole());
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		
		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_USER);
		preparedStatement.setString(1, newSecretary.getUsername());
		preparedStatement.setString(2, newSecretary.getSalt());
		preparedStatement.setString(3, newSecretary.getPassword());
		preparedStatement.setString(4, newSecretary.getFirstName());
		preparedStatement.setString(5, newSecretary.getLastName());
		preparedStatement.setString(6, newSecretary.getPhone());
		preparedStatement.setString(7, newSecretary.getGender());
		preparedStatement.setString(8, newSecretary.getEmail());
		preparedStatement.setString(9, newSecretary.getRole());
		
	}
	
	public void updateCourse(String courseId, String title, int semester, String type, int ects, boolean requiresFinalExams) throws ClassNotFoundException, SQLException {
		
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(UPDATE_COURSE);
		preparedStatement.setString(1, title);
		preparedStatement.setInt(2, semester);
		preparedStatement.setString(3, type);
		preparedStatement.setInt(4, ects);
		preparedStatement.setBoolean(5, requiresFinalExams);
		preparedStatement.setString(6, courseId);

		preparedStatement.executeUpdate();

		System.out.println("Course has been updated.");

		connection.close();
	}

	public void setCourseToInstructor(String instructorAfm, String courseId, String instructorRank)
			throws ClassNotFoundException, SQLException, InvalidInputException {

		if (existsCourseToInstructor(instructorAfm, courseId))
			throw new InvalidInputException("Row already exists.");

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(INSERT_TEACHES);
		preparedStatement.setString(1, instructorAfm);
		preparedStatement.setString(2, courseId);
		preparedStatement.setString(3, instructorRank);

		preparedStatement.executeUpdate();

		connection.close();

	}

	public void setNewListing(String courseId) throws ClassNotFoundException, SQLException {
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(SET_NEW_LISTING);
		preparedStatement.setString(1, courseId);

		preparedStatement.executeUpdate();

		connection.close();
	}
	
	private boolean existsCourseToInstructor(String instructorAfm, String courseId)
			throws ClassNotFoundException, SQLException {

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_TEACHES);
		preparedStatement.setString(1, instructorAfm);
		preparedStatement.setString(2, courseId);

		ResultSet rs = preparedStatement.executeQuery();

		connection.close();

		if (rs.next()) {
			return true;
		}

		return false;
	}

	private boolean courseInputsAreValid(String code) {
		
		// TODO add more input field If's and instead of return throw new InvalidInputException
		System.out.println("In validation");

		if (code.length() != 6)
			return false;
		System.out.println("Course ID validation passed length check");

		if (!(code.matches("[A-Z]{3}[0-9]{3}")))
			return false;
		System.out.println("Course ID validation passed letters check");

		return true;
	}

	private boolean existsCourse(String courseId) throws ClassNotFoundException, SQLException {

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COURSE_BY_ID);
		preparedStatement.setString(1, courseId);

		ResultSet rs = preparedStatement.executeQuery();

		connection.close();

		if (rs.next()) {
			return true;
		}

		return false;
	}

	public int getCountOfCourses() {
		int coursesCount = 0;

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COUNT_OF_COURSES);
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			if (rs.next()) {
				coursesCount = rs.getInt("count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return coursesCount;
	}
	
	public int getCountOfTeaches() {
		int teachesCount = 0;

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COUNT_OF_TEACHES);
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			if (rs.next()) {
				teachesCount = rs.getInt("count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return teachesCount;
	}
	
	public int getCountOfUsers() {
		int usersCount = 0;

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COUNT_OF_USERS);
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			if (rs.next()) {
				usersCount = rs.getInt("count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return usersCount;
	}

	public int getCountOfEnrolledCourses() {
		int coursesCount = 0;

		try {
			Class.forName("org.postgresql.Driver");
			Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

			PreparedStatement preparedStatement = connection.prepareStatement(SELECT_COUNT_OF_ENROLLED_COURSES);
			ResultSet rs = preparedStatement.executeQuery();

			connection.close();

			if (rs.next()) {
				coursesCount = rs.getInt("count");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

		return coursesCount;
	}
	
	public void deleteTeaches(String instructor_AFM, String course_id) throws ClassNotFoundException, SQLException {

		if (!existsCourseToInstructor(instructor_AFM, course_id)) throw new InvalidInputException("Αυτός ο συνδυασμός δεν υπάρχει.");

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(DELETE_TEACHES);
		preparedStatement.setString(1, instructor_AFM);
		preparedStatement.setString(2, course_id);

		preparedStatement.executeUpdate();

		connection.close();

	}
	
	public void deleteUser(String username) throws ClassNotFoundException, SQLException {
		
		if (!usernameExists(username)) throw new InvalidInputException("Αυτός ο χρήστης δεν υπάρχει.");
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(DELETE_USER);
		preparedStatement.setString(1, username);

		preparedStatement.executeUpdate();

		connection.close();
		
	}

	public void deleteCourseByID(String courseId) throws ClassNotFoundException, SQLException {

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(DELETE_COURSE);
		preparedStatement.setString(1, courseId);

		preparedStatement.executeUpdate();

		System.out.println("Course has been deleted.");

		connection.close();

	}
	
	
	private void checkUserFields(String firstName, String lastName, String gender, String tempUsername, String tempPassword, String email, String phone, String role) throws ClassNotFoundException, SQLException, InvalidInputException{
		
		if(usernameExists(tempUsername)) throw new InvalidInputException("Το username υπάρχει ήδη");
		
		if (!validUsername(tempUsername, false)) throw new InvalidInputException("Μη έγκυρο username");

		if (!validName(firstName) ) throw new InvalidInputException("Μη έγκυρο όνομα");
		
		if (!validName(lastName) ) throw new InvalidInputException("Μη έγκυρο επώνυμο");

		if (!validPhone(phone) ) throw new InvalidInputException("Μη έγκυρος αριθμός τηλεφώνου");
		
		if (!validPhone(gender) ) throw new InvalidInputException("Το φύλο δεν είναι έγκυρο");
	
		if (!validEmail(email) ) throw new InvalidInputException("Μη έγκυρο email");
		
	}
	
	private void checkInstructorFields(String afm, String department, String office, String website) throws ClassNotFoundException, SQLException {
		
		if (AfmExists(afm)) throw new InvalidInputException("Ο ΑΦΜ υπάρχει ήδη");
		
		if (!validAFM(afm)) throw new InvalidInputException("Μη έγκυρο ΑΦΜ");
		
		if (!validDep(department)) throw new InvalidInputException("Μη έγκυρο κτήριο");
		
		if (!validOffice(office)) throw new InvalidInputException("Μη έγκυρος κωδικός γραφείου");
		
		if (!validWebsite(website)) throw new InvalidInputException("Μη έγκυρη ιστοσελίδα");
		
	}
	
	private boolean usernameExists(String tempUsername)  throws ClassNotFoundException, SQLException{
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER);
		preparedStatement.setString(1, tempUsername);

		ResultSet rs = preparedStatement.executeQuery();

		connection.close();

		if (rs.next()) {
			return true;
		}

		return false;
	}
	
	public boolean AfmExists(String afm)  throws ClassNotFoundException, SQLException{
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_INSTRUCTOR);
		
		preparedStatement.setString(1, afm);
		ResultSet rs = preparedStatement.executeQuery();

		connection.close();

		if (rs.next()) {
			return true;
		}

		return false;
	}
	
	private boolean validUsername(String username, boolean type) {
		//type = true = student
		if (type) {
			if (username.length() == 6) {
				return true;
			}
		}else
			if (username.length() > 0 && username.length() <= 50) {
				return true;
			}
		
		return false;
	}
	
	private boolean validName(String name) {
		if (name.length() > 0 && name.length() <=50) {
			return true;
		}
		return false;
	}
	
	private boolean validPhone(String phone) {
		if (phone.length() > 0 && phone.length() <= 20) {
			return true;
		}
		return false;
	}
	
	private boolean validGender(String gender) {
		if (gender.length() > 0 && gender.length() <= 20) {
			return true;
		}
		return false;
	}
	
	private boolean validEmail(String email) {
		if (email.length() > 0 && email.length() <= 100) {
			return true;
		}
		return false;
	}
	
	private boolean validAFM(String AFM) {
		if (AFM.length() == 9) {
			return true;
		}
		return false;
	}
	
	private boolean validDep(String department) {
		if (department.length() > 0 && department.length() <= 20) {
			return true;
		}
		return false;
	}
	
	private boolean validOffice(String office) {
		if (office.length() > 0 && office.length() <= 16) {
			return true;
		}
		return false;
	}
	
	private boolean validWebsite(String website) {
		if (website.length() <= 64) {
			return true;
		}
		return false;
	}
	
	private boolean validBasicField(String field) {
		if (field.length() > 0 && field.length() <= 32) {
			return true;
		}
		return false;
	}
	
	private boolean validTresidence(String field) {
		if (field.length() <= 32) {
			return true;
		}
		return false;
	}
	
	public String bytesToHex(byte[] hash) {
	    StringBuffer hexString = new StringBuffer();
	    for (int i = 0; i < hash.length; i++) {
	    String hex = Integer.toHexString(0xff & hash[i]);
	    if(hex.length() == 1) hexString.append('0');
	        hexString.append(hex);
	    }
	    return hexString.toString();
	}


}
