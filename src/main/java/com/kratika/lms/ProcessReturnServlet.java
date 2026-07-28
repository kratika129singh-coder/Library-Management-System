package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ProcessReturnServlet")
public class ProcessReturnServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // Agar request GET se aaye toh use POST par bhej do
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doPost(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        String fineParam = request.getParameter("fine_amount");
        String fineStatusParam = request.getParameter("fine_status");

        // Parameters check
        if (idParam == null || fineParam == null) {
            response.sendRedirect("view_issue_book.jsp?error=Invalid parameters received!");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = com.kratika.lms.DBConnection.getConnection();

            int fineAmount = Integer.parseInt(fineParam);
            String fineStatus = (fineStatusParam != null) ? fineStatusParam : "No Fine";

            if (fineAmount > 0) {
                fineStatus = "Paid";
            }

            // Aaj ki live date
            String todayDate = java.time.LocalDate.now().toString();

            // Database Query Execution WITH WHERE CLAUSE
            String updateQuery = "UPDATE issue_book SET status = 'Returned', return_date = ?, fine_amount = ?, fine_status = ? WHERE id = ?";
            ps = con.prepareStatement(updateQuery);

            ps.setString(1, todayDate);
            ps.setInt(2, fineAmount);
            ps.setString(3, fineStatus);
            ps.setInt(4, Integer.parseInt(idParam));

            int result = ps.executeUpdate();

            if (result > 0) {
                if (fineAmount > 0) {
                    response.sendRedirect("view_issue_book.jsp?msg=Book Returned! Fine worth Rs. " + fineAmount + " Collected.");
                } else {
                    response.sendRedirect("view_issue_book.jsp?msg=Book Returned Successfully!");
                }
            } else {
                response.sendRedirect("view_issue_book.jsp?error=Failed to process return transaction.");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view_issue_book.jsp?error=Database Error: " + e.getMessage());
        } finally {
            try { if (ps != null) ps.close(); if (con != null) con.close(); } catch (Exception e) {}
        }
    }
}















































