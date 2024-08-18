package com.estudent.servlets;

import static com.estudent.model.StringCodes.WARNING_TEACHES_ALREADY_EXISTS;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.estudent.dao.InstructorDAO;
import com.estudent.dao.SecretaryDAO;
import com.estudent.exceptions.InvalidInputException;
import com.estudent.model.Message;

import static com.estudent.model.StringCodes.*;

@WebServlet("/instructor")
public class InstructorServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	private InstructorDAO connection;
	private HttpSession session;
    
    public InstructorServlet() {
        super();
        connection = new InstructorDAO();
    }

	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		
		switch(action) {
		case "insert-grade":
			this.insertGrade(request, response);
			break;
		case "update-grade":
			this.updateGrade(request, response);
			break;
		}
		
	}

	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

	private void insertGrade(HttpServletRequest request, HttpServletResponse response) {
		
		session = request.getSession();
		
		int assignmentGrade, examGrade, finalGrade;
		
		String course_id = request.getParameter("course_id");
		
		try {
			int registration_id = Integer.parseInt(request.getParameter("registration_id"));
			
			try {
				finalGrade = Integer.parseInt(request.getParameter("finalGrade"));
			} catch (NumberFormatException e) {
				throw new InvalidInputException("<strong>Σφάλμα!</strong> Ελέγξτε ξανά τον τελικό βαθμό.");
			}
			
			try {
				assignmentGrade = Integer.parseInt(request.getParameter("assignmentGrade"));
			} catch (NumberFormatException e) {
				assignmentGrade = 0;
			}
			
			try {
				examGrade = Integer.parseInt(request.getParameter("examGrade"));
			} catch (NumberFormatException e) {
				examGrade = 0;
			}
			

			connection.insertGrade(registration_id, course_id, assignmentGrade, examGrade, finalGrade);
			
			session.setAttribute("insert_grade_alert", SUCCESS_INSERTED_GRADE);
			
		
		} catch (InvalidInputException e) {
			session.setAttribute("insert_grade_alert", new Message(e.getMessage() , "alert-danger"));
			
		} catch (ClassNotFoundException | SQLException e) {
			session.setAttribute("insert_grade_alert", ERROR_GENERAL_ERROR);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			response.sendRedirect(request.getContextPath() + "/instructor/grades/new-grades.jsp?course_id="+course_id);
		} catch (IOException e) {
			e.printStackTrace();
		}
		

		
	}
	
	private void updateGrade(HttpServletRequest request, HttpServletResponse response) {
		
		session = request.getSession();
		
		int assignmentGrade, examGrade, finalGrade;
		String course_id = request.getParameter("course_id");
		
		try {
			int registrationId = Integer.parseInt(request.getParameter("registrationId"));
			
			try {
				finalGrade = Integer.parseInt(request.getParameter("finalGrade"));
			} catch (NumberFormatException e) {
				throw new InvalidInputException("<strong>Σφάλμα!</strong> Ελέγξτε ξανά τον τελικό βαθμό.");
			}
			
			try {
				assignmentGrade = Integer.parseInt(request.getParameter("assignmentGrade"));
			} catch (NumberFormatException e) {
				assignmentGrade = 0;
			}
			
			try {
				examGrade = Integer.parseInt(request.getParameter("examGrade"));
			} catch (NumberFormatException e) {
				examGrade = 0;
			}
			

			connection.updateGrade(registrationId, course_id, assignmentGrade, examGrade, finalGrade);

			session.setAttribute("all_grades_alert", SUCCESS_UPDATED_GRADE);
			
		
		} catch (InvalidInputException e) {
			session.setAttribute("all_grades_alert", new Message(e.getMessage() , "alert-danger"));
			
		} catch (ClassNotFoundException | SQLException e) {
			session.setAttribute("all_grades_alert", ERROR_GENERAL_ERROR);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		try {
			response.sendRedirect(request.getContextPath() + "/instructor/grades/all-grades.jsp?course_id="+course_id);
		} catch (IOException e) {
			e.printStackTrace();
		}
		
	}
	
}
