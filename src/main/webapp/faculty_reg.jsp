<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Faculty Registration - LMS Admin</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            display: flex;
            background: linear-gradient(135deg, #c3b4df 0%, #e8dbfc 100%);
            min-height: 100vh;
        }

        /* Sidebar Styling */
        .sidebar {
            width: 18%;
            background-color: #6a25b3;
            color: white;
            padding: 20px 10px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            min-height: 100vh;
            box-shadow: 4px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-brand {
            font-size: 22px;
            font-weight: bold;
            text-align: center;
            padding-bottom: 20px;
            border-bottom: 1px solid rgba(255,255,255,0.2);
            margin-bottom: 20px;
        }

        .sidebar-menu {
            list-style: none;
            flex-grow: 1;
        }

        .sidebar-menu li {
            margin-bottom: 10px;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            padding: 12px 15px;
            border-radius: 10px;
            font-size: 15px;
            transition: all 0.3s;
        }

        .sidebar-menu a i {
            margin-right: 10px;
            width: 20px;
        }

        .sidebar-menu li.active a, .sidebar-menu a:hover {
            background-color: rgba(255, 255, 255, 0.2);
            color: white;
            font-weight: 500;
        }

        .logout-btn {
            background-color: #d1c4e9;
            color: #512da8 !important;
            text-align: center;
            padding: 12px;
            border-radius: 10px;
            text-decoration: none;
            font-weight: bold;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            transition: background 0.3s;
        }

        .logout-btn:hover {
            background-color: #c0392b;
            color: white !important;
        }

        /* Main Content Container */
        .main-content {
            width: 82%;
            padding: 40px;
            display: flex;
            justify-content: center;
            align-items: flex-start;
        }

        /* Form Card Styling */
        .form-container {
            background-color: white;
            width: 100%;
            max-width: 900px;
            padding: 40px;
            border-radius: 20px;
            box-shadow: 0 10px 25px rgba(0,0,0,0.05);
        }

        .form-title {
            color: #511c8a;
            font-size: 28px;
            font-weight: bold;
            text-align: center;
            margin-bottom: 5px;
        }

        .form-subtitle {
            color: #888;
            font-size: 14px;
            text-align: center;
            margin-bottom: 35px;
        }

        /* 2-Column Grid */
        .form-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 25px;
        }

        .form-group {
            display: flex;
            flex-direction: column;
        }

        .form-group label {
            color: #511c8a;
            font-size: 14px;
            font-weight: 600;
            margin-bottom: 8px;
        }

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

        /* Input field arrows removal */
        .form-group input[type=number]::-webkit-inner-spin-button,
        .form-group input[type=number]::-webkit-outer-spin-button {
            -webkit-appearance: none;
            margin: 0;
        }

        .error-msg {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        /* Buttons Layout */
        .btn-group {
            margin-top: 35px;
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
        }

        .btn {
            padding: 15px;
            font-size: 15px;
            font-weight: bold;
            border: none;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s;
            text-align: center;
            text-decoration: none;
        }

        .btn-submit {
            background-color: #511c8a;
            color: white;
        }

        .btn-submit:hover {
            background-color: #3d1469;
            box-shadow: 0 5px 15px rgba(81, 28, 138, 0.3);
        }

        .btn-reset {
            background-color: #f1f5f9;
            color: #64748b;
        }

        .btn-reset:hover {
            background-color: #e2e8f0;
            color: #334155;
        }

        .btn-dashboard {
            background-color: #dcd1f3;
            color: #511c8a;
        }

        .btn-dashboard:hover {
            background-color: #cbbae8;
        }

        /* Success Alert Pop-up Notification */
        .success-modal {
            display: none;
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #2ecc71;
            color: white;
            padding: 15px 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 1000;
            animation: slideIn 0.5s ease-out;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        /* Error Popup Notification */
        .error-modal {
            display: none;
            position: fixed;
            top: 20px;
            right: 20px;
            background-color: #e74c3c;
            color: white;
            padding: 15px 25px;
            border-radius: 12px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.2);
            z-index: 1000;
            animation: slideIn 0.5s ease-out;
            align-items: center;
            gap: 10px;
            font-weight: 500;
        }

        @keyframes slideIn {
            from { transform: translateX(120%); }
            to { transform: translateX(0); }
        }
    </style>
</head>
<body>

<div id="successAlert" class="success-modal">
    <i class="fa-solid fa-circle-check" style="font-size: 20px;"></i>
    <span>Faculty Registered Successfully!</span>
</div>

<div id="duplicateAlert" class="error-modal">
    <i class="fa-solid fa-circle-exclamation" style="font-size: 20px;"></i>
    <span>This Faculty ID is already registered!</span>
</div>

<div class="sidebar">
    <div class="sidebar-brand">LMS Admin</div>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
        <li><a href="student_reg.jsp"><i class="fa-solid fa-user-graduate"></i> Student Registration</a></li>
        <li class="active"><a href="faculty_reg.jsp"><i class="fa-solid fa-chalkboard-user"></i> Faculty Registration</a></li>
        <li><a href="add_book.jsp"><i class="fa-solid fa-plus"></i> Add New Book</a></li>
        <li><a href="issue_book.jsp"><i class="fa-solid fa-book-open"></i> Issue Book</a></li>
        <li><a href="view_book.jsp"><i class="fa-solid fa-book"></i> View Books</a></li>
        <li><a href="view_student.jsp"><i class="fa-solid fa-users"></i> View Students</a></li>
        <li><a href="view_faculty.jsp"><i class="fa-solid fa-chalkboard-user"></i> View Faculty</a></li>
        <li><a href="view_issue_book.jsp"><i class="fa-solid fa-book-open"></i>View Issue Books</a></li>
    </ul>
    <a href="logout" class="logout-btn"><i class="fa-solid fa-door-open"></i> Log-out</a>
</div>

<div class="main-content">
    <div class="form-container">
        <h2 class="form-title">Faculty Registration</h2>
        <p class="form-subtitle">Enter profile metrics to sync faculty records with tracking node</p>

        <form id="facultyForm" action="RegisterFacultyServlet" method="POST" onsubmit="return validateFacultyForm(event)">
            <div class="form-grid">

                <div class="form-group">
                    <label for="facultyId">Faculty ID Number</label>
                    <input type="text" id="facultyId" name="facultyId" placeholder="e.g. FAC202601" required>
                    <div id="idError" class="error-msg">🚨 ID can only contain alphanumeric values (No spaces or special chars)</div>
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="Enter full name" required>
                    <div id="nameError" class="error-msg">🚨 Name can only take characters (A-Z), not numbers</div>
                </div>

                <div class="form-group">
                    <label for="course">Department / Course Mapping</label>
                    <select id="course" name="course" required>
                        <option value="" disabled selected>Select Department</option>
                        <option value="BCA">BCA / Computer Applications</option>
                        <option value="B.Tech">B.Tech / Engineering</option>
                        <option value="B.Sc">B.Sc / Science</option>
                        <option value="BBA">BBA / Management</option>
                        <option value="MCA">MCA</option>
                        <option value="M.Tech">M.Tech</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="designation">Designation</label>
                    <select id="designation" name="designation" required>
                        <option value="" disabled selected>Select Designation</option>
                        <option value="Professor">Professor</option>
                        <option value="Assistant Professor">Assistant Professor</option>
                        <option value="Associate Professor">Associate Professor</option>
                        <option value="HOD">Head of Department (HOD)</option>
                        <option value="Lab Assistant">Lab Assistant</option>
                        <option value="Lecturer">Lecturer</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="joiningYear">Year of Joining (4 Digits)</label>
                    <input type="number" id="joiningYear" name="joiningYear" placeholder="e.g. 1998" min="1950" max="2026" required>
                    <div id="yearError" class="error-msg">🚨 Year must be a valid 4-digit number (e.g., 1950 to 2026)</div>
                </div>

                <div class="form-group">
                    <label for="phoneNo">Phone Number</label>
                    <input type="tel" id="phoneNo" name="phoneNo" placeholder="Enter 10-digit number" required>
                    <div id="phoneError" class="error-msg">🚨 Please enter a valid 10-digit phone number</div>
                </div>

            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-submit">Register Faculty</button>
                <button type="reset" class="btn btn-reset">Reset Form</button>
                <a href="dashboard.jsp" class="btn btn-dashboard">Back to Dashboard</a>
            </div>
        </form>
    </div>
</div>

<script>
    // --- URL PARAMETER STATUS CHECK LOGIC ---
    window.onload = function() {
        const urlParams = new URLSearchParams(window.location.search);
        const status = urlParams.get('status');

        if (status === 'success') {
            const toast = document.getElementById('successAlert');
            toast.style.display = 'flex';
            setTimeout(() => { toast.style.display = 'none'; }, 3500);
        } else if (status === 'duplicate') {
            const toast = document.getElementById('duplicateAlert');
            toast.style.display = 'flex';
            setTimeout(() => { toast.style.display = 'none'; }, 3500);
        }
    }

    // --- LIVE FORM VALIDATIONS ---
    function validateFacultyForm(event) {
        const fullName = document.getElementById('fullName').value.trim();
        const facultyId = document.getElementById('facultyId').value.trim();
        const phoneInput = document.getElementById('phoneNo').value.trim();
        const joiningYear = document.getElementById('joiningYear').value.trim();

        const nameError = document.getElementById('nameError');
        const idError = document.getElementById('idError');
        const phoneError = document.getElementById('phoneError');
        const yearError = document.getElementById('yearError');

        const nameRegex = /^[a-zA-Z\s]+$/;
        const idRegex = /^[a-zA-Z0-9]+$/;
        const yearRegex = /^[0-9]{4}$/;

        let isValid = true;

        // 1. Full Name Validation
        if (!nameRegex.test(fullName)) {
            nameError.style.display = 'block';
            document.getElementById('fullName').style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            nameError.style.display = 'none';
            document.getElementById('fullName').style.borderColor = '#e2e8f0';
        }

        // 2. Faculty ID Validation
        if (!idRegex.test(facultyId)) {
            idError.style.display = 'block';
            document.getElementById('facultyId').style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            idError.style.display = 'none';
            document.getElementById('facultyId').style.borderColor = '#e2e8f0';
        }

        // 3. Year of Joining Validation
        const currentYear = new Date().getFullYear();
        if (!yearRegex.test(joiningYear) || parseInt(joiningYear) < 1950 || parseInt(joiningYear) > currentYear) {
            yearError.style.display = 'block';
            document.getElementById('joiningYear').style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            yearError.style.display = 'none';
            document.getElementById('joiningYear').style.borderColor = '#e2e8f0';
        }

        // 4. Phone Number Validation
        if (phoneInput.length !== 10 || isNaN(phoneInput)) {
            phoneError.style.display = 'block';
            document.getElementById('phoneNo').style.borderColor = '#e74c3c';
            isValid = false;
        } else {
            phoneError.style.display = 'none';
            document.getElementById('phoneNo').style.borderColor = '#e2e8f0';
        }

        if (!isValid) {
            event.preventDefault();
            return false;
        }
        return true;
    }
</script>
</body>
</html>