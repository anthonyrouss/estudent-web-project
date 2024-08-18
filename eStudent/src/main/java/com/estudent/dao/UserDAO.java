package com.estudent.dao;

import com.estudent.exceptions.InvalidInputException;
import com.estudent.model.Instructor;
import com.estudent.model.Student;
import com.estudent.model.User;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import static com.estudent.dao.CommonValues.*;

public class UserDAO {

	private static final String SELECT_USER_WHERE = "SELECT * FROM users WHERE username = ? AND password = ?";
	private static final String SELECT_USER_ROLE = "SELECT role FROM users WHERE username = ? AND password = ?";
	private static final String SELECT_STUDENT_BY_USERNAME = "SELECT * FROM users u JOIN students s "
			+ "ON username = users_username WHERE username = ?";
	private static final String SELECT_INSTRUCTOR_BY_USERNAME = "SELECT * FROM users u JOIN instructors i "
			+ "ON username = users_username WHERE username = ?";
	

	public UserDAO() {
	}

	public String bytesToHex(byte[] hash) {
		StringBuffer hexString = new StringBuffer();
		for (int i = 0; i < hash.length; i++) {
			String hex = Integer.toHexString(0xff & hash[i]);
			if (hex.length() == 1)
				hexString.append('0');
			hexString.append(hex);
		}
		return hexString.toString();
	}

	
	public void checkForNullInputs(String username, String password) {
		String usernameNoSpaces = username.replace(" ", "");
		String passwordNoSpaces = password.replace(" ", "");
		
		if(usernameNoSpaces == "" || passwordNoSpaces == "") throw new InvalidInputException("1 or more empty input fields.");
		
		
		
	}
	
	public String getSalt(String username) throws ClassNotFoundException, SQLException {

		String salt = null;

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement("SELECT salt FROM users WHERE username=?");
		preparedStatement.setString(1, username);

		ResultSet rs = preparedStatement.executeQuery();

		if (rs.next()) {
			salt = rs.getString("salt");
		}

		return salt;
	}

	public User getUser(String uName, String uPass) throws ClassNotFoundException, SQLException {

		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_WHERE);
		preparedStatement.setString(1, uName);
		preparedStatement.setString(2, uPass);
		ResultSet rs = preparedStatement.executeQuery();

		connection.close();

		if (rs.next()) {
			String username = rs.getString("username");
			String firstName = rs.getString("firstName");
			String lastName = rs.getString("lastName");
			String phone = rs.getString("phone");
			String gender = rs.getString("gender");
			String email = rs.getString("email");
			
			System.out.println(username+ " " + firstName+ " " +lastName+ " " +phone+ " " +gender+ " " +email);
			return new User(username, firstName, lastName, phone, gender, email);
			
			
		}

		return null;
	}

	public String getUserRole(String uName, String uPass) throws ClassNotFoundException, SQLException{
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_USER_ROLE);
		preparedStatement.setString(1, uName);
		preparedStatement.setString(2, uPass);
		ResultSet rs = preparedStatement.executeQuery();

		connection.close();

		if (rs.next()) {
			String role = rs.getString("role");
			return role;
		}

		return null;
		
	}
	
	public Student getStudentCredentials(String uName) throws ClassNotFoundException, SQLException{
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_STUDENT_BY_USERNAME);
		preparedStatement.setString(1, uName);
		ResultSet rs = preparedStatement.executeQuery();

		connection.close();
		
		if (rs.next()) {
			int registration_id = rs.getInt("registration_id");
			String username = rs.getString("username");
			String firstName = rs.getString("firstName");
			String lastName = rs.getString("lastName");
			String phone = rs.getString("phone");
			String gender = rs.getString("gender");
			String email = rs.getString("email");
			String permanentResidence = rs.getString("permanentResidence");
			String temporaryResidence = rs.getString("temporaryResidence");
			String classTitle = rs.getString("classTitle");
			int currentSemester = rs.getInt("currentSemester");
			String wayOfEntry = rs.getString("wayOfEntry");
			int yearOfEntry = rs.getInt("yearOfEntry");
			int ects = rs.getInt("ects");
			boolean foodClubAccess = rs.getBoolean("foodClubAccess");
			
			return new Student(registration_id, username, firstName, lastName, phone, gender, email, permanentResidence, temporaryResidence, classTitle,
					currentSemester, wayOfEntry, yearOfEntry, ects, foodClubAccess);
		}

		return null;
		
	}
	
	public Instructor getInstructorCredentials(String uName) throws ClassNotFoundException, SQLException{
		
		Class.forName("org.postgresql.Driver");
		Connection connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

		PreparedStatement preparedStatement = connection.prepareStatement(SELECT_INSTRUCTOR_BY_USERNAME);
		preparedStatement.setString(1, uName);
		ResultSet rs = preparedStatement.executeQuery();

		connection.close();
		
		if(rs.next()) {
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
			
			return new Instructor(afm, username, firstName, lastName, phone, gender, email, department, office, website);
		}
		
		return null;
		
	}
	
}
