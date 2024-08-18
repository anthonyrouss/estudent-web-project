package com.estudent.servlets;

import com.estudent.dao.SecretaryDAO;
import com.estudent.exceptions.InvalidInputException;
import com.estudent.model.Instructor;
import com.estudent.model.Message;
import com.estudent.model.StringCodes;
import com.estudent.model.Student;
import com.estudent.model.User;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static com.estudent.model.StringCodes.*;

@WebServlet("/secretary")
public class SecretaryServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	private static final String alphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ" + "0123456789"
			+ "abcdefghijklmnopqrstuvxyz";
	
	private SecretaryDAO connection;
	private HttpSession session;
	
	public SecretaryServlet() {
		connection = new SecretaryDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		String action = request.getParameter("action");
		
		switch (action) {
			
		case "new-course":
			this.insertNewCourse(request, response);
			break;
		
		case "update-course":
			this.updateCourse(request, response);
			break;

		case "delete-course":
			this.deleteCourse(request, response);
			break;

		case "set-teaches":
			this.setCourseToInstructor(request, response);
			break;
			
		case "delete-teaches":
			this.deleteTeaches(request, response);
			break;
		
		case "set-listing":
			this.setNewListing(request, response);
			break;
		
		case "fetch-user":
			this.fetchUser(request, response);
			break;
			
		case "new-instructor":
			System.out.println("new instructor");
			this.insertNewInstructor(request, response);
			break;
			
		case "new-secretary":
			this.insertNewSecretary(request, response);
			break;
			
		case "new-student":
			this.insertNewStudent(request, response);
			break;
		
		case "delete-user":
			this.deleteUser(request, response);
			break;

		}

		System.out.println("Out of Secretary action switch");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		this.doGet(request, response);
	}

	private String getAlphaNumericString(int n) {

		// create StringBuffer size of AlphaNumericString
		StringBuilder sb = new StringBuilder(n);

		for (int i = 0; i < n; i++) {

			// generate a random int between
			// 0 to AlphaNumericString variable length
			int index = (int) (alphaNumericString.length() * Math.random());

			// add Character one by one in end of sb
			sb.append(alphaNumericString.charAt(index));
		}

		return sb.toString();
	}

	private void setCourseToInstructor(HttpServletRequest request, HttpServletResponse response) {

		session = request.getSession();

		try {
			String instructorAfm = request.getParameter("selected_instructor");
			String courseId = request.getParameter("selected_course");
			int rankPosition = Integer.parseInt(request.getParameter("selected_rank"));
			String instructorRank = Instructor.getInstructor_ranks()[rankPosition];
			System.out.println(instructorRank + " " + Instructor.getInstructor_ranks()[rankPosition]);

			connection.setCourseToInstructor(instructorAfm, courseId, instructorRank);

			session.setAttribute("course_to_instructor_alert", SUCCESS_TEACHES_INSERT);

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			session.setAttribute("course_to_instructor_alert", ERROR_GENERAL_ERROR);

		} catch (InvalidInputException e2) {
			session.setAttribute("course_to_instructor_alert", WARNING_TEACHES_ALREADY_EXISTS);
		}

		try {
			response.sendRedirect(request.getContextPath() + "/secretary/courses/course-to-instructor.jsp");
		} catch (IOException e) {
			e.printStackTrace();
		}

	}

	private void setNewListing(HttpServletRequest request, HttpServletResponse response) {
		
		session = request.getSession();
		
		try {
			String courseId = request.getParameter("courseId");
			
			connection.setNewListing(courseId);
			
			session.setAttribute("new_listing_alert", SUCCESS_SET_LISTING);
			
		} catch (ClassNotFoundException | SQLException e) {
			session.setAttribute("new_listing_alert", ERROR_GENERAL_ERROR);
			e.printStackTrace();
		} 
		
		try {
			response.sendRedirect(request.getContextPath() + "/secretary/grades/grade-listings.jsp");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
	
	private void deleteTeaches(HttpServletRequest request, HttpServletResponse response) {
		// Get the session
		session = request.getSession();

		try {
			String instructorAfm = request.getParameter("instructorAfm");
			instructorAfm = instructorAfm.replace(" ", "");

			String courseId = (String) request.getParameter("courseId");

			// Try to delete teaches
			connection.deleteTeaches(instructorAfm, courseId);

			session.setAttribute("course_to_instructor_alert", SUCCESS_DELETE_TEACHES);

		} catch (ClassNotFoundException | SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			session.setAttribute("course_to_instructor_alert", ERROR_GENERAL_ERROR);

		} catch (InvalidInputException e2) {
			session.setAttribute("course_to_instructor_alert", ERROR_TEACHES_NO_ROW);
		}

		try {
			response.sendRedirect(request.getContextPath() + "/secretary/courses/course-to-instructor.jsp");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void deleteUser(HttpServletRequest request, HttpServletResponse response) {
		// Get the session
				session = request.getSession();

				try {
					String username = request.getParameter("username");

					// Try to delete user
					connection.deleteUser(username);

					session.setAttribute("all_users_alert", SUCCESS_DELETED_USER);

				} catch (ClassNotFoundException | SQLException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					session.setAttribute("all_users_alert", ERROR_GENERAL_ERROR);

				} catch (InvalidInputException e2) {
					session.setAttribute("all_users_alert", new Message(e2.getMessage(), "alert-danger"));
				}

				try {
					response.sendRedirect(request.getContextPath() + "/secretary/users/show-users.jsp");
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	}

	private void insertNewCourse(HttpServletRequest request, HttpServletResponse response) {

		session = request.getSession();

		try {
			String courseId = request.getParameter("courseId").toUpperCase();
			String title = decodeGreekText(request.getParameter("title"));
			int semester = Integer.parseInt(request.getParameter("semester"));
			String type = decodeGreekText(request.getParameter("type"));
			int ects = Integer.parseInt(request.getParameter("ects"));
			boolean hasExams = Boolean.parseBoolean(request.getParameter("exams"));
			
			connection.insertNewCourse(courseId, title, semester, type, ects, hasExams);

			session.setAttribute("all_courses_alert", SUCCESS_INSERT_NEW_COURSE);

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			session.setAttribute("all_courses_alert", ERROR_GENERAL_ERROR);

		} catch (InvalidInputException e2) {
			session.setAttribute("all_courses_alert", new Message(e2.getMessage(), "alert-danger"));
		}

		try {
			response.sendRedirect(request.getContextPath() + "/secretary/courses/show-courses.jsp");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}
	
	private void updateCourse(HttpServletRequest request, HttpServletResponse response) {
		session = request.getSession();
		
		try {
			String courseId = request.getParameter("courseId");
			String title = decodeGreekText(request.getParameter("title"));
			int semester = Integer.parseInt(request.getParameter("semester"));
			String type = decodeGreekText(request.getParameter("type"));
			int ects = Integer.parseInt(request.getParameter("ects"));
			boolean hasExams = decodeGreekText(request.getParameter("exams")).equalsIgnoreCase("Γραπτή εξέταση") ? true : false;
			
			// Debugging reasons
			System.out.println("Updating course... " + courseId + " " + title + " " + semester + " " + type + " " + ects + " " + hasExams);
			
			connection.updateCourse(courseId, title, semester, type, ects, hasExams);
			session.setAttribute("all_courses_alert", SUCCESS_UPDATE_COURSE);

		} catch (ClassNotFoundException | SQLException e) {
			e.printStackTrace();
			session.setAttribute("all_courses_alert", ERROR_GENERAL_ERROR);
		} 
		
		try {
			response.sendRedirect(request.getContextPath() + "/secretary/courses/show-courses.jsp");
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	private void deleteCourse(HttpServletRequest request, HttpServletResponse response) {
		// Get session
		session = request.getSession();
		
		String courseId = request.getParameter("courseId");

		try {
			connection.deleteCourseByID(courseId);
			
			session.setAttribute("all_courses_alert", SUCCESS_DELETE_COURSE);
			
		} catch (ClassNotFoundException | SQLException e1) {
			e1.printStackTrace();
		}

		try {
			response.sendRedirect(request.getContextPath() + "/secretary/courses/show-courses.jsp");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	private void fetchUser(HttpServletRequest request, HttpServletResponse response) {
		  
		
		session = request.getSession();
		
		String username = request.getParameter("username");
		String role = request.getParameter("role");
		
		connection.setUserAttributesToRequest(username, role, request);
		
		RequestDispatcher rd = request.getRequestDispatcher("/secretary/users/show-users.jsp");
		
		try {
			rd.forward(request, response);
		} catch (ServletException | IOException e) {
			e.printStackTrace();
			
		}

	}
	
	private String decodeGreekText(String text) {
		
		// If the text is Greek, this method is making it readable
		
		byte[] bytes = text.getBytes(StandardCharsets.ISO_8859_1);
		return new String(bytes, StandardCharsets.UTF_8);
	}

	private void insertNewInstructor(HttpServletRequest request, HttpServletResponse response) {
		
		System.out.println("new instructor inside");
		session = request.getSession();
		
		String firstName =  decodeGreekText(request.getParameter("firstName"));
		String lastName =  decodeGreekText(request.getParameter("lastName"));
		String gender =  decodeGreekText(request.getParameter("gender"));
		String role = "Instructor";
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		
		// generate a salt
		String salt = getAlphaNumericString(16);

		String afm = request.getParameter("afm");
		String department = decodeGreekText(request.getParameter("department"));
		String office = decodeGreekText(request.getParameter("office"));
		String website = request.getParameter("website");
		
		MessageDigest digest;
		
		try {
			password = password+salt;
			digest = MessageDigest.getInstance("SHA-1");
			byte[] encodedhash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
			password = connection.bytesToHex(encodedhash);
			
		} catch (NoSuchAlgorithmException e1) {
			e1.printStackTrace();
		}
	
		
		Instructor newInstructor = new Instructor(afm, username, firstName, lastName, phone, gender, role, email, department, office, website, salt, password);
		
		
		try {
			connection.insertNewInstructor(newInstructor);
			
			session.setAttribute("new_user_alert", new Message("Επιτυχής προσθήκη καθηγητή!", "alert-success"));
			
		} catch (Exception e) {
			session.setAttribute("new_user_alert", new Message(e.getMessage(), "alert-danger"));
			e.printStackTrace();
		}
		
		try {
			response.sendRedirect(request.getContextPath() + "/secretary/users/add-user.jsp?role=Instructor");
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
	private void insertNewStudent(HttpServletRequest request, HttpServletResponse response) {
		
		System.out.println("new students inside");
		session = request.getSession();
		
		String firstName =  decodeGreekText(request.getParameter("firstName"));
		String lastName =  decodeGreekText(request.getParameter("lastName"));
		String gender =  decodeGreekText(request.getParameter("gender"));
		String role = "Student";
		
		String username = request.getParameter("username");
		int registration_id = Integer.parseInt(username);
		username = "p"+username;
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		
		// generate a salt
		String salt = getAlphaNumericString(16);

		String pResidence = decodeGreekText(request.getParameter("pResidence"));
		String tResidence = decodeGreekText(request.getParameter("tResidence"));
		String wayOfEntry = decodeGreekText(request.getParameter("wayOfEntry"));
		
		int yearOfEntry = Integer.parseInt(request.getParameter("yearOfEntry"));
		String classTitle = decodeGreekText(request.getParameter("class"));
		boolean foodClubAccess = Boolean.parseBoolean(request.getParameter("foodClubAccess"));
		
		MessageDigest digest;
		
		try {
			password = password+salt;
			digest = MessageDigest.getInstance("SHA-1");
			byte[] encodedHash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
			password = connection.bytesToHex(encodedHash);
			
		} catch (NoSuchAlgorithmException e1) {
			e1.printStackTrace();
		}
	
		Student newStudent = new Student(registration_id, username, firstName, lastName, phone, gender, email, pResidence, tResidence, classTitle, 0, wayOfEntry, yearOfEntry, 0, foodClubAccess, salt, password);
		
		
		try {
			connection.insertNewStudent(newStudent);
			
			session.setAttribute("new_user_alert", new Message("Επιτυχής προσθήκη φοιτητή!", "alert-success"));
			
		} catch (Exception e) {
			session.setAttribute("new_user_alert", new Message(e.getMessage(), "alert-danger"));
			e.printStackTrace();
		} 
		
		try {
			response.sendRedirect(request.getContextPath() + "/secretary/users/add-user.jsp?role=Student");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	private void insertNewSecretary(HttpServletRequest request, HttpServletResponse response) {
		
		System.out.println("new secretary inside");
		session = request.getSession();
		
		String firstName =  decodeGreekText(request.getParameter("firstName"));
		String lastName =  decodeGreekText(request.getParameter("lastName"));
		String gender =  decodeGreekText(request.getParameter("gender"));
		String role = "Secretary";
		
		String username = request.getParameter("username");
		String password = request.getParameter("password");
		String email = request.getParameter("email");
		String phone = request.getParameter("phone");
		
		// generate a salt
		String salt = getAlphaNumericString(16);
		
		MessageDigest digest;
		
		try {
			password = password+salt;
			digest = MessageDigest.getInstance("SHA-1");
			byte[] encodedHash = digest.digest(password.getBytes(StandardCharsets.UTF_8));
			password = connection.bytesToHex(encodedHash);
			
		} catch (NoSuchAlgorithmException e1) {
			e1.printStackTrace();
		}
	
		User newSecretary = new User(username, firstName, lastName, phone, gender, role, email, salt, password);
		
		
		try {
			connection.insertNewSecretary(newSecretary);
			
			session.setAttribute("new_user_alert", new Message("Επιτυχής προσθήκη καθηγητή!", "alert-success"));
			
		} catch (Exception e) {
			session.setAttribute("new_user_alert", new Message(e.getMessage(), "alert-danger"));
			e.printStackTrace();
		}
		
		try {
			response.sendRedirect(request.getContextPath() + "/secretary/users/add-user.jsp?role=Instructor");
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
}
