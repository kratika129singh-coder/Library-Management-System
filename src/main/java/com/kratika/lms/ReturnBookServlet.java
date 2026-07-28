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
import java.util.Date;

@WebServlet("/ReturnBookServlet")
public class ReturnBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");

        if (idParam == null) {
            response.sendRedirect("view_issue_book.jsp");
            return;
        }

        Connection con = null;
        PreparedStatement ps = null;

        try {
            con = DBConnection.getConnection();

            // Aaj ki date format karna return_date ke liye
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            String todayStr = sdf.format(new Date());

            // UPDATE query: Status aur Return Date dono set honge
            String updateQuery = "UPDATE issue_book SET status = 'Returned', return_date = ? WHERE id = ?";
            ps = con.prepareStatement(updateQuery);
            ps.setString(1, todayStr);
            ps.setInt(2, Integer.parseInt(idParam));

            int result = ps.executeUpdate();

            if (result > 0) {
                response.sendRedirect("view_issue_book.jsp?msg=Book Returned Successfully!");
            } else {
                response.sendRedirect("view_issue_book.jsp?error=Failed to return book!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view_issue_book.jsp?error=Database error occurred!");
        } finally {
            try { if(ps != null) ps.close(); if(con != null) con.close(); } catch(Exception e) {}
        }
    }
}