package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

// NOTE: Mapping matching exactly with view_issue_book.jsp call
@WebServlet("/ReissueBookServlet")
public class ReIssueBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. URL se Parameters catch karna
        String idParam = request.getParameter("id"); // Transaction Row ID
        String borrowerType = request.getParameter("type"); // Student ya Faculty

        // Validation check
        if (idParam == null || borrowerType == null) {
            response.sendRedirect("view_issue_book.jsp?error=Invalid Request Parameters!");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            // 2. Aaj ki date nikalna (Nayi Issue Date)
            Date today = new Date();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String newIssueDate = sdf.format(today);

            // 3. Calendar ke through din jodhna (Nayi Due Date)
            Calendar cal = Calendar.getInstance();
            cal.setTime(today);

            // Condition Check: Student ko 7 din aur Faculty ko 90 din (3 mahine) ka extension
            int daysToAdd = "Student".equalsIgnoreCase(borrowerType) ? 7 : 90;
            cal.add(Calendar.DAY_OF_MONTH, daysToAdd);
            String newDueDate = sdf.format(cal.getTime());

            // 4. SQL Update Query Execution
            // FIX: Reissue karte samay status 'Issued' rahega, par fine_amount 0 aur fine_status 'No Fine' reset ho jayega
            String updateQuery = "UPDATE issue_book SET issue_date = ?, due_date = ?, status = 'Issued', fine_amount = 0, fine_status = 'No Fine' WHERE id = ?";
            ps = con.prepareStatement(updateQuery);
            ps.setString(1, newIssueDate);
            ps.setString(2, newDueDate);
            ps.setInt(3, Integer.parseInt(idParam));

            int rowsAffected = ps.executeUpdate();

            if (rowsAffected > 0) {
                response.sendRedirect("view_issue_book.jsp?msg=Book Allocation ReIssued Successfully! New Due Date: " + newDueDate);
            } else {
                response.sendRedirect("view_issue_book.jsp?error=Failed to reissue the book allocation record.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view_issue_book.jsp?error=Database error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}