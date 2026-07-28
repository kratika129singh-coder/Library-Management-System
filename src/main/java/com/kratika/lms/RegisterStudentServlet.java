package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/RegisterStudentServlet")
public class RegisterStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. JSP Form se saara data fetch karna (Matching your student_reg.jsp fields)
        String rollNo = request.getParameter("rollNo");
        String fullName = request.getParameter("fullName");
        String course = request.getParameter("course");
        String batch = request.getParameter("batch");
        String semester = request.getParameter("semester");
        String phoneNo = request.getParameter("phoneNo");
        String email = request.getParameter("email");

        try {
            // 2. Aapke pattern ke mutabik Database connection lena
            Connection con = DBConnection.getConnection();

            // 3. SQL Query taiyaar karna (Bina photo ke)
            String sql = "INSERT INTO students (roll_no, full_name, course, batch, semester, phone_no, email) VALUES (?, ?, ?, ?, ?, ?, ?)";

            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, rollNo);
            ps.setString(2, fullName);
            ps.setString(3, course);
            ps.setString(4, batch);
            ps.setString(5, semester);
            ps.setString(6, phoneNo);
            ps.setString(7, email);

            // 4. Query execute karna
            int status = ps.executeUpdate();

            if (status > 0) {
                // Success: Form par waapis redirect karenge success status ke sath
                response.sendRedirect("student_reg.jsp?status=success");
            } else {
                // Failure: Form par error message ke sath redirect
                response.sendRedirect("student_reg.jsp?status=failed");
            }

            // Connection close karna
            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            // Agar duplicate key enter hoti hai ya koi SQL error aata hai
            response.sendRedirect("student_reg.jsp?status=duplicate");
        }
    }
}