package com.estudent.servlets;

import com.estudent.model.StringCodes;
import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	public LogoutServlet() {
		super();
	}
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		try {
			HttpSession session = request.getSession();

			session.removeAttribute("logged_in_user");
			session.removeAttribute("logged_in_user_role");
			session.invalidate();
			
			
			//TODO change
			session = request.getSession();
			
			session.setAttribute("login_alert", StringCodes.SUCCESS_LOGOUT);
			response.sendRedirect("login.jsp");
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		this.doGet(request, response);
	}
}
