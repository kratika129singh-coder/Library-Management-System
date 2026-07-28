<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Student Registration - LMS Admin</title>
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

        /* Sidebar Styling (Purple Theme) */
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
            position: relative;
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

        /* 2-Column Responsive Grid */
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

        /* Input error text styling */
        .error-msg {
            color: #e74c3c;
            font-size: 12px;
            margin-top: 5px;
            display: none;
        }

        /* Button Layout (3 buttons row) */
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

        @keyframes slideIn {
            from { transform: translateX(120%); }
            to { transform: translateX(0); }
        }
    </style>
    <script>
    function validateForm() {
        var name = document.forms["regForm"]["student_name"].value;
        // Regular Expression: Sirf alphabets aur spaces allowed hain
        var regex = /^[a-zA-Z\s]+$/;

        if (!regex.test(name)) {
            document.getElementById("name-error").style.display = "block";
            return false; // Form submit nahi hoga
        }
        document.getElementById("name-error").style.display = "none";
        return true;
    }
</script>
</head>
<body>

<div id="successAlert" class="success-modal">
    <i class="fa-solid fa-circle-check" style="font-size: 20px;"></i>
    <span>Student Registered Successfully!</span>
</div>

<div class="sidebar">
    <div class="sidebar-brand">LMS Admin</div>
    <ul class="sidebar-menu">
        <li><a href="dashboard.jsp"><i class="fa-solid fa-chart-pie"></i> Dashboard</a></li>
        <li class="active"><a href="student_reg.jsp"><i class="fa-solid fa-user-graduate"></i> Student Registration</a></li>
        <li><a href="faculty_reg.jsp"><i class="fa-solid fa-chalkboard-user"></i> Faculty Registration</a></li>
        <li><a href="add_book.jsp"><i class="fa-solid fa-plus"></i> Add New Book</a></li>
        <li><a href="issue_book.jsp"><i class="fa-solid fa-book-open"></i> Issue Book</a></li>
        <li><a href="view_book.jsp"><i class="fa-solid fa-book"></i> View Books</a></li>
        <li><a href="view_student.jsp"><i class="fa-solid fa-user-graduate"></i>View Students</a></li>
        <li><a href="view_faculty.jsp"><i class="fa-solid fa-chalkboard-user"></i>View Faculty</a></li>
        <li><a href="view_issue_book.jsp"><i class="fa-solid fa-book-open"></i>View Issued Books</a></li>
    </ul>
    <a href="logout" class="logout-btn"><i class="fa-solid fa-door-open"></i> Log-out</a>
</div>

<div class="main-content">
    <div class="form-container">
        <h2 class="form-title">Student Registration</h2>
        <p class="form-subtitle">Enter student details to add them to the system</p>

        <form id="studentForm" action="RegisterStudentServlet" method="POST" onsubmit="return validateForm(event)">
            <div class="form-grid">

                <div class="form-group">
                    <label for="rollNo">Student Roll Number</label>
                    <input type="text" id="rollNo" name="rollNo" placeholder="e.g. 23BCA101" onblur="checkDuplicateRoll()" required>
                    <div id="rollFormatError" class="error-msg">! Roll Number take only Numbers</div>
                    <div id="rollError" class="error-msg">This Roll Number is already registered!</div>
                </div>

                <div class="form-group">
                    <label for="fullName">Full Name</label>
                    <input type="text" id="fullName" name="fullName" placeholder="Enter full name" required>
                    <div id="nameError" class="error-msg">! Name take only characters(A-Z) not Numbers</div>

                </div>

                <div class="form-group">
                    <label for="course">Course / Department</label>
                    <select id="course" name="course" required>
                        <option value="" disabled selected>Select Course</option>
                        <option value="BCA">BCA</option>
                        <option value="B.Tech">B.Tech</option>
                        <option value="B.Sc">B.Sc</option>
                        <option value="BBA">BBA</option>
                        <option value="BCom">BCom</option>
                        <option value="BioTech">BioTech</option>
                        <option value="BA">BA</option>
                        <option value="BA(LLB)">BA(LLB)</option>
                        <option value="MCA">MCA</option>
                        <option value="M.Tech">M.Tech</option>
                        <option value="M.Sc">M.Sc</option>
                        <option value="MA">MA</option>

                    </select>
                </div>

                <div class="form-group">
                    <label for="batch">Year of Admission</label>
                    <select id="batch" name="batch" required>
                        <option value="" disabled selected>Select Year</option>
                        <option value="2026">2026</option>
                        <option value="2025">2025</option>
                        <option value="2024">2024</option>
                        <option value="2023">2023</option>
                        <option value="2022">2022</option>
                        <option value="2021">2021</option>
                        <option value="2020">2020</option>
                    </select>

                </div>

                <div class="form-group">
                    <label for="semester">Current Semester</label>
                    <select id="semester" name="semester" required>
                        <option value="" disabled selected>Select Semester</option>
                        <option value="1st Semester">1st Semester</option>
                        <option value="2nd Semester">2nd Semester</option>
                        <option value="3rd Semester">3rd Semester</option>
                        <option value="4th Semester">4th Semester</option>
                        <option value="5th Semester">5th Semester</option>
                        <option value="6th Semester">6th Semester</option>
                        <option value="6th Semester">7th Semester</option>
                        <option value="6th Semester">8th Semester</option>
                        <option value="6th Semester">9th Semester</option>
                        <option value="6th Semester">10th Semester</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="phoneNo">Phone Number</label>
                    <input type="tel" id="phoneNo" name="phoneNo" placeholder="Enter 10-digit phone number" pattern="[0-9]{10}" required>
                    <div id="phoneError" class="error-msg">Please enter a valid 10-digit phone number.</div>
                </div>

                <div class="form-group">
                    <label for="email">Email ID</label>
                    <input type="email" id="email" name="email" placeholder="e.g. student@gmail.com" required>
                </div>

            </div>

            <div class="btn-group">
                <button type="submit" class="btn btn-submit">Register Student</button>
                <button type="reset" class="btn btn-reset">Reset Form</button>
                <a href="dashboard.jsp" class="btn btn-dashboard">Back to Dashboard</a>
            </div>
        </form>
    </div>
