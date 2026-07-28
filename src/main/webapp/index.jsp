<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>LMS | Library Management System</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600;700&display=swap" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background: linear-gradient(135deg, #c3a7f1 0%, #f2c1d1 100%);
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-card {
            background: white;
            padding: 50px 40px;
            width: 450px;
            border-radius: 30px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            text-align: center;
        }

        .login-card h1 {
            color: #333;
            font-size: 28px;
            font-weight: 700;
            line-height: 1.2;
            margin-bottom: 30px;
        }

        .input-box {
            width: 100%;
            padding: 12px 15px;
            margin-bottom: 15px;
            border: 1px solid #eee;
            border-radius: 10px;
            background: #f9f9f9;
            outline: none;
            font-size: 15px;
        }

        .error-msg {
            color: #e74c3c;
            font-size: 14px;
            margin-bottom: 15px;
            font-weight: 600;
            background: #fdf2f2;
            padding: 8px;
            border-radius: 8px;
            border: 1px solid #fde2e2;
        }

        .admin-btn {
            background: linear-gradient(to right, #7b88e7, #7e57c2);
            color: white;
            padding: 12px 30px;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(126, 87, 194, 0.3);
            transition: 0.3s;
            display: inline-block;
            text-decoration: none;
            width: 100%;
        }

        .admin-btn:hover {
            transform: scale(1.02);
            box-shadow: 0 6px 20px rgba(126, 87, 194, 0.4);
        }
    </style>
</head>
<body>
<div class="login-card">
    <h1>Library Management<br>System</h1>
    <%
        if(request.getParameter("error") != null) {
    %>
    <div class="error-msg" id="errorBlock">❌ Invalid Username or Password!</div>
    <%
        }
    %>

    <form action="login" method="post" autocomplete="off">

        <input type="text" style="display:none;" name="fake_username"/>
        <input type="password" style="display:none;" name="fake_password"/>

        <input type="text" name="username" id="username" class="input-box" placeholder="Enter Username" autocomplete="new-username" required>
        <input type="password" name="password" id="password" class="input-box" placeholder="Enter Password" autocomplete="new-password" required>

        <button type="submit" class="admin-btn">Admin Login</button>
    </form>
</div>

<script>
    window.onload = function() {
        // Forcefully donon fields ko khali rakhna boot par
        document.getElementById('username').value = '';
        document.getElementById('password').value = '';

        // Error message hide karne ka logic jab user naya type karega
        const inputs = document.querySelectorAll('.input-box');
        inputs.forEach(input => {
            input.addEventListener('input', function() {
                const errorBlock = document.getElementById('errorBlock');
                if(errorBlock) {
                    errorBlock.style.display = 'none';
                }
                // URL se ?error=invalid ko clear karne ke liye
                if (window.location.search.indexOf('error=invalid') > -1) {
                    window.history.replaceState({}, document.title, window.location.pathname);
                }
            });
        });
    }
</script>
</body>
</html>