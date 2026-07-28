<%@ page import="java.sql.*, com.kratika.lms.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Session Check
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // Java code to read filter parameters from the URL/Form Request
    String searchParam = request.getParameter("search_input");
    String typeParam = request.getParameter("filter_type");
    String statusParam = request.getParameter("filter_status");

    // Default values if parameters are null (First time page load)
    if(searchParam == null) searchParam = "";
    if(typeParam == null) typeParam = "ALL";
    if(statusParam == null) statusParam = "ALL";
%>
<html>
<head>
    <title>LMS | View Issued Books</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { display: flex; background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%); background-attachment: fixed; height: 100vh; overflow: hidden; }

        /* Sidebar Component */
        .sidebar { width: 240px; background: #812ea0; color: white; display: flex; flex-direction: column; padding: 20px; box-shadow: 4px 0 15px rgba(0,0,0,0.1); z-index: 10; }
        .sidebar h2 { font-size: 20px; text-align: center; margin-bottom: 30px; border-bottom: 1px solid rgba(255,255,255,0.2); padding-bottom: 15px; letter-spacing: 1px; }
        .sidebar a { color: #efedff; padding: 10px 12px; text-decoration: none; margin-bottom: 6px; border-radius: 8px; transition: all 0.3s; font-size: 13px; }
        .sidebar a:hover { background: rgba(255, 255, 255, 0.15); color: white; transform: translateX(6px); }
        .sidebar a.active { background: #9750a8; font-weight: 600; }

        /* Main Content Area */
        .main-content { flex: 1; padding: 30px; overflow-y: auto; background: rgba(255, 255, 255, 0.25); backdrop-filter: blur(8px); }
        .table-container { background: white; padding: 30px; border-radius: 25px; box-shadow: 0 15px 35px rgba(81, 45, 168, 0.15); width: 100%; overflow-x: auto; }
        .table-header h2 { color: #512da8; font-size: 24px; margin-bottom: 20px; }

        /* Filter Panel Control Row */
        .filter-panel-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            background: #fdfaff;
            padding: 15px;
            border-radius: 15px;
            border: 1px solid #efedff;
            margin-bottom: 20px;
        }
        .filter-group { flex: 1; min-width: 180px; display: flex; flex-direction: column; gap: 5px; }
        .filter-group label { font-size: 12px; color: #7e57c2; font-weight: 600; text-transform: uppercase; }
        .filter-group input, .filter-group select { width: 100%; padding: 10px 15px; border: 2px solid #efedff; border-radius: 8px; font-size: 14px; outline: none; }

        .btn-search-submit {
            background: #812ea0;
            color: white;
            padding: 11px 25px;
            border: none;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: 0.3s;
            font-size: 14px;
        }
        .btn-search-submit:hover { background: #512da8; }

        /* Table Styling */
        table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        th { background: #812ea0; color: white; padding: 14px 10px; font-size: 13px; font-weight: 600; text-align: left; text-transform: uppercase; white-space: nowrap; }
        th:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        th:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        td { padding: 14px 10px; border-bottom: 1px solid #efedff; color: #333; font-size: 13px; vertical-align: middle; }
        tr:hover { background-color: #fcfaff; }

        .date-cell { white-space: nowrap; }

        .badge { padding: 6px 12px; border-radius: 20px; font-size: 12px; font-weight: 600; display: inline-block; }
        .badge-issued { background: #fff3cd; color: #856404; border: 1px solid #ffeeba; }
        .badge-returned { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }

        /* Fine Status Badges */
        .fine-unpaid { background: #ffebee; color: #c62828; padding: 4px 8px; border-radius: 6px; font-weight: 600; }
        .fine-paid { background: #e8f5e9; color: #2e7d32; padding: 4px 8px; border-radius: 6px; font-weight: 600; }
        .fine-none { color: #777; font-style: italic; }

        /* Action Buttons Row Configuration */
        .action-container { display: inline-flex; gap: 8px; align-items: center; white-space: nowrap; }

        /* NEW BUTTON: Process Return Leads to Independent Form Desk Counter */
        .btn-return-counter {
            color: #d84315;
            text-decoration: none;
            font-weight: 600;
            font-size: 12px;
            border: 1px solid #ffccbc;
            padding: 6px 12px;
            border-radius: 6px;
            background: #fbe9e7;
            transition: 0.2s;
            display: inline-block;
        }
        .btn-return-counter:hover { background: #d84315; color: white; }

        .btn-renew { color: #007975; text-decoration: none; font-weight: 600; font-size: 12px; border: 1px solid #b2dfdb; padding: 6px 12px; border-radius: 6px; background: #e0f2f1; transition: 0.2s; display: inline-block; }
        .btn-renew:hover { background: #007975; color: white; }

        .logout-btn { margin-top: auto; background: #d1c4e9 !important; color: #512da8 !important; text-align: center; font-weight: 600; border: 1px solid #b39ddb; }

        .alert { padding: 12px; border-radius: 8px; font-size: 14px; font-weight: 600; margin-bottom: 15px; text-align: center; }
        .alert-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .alert-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
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
    <a href="view_student.jsp">👨‍🎓 View Students</a>
    <a href="view_faculty.jsp">👨‍🏫 View Faculty</a>
    <a href="view_issue_book.jsp" class="active">📑 View Issued Books</a>
    <a href="index.jsp" class="logout-btn">🚪 Log-out</a>
</div>

<div class="main-content">
    <div class="table-container">
        <div class="table-header">
            <h2>Issued Books Record</h2>

            <% if(request.getParameter("msg") != null) { %>
            <div class="alert alert-success">✓ <%= request.getParameter("msg") %></div>
            <% } %>
            <% if(request.getParameter("error") != null) { %>
            <div class="alert alert-error">✗ <%= request.getParameter("error") %></div>
            <% } %>

            <form action="view_issue_book.jsp" method="get" class="filter-panel-form">
                <div class="filter-group">
                    <label>Search Key</label>
                    <input type="text" name="search_input" value="<%= searchParam %>" placeholder="Borrower ID / Accession No">
                </div>

                <div class="filter-group">
                    <label>Borrower Type</label>
                    <select name="filter_type">
                        <option value="ALL" <%= "ALL".equals(typeParam) ? "selected" : "" %>>All Types</option>
                        <option value="Student" <%= "Student".equals(typeParam) ? "selected" : "" %>>Student</option>
                        <option value="Faculty" <%= "Faculty".equals(typeParam) ? "selected" : "" %>>Faculty</option>
                    </select>
                </div>

                <div class="filter-group">
                    <label>Status</label>
                    <select name="filter_status">
                        <option value="ALL" <%= "ALL".equals(statusParam) ? "selected" : "" %>>All Status</option>
                        <option value="Issued" <%= "Issued".equals(statusParam) ? "selected" : "" %>>Issued</option>
                        <option value="Returned" <%= "Returned".equals(statusParam) ? "selected" : "" %>>Returned</option>
                    </select>
                </div>

                <button type="submit" class="btn-search-submit">Apply Filters</button>
            </form>
        </div>

        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Borrower Type</th>
                <th>Borrower ID</th>
                <th>Accession No</th>
                <th>Issue Date</th>
                <th>Due Date</th>
                <th>Return Date</th>
                <th>Fine Details</th> <th>Status</th>
                <th style="min-width: 190px;">Actions</th>
            </tr>
            </thead>
            <tbody>
            <%
                Connection con = null;
                PreparedStatement ps = null;
                ResultSet rs = null;
                try {
                    con = DBConnection.getConnection();

                    StringBuilder queryBuilder = new StringBuilder("SELECT * FROM issue_book WHERE 1=1");

                    if (!searchParam.trim().isEmpty()) {
                        queryBuilder.append(" AND (borrower_id LIKE ? OR accession_no LIKE ?)");
                    }
                    if (!"ALL".equals(typeParam)) {
                        queryBuilder.append(" AND borrower_type = ?");
                    }
                    if (!"ALL".equals(statusParam)) {
                        queryBuilder.append(" AND status = ?");
                    }

                    queryBuilder.append(" ORDER BY id DESC");

                    ps = con.prepareStatement(queryBuilder.toString());
                    int paramIndex = 1;

                    if (!searchParam.trim().isEmpty()) {
                        ps.setString(paramIndex++, "%" + searchParam + "%");
                        ps.setString(paramIndex++, "%" + searchParam + "%");
                    }
                    if (!"ALL".equals(typeParam)) {
                        ps.setString(paramIndex++, typeParam);
                    }
                    if (!"ALL".equals(statusParam)) {
                        ps.setString(paramIndex++, statusParam);
                    }

                    rs = ps.executeQuery();

                    boolean hasData = false;
                    while(rs.next()) {
                        hasData = true;
                        int id = rs.getInt("id");
                        String bType = rs.getString("borrower_type");
                        String bId = rs.getString("borrower_id");
                        String accNo = rs.getString("accession_no");
                        String iDate = rs.getString("issue_date");
                        String dDate = rs.getString("due_date");

                        String rDate = rs.getString("return_date");
                        if(rDate == null || rDate.trim().isEmpty()) {
                            rDate = "Not Returned Yet";
                        }

                        int fineAmt = rs.getInt("fine_amount");
                        String fineStatus = rs.getString("fine_status");
                        if(fineStatus == null) fineStatus = "No Fine";

                        String status = rs.getString("status");
            %>
            <tr>
                <td><%= id %></td>
                <td><%= bType %></td>
                <td><b><%= bId %></b></td>
                <td><%= accNo %></td>
                <td class="date-cell"><%= iDate %></td>
                <td class="date-cell"><%= dDate %></td>

                <td class="date-cell">
                    <% if("Not Returned Yet".equalsIgnoreCase(rDate)) { %>
                    <span style="color: #888; font-style: italic;">-</span>
                    <% } else { %>
                    <span style="color: #2e7d32; font-weight: 600;"><%= rDate %></span>
                    <% } %>
                </td>

                <td>
                    <% if("Unpaid".equalsIgnoreCase(fineStatus)) { %>
                    <span class="fine-unpaid">₹<%= fineAmt %> (Unpaid)</span>
                    <% } else if("Paid".equalsIgnoreCase(fineStatus)) { %>
                    <span class="fine-paid">₹<%= fineAmt %> (Paid)</span>
                    <% } else { %>
                    <span class="fine-none">₹0</span>
                    <% } %>
                </td>

                <td>

                    <% if("Issued".equalsIgnoreCase(status)) { %>
                    <span class="badge badge-issued">Issued</span>
                    <% } else { %>
                    <span class="badge badge-returned">Returned</span>
                    <% } %>
                </td>

                <td>
                    <div class="action-container">
                        <% if("Issued".equalsIgnoreCase(status)) { %>
                        <a href="return_book_counter.jsp?id=<%= id %>" class="btn-return-counter">Process Return</a>
                        <a href="ReIssueBookServlet?id=<%= id %>&type=<%= bType %>" class="btn-renew" onclick="return confirm('Are you sure you want to Reissue this book?');">Reissue</a>
                        <% } else { %>
                        <span style="color:#888; font-size:12px;">No Action Completed</span>
                        <% } %>
                    </div>
                </td>
            </tr>
            <%
                }
                if (!hasData) {
            %>
            <tr>
                <td colspan="10" style="text-align: center; color: #7e57c2; font-weight: 600; padding: 30px;">
                    🔍 No matching records found for selected criteria.
                </td>
            </tr>
            <%
                    }
                } catch(Exception e) {
                    e.printStackTrace();
                } finally {
                    try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } catch(Exception e) {}
                }
            %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>