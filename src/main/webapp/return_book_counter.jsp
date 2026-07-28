<%@ page import="java.sql.*, com.kratika.lms.DBConnection, java.time.LocalDate, java.time.temporal.ChronoUnit" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    if(session.getAttribute("adminUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    String transactionId = request.getParameter("id");
    if(transactionId == null || transactionId.trim().isEmpty()) {
        response.sendRedirect("view_issue_book.jsp?error=Invalid Request!");
        return;
    }

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    String bType="", bId="", accNo="", iDate="", dDate="";
    int fineAmt = 0;
    String fineStatus = "No Fine";

    try {
        con = DBConnection.getConnection();
        ps = con.prepareStatement("SELECT * FROM issue_book WHERE id = ?");
        ps.setInt(1, Integer.parseInt(transactionId));
        rs = ps.executeQuery();

        if(rs.next()) {
            bType = rs.getString("borrower_type");
            bId = rs.getString("borrower_id");
            accNo = rs.getString("accession_no");
            iDate = rs.getString("issue_date");
            dDate = rs.getString("due_date");

            // LIVE FINE CALCULATION (₹5 Per Day)
            if(dDate != null) {
                LocalDate dueDate = LocalDate.parse(dDate);
                LocalDate today = LocalDate.now();
                if(today.isAfter(dueDate)) {
                    long daysBetween = ChronoUnit.DAYS.between(dueDate, today);
                    fineAmt = (int) daysBetween * 5;
                    fineStatus = "Unpaid";
                }
            }
        } else {
            response.sendRedirect("view_issue_book.jsp?error=Record Not Found!");
            return;
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        try { if(rs != null) rs.close(); if(ps != null) ps.close(); if(con != null) con.close(); } catch(Exception ex) {}
    }
%>
<html>
<head>
    <title>LMS | Return Book Counter</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; font-family: 'Poppins', sans-serif; }
        body { display: flex; background: linear-gradient(135deg, #a18cd1 0%, #fbc2eb 100%); background-attachment: fixed; height: 100vh; justify-content: center; align-items: center; }
        .counter-box { background: white; padding: 40px; border-radius: 20px; box-shadow: 0 15px 35px rgba(0,0,0,0.1); width: 450px; }
        h2 { color: #812ea0; margin-bottom: 25px; text-align: center; font-size: 22px; border-bottom: 2px solid #efedff; padding-bottom: 10px; }
        .detail-row { display: flex; justify-content: space-between; margin-bottom: 15px; font-size: 14px; border-bottom: 1px dashed #f0f0f0; padding-bottom: 8px; }
        .detail-row span.label { font-weight: 600; color: #666; }
        .detail-row span.value { color: #333; font-weight: 400; }
        .fine-box { background: #ffebee; color: #c62828; padding: 12px; border-radius: 8px; text-align: center; font-weight: 600; margin-top: 20px; font-size: 16px; }
        .no-fine { background: #e8f5e9; color: #2e7d32; }
        .btn-submit { width: 100%; background: #812ea0; color: white; padding: 12px; border: none; border-radius: 8px; font-weight: 600; cursor: pointer; margin-top: 25px; transition: 0.3s; font-size: 15px; }
        .btn-submit:hover { background: #512da8; }
        .back-link { display: block; text-align: center; margin-top: 15px; color: #812ea0; text-decoration: none; font-size: 13px; font-weight: 600; }
    </style>
</head>
<body>

<div class="counter-box">
    <h2>📖 Return Book Desk</h2>

    <form action="ProcessReturnServlet" method="post">
        <input type="hidden" name="id" value="<%= transactionId %>">
        <input type="hidden" name="fine_amount" value="<%= fineAmt %>">
        <input type="hidden" name="fine_status" value="<%= fineStatus %>">

        <div class="detail-row">
            <span class="label">Borrower Type:</span>
            <span class="value"><%= bType %></span>
        </div>
        <div class="detail-row">
            <span class="label">Borrower ID:</span>
            <span class="value"><b><%= bId %></b></span>
        </div>
        <div class="detail-row">
            <span class="label">Accession No:</span>
            <span class="value"><%= accNo %></span>
        </div>
        <div class="detail-row">
            <span class="label">Issue Date:</span>
            <span class="value"><%= iDate %></span>
        </div>
        <div class="detail-row">
            <span class="label">Due Date:</span>
            <span class="value" style="color: #d84315; font-weight:600;"><%= dDate %></span>
        </div>

        <% if(fineAmt > 0) { %>
            <div class="fine-box">
                ⚠️ Penalty Fine: ₹<%= fineAmt %> (Overdue)
            </div>
        <% } else { %>
            <div class="fine-box no-fine">
                ✓ No Fine Pending (On Time)
            </div>
        <% } %>

        <button type="submit" class="btn-submit">Confirm & Process Return</button>
        <a href="view_issue_book.jsp" class="back-link">← Cancel and Go Back</a>
    </form>
</div>

</body>
</html>