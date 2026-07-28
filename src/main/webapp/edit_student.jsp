<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/17/2026
  Time: 11:00 AM
--%>
<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String id = request.getParameter("id"); // View Students page table line se dynamic primary key parameter fetch
    String fullName="", course="", batch="", semester="", phoneNo="", email="";

    try {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM students WHERE roll_no = ?");
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            fullName = rs.getString("full_name");
            course = rs.getString("course");
            batch = rs.getString("batch");
            semester = rs.getString("semester");
            phoneNo = rs.getString("phone_no");
            email = rs.getString("email");
        }
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Student Details - LMS Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }

        body {
            display: flex;
            justify-content: center;
            align-items: center;
            background: linear-gradient(135deg, #c3b4df 0%, #e8dbfc 100%);
            min-height: 100vh;
            padding: 40px 20px;
        }

        .form-container {
            background-color: white;
            width: 100%;
            max-width: 900px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        .form-title { color: #511c8a; font-size: 28px; font-weight: bold; text-align: center; margin-bottom: 5px; }
        .form-subtitle { color: #888; font-size: 14px; text-align: center; margin-bottom: 35px; }

        .form-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 25px; }
        .form-group { display: flex; flex-direction: column; }
        .form-group label { color: #511c8a; font-size: 14px; font-weight: 600; margin-bottom: 8px; }

        .form-group input, .form-group select {
            padding: 14px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            font-size: 14px;
            background-color: #f8fafc;
            color: #334155;
            outline: none;
            transition: all 0.3s;
        }

        .form-group input:focus, .form-group select:focus {
            border-color: #6a25b3;
            background-color: white;
            box-shadow: 0 0 0 3px rgba(106, 37, 179, 0.1);
        }

        .form-group input[readonly] {
            background-color: #e2e8f0;
            color: #64748b;
            cursor: not-allowed;
            border-color: #cbd5e1;
        }

        .error-msg { color: #e74c3c; font-size: 12px; margin-top: 5px; display: none; }

        .btn-group { margin-top: 35px; display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
        .btn { padding: 15px; font-size: 15px; font-weight: bold; border: none; border-radius: 12px; cursor: pointer; transition: all 0.3s; text-align: center; text-decoration: none; }
        .btn-submit { background-color: #511c8a; color: white; }
        .btn-submit:hover { background-color: #3d1469; box-shadow: 0 5px 15px rgba(81, 28, 138, 0.3); }
        .btn-dashboard { background-color: #dcd1f3; color: #511c8a; }
        .btn-dashboard:hover { background-color: #cbbae8; }
    </style>
</head>
<body>

<div class="form-container">
    <h2 class="form-title">Edit Student Profile</h2>
    <p class="form-subtitle">Modify student metrics and sync tracking updates</p>

    <form id="studentForm" action="UpdateStudentServlet" method="POST" onsubmit="return validateForm(event)">
        <div class="form-grid">

            <div class="form-group">
                <label for="rollNo">Student Roll Number (Read-only)</label>
                <input type="text" id="rollNo" name="rollNo" value="<%= id %>" readonly required>
            </div>

            <div class="form-group">
                <label for="fullName">Full Name</label>
                <input type="text" id="fullName" name="fullName" value="<%= fullName %>" required>
                <div id="nameError" class="error-msg">Name take only characters(A-Z) not Numbers</div>
            </div>

            <div class="form-group">
                <label for="course">Course / Department</label>
                <select id="course" name="course" required>
                    <option value="BCA" <%= "BCA".equals(course) ? "selected" : "" %>>BCA</option>
                    <option value="B.Tech" <%= "B.Tech".equals(course) ? "selected" : "" %>>B.Tech</option>
                    <option value="B.Sc" <%= "B.Sc".equals(course) ? "selected" : "" %>>B.Sc</option>
                    <option value="BBA" <%= "BBA".equals(course) ? "selected" : "" %>>BBA</option>
                    <option value="BCom" <%= "BCom".equals(course) ? "selected" : "" %>>BCom</option>
                    <option value="BioTech" <%= "BioTech".equals(course) ? "selected" : "" %>>BioTech</option>
                    <option value="BA" <%= "BA".equals(course) ? "selected" : "" %>>BA</option>
                    <option value="BA(LLB)" <%= "BA(LLB)".equals(course) ? "selected" : "" %>>BA(LLB)</option>
                    <option value="MCA" <%= "MCA".equals(course) ? "selected" : "" %>>MCA</option>
                    <option value="M.Tech" <%= "M.Tech".equals(course) ? "selected" : "" %>>M.Tech</option>
                    <option value="M.Sc" <%= "M.Sc".equals(course) ? "selected" : "" %>>M.Sc</option>
                    <option value="MA" <%= "MA".equals(course) ? "selected" : "" %>>MA</option>
                </select>
            </div>

            <div class="form-group">
                <label for="batch">Year of Admission</label>
                <select id="batch" name="batch" required>
                    <option value="2026" <%= "2026".equals(batch) ? "selected" : "" %>>2026</option>
                    <option value="2025" <%= "2025".equals(batch) ? "selected" : "" %>>2025</option>
                    <option value="2024" <%= "2024".equals(batch) ? "selected" : "" %>>2024</option>
                    <option value="2023" <%= "2023".equals(batch) ? "selected" : "" %>>2023</option>
                    <option value="2022" <%= "2022".equals(batch) ? "selected" : "" %>>2022</option>
                    <option value="2021" <%= "2021".equals(batch) ? "selected" : "" %>>2021</option>
                    <option value="2020" <%= "2020".equals(batch) ? "selected" : "" %>>2020</option>
                </select>
            </div>

            <div class="form-group">
                <label for="semester">Current Semester</label>
                <select id="semester" name="semester" required>
                    <option value="1st Semester" <%= "1st Semester".equals(semester) ? "selected" : "" %>>1st Semester</option>
                    <option value="2nd Semester" <%= "2nd Semester".equals(semester) ? "selected" : "" %>>2nd Semester</option>
                    <option value="3rd Semester" <%= "3rd Semester".equals(semester) ? "selected" : "" %>>3rd Semester</option>
                    <option value="4th Semester" <%= "4th Semester".equals(semester) ? "selected" : "" %>>4th Semester</option>
                    <option value="5th Semester" <%= "5th Semester".equals(semester) ? "selected" : "" %>>5th Semester</option>
                    <option value="6th Semester" <%= "6th Semester".equals(semester) ? "selected" : "" %>>6th Semester</option>
                    <option value="7th Semester" <%= "7th Semester".equals(semester) ? "selected" : "" %>>7th Semester</option>
                    <option value="8th Semester" <%= "8th Semester".equals(semester) ? "selected" : "" %>>8th Semester</option>
                    <option value="9th Semester" <%= "9th Semester".equals(semester) ? "selected" : "" %>>9th Semester</option>
                    <option value="10th Semester" <%= "10th Semester".equals(semester) ? "selected" : "" %>>10th Semester</option>
                </select>
            </div>

            <div class="form-group">
                <label for="phoneNo">Phone Number</label>
                <input type="tel" id="phoneNo" name="phoneNo" value="<%= phoneNo %>" placeholder="Enter 10-digit phone number" required>
                <div id="phoneError" class="error-msg">Please enter a valid 10-digit phone number.</div>
            </div>

            <div class="form-group">
                <label for="email">Email ID</label>
                <input type="email" id="email" name="email" value="<%= email %>" placeholder="e.g. student@gmail.com" required>
            </div>

        </div>

        <div class="btn-group">
            <button type="submit" class="btn btn-submit">Update Details</button>
            <a href="view_student.jsp" class="btn btn-dashboard">Cancel </a>
        </div>
    </form>
</div>
<script>
    function validateForm(event) {
        const fullName = document.getElementById('fullName').value.trim();
        const phoneInput = document.getElementById('phoneNo').value.trim();

        const nameError = document.getElementById('nameError');
        const phoneError = document.getElementById('phoneError');

        const nameRegex = /^[a-zA-Z\s]+$/;
        let isValid = true;

        // Name Verification
        if (!nameRegex.test(fullName)) {
            nameError.style.display = 'block';
            document.getElementById('fullName').style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            nameError.style.display = 'none';
            document.getElementById('fullName').style.borderColor = '#e2e8f0';
        }

        // Phone Number Verification
        if (phoneInput.length !== 10 || isNaN(phoneInput)) {
            phoneError.style.display = 'block';
            document.getElementById('phoneNo').style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            phoneError.style.display = 'none';
            document.getElementById('phoneNo').style.borderColor = '#e2e8f0';
        }

        // Agar form invalid hai toh submit event ko roko
        if (!isValid) {
            if (event && event.preventDefault) {
                event.preventDefault();
            }
            return false;
        }
        return true;
    }
</script>
</body>
</html>
