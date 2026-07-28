<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/15/2026
  Time: 3:17 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%
    String id = request.getParameter("id");
    try {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("DELETE FROM books WHERE Accession_no = ?");
        ps.setString(1, id);

        int i = ps.executeUpdate();
        if(i > 0) {
            response.sendRedirect("view_book.jsp?msg=deleted");
        } else {
            response.sendRedirect("view_book.jsp?msg=error");
        }
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
        response.sendRedirect("view_book.jsp?msg=error");
    }
%>