</div>

<script>
    // Real-time Phone Validation & Success Alert Logic
    function validateForm(event) {
    const fullName = document.getElementById('fullName').value.trim();
    const rollNo = document.getElementById('rollNo').value.trim();
    const phoneInput = document.getElementById('phoneNo').value;

    // Error Elements Fetch Karna
    const nameError = document.getElementById('nameError');
    const rollFormatError = document.getElementById('rollFormatError');
    const phoneError = document.getElementById('phoneError');

    // Regex Formulae
    const nameRegex = /^[a-zA-Z\s]+$/;   // Sirf akshar aur space
    const rollRegex = /^[a-zA-Z0-9]+$/;  // Akshar aur numbers (No @, #, $, spaces)

    let isValid = true;

    // 1. Name Check (Agar number dala toh red text dikhao)
    if (!nameRegex.test(fullName)) {
        nameError.style.display = 'block';
        document.getElementById('fullName').style.borderColor = '#e74c3c';
        isValid = false;
    } else {
        nameError.style.display = 'none';
        document.getElementById('fullName').style.borderColor = '#e2e8f0';
    }

    // 2. Roll Number Check (Special characters/spaces block)
    if (!rollRegex.test(rollNo)) {
        rollFormatError.style.display = 'block';
        document.getElementById('rollNo').style.borderColor = '#e74c3c';
        isValid = false;
    } else {
        rollFormatError.style.display = 'none';
        document.getElementById('rollNo').style.borderColor = '#e2e8f0';
    }

    // 3. Phone Number Check
    if(phoneInput.length !== 10 || isNaN(phoneInput)) {
        phoneError.style.display = 'block';
        document.getElementById('phoneNo').style.borderColor = '#e74c3c';
        isValid = false;
    } else {
        phoneError.style.display = 'none';
        document.getElementById('phoneNo').style.borderColor = '#e2e8f0';
    }

    // Agar sab sahi hai, tabhi toast notification aur form submit hoga
    if (isValid) {
        const toast = document.getElementById('successAlert');
        toast.style.display = 'flex';
        setTimeout(() => {
            toast.style.display = 'none';
        }, 3000);
        return true;
    }

    return false; // Ek bhi mistake par form ruk jayega
}


    // Duplicate Roll Number Basic Tracking (For client-side warning)
    function checkDuplicateRoll() {
        const rollInput = document.getElementById('rollNo').value;
        const rollError = document.getElementById('rollError');

        // Demo duplicate validation: Agar value "101" dalenge toh warning aayegi
        if(rollInput === "101" || rollInput.toLowerCase() === "demo") {
            rollError.style.display = 'block';
            document.getElementById('rollNo').style.borderColor = '#e74c3c';
        } else {
            rollError.style.display = 'none';
            document.getElementById('rollNo').style.borderColor = '#e2e8f0';
        }
    }
</script>
</body>
</html>