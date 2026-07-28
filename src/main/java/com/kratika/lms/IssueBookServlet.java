package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/IssueBookServlet")
public class IssueBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Aapke naye form elements ke exact name attributes matching hain
        String borrowerType = request.getParameter("borrower_type");
        String borrowerId = request.getParameter("borrower_id");
        String accessionNo = request.getParameter("accession_no");
        String issueDate = request.getParameter("issue_date");
        String dueDate = request.getParameter("due_date");

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            // Query mapping exactly to your new setup
            String query = "INSERT INTO issue_book (borrower_type, borrower_id, accession_no, issue_date, due_date, status) VALUES (?, ?, ?, ?, ?, 'Issued')";
            ps = con.prepareStatement(query);

            ps.setString(1, borrowerType);
            ps.setString(2, borrowerId);
            ps.setString(3, accessionNo);
            ps.setString(4, issueDate);
            ps.setString(5, dueDate);

            int result = ps.executeUpdate();

            if (result > 0) {
                // Success popup trigger ke liye parameter pass kiya
                response.sendRedirect("issue_book.jsp?status=success");
            } else {
                response.sendRedirect("issue_book.jsp?status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("issue_book.jsp?status=error");
        } finally {
            try { if(ps != null) ps.close(); if(con != null) con.close(); } catch(Exception e) { e.printStackTrace(); }
        }
    }
}
