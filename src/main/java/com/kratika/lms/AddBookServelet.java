package com.kratika.lms;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddBookServelet")
public class AddBookServelet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. JSP Form se saara data fetch karna
        String accNo = request.getParameter("accession_no"); // Matching JSP
        String bname = request.getParameter("book_title");   // Matching JSP
        String author = request.getParameter("author");
        String edition = request.getParameter("edition");
        String address = request.getParameter("pub_place");  // Matching JSP
        String year = request.getParameter("pub_year");      // Matching JSP
        String pages = request.getParameter("pages");
        String source = request.getParameter("purchase_source"); // Matching JSP
        String price = request.getParameter("price");
        String bill = request.getParameter("bill_no");       // Matching JSP

        // ==================== EDIT / VALIDATION START ====================

        // Check 1: Koi bhi field khali (null ya empty) nahi honi chahiye
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

            // Khali field milne par wapas page par bhej do ek warning msg ke sath
            response.sendRedirect("add_book.jsp?msg=empty_fields");
            return; // Code ko aage badhne se yahin rok do
        }

        // Check 2: Numbers ka sahi hona (Pages > 0, Price > 0, aur Year 1800-2026 tak)
        try {
            int yearInt = Integer.parseInt(year);
            int pagesInt = Integer.parseInt(pages);
            double priceDouble = Double.parseDouble(price);

            if (yearInt < 1800 || yearInt > 2026 || pagesInt <= 0 || priceDouble <= 0) {
                response.sendRedirect("add_book.jsp?msg=invalid_values");
                return;
            }
        } catch (NumberFormatException e) {
            // Agar number waali field me kisi ne abcd likh diya ho
            response.sendRedirect("add_book.jsp?msg=invalid_format");
            return;
        }

        // ==================== EDIT / VALIDATION END ====================

        try {
            // 2. Database connection lena
            Connection con = DBConnection.getConnection();

            // 3. SQL Query taiyaar karna
            String sql = "INSERT INTO books (Accession_no, book_title, author, edition, publication_place, pub_year, pages, purchase_source, price, bill_no) VALUES (?,?,?,?,?,?,?,?,?,?)";

            PreparedStatement ps = con.prepareStatement(sql);
            // .trim() use kiya hai taaki faltu ke aage-piche ke spaces hat jayein
            ps.setString(1, accNo.trim());
            ps.setString(2, bname.trim());
            ps.setString(3, author.trim());
            ps.setString(4, edition.trim());
            ps.setString(5, address.trim());
            ps.setString(6, year.trim());
            ps.setString(7, pages.trim());
            ps.setString(8, source.trim());
            ps.setString(9, price.trim());
            ps.setString(10, bill.trim());

            // 4. Query execute karna
            int status = ps.executeUpdate();

            if(status > 0) {
                // Success: Dashboard par wapas bhej do
                response.sendRedirect("dashboard.jsp?msg=success");
            } else {
                // Failure: Add book page par error dikhao
                response.sendRedirect("add_book.jsp?msg=failed");
            }

            con.close();

        } catch (Exception e) {
            e.printStackTrace();
            // Error handling ke liye
            response.sendRedirect("add_book.jsp?msg=error");
        }
    }
}