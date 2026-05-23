<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - TA Recruitment System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bupt-brand.css?v=10">
</head>
<body class="auth-page">
    <div class="card">
        <div class="header">
            <h1 class="bupt-school-name">BUPT International School</h1>
            <p class="subtitle">TA Recruitment System</p>
        </div>

        <% if ("1".equals(request.getParameter("error"))) { %>
        <div class="error-message">
            Invalid email, password, or role. Please try again.
        </div>
        <% } %>

        <form action="<%= request.getContextPath() %>/login" method="post">
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="your.email@bupt.edu.cn" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter password" required>
            </div>
            
            <div class="form-group">
                <label for="role">Login As</label>
                <select id="role" name="role" required>
                    <option value="student">Student (TA)</option>
                    <option value="module-organiser">Module Organiser</option>
                    <option value="admin">Administrator</option>
                </select>
            </div>
            
            <button type="submit" class="btn">Sign In</button>
            
            <div class="register-link">
                <small>Don't have an account? <a href="<%= request.getContextPath() %>/register.jsp">Register</a></small>
            </div>
        </form>
    </div>
</body>
</html>
