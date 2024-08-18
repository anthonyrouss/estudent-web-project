<%@ page import="com.estudent.model.Secretary" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% Secretary logged_in_user = (Secretary) session.getAttribute("logged_in_user"); %>
<table>
  <tr>
    <td>First Name: </td>
    <td><%= logged_in_user.getFirstName() %></td>
  </tr>
  <tr>
    <td>Last Name: </td>
    <td><%= logged_in_user.getLastName() %></td>
  </tr>
</table>