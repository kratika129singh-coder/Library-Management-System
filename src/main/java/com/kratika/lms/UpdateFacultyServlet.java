package com.kratika.lms;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/UpdateFacultyServlet")
public class UpdateFacultyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the admin user session is active, if not redirect to login page
        HttpSession session = request.getSession();
        if(session.getAttribute("adminUser") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Fetching input parameters submitted from the edit_faculty.jsp form
        String facultyId = request.getParameter("faculty_id");
        String fullName = request.getParameter("full_name");
        String department = request.getParameter("department");
        String designation = request.getParameter("designation");
        String joiningYear = request.getParameter("joining_year");
        String phoneNo = request.getParameter("phone_no");

        // Setting the response content type to HTML for displaying JavaScript alerts if needed
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Server-side Validation: Check if any of the required fields are empty or null
        if (facultyId == null || facultyId.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                department == null || department.trim().isEmpty() ||
                designation == null || designation.trim().isEmpty() ||
                joiningYear == null || joiningYear.trim().isEmpty() ||
                phoneNo == null || phoneNo.trim().isEmpty()) {

            out.print("<script>alert('All fields are compulsory!'); window.history.back();</script>");
            return;
        }

        // Server-side Validation: Ensure full name contains only letters, spaces, and basic symbols
        if (!fullName.matches("^[a-zA-Z\\s\\.\\,\\'-]+$")) {
            out.print("<script>alert('Invalid Name! Only letters and spaces are allowed.'); window.history.back();</script>");
            return;
        }

        // Server-side Validation: Ensure joining year is exactly a 4-digit number
        if (!joiningYear.matches("^[0-9]{4}$")) {
            out.print("<script>alert('Invalid Joining Year! Enter a 4-digit year.'); window.history.back();</script>");
            return;
        }

        // Server-side Validation: Ensure phone number contains exactly 10 digits ranging from 0 to 9
        if (!phoneNo.matches("^[0-9]{10}$")) {
            out.print("<script>alert('Invalid Phone Number! Must be exactly 10 digits.'); window.history.back();</script>");
            return;
        }

        // Database Operation: Update existing record in the database
        try {
            // Getting a database connection from the connection helper class
            Connection con = DBConnection.getConnection();

            // Preparing SQL query to update faculty details matching the faculty_id
            String query = "UPDATE faculty SET full_name=?, department=?, designation=?, joining_year=?, phone_no=? WHERE faculty_id=?";
            PreparedStatement ps = con.prepareStatement(query);

            // Binding the form data variables to the SQL query place holders
            ps.setString(1, fullName);
            ps.setString(2, department);
            ps.setString(3, designation);
            ps.setString(4, joiningYear);
            ps.setString(5, phoneNo);
            ps.setString(6, facultyId);

            // Executing the update statement and capturing the row count affected
            int result = ps.executeUpdate();
            con.close(); // Closing the database connection

            // Checking if the record updated successfully
            if (result > 0) {
                // If successful, redirect user to the view faculty dashboard directory
                response.sendRedirect("view_faculty.jsp");
            } else {
                // If update fails, show an alert and go back to the form page
                out.print("<script>alert('Failed to update faculty details. Please try again.'); window.history.back();</script>");
            }

        } catch (Exception e) {
            // Log full error stack trace on server console and display alert to client side
            e.printStackTrace();
            out.print("<script>alert('Error: " + e.getMessage() + "'); window.history.back();</script>");
        }
    }
}