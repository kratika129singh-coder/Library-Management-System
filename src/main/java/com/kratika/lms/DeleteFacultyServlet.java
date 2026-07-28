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

@WebServlet("/DeleteFacultyServlet")
public class DeleteFacultyServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Check if the admin user session is active, if not redirect to login page
        HttpSession session = request.getSession();
        if(session.getAttribute("adminUser") == null) {
            response.sendRedirect("index.jsp");
            return;
        }

        // Extracting the faculty ID passed via the URL query parameter (?id=...)
        String facultyId = request.getParameter("id");

        // Setting up HTML output configurations for printing error/success script logs
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // Validation: Verify if the requested ID parameter is null or empty string
        if (facultyId == null || facultyId.trim().isEmpty()) {
            response.sendRedirect("view_faculty.jsp");
            return;
        }

        // Database Operation: Delete matching record from table
        try {
            // Establishing a database connectivity token
            Connection con = DBConnection.getConnection();

            // Preparing target SQL deletion command mapping the selected primary key ID
            String query = "DELETE FROM faculty WHERE faculty_id=?";
            PreparedStatement ps = con.prepareStatement(query);
            ps.setString(1, facultyId);

            // Running query execution and evaluating operational response status
            int result = ps.executeUpdate();
            con.close(); // Closing resources to clear memory overheads

            // Evaluating query execution returns
            if (result > 0) {
                // Redirect back to view directory if removal was successful
                response.sendRedirect("view_faculty.jsp");
            } else {
                // Display informative warning alert if record doesn't exist or is already removed
                out.print("<script>alert('Faculty record not found or already deleted.'); window.location.href='view_faculty.jsp';</script>");
            }

        } catch (Exception e) {
            // Capture core compilation faults into server stack logs and show alerts
            e.printStackTrace();
            out.print("<script>alert('Error while deleting record: " + e.getMessage() + "'); window.location.href='view_faculty.jsp';</script>");
        }
    }
}
