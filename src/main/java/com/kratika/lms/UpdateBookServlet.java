package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdateBookServlet")
public class UpdateBookServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Request se data fetch karna
        String accNo = request.getParameter("accession_no");
        String bname = request.getParameter("book_title");
        String author = request.getParameter("author");
        String edition = request.getParameter("edition");
        String address = request.getParameter("pub_place");
        String year = request.getParameter("pub_year");
        String pages = request.getParameter("pages");
        String source = request.getParameter("purchase_source");
        String price = request.getParameter("price");
        String bill = request.getParameter("bill_no");

        // ==================== DOUBLE CHECK VALIDATION ====================

        if (accNo == null || accNo.trim().isEmpty() ||
                bname == null || bname.trim().isEmpty() ||
                author == null || author.trim().isEmpty() ||
                edition == null || edition.trim().isEmpty() ||
                address == null || address.trim().isEmpty() ||
                year == null || year.trim().isEmpty() ||
                pages == null || pages.trim().isEmpty() ||
                source == null || source.trim().isEmpty() ||
                price == null || price.trim().isEmpty() ||
                bill == null || bill.trim().isEmpty()) {

            response.sendRedirect("view_book.jsp?msg=empty_fields");
            return;
        }

        try {
            int yearInt = Integer.parseInt(year);
            int pagesInt = Integer.parseInt(pages);
            double priceDouble = Double.parseDouble(price);

            if (yearInt < 1800 || yearInt > 2026 || pagesInt <= 0 || priceDouble <= 0) {
                response.sendRedirect("view_book.jsp?msg=invalid_values");
                return;
            }
        } catch (NumberFormatException e) {
            response.sendRedirect("view_book.jsp?msg=invalid_format");
            return;
        }

        // ==================== SQL OPERATION ====================

        try {
            Connection con = DBConnection.getConnection();

            // SQL Update query matching all columns exactly
            String sql = "UPDATE books SET book_title=?, author=?, edition=?, publication_place=?, pub_year=?, pages=?, purchase_source=?, price=?, bill_no=? WHERE Accession_no=?";

            PreparedStatement ps = con.prepareStatement(sql);

            ps.setString(1, bname.trim());
            ps.setString(2, author.trim());
            ps.setString(3, edition.trim());
            ps.setString(4, address.trim());
            ps.setString(5, year.trim());
            ps.setString(6, pages.trim());
            ps.setString(7, source.trim());
            ps.setString(8, price.trim());
            ps.setString(9, bill.trim());
            ps.setString(10, accNo.trim()); // WHERE clause identifier

            int status = ps.executeUpdate();

            if(status > 0) {
                response.sendRedirect("view_book.jsp?msg=updated");
            } else {
                response.sendRedirect("view_book.jsp?msg=fail");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("view_book.jsp?msg=error");
        }
    }
}