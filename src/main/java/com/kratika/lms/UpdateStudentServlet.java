package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateStudentServlet")
public class UpdateStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Fetching registration structural inputs from the submission request
        String rollNo = request.getParameter("rollNo");
        String fullName = request.getParameter("fullName");
        String course = request.getParameter("course");
        String batch = request.getParameter("batch");
        String semester = request.getParameter("semester");
        String phoneNo = request.getParameter("phoneNo");
        String email = request.getParameter("email");

        // ==================== STRICT SERVER-SIDE VALIDATION ====================

        if (rollNo == null || rollNo.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                course == null || course.trim().isEmpty() ||
                batch == null || batch.trim().isEmpty() ||
                semester == null || semester.trim().isEmpty() ||
                phoneNo == null || phoneNo.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {

            response.sendRedirect("view_student.jsp?status=empty_fields");
            return;
        }

        // Check if phone format matches baseline length configurations
        if(phoneNo.trim().length() != 10) {
            response.sendRedirect("view_student.jsp?status=invalid_phone");
            return;
        }

        // ==================== DATABASE OPERATION ====================

        try {
            Connection con = DBConnection.getConnection();

            // Processing the update matching exactly with table schema values
            String sql = "UPDATE students SET full_name=?, course=?, batch=?, semester=?, phone_no=?, email=? WHERE roll_no=?";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, fullName.trim());
            ps.setString(2, course.trim());
            ps.setString(3, batch.trim());
            ps.setString(4, semester.trim());
            ps.setString(5, phoneNo.trim());
            ps.setString(6, email.trim());
            ps.setString(7, rollNo.trim()); // Targeted matching constraint

            int status = ps.executeUpdate();

            if (status > 0) {
                response.sendRedirect("view_student.jsp?status=updated");
            } else {
                response.sendRedirect("view_student.jsp?status=failed");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view_student.jsp?status=error");
        }
    }
}