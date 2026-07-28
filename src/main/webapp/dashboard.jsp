<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/14/2026
  Time: 11:07 AM
--%>
<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Session Check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Default values
    int totalBooks = 0;
    int availableBooks = 0;
    int totalIssued = 0;
    int totalStudents = 0;
    int totalFaculty = 0;
    int overdueBooks = 0;

    Connection con = null;
    Statement st = null;

    try {
        con = DBConnection.getConnection();
        st = con.createStatement();

        // 1. Fetch Total Books
        try {
            ResultSet rs1 = st.executeQuery("SELECT COUNT(*) FROM books");
            if(rs1.next()) { totalBooks = rs1.getInt(1); }
        } catch(Exception e) { System.out.println("Error in Total Books Query: " + e.getMessage()); }

        // 2. Fetch Total Registered Students (Jo apka view page pr chal rha hai)
        try {
            ResultSet rs3 = st.executeQuery("SELECT COUNT(*) FROM students");
            if(rs3.next()) { totalStudents = rs3.getInt(1); }
        } catch(Exception e) { System.out.println("Error in Students Query: " + e.getMessage()); }

        // 3. Fetch Total Registered Faculty
        try {
            ResultSet rs4 = st.executeQuery("SELECT COUNT(*) FROM faculty");
            if(rs4.next()) { totalFaculty = rs4.getInt(1); }
        } catch(Exception e) { System.out.println("Error in Faculty Query: " + e.getMessage()); }

        // 4. Fetch Total Issued Books
        try {
            ResultSet rs2 = st.executeQuery("SELECT COUNT(*) FROM issue_book WHERE status = 'Issued'");
            if(rs2.next()) { totalIssued = rs2.getInt(1); }
        } catch(Exception e) { System.out.println("Error in Issued Books Query: " + e.getMessage()); }

        // Calculate Available Books dynamically
        availableBooks = totalBooks - totalIssued;
        if(availableBooks < 0) availableBooks = 0;

        // 5. Fetch Overdue Books
        try {
            ResultSet rs5 = st.executeQuery("SELECT COUNT(*) FROM issue_book WHERE return_date < CURDATE() AND status = 'Issued'");
            if(rs5.next()) { overdueBooks = rs5.getInt(1); }
        } catch(Exception e) { System.out.println("Error in Overdue Query: " + e.getMessage()); }

    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        // Safe Closing
        try { if(st != null) st.close(); if(con != null) con.close(); } catch(Exception e) {}
    }
%>
<html>
<head>
    <title>LMS | Admin Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            display: flex;
            background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
            background-attachment: fixed;
            height: 100vh;
            overflow: hidden;
        }

        /* Sidebar: Dark Purple */
        .sidebar {
            width: 280px;
            background: #8845af;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 25px;
            box-shadow: 4px 0 15px rgba(0,0,0,0.1);
            z-index: 10;
        }

        .sidebar h2 {
            font-size: 22px;
            text-align: center;
            margin-bottom: 40px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            padding-bottom: 15px;
            letter-spacing: 1px;
        }

        .sidebar a {
            color: #efedff;
            padding: 12px 15px;
            text-decoration: none;
            margin-bottom: 8px;
            border-radius: 8px;
            transition: all 0.3s;
            font-size: 14px;
        }

        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            transform: translateX(8px);
        }

        .sidebar a.active {
            background: #aa6dbd;
            font-weight: 600;
        }

        /* Main Content */
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
        }

        /* Header layout row for welcome text and search bar */
        .header-container {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 35px;
        }

        .header { color: #311b92; }
        .header h1 { font-size: 28px; font-weight: 600; }
        .header p { color: #5e35b1; font-weight: 500; }


        /* Stats Cards Wrapper Layout */
        .stats-wrapper {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 25px;
            margin-bottom: 30px;
        }

        /* Beautiful Horizontal Rectangle Design */
        .stat-card {
            background: white;
            padding: 22px 28px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(81, 45, 168, 0.1);
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: flex-start;
            border-left: 6px solid #812ea0;
            transition: 0.3s;
        }

        .stat-card:hover { transform: translateY(-5px); }

        .stat-card h3 { font-size: 13px; color: #7e57c2; margin-bottom: 5px; text-transform: uppercase; letter-spacing: 0.5px; }
        .stat-card .count { font-size: 34px; font-weight: 600; color: #311b92; }

        /* Color profiles */
        .card-books { border-left-color: #512da8; }
        .card-available { border-left-color: #512da8; }
        .card-issued { border-left-color: #512da8; }
        .card-students { border-left-color: #512da8; }
        .card-faculty { border-left-color: #512da8; }
        .card-overdue { border-left-color: #512da8; }

        /* Logout Button: Lavender */
        .logout-btn {
            margin-top: auto;
            background: #d1c4e9 !important;
            color: #512da8 !important;
            text-align: center;
            font-weight: 600;
            border: 1px solid #b39ddb;
        }
        .logout-btn:hover {
            background: #b39ddb !important;
            transform: scale(1.02);
        }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>LMS Admin</h2>
    <a href="dashboard.jsp" class="active">🏠 Dashboard</a>
    <a href="student_reg.jsp">👨‍🎓 Student Registration</a>
    <a href="faculty_reg.jsp">👨‍🏫 Faculty Registration</a>
    <a href="add_book.jsp">➕ Add New Book</a>
    <a href="issue_book.jsp">📑 Issue Book</a>
    <a href="view_book.jsp">📚 View Books</a>
    <a href="view_student.jsp">👨‍🎓 View Students</a>
    <a href="view_faculty.jsp">👨‍🏫 View Faculty</a>
    <a href="view_issue_book.jsp">📑 View Issued Books</a>
    <a href="index.jsp" class="logout-btn">🚪 Log-out</a>
</div>

<div class="main-content">

    <div class="header-container">
        <div class="header">
            <h1>Admin Dashboard</h1>
            <p>Welcome back, <%= session.getAttribute("adminUser") %>!</p>
        </div>
    </div>

    <div class="stats-wrapper">

        <div class="stat-card card-books">
            <h3>Total Books</h3>
            <div class="count"><%= totalBooks %></div>
        </div>

        <div class="stat-card card-available">
            <h3>Available Books</h3>
            <div class="count"><%= availableBooks %></div>
        </div>

        <div class="stat-card card-issued">
            <h3>Total Issued</h3>
            <div class="count"><%= totalIssued %></div>
        </div>

        <div class="stat-card card-students">
            <h3>Registered Students</h3>
            <div class="count"><%= totalStudents %></div>
        </div>

        <div class="stat-card card-faculty">
            <h3>Registered Faculty</h3>
            <div class="count"><%= totalFaculty %></div>
        </div>

        <div class="stat-card card-overdue">
            <h3>Overdue Books</h3>
            <div class="count" style="color:#512da8;"><%= overdueBooks %></div>
        </div>

    </div>
</div>

</body>
</html>