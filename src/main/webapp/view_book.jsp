<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/15/2026
  Time: 2:30 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session Check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
    }
%>
<html>
<head>
    <title>LMS | View Books</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            display: flex;
            background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
            background-attachment: fixed;
            height: 100vh;
        }

        /* Sidebar (Same as Dashboard) */
        .sidebar {
            width: 280px;
            background: #812ea0;
            color: white;
            display: flex;
            flex-direction: column;
            padding: 25px;
            box-shadow: 4px 0 15px rgba(0,0,0,0.1);
        }
        .sidebar h2 { text-align: center; margin-bottom: 40px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 15px; }
        .sidebar a {
            color: #efedff; padding: 12px 15px; text-decoration: none; margin-bottom: 8px;
            border-radius: 8px; transition: 0.3s; font-size: 14px;
        }
        .sidebar a:hover { background: rgba(255, 255, 255, 0.15); transform: translateX(8px); }
        .sidebar a.active { background: #9750a8; font-weight: 600; }

        /* Main Content */
        .main-content { flex: 1; padding: 40px; overflow-y: auto; }

        .card {
            background: rgba(255, 255, 255, 0.9);
            padding: 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .header-flex {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 30px;
        }

        h1 { color: #311b92; font-size: 24px; }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 10px;
            background: white;
            border-radius: 10px;
            overflow: hidden;
        }
        th {
            background: #673ab7;
            color: white;
            text-align: left;
            padding: 15px;
            font-size: 14px;
            text-transform: uppercase;
        }
        td {
            padding: 12px 15px;
            border-bottom: 1px solid #eee;
            font-size: 13px;
            color: #444;
        }
        tr:hover { background: #f9f6ff; }

        /* Action Buttons */
        .btn-edit { color: #2e7d32; text-decoration: none; font-weight: 600; margin-right: 10px; }
        .btn-delete { color: #c62828; text-decoration: none; font-weight: 600; }

        .no-data { text-align: center; padding: 50px; color: #777; }
    </style>
</head>
<body>

<div class="sidebar">
    <h2>LMS Admin</h2>
    <a href="dashboard.jsp">🏠 Dashboard</a>
    <a href="student_reg.jsp">👨‍🎓 Student Registration</a>
    <a href="faculty_reg.jsp">👨‍🏫 Faculty Registration</a>
    <a href="add_book.jsp">➕ Add New Book</a>
    <a href="issue_book.jsp">📑 Issue Book</a>
    <a href="view_book.jsp" class="active">📚 View Books</a>
    <a href="view_student.jsp">👨‍🎓 View Students</a>
    <a href="view_faculty.jsp">👨‍🏫 View Faculty</a>
    <a href="view_issue_book.jsp">📑 View Issued Books</a>
    <a href="index.jsp" style="margin-top:auto; background:#d1c4e9; color:#512da8; text-align:center;">🚪 Log-out</a>
</div>

<div class="main-content">
    <div class="card">
        <div class="header-flex">
            <h1>Library Inventory (All Books)</h1>
            <div style="margin-bottom: 20px;">
                <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Search by Book Title or Author..."
                       style="width: 100%; padding: 12px 20px; border-radius: 10px; border: 1px solid #ddd; outline: none; font-size: 14px;">
            </div>
            <a href="add_book.jsp" style="background:#812ea0; color:white; padding:10px 20px; border-radius:8px; text-decoration:none; font-size:14px;">+ Add More</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>Acc. No</th>
                <th>Book Title</th>
                <th>Author</th>
                <th>Edition</th>
                <th>Year</th>
                <th>Pages</th>
                <th>Price</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                try {
                    Connection con = DBConnection.getConnection();
                    Statement st = con.createStatement();
                    // Query to fetch all books
                    ResultSet rs = st.executeQuery("SELECT * FROM books ORDER BY Accession_no DESC");

                    boolean hasData = false;
                    while(rs.next()) {
                        hasData = true;
            %>
            <tr>
                <td><strong><%= rs.getString("Accession_no") %></strong></td>
                <td><%= rs.getString("book_title") %></td>
                <td><%= rs.getString("author") %></td>
                <td><%= rs.getString("edition") %></td>
                <td><%= rs.getInt("pub_year") %></td>
                <td><%= rs.getInt("pages") %></td>
                <td>₹<%= rs.getDouble("price") %></td>
                <td>
                    <a href="edit_book.jsp?id=<%= rs.getString("Accession_no") %>" class="btn-edit">Edit</a>
                    <a href="delete_book.jsp?id=<%= rs.getString("Accession_no") %>"
                       class="btn-delete"
                       onclick="return confirm('Do You really want to delete this')">Delete</a>
                </td>
            </tr>
            <%
                }
                if(!hasData) {
            %>
            <tr>
                <td colspan="8" class="no-data">Koi book nahi mili. Pehle ek book add kijiye!</td>
            </tr>
            <%
                    }
                    con.close();
                } catch(Exception e) {
                    out.print("Error: " + e.getMessage());
                }
            %>
            </tbody>
        </table>
    </div>
</div><script>
    function searchTable() {
        // Input aur Filter variables
        var input = document.getElementById("searchInput");
        var filter = input.value.toUpperCase();
        var table = document.querySelector("table");
        var tr = table.getElementsByTagName("tr");

        // Har row check karo (Header ko chhod kar)
        for (var i = 1; i < tr.length; i++) {
            var tdTitle = tr[i].getElementsByTagName("td")[1]; // Book Title column
            var tdAuthor = tr[i].getElementsByTagName("td")[2]; // Author column

            if (tdTitle || tdAuthor) {
                var textValueTitle = tdTitle.textContent || tdTitle.innerText;
                var textValueAuthor = tdAuthor.textContent || tdAuthor.innerText;

                if (textValueTitle.toUpperCase().indexOf(filter) > -1 ||
                    textValueAuthor.toUpperCase().indexOf(filter) > -1) {
                    tr[i].style.display = "";
                } else {
                    tr[i].style.display = "none";
                }
            }
        }
    }
</script>

</body>
</html>