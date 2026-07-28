<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/18/2026
  Time: 2:15 PM
--%>
<%@ page import="java.util.Date, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session Check: Redirect to login if admin session is not active
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Generate today's date in standard HTML5 date format (yyyy-MM-dd)
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    String todayStr = sdf.format(new Date());
%>
<html>
<head>
    <title>LMS | Issue & Reissue Book</title>
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

        /* Sidebar: Dark Purple Navigation Panel */
        .sidebar {
            width: 280px;
            background: #812ea0;
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
            background: #9750a8;
            font-weight: 600;
        }

        /* Main Scrollable Content Area on Right Side */
        .main-content {
            flex: 1;
            padding: 40px;
            overflow-y: auto;
            display: flex;
            justify-content: center;
            align-items: center;
            background: rgba(255, 255, 255, 0.25);
            backdrop-filter: blur(8px);
        }

        /* Core Form Layout Box Container */
        .form-container {
            background: white;
            padding: 40px;
            border-radius: 25px;
            box-shadow: 0 15px 35px rgba(81, 45, 168, 0.15);
            width: 100%;
            max-width: 800px;
        }

        .form-header {
            text-align: center;
            margin-bottom: 25px;
        }

        .form-header h2 { color: #512da8; font-size: 26px; letter-spacing: 1px; }
        .form-header p { color: #888; font-size: 14px; }

        /* Two-Column Grid For Input Items */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .input-group { margin-bottom: 5px; position: relative; }
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

        .input-group input[readonly] {
            background: #eee;
            border-color: #d1c4e9;
            cursor: not-allowed;
            color: #777;
        }

        /* Async Live Verification Response Status Flags Labels */
        .live-status {
            font-size: 11px;
            margin-top: 5px;
            font-weight: 600;
            display: block;
        }
        .status-success { color: #2e7d32; }
        .status-error { color: #c62828; }

        /* Policy Alert Instruction Notification Container Block */
        .rules-box {
            grid-column: span 2;
            background: #f4f0ff;
            border-left: 5px solid #812ea0;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 5px;
        }
        .rules-box h4 { color: #512da8; font-size: 14px; margin-bottom: 5px; }
        .rules-box ul { list-style-type: none; padding-left: 5px; }
        .rules-box li { font-size: 12px; color: #555; display: flex; align-items: center; gap: 6px; }

        /* Button controls row panel */
        .button-group { grid-column: span 2; display: flex; margin-top: 15px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 12px; font-size: 15px; font-weight: 600; cursor: pointer; transition: 0.3s; text-align: center; text-decoration: none; }

        .btn-issue { background: #512da8; color: white; width: 100%; }
        .btn-issue:hover { background: #311b92; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(81, 45, 168, 0.3); }

        /* Logout Buttons Configurations */
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
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="student_reg.jsp">👨‍🎓 Student Registration</a>
    <a href="faculty_reg.jsp">👨‍🏫 Faculty Registration</a>
    <a href="add_book.jsp">➕ Add New Book</a>
    <a href="issue_book.jsp" class="active">📑 Issue Book</a>
    <a href="view_book.jsp">📚 View Books</a>
    <a href="view_student.jsp">👨‍🎓 View Students</a>
    <a href="view_faculty.jsp">👨‍🏫 View Faculty</a>
    <a href="view_issue_book.jsp" >📑 View Issued Books</a>
    <a href="index.jsp" class="logout-btn">🚪 Log-out</a>
</div>

<div class="main-content">
    <div class="form-container">
        <div class="form-header">
            <h2>Manage Book Allocation</h2>
            <p>Allocate new assets or renew active allocations seamlessly</p>
        </div>

        <div class="rules-box">
            <h4>Library Allocation Policies:</h4>
            <ul>
                <li>• Allocation Cap: Borrowers are limited to a maximum of 1 active allocation item at any point.</li>
                <li>• Duration Terms: Students receive 7 Days limit. Faculty profile layers are granted 3 Months (90 Days).</li>
            </ul>
        </div>

        <form id="allocationForm" method="post" onsubmit="return validateForm();">
            <div class="form-grid">

                <div class="input-group">
                    <label>Borrower Type</label>
                    <select id="borrower_type" name="borrower_type" onchange="handleTypeChange()" required>
                        <option value="" disabled selected>Choose Type</option>
                        <option value="Student">Student</option>
                        <option value="Faculty">Faculty</option>
                    </select>
                </div>

                <div class="input-group">
                    <label>Borrower ID (Roll No / Faculty ID)</label>
                    <input type="text" id="borrower_id" name="borrower_id" placeholder="Enter valid registration ID" onchange="verifyBorrower()" required>
                    <span id="borrower_status" class="live-status"></span>
                </div>

                <div class="input-group">
                    <label>Book Accession Number</label>
                    <input type="text" id="accession_no" name="accession_no" placeholder="Enter book accession number" onchange="verifyBook()" required>
                    <span id="book_status" class="live-status"></span>
                </div>

                <div class="input-group">
                    <label>Issue / Reissue Date</label>
                    <input type="date" id="issue_date" name="issue_date" value="<%= todayStr %>" readonly required>
                </div>

                <div class="input-group" style="grid-column: span 2;">
                    <label>Expected Due Date (Auto-calculated)</label>
                    <input type="date" id="due_date" name="due_date" readonly required>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-issue" onclick="setFormAction('IssueBookServlet')">Process Allocation</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // Validation control execution check variables
    let isBorrowerValid = false;
    let isBookValid = false;

    // Dynamically re-routes form targets according to clicked button context
    function setFormAction(servletName) {
        document.getElementById('allocationForm').action = servletName;
    }

    // Flushes profile references upon identifier switch shifts
    function handleTypeChange() {
        calculateDueDate();
        document.getElementById('borrower_id').value = "";
        document.getElementById('borrower_status').innerHTML = "";
        isBorrowerValid = false;
    }

    // Computes milestones based on rule configurations (Students: 7 days, Faculty: 90 days)
    function calculateDueDate() {
        const typeSelect = document.getElementById('borrower_type').value;
        const issueDateVal = document.getElementById('issue_date').value;
        const dueDateField = document.getElementById('due_date');

        if (!issueDateVal || !typeSelect) return;

        let baseDate = new Date(issueDateVal);

        // Updates condition matrix mapping: Student = 7 Days, Faculty = 90 Days (3 Months)
        let allocationDays = (typeSelect === "Student") ? 7 : 90;

        baseDate.setDate(baseDate.getDate() + allocationDays);

        const computedYear = baseDate.getFullYear();
        const computedMonth = String(baseDate.getMonth() + 1).padStart(2, '0');
        const computedDay = String(baseDate.getDate()).padStart(2, '0');

        dueDateField.value = computedYear + "-" + computedMonth + "-" + computedDay;
    }

    // Async live data evaluator verification process scanning database maps
    function verifyBorrower() {
        const type = document.getElementById('borrower_type').value;
        const borrowerId = document.getElementById('borrower_id').value.trim();
        const statusSpan = document.getElementById('borrower_status');

        if (!type) {
            alert("Please select Borrower Type first!");
            document.getElementById('borrower_id').value = "";
            return;
        }

        if (borrowerId === "") {
            statusSpan.innerHTML = "";
            return;
        }

        statusSpan.className = "live-status";
        statusSpan.innerHTML = "Checking database records...";

        const xhr = new XMLHttpRequest();
        xhr.open("GET", "VerifyBorrowerServlet?type=" + type + "&id=" + borrowerId, true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const response = xhr.responseText.trim();

                if (response.startsWith("VALID:")) {
                    const name = response.substring(6);
                    statusSpan.className = "live-status status-success";
                    statusSpan.innerHTML = "Verified Name: " + name;
                    isBorrowerValid = true;
                } else {
                    statusSpan.className = "live-status status-error";
                    statusSpan.innerHTML = "✗ " + response;
                    isBorrowerValid = false;
                }
            }
        };
        xhr.send();
    }

    // Async live data evaluator verification process validating inventory item rows
    function verifyBook() {
        const accessionNo = document.getElementById('accession_no').value.trim();
        const statusSpan = document.getElementById('book_status');

        if (accessionNo === "") {
            statusSpan.innerHTML = "";
            return;
        }

        statusSpan.className = "live-status";
        statusSpan.innerHTML = "Verifying book inventory status...";

        const xhr = new XMLHttpRequest();
        xhr.open("GET", "VerifyBookServlet?accession_no=" + accessionNo, true);

        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                const response = xhr.responseText.trim();

                if (response.startsWith("AVAILABLE:")) {
                    const title = response.substring(10);
                    statusSpan.className = "live-status status-success";
                    statusSpan.innerHTML = "✓ Available Book: " + title;
                    isBookValid = true;
                } else {
                    statusSpan.className = "live-status status-error";
                    statusSpan.innerHTML = "✗ " + response;
                    isBookValid = false;
                }
            }
        };
        xhr.send();
    }

    // Master client submit execution pipe interceptor logic
    function validateForm() {
        if (!isBorrowerValid) {
            alert("Please enter a verified and valid Borrower ID.");
            return false;
        }
        if (!isBookValid) {
            alert("Please enter a valid, unissued Book Accession Number.");
            return false;
        }
        return true;
    }
</script>
</body>
</html>