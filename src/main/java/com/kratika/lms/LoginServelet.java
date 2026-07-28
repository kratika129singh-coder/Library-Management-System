package com.kratika.lms;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

 @WebServlet("/login")
    public class LoginServelet extends HttpServlet
 {
        protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
            String u = request.getParameter("username");
            String p = request.getParameter("password");

            try
            {
                Connection con = DBConnection.getConnection();
                PreparedStatement ps = con.prepareStatement("SELECT * FROM admin WHERE username=? AND password=?");
                ps.setString(1, u);
                ps.setString(2, p);

                ResultSet rs = ps.executeQuery();
                if (rs.next())
                {
                    // Agar login sahi hai
                    HttpSession session = request.getSession();
                    session.setAttribute("adminUser", u);
                    response.sendRedirect("dashboard.jsp");
                } else
                {
                    // Agar galat hai
                    response.sendRedirect("index.jsp?error=invalid");
                }
            } catch (Exception e)
            {
                e.printStackTrace();}}}

