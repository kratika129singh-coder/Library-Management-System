package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/RegisterFacultyServlet")
public class RegisterFacultyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. JSP Form ke fields se data fetch karna
        String facultyId = request.getParameter("facultyId");
        String fullName = request.getParameter("fullName");
        String course = request.getParameter("course");
        String designation = request.getParameter("designation");
        String joiningYear = request.getParameter("joiningYear");
        String phoneNo = request.getParameter("phoneNo");

        // 2. Server-side Validation Check (Kuch khali toh nahi chuta)
        if (facultyId == null || facultyId.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                course == null || course.trim().isEmpty() ||
                designation == null || designation.trim().isEmpty() ||
                joiningYear == null || joiningYear.trim().isEmpty() ||
                phoneNo == null || phoneNo.trim().isEmpty()) {

            response.sendRedirect("faculty_reg.jsp?status=empty_fields");
            return;
        }

        try {
            // 3. Database Connection setup karna
            Connection con = DBConnection.getConnection();

            // 4. SQL Insert Query taiyaar karna
            String sql = "INSERT INTO faculty (faculty_id, full_name, department, designation, joining_year, phone_no) VALUES (?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, facultyId.trim());
            ps.setString(2, fullName.trim());
            ps.setString(3, course.trim()); // Mapping to department
            ps.setString(4, designation.trim());
            ps.setInt(5, Integer.parseInt(joiningYear.trim())); // Integer Conversion 4-digit ke liye
            ps.setString(6, phoneNo.trim());

            // 5. Query execute karna
            int status = ps.executeUpdate();

            if (status > 0) {
                // Success redirect
                response.sendRedirect("faculty_reg.jsp?status=success");
            } else {
                // Fail redirect
                response.sendRedirect("faculty_reg.jsp?status=failed");
            }

            // Connection safe close karna
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            // Agar duplicate Faculty ID enter ho jaye toh catch block handles it
            response.sendRedirect("faculty_reg.jsp?status=duplicate");
        }
    }
}