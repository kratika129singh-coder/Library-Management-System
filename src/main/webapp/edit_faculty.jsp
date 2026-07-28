<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/18/2026
  Time: 12:15 PM
--%>
<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session Check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String id = request.getParameter("id"); // view_faculty.jsp से जो id आई है
    String fullName="", department="", designation="", joiningYear="", phoneNo="";

    try {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM faculty WHERE faculty_id = ?");
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            fullName = rs.getString("full_name");
            department = rs.getString("department");
            designation = rs.getString("designation");
            joiningYear = rs.getString("joining_year");
            phoneNo = rs.getString("phone_no");
        }
        con.close();
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

<html>
<head>
    <title>LMS | Edit Faculty Details</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }

        body {
            background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }

        .form-container {
            background: white;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 35px rgba(81, 45, 168, 0.2);
            width: 100%;
            max-width: 850px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 30px;
        }

        .form-header h2 { color: #512da8; font-size: 26px; letter-spacing: 1px; }
        .form-header p { color: #888; font-size: 14px; }

        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .input-group { margin-bottom: 15px; }
        .input-group label { display: block; font-size: 13px; color: #512da8; font-weight: 600; margin-bottom: 8px; }

        .input-group input, .input-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #efedff;
            border-radius: 10px;
            font-size: 14px;
            transition: 0.3s;
            background: #fcfaff;
            color: #333;
        }

        .input-group input:focus, .input-group select:focus { outline: none; border-color: #512da8; background: white; }
        .input-group input:invalid, .input-group select:invalid { border-color: grey; background: #fff6f6; }

        .input-group input[readonly] {
            background: #eee;
            border-color: #d1c4e9;
            cursor: not-allowed;
            color: #777;
        }

        .button-group { grid-column: span 2; display: flex; gap: 15px; margin-top: 20px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; text-align: center; text-decoration: none; }
        .btn-save { background: #512da8; color: white; }
        .btn-save:hover { background: #311b92; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(81, 45, 168, 0.3); }
        .btn-back { background: #d1c4e9; color: #512da8; }
        .btn-back:hover { background: #b39ddb; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="form-container">
    <div class="form-header">
        <h2>Edit Faculty Details</h2>
        <p>Modify and update faculty details for College Records</p>
    </div>

    <form action="UpdateFacultyServlet" method="post" oninput="validateLiveFields()">
        <div class="form-grid">

            <div class="input-group">
                <label>Faculty ID (Read-only)</label>
                <input type="text" id="faculty_id" name="faculty_id" value="<%= id %>" readonly required>
            </div>

            <div class="input-group">
                <label>Full Name</label>
                <input type="text" id="full_name" name="full_name" value="<%= fullName %>" required>
            </div>

            <div class="input-group">
                <label>Department</label>
                <select id="department" name="department" required>
                    <option value="" disabled>Select Department</option>
                    <option value="Computer Science" <%= "Computer Science".equals(department) ? "selected" : "" %>>Computer Science (CSE)</option>
                    <option value="Information Technology" <%= "Information Technology".equals(department) ? "selected" : "" %>>Information Technology (IT)</option>
                    <option value="Mechanical Engineering" <%= "Mechanical Engineering".equals(department) ? "selected" : "" %>>Mechanical Engineering</option>
                    <option value="Civil Engineering" <%= "Civil Engineering".equals(department) ? "selected" : "" %>>Civil Engineering</option>
                    <option value="Electronics & Communication" <%= "Electronics & Communication".equals(department) ? "selected" : "" %>>Electronics & Communication</option>
                    <option value="Applied Sciences" <%= "Applied Sciences".equals(department) ? "selected" : "" %>>Applied Sciences</option>
                </select>
            </div>

            <div class="input-group">
                <label>Designation</label>
                <select id="designation" name="designation" required>
                    <option value="" disabled>Select Designation</option>
                    <option value="Assistant Professor" <%= "Assistant Professor".equals(designation) ? "selected" : "" %>>Assistant Professor</option>
                    <option value="Associate Professor" <%= "Associate Professor".equals(designation) ? "selected" : "" %>>Associate Professor</option>
                    <option value="Professor" <%= "Professor".equals(designation) ? "selected" : "" %>>Professor</option>
                    <option value="Head of Department" <%= "Head of Department".equals(designation) ? "selected" : "" %>>Head of Department (HOD)</option>
                    <option value="Lab Assistant" <%= "Lab Assistant".equals(designation) ? "selected" : "" %>>Lab Assistant</option>
                </select>
            </div>

            <div class="input-group">
                <label>Joining Year</label>
                <input type="number" id="joining_year" name="joining_year" value="<%= joiningYear %>" required>
            </div>

            <div class="input-group">
                <label>Phone Number</label>
                <input type="text" id="phone_no" name="phone_no" value="<%= phoneNo %>" maxlength="10" required>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-save">Update Changes</button>
                <a href="view_faculty.jsp" class="btn btn-back">Cancel</a>
            </div>
        </div>
    </form>
</div>

<script>
    function validateLiveFields() {
        const idField = document.getElementById('faculty_id');
        const nameField = document.getElementById('full_name');
        const deptField = document.getElementById('department');
        const desigField = document.getElementById('designation');
        const yearField = document.getElementById('joining_year');
        const phoneField = document.getElementById('phone_no');

        const alphaNumericDash = /^[a-zA-Z0-9\-]+$/;
        const pureText = /^[a-zA-Z\s\.\,\'\:\-]+$/;
        // 0-9 तक कोई भी संख्या और पूरी लंबाई सिर्फ 10 अंक
        const phonePattern = /^[0-9]{10}$/;

        // 1. Faculty ID Validation
        if (idField.value.trim() === "") {
            idField.setCustomValidity("we can not skipit! Fill this too");
        } else if (!alphaNumericDash.test(idField.value.trim())) {
            idField.setCustomValidity("Alphabets, numbers and dash (-) are allowed in faculty ID !");
        } else { idField.setCustomValidity(""); }

        // 2. Full Name Validation
        if (nameField.value.trim() === "") {
            nameField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(nameField.value.trim()) || !isNaN(nameField.value.trim())) {
            nameField.setCustomValidity("Only letters are allowed not numbers!");
        } else { nameField.setCustomValidity(""); }

        // 3. Department Validation
        if (deptField.value === "") {
            deptField.setCustomValidity("Please select a department!");
        } else { deptField.setCustomValidity(""); }

        // 4. Designation Validation
        if (desigField.value === "") {
            desigField.setCustomValidity("Please select a designation!");
        } else { desigField.setCustomValidity(""); }

        // 5. Joining Year Validation
        const yearVal = parseInt(yearField.value);
        if (yearField.value.trim() === "") {
            yearField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(yearVal) || yearVal < 1950 || yearVal > 2026) {
            yearField.setCustomValidity("Enter year between 1950 se 2026 year only .");
        } else { yearField.setCustomValidity(""); }

        // 6. Phone Number Validation (0-9 Limit 10)
        if (phoneField.value.trim() === "") {
            phoneField.setCustomValidity("It is compulsory ti fill!");
        } else if (!phonePattern.test(phoneField.value.trim())) {
            phoneField.setCustomValidity("Enter a valid 10-digit phone number using digits 0-9!");
        } else { phoneField.setCustomValidity(""); }
    }

    window.onload = function() {
        validateLiveFields();
    };
</script>
</body>
</html>