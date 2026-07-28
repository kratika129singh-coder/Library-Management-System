package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/VerifyBorrowerServlet")
public class VerifyBorrowerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String type = request.getParameter("type"); // Student ya Faculty
        String id = request.getParameter("id"); // Roll No ya Faculty ID

        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            con = DBConnection.getConnection();
            String query = "";

            // Aapke exact table and column names ke hisab se mapping
            if ("Student".equalsIgnoreCase(type)) {
                query = "SELECT full_name FROM students WHERE roll_no = ?";
            } else if ("Faculty".equalsIgnoreCase(type)) {
                query = "SELECT full_name FROM faculty WHERE faculty_id = ?";
            }

            ps = con.prepareStatement(query);
            ps.setString(1, id);
            rs = ps.executeQuery();

            if (rs.next()) {
                // Agar data mil gaya toh JavaScript ko "VALID:" prefix ke sath naam bhejenge
                out.print("VALID:" + rs.getString("full_name"));
            } else {
                out.print("ID not found in " + type + " records!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Database connection error during verification!");
        } finally {
            try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } catch(Exception e) {}
        }
    }
}