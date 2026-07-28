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

@WebServlet("/VerifyBookServlet")
public class VerifyBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();

        String accessionNo = request.getParameter("accession_no");

        Connection con = null;
        PreparedStatement psCheckBook = null;
        PreparedStatement psCheckIssued = null;
        ResultSet rsBook = null;
        ResultSet rsIssued = null;

        try {
            con = DBConnection.getConnection();

            // 1. Pehle check karein kya yeh book database mein exist karti hai?
            // (Aapki books table mein column ka naam check kar lena agar accession_no se alag ho)
            String queryBook = "SELECT book_title FROM books WHERE accession_no = ?";
            psCheckBook = con.prepareStatement(queryBook);
            psCheckBook.setString(1, accessionNo);
            rsBook = psCheckBook.executeQuery();

            if (rsBook.next()) {
                String bookTitle = rsBook.getString("book_title");

                // 2. Agar book hai, toh check karein kahi yeh pehle se 'Issued' toh nahi hai?
                String queryIssued = "SELECT id FROM issue_book WHERE accession_no = ? AND status = 'Issued'";
                psCheckIssued = con.prepareStatement(queryIssued);
                psCheckIssued.setString(1, accessionNo);
                rsIssued = psCheckIssued.executeQuery();

                if (rsIssued.next()) {
                    out.print("This book is already issued to someone else!");
                } else {
                    // Agar book available hai toh JavaScript ko "AVAILABLE:" ke sath bhejenge
                    out.print("AVAILABLE:" + bookTitle);
                }
            } else {
                out.print("Book Accession Number not found in library!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            out.print("Database error during inventory check!");
        } finally {
            try {
                if(rsBook != null) rsBook.close();
                if(rsIssued != null) rsIssued.close();
                if(psCheckBook != null) psCheckBook.close();
                if(psCheckIssued != null) psCheckIssued.close();
                if(con != null) con.close();
            } catch(Exception e) {}
        }
    }
}