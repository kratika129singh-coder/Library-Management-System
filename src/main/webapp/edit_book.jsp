<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/15/2026
  Time: 3:28 PM
--%>
<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String id = request.getParameter("id"); // View Books table se jo id aayi h
    String bname="", author="", edition="", address="", year="", pages="", source="", price="", bill="";

    try {
        Connection con = DBConnection.getConnection();
        PreparedStatement ps = con.prepareStatement("SELECT * FROM books WHERE Accession_no = ?");
        ps.setString(1, id);
        ResultSet rs = ps.executeQuery();

        if(rs.next()) {
            bname = rs.getString("book_title");
            author = rs.getString("author");
            edition = rs.getString("edition");
            address = rs.getString("publication_place");
            year = rs.getString("pub_year");
            pages = rs.getString("pages");
            source = rs.getString("purchase_source");
            price = rs.getString("price");
            bill = rs.getString("bill_no");
        }
        con.close();
    } catch(Exception e) { e.printStackTrace(); }
%>

<html>
<head>
    <title>LMS | Edit Book Details</title>
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
        .input-group input:invalid { border-color: grey; background: #fff6f6; }

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
        <h2>Edit Book Details</h2>
        <p>Modify and update book details for Library Inventory</p>
    </div>

    <form action="UpdateBookServlet" method="post" oninput="validateLiveFields()">
        <div class="form-grid">
            <div class="input-group">
                <label>Book Accession Number (Read-only)</label>
                <input type="text" id="accession_no" name="accession_no" value="<%= id %>" readonly required>
            </div>
            <div class="input-group">
                <label>Book Name</label>
                <input type="text" id="book_title" name="book_title" value="<%= bname %>" required>
            </div>

            <div class="input-group">
                <label>Book Author</label>
                <input type="text" id="author" name="author" value="<%= author %>" required>
            </div>
            <div class="input-group">
                <label>Edition Number</label>
                <input type="text" id="edition" name="edition" value="<%= edition %>" required>
            </div>

            <div class="input-group">
                <label>Address (Place of Publication)</label>
                <input type="text" id="pub_place" name="pub_place" value="<%= address %>" required>
            </div>
            <div class="input-group">
                <label>Year of Publication</label>
                <input type="number" id="pub_year" name="pub_year" value="<%= year %>" required>
            </div>

            <div class="input-group">
                <label>Total Pages</label>
                <input type="number" id="pages" name="pages" value="<%= pages %>" required>
            </div>
            <div class="input-group">
                <label>Source of Purchase</label>
                <input type="text" id="purchase_source" name="purchase_source" value="<%= source %>" required>
            </div>

            <div class="input-group">
                <label>Price (₹)</label>
                <input type="number" id="price" step="0.01" name="price" value="<%= price %>" required>
            </div>
            <div class="input-group">
                <label>Bill Number</label>
                <input type="text" id="bill_no" name="bill_no" value="<%= bill %>" required>
            </div>

            <div class="button-group">
                <button type="submit" class="btn btn-save">Update Changes</button>
                <a href="view_book.jsp" class="btn btn-back">Cancel</a>
            </div>
        </div>
    </form>
</div>

<script>
    function validateLiveFields() {
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

        const alphaNumericDash = /^[a-zA-Z0-9\-]+$/;
        const pureText = /^[a-zA-Z\s\.\,\'\:\-]+$/;
        const alphaNumericSpace = /^[a-zA-Z0-9\s\/\-]+$/;

        // 1. Accession Number
        if (accField.value.trim() === "") {
            accField.setCustomValidity("we can not skipit! Fill this too");
        } else if (!alphaNumericDash.test(accField.value.trim())) {
            accField.setCustomValidity("Alphabets, numbers and dash (-) are allowed in accession number !");
        } else { accField.setCustomValidity(""); }

        // 2. Book Title
        if (titleField.value.trim() === "") {
            titleField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(titleField.value.trim()) || !isNaN(titleField.value.trim())) {
            titleField.setCustomValidity("Only letters are allowed not numbers!");
        } else { titleField.setCustomValidity(""); }

        // 3. Author
        if (authorField.value.trim() === "") {
            authorField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(authorField.value.trim()) || !isNaN(authorField.value.trim())) {
            authorField.setCustomValidity("Only letters are allowed not numbers!");
        } else { authorField.setCustomValidity(""); }

        // 4. Edition
        if (editionField.value.trim() === "") {
            editionField.setCustomValidity("It is compulsory ti fill!");
        } else if (!alphaNumericSpace.test(editionField.value.trim())) {
            editionField.setCustomValidity("Special symbols characters are not allowed !");
        } else { editionField.setCustomValidity(""); }

        // 5. Publication Place
        if (placeField.value.trim() === "") {
            placeField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(placeField.value.trim())) {
            placeField.setCustomValidity("In Place of Publication should be city's name in (text)!");
        } else { placeField.setCustomValidity(""); }

        // 6. Year
        const yearVal = parseInt(yearField.value);
        if (yearField.value.trim() === "") {
            yearField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(yearVal) || yearVal < 1800 || yearVal > 2026) {
            yearField.setCustomValidity("Enter year between 1800 se 2026 year only .");
        } else { yearField.setCustomValidity(""); }

        // 7. Pages
        const pagesVal = parseInt(pagesField.value);
        if (pagesField.value.trim() === "") {
            pagesField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(pagesVal) || pagesVal <= 0) {
            pagesField.setCustomValidity("Fill the page number properely");
        } else { pagesField.setCustomValidity(""); }
        // 8. Purchase Source
        if (sourceField.value.trim() === "") {
            sourceField.setCustomValidity("It is compulsory ti fill!");
        } else if (!pureText.test(sourceField.value.trim())) {
            sourceField.setCustomValidity("Only text are allowed!");
        } else { sourceField.setCustomValidity(""); }

        // 9. Price
        const priceVal = parseFloat(priceField.value);
        if (priceField.value.trim() === "") {
            priceField.setCustomValidity("It is compulsory ti fill!");
        } else if (isNaN(priceVal) || priceVal <= 0) {
            priceField.setCustomValidity("Price should be greater to 0!");
        } else { priceField.setCustomValidity(""); }

        // 10. Bill Number
        if (billField.value.trim() === "") {
            billField.setCustomValidity("It is compulsory ti fill!");
        } else if (!alphaNumericSpace.test(billField.value.trim())) {
            billField.setCustomValidity("Special symbols are not allowed!");
        } else { billField.setCustomValidity(""); }
    }

    window.onload = function() {
        validateLiveFields();
    };
</script>
</body>
</html>