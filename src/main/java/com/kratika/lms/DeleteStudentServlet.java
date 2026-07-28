package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteStudentServlet")
public class DeleteStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String rollNo = request.getParameter("id");

        if (rollNo != null && !rollNo.trim().isEmpty()) {
            try {
                Connection con = DBConnection.getConnection();
                String sql = "DELETE FROM students WHERE roll_no=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, rollNo);

                int status = ps.executeUpdate();
                con.close();

                if (status > 0) {
                    response.sendRedirect("view_student.jsp?status=deleted");
                } else {
                    response.sendRedirect("view_student.jsp?status=failed");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("view_student.jsp?status=error");
            }
        } else {
            response.sendRedirect("view_student.jsp");
        }
    }
}