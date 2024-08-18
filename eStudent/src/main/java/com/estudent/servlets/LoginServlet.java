package com.estudent.servlets;

import com.estudent.dao.UserDAO;
import com.estudent.exceptions.InvalidInputException;
import com.estudent.model.StringCodes;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import static com.estudent.model.StringCodes.*;

@WebServlet("/Login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO connection;
    
    public LoginServlet() {
    	super();
    	connection = new UserDAO();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        this.doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
    	
    	HttpSession session = request.getSession();
    	String redirectPage;
        String username = request.getParameter("uname");
        String password = request.getParameter("upass");
        
        // Check if the username exists and fetch the salt
        try {
        	
        	// Check if the input fields are empty, if so throw an InvalidInputException
        	connection.checkForNullInputs(username, password);
        	
        	// Getting the salt from the db if exists
        	String salt = connection.getSalt(username);
        	
        	// Throw InvalidInputException if there is no salt with that username
			if(salt == null) throw new InvalidInputException();
			
			// Adding the salt to the password
			password = password + salt;
			
			// Hash the password
			MessageDigest md = MessageDigest.getInstance("SHA-1");
			byte[] encodedHash = md.digest(password.getBytes(StandardCharsets.UTF_8));
			password = connection.bytesToHex(encodedHash);
			
			// Return the user role if the password is correct
			String userRole = connection.getUserRole(username, password);
			
			// Throw InvalidInputException if there is no user with that credentials
			if(userRole == null) throw new InvalidInputException();
			
			switch (userRole) {
			case "Student":
				session.setAttribute("logged_in_user", connection.getStudentCredentials(username));
				break;
			case "Instructor":
				session.setAttribute("logged_in_user", connection.getInstructorCredentials(username));
				break;
			case "Secretary":
				session.setAttribute("logged_in_user", connection.getUser(username, password));
				break;
			}
			
			// Set some session attributes for the user
			session.setAttribute("logged_in_user_role", userRole);
			
			// Redirect to index page
			redirectPage = "index.jsp";

			
			// Debugging reasons
			System.out.println(userRole);
			System.out.println("Logged in!");
			
			
			
		} catch ( InvalidInputException e1) {
			
			// Exception called: Show login alert and set redirect page to login.jsp
			
			System.out.format("Input Exception: %s", e1.getMessage() + "\n");
			session.setAttribute("login_alert", ERROR_LOGIN_WRONG_CREDENTIALS);
			redirectPage = "login.jsp";
			
		} catch (ClassNotFoundException | SQLException | NoSuchAlgorithmException e2) {
        	e2.printStackTrace();
			session.setAttribute("login_alert", ERROR_GENERAL_ERROR);
        	redirectPage = "login.jsp";
        }
        
        response.sendRedirect(redirectPage);
        
    }
}
