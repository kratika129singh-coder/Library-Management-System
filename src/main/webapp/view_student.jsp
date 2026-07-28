<%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/16/2026
  Time: 2:49 PM
  To change this template use File | Settings | File Templates.
--%><%--
  Created by IntelliJ IDEA.
  User: jjjj
  Date: 5/16/2026
  Time: 2:45 PM
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
    <title>LMS | View Students</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body {
            display: flex;
            background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%);
            background-attachment: fixed;
            height: 100vh;
        }

        /* Sidebar (Exact same as dashboard & view_book) */
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
    <a href="view_book.jsp">📚 View Books</a>
    <a href="view_student.jsp" class="active">👨‍🎓 View Students</a>
    <a href="view_faculty.jsp">👨‍🏫 View Faculty</a>
    <a href="view_issue_book.jsp">📑 View Issued Books</a>
    <a href="index.jsp" style="margin-top:auto; background:#d1c4e9; color:#512da8; text-align:center;">🚪 Log-out</a>
</div>

<div class="main-content">
    <div class="card">
        <div class="header-flex">
            <h1>Registered Students Directory</h1>
            <div style="margin-bottom: 20px;">
                <input type="text" id="searchInput" onkeyup="searchTable()" placeholder="Search by Roll No or Name"
                       style="width: 100%; padding: 12px 20px; border-radius: 10px; border: 1px solid #ddd; outline: none; font-size: 14px;">
            </div>
            <a href="student_reg.jsp" style="background:#812ea0; color:white; padding:10px 20px; border-radius:8px; text-decoration:none; font-size:14px;">+ Add Student</a>
        </div>

        <table>
            <thead>
            <tr>
                <th>Roll No</th>
                <th>Full Name</th>
                <th>Course</th>
                <th>Batch</th>
                <th>Semester</th>
                <th>Phone No</th>
                <th>Email ID</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                try {
                    Connection con = DBConnection.getConnection();
                    Statement st = con.createStatement();
                    // Query to fetch students
                    ResultSet rs = st.executeQuery("SELECT * FROM students ORDER BY roll_no ASC");

                    boolean hasData = false;
                    while(rs.next()) {
                        hasData = true;
            %>
            <tr>
                <td><strong><%= rs.getString("roll_no") %></strong></td>
                <td><%= rs.getString("full_name") %></td>
                <td><%= rs.getString("course") %></td>
                <td><%= rs.getString("batch") %></td>
                <td><%= rs.getString("semester") %></td>
                <td><%= rs.getString("phone_no") %></td>
                <td><%= rs.getString("email") %></td>
                <td>
                    <a href="edit_student.jsp?id=<%= rs.getString("roll_no") %>"
                       class="btn-edit">Edit</a>
                    <a href="DeleteStudentServlet?id=<%= rs.getString("roll_no") %>"  class="btn-delete"
                       onclick="return confirm('Do you really want to delete student <%= rs.getString("roll_no")%>?')"><i class="fa-solid fa-trash"></i> Delet</a>
                </td>
            </tr>
            <%
                }
                if(!hasData) {
            %>
            <tr>
                <td colspan="8" class="no-data">There is not student any more!</td>
            </tr>
            <%
                    }
                    con.close();
                } catch(Exception e) {
                    out.print("<tr><td colspan='8' class='no-data' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                }
            %>
            </tbody>
        </table>
    </div>
</div>

<script>
    function searchTable() {
        var input = document.getElementById("searchInput");
        var filter = input.value.toUpperCase();
        var table = document.querySelector("table");
        var tr = table.getElementsByTagName("tr");

        for (var i = 1; i < tr.length; i++) {
            var tdRoll = tr[i].getElementsByTagName("td")[0]; // Roll No column
            var tdName = tr[i].getElementsByTagName("td")[1]; // Full Name column

            if (tdRoll || tdName) {
                var textValueRoll = tdRoll.textContent || tdRoll.innerText;
                var textValueName = tdName.textContent || tdName.innerText;

                if (textValueRoll.toUpperCase().indexOf(filter) > -1 ||
                    textValueName.toUpperCase().indexOf(filter) > -1) {
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
