<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/14/2026
  Time: 1:54 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session Check: Redirect to login if admin session is not active
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
%>
<html>
<head>
    <title>LMS | Add New Book</title>
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

        /* Sidebar: Dark Purple Navigation Panel (Consistent with Dashboard) */
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

        /* Main Scrollable Content Area on the Right Side */
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

        /* Form Layout Box Container */
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

        /* Two-Column Grid Setup */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .input-group { margin-bottom: 5px; }
        .input-group label { display: block; font-size: 13px; color: #512da8; font-weight: 600; margin-bottom: 8px; }

        .input-group input {
            width: 100%;
            padding: 12px;
            border: 2px solid #efedff;
            border-radius: 10px;
            font-size: 14px;
            transition: 0.3s;
            background: #fcfaff;
            color: #333;
        }

        .input-group input:focus { outline: none; border-color: #512da8; background: white; }

        /* Background color change highlighting invalid field entries */
        .input-group input:invalid { border-color: grey; background: #fff6f6; }

        .button-group { grid-column: span 2; display: flex; gap: 15px; margin-top: 15px; }
        .btn { flex: 1; padding: 12px; border: none; border-radius: 12px; font-size: 16px; font-weight: 600; cursor: pointer; transition: 0.3s; text-align: center; text-decoration: none; }
        .btn-save { background: #512da8; color: white; }
        .btn-save:hover { background: #311b92; transform: translateY(-2px); box-shadow: 0 5px 15px rgba(81, 45, 168, 0.3); }

        /* Logout Button Styles */
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
    <a href="add_book.jsp" class="active">➕ Add New Book</a>
    <a href="issue_book.jsp">📑 Issue Book</a>
    <a href="view_book.jsp">📚 View Books</a>
    <a href="view_student.jsp">👨‍🎓 View Students</a>
    <a href="view_faculty.jsp">👨‍🏫 View Faculty</a>
    <a href="view_issue_book.jsp">📑 View Issued Books</a>
    <a href="index.jsp" class="logout-btn">🚪 Log-out</a>
</div>

<div class="main-content">

    <div class="form-container">
        <div class="form-header">
            <h2>Add New Book</h2>
            <p>Enter book details for Library Inventory</p>
        </div>

        <form action="AddBookServelet" method="post" oninput="validateLiveFields()">
            <div class="form-grid">
                <div class="input-group">
                    <label>Book Accession Number</label>
                    <input type="text" id="accession_no" name="accession_no" placeholder="e.g. ACC-2026" required>
                </div>
                <div class="input-group">
                    <label>Book Name(Title)</label>
                    <input type="text" id="book_title" name="book_title" placeholder="Enter book name" required>
                </div>

                <div class="input-group">
                    <label>Book Author</label>
                    <input type="text" id="author" name="author" placeholder="Enter author name" required>
                </div>
                <div class="input-group">
                    <label>Edition Number</label>
                    <input type="text" id="edition" name="edition" placeholder="e.g. 2nd Edition" required>
                </div>

                <div class="input-group">
                    <label>Address (Place of Publication)</label>
                    <input type="text" id="pub_place" name="pub_place" placeholder="e.g. Aligarh" required>
                </div>
                <div class="input-group">
                    <label>Year of Publication</label>
                    <input type="number" id="pub_year" name="pub_year" placeholder="e.g. 2026" required>
                </div>

                <div class="input-group">
                    <label>Total Pages</label>
                    <input type="number" id="pages" name="pages" placeholder="Number of pages" required>
                </div>
                <div class="input-group">
                    <label>Source of Purchase</label>
                    <input type="text" id="purchase_source" name="purchase_source" placeholder="e.g. Online/Local Vendor" required>
                </div>

                <div class="input-group">
                    <label>Price (₹)</label>
                    <input type="number" id="price" step="0.01" name="price" placeholder="0.00" required>
                </div>
                <div class="input-group">
                    <label>Bill Number</label>
                    <input type="text" id="bill_no" name="bill_no" placeholder="Enter bill reference" required>
                </div>

                <div class="button-group">
                    <button type="submit" class="btn btn-save">Save Book</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
    // Live validation evaluator checking entries continuously during inputs
    function validateLiveFields() {
        // Fetching reference pointers for input fields
        const accField = document.getElementById('accession_no');
        const titleField = document.getElementById('book_title');
        const authorField = document.getElementById('author');
        const editionField = document.getElementById('edition');
        const placeField = document.getElementById('pub_place');
        const yearField = document.getElementById('pub_year');
        const pagesField = document.getElementById('pages');
        const sourceField = document.getElementById('purchase_source');
        const priceField = document.getElementById('price');
        const billField = document.getElementById('bill_no');

        // Regex regular expression pattern configurations
        const alphaNumericDash = /^[a-zA-Z0-9\-]+$/;    // Letters, Numbers, Dash
        const pureText = /^[a-zA-Z\s\.\,\'\:\-]+$/;      // Only Letters and space punctuation
        const alphaNumericSpace = /^[a-zA-Z0-9\s\/\-]+$/; // Mixed codes for bills/editions

        // 1. Accession Number Policy Check
        if (accField.value.trim() === "") {
            accField.setCustomValidity("we can not skipit! Fill this too");
        } else if (!alphaNumericDash.test(accField.value.trim())) {
            accField.setCustomValidity("Alphabets, numbers and dash (-) are allowed in accession number !");
        } else {
            accField.setCustomValidity(""); // Clear error state successfully
        }

        // 2. Book Title Policy Check
        if (titleField.value.trim() === "") {
            titleField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(titleField.value.trim()) || !isNaN(titleField.value.trim())) {
            titleField.setCustomValidity("Only letters are allowed not numbers!");
        } else {
            titleField.setCustomValidity("");
        }

        // 3. Author Profile Layer Check
        if (authorField.value.trim() === "") {
            authorField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(authorField.value.trim()) || !isNaN(authorField.value.trim())) {
            authorField.setCustomValidity("Only letters are allowed not numbers!");
        } else {
            authorField.setCustomValidity("");
        }

        // 4. Edition Meta Format Check
        if (editionField.value.trim() === "") {
            editionField.setCustomValidity("It is compulsory ti fill!");
        } else if (!alphaNumericSpace.test(editionField.value.trim())) {
            editionField.setCustomValidity("Special symbols characters are not allowed !");
        } else {
            editionField.setCustomValidity("");
        }

        // 5. Publication Place Text Check
        if (placeField.value.trim() === "") {
            placeField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(placeField.value.trim())) {
            placeField.setCustomValidity("In Place of Publication should be city's name in  (text)!");
        } else {
            placeField.setCustomValidity("");
        }

        // 6. Timeline Boundary Year Check
        const yearVal = parseInt(yearField.value);
        if (yearField.value.trim() === "") {
            yearField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(yearVal) || yearVal < 1800 || yearVal > 2026) {
            yearField.setCustomValidity("Enter year between 1800 se 2026 year only .");
        } else {
            yearField.setCustomValidity("");
        }

        // 7. Page Volume Counter Check
        const pagesVal = parseInt(pagesField.value);
        if (pagesField.value.trim() === "") {
            pagesField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(pagesVal) || pagesVal <= 0) {
            pagesField.setCustomValidity("Fill the page number properely");
        } else {
            pagesField.setCustomValidity("");
        }

        // 8. Procurement Origin Text Check
        if (sourceField.value.trim() === "") {
            sourceField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(sourceField.value.trim())) {
            sourceField.setCustomValidity("Only text are allowed!");
        } else {
            sourceField.setCustomValidity("");
        }

        // 9. Financial Valuation Numeric Value Check
        const priceVal = parseFloat(priceField.value);
        if (priceField.value.trim() === "") {
            priceField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(priceVal) || priceVal <= 0) {
            priceField.setCustomValidity("Price should be greater to 0!");
        } else {
            priceField.setCustomValidity("");
        }

        // 10. Billing Reference Reference ID Check
        if (billField.value.trim() === "") {
            billField.setCustomValidity("It is compulsory ti fill!");
        } else if (!alphaNumericSpace.test(billField.value.trim())) {
            billField.setCustomValidity("Special symbols are not allowed!");
        } else {
            billField.setCustomValidity("");
        }
    }

    // Trigger validation checklist setups instantly upon core screen load events completion
    window.onload = function() {
        validateLiveFields();
    };
</script>

</body>
</html>