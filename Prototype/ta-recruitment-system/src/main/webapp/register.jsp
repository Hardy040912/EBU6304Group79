<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - TA Recruitment System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f3f4f6;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 1rem;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            width: 100%;
            max-width: 28rem;
            padding: 2rem;
        }
        
        .header {
            text-align: center;
            margin-bottom: 2rem;
        }
        
        .logo {
            width: 4rem;
            height: 4rem;
            background-color: #2563eb;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 1rem;
            color: white;
            font-size: 2rem;
        }
        
        .title {
            font-size: 1.5rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.5rem;
        }
        
        .subtitle {
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        .form-group {
            margin-bottom: 1rem;
        }
        
        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }
        
        input, select {
            width: 100%;
            padding: 0.5rem 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            transition: border-color 0.15s;
        }
        
        input:focus, select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        .btn {
            width: 100%;
            padding: 0.625rem 1rem;
            background-color: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: background-color 0.15s;
        }
        
        .btn:hover {
            background-color: #1d4ed8;
        }
        
        .login-link {
            text-align: center;
            margin-top: 1rem;
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .login-link a {
            color: #2563eb;
            text-decoration: none;
        }
        
        .login-link a:hover {
            text-decoration: underline;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="header">
            <div class="logo">🎓</div>
            <h1 class="title">Create Account</h1>
            <p class="subtitle">Join BUPT TA Recruitment System</p>
        </div>
        
        <form action="<%= request.getContextPath() %>/register" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label for="firstName">First Name</label>
                    <input type="text" id="firstName" name="firstName" placeholder="Alice" required>
                </div>
                
                <div class="form-group">
                    <label for="lastName">Last Name</label>
                    <input type="text" id="lastName" name="lastName" placeholder="Chen" required>
                </div>
            </div>
            
            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" placeholder="your.email@bupt.edu.cn" required>
            </div>
            
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="••••••••" required>
            </div>
            
            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" placeholder="••••••••" required>
            </div>
            
            <div class="form-group">
                <label for="role">Register As</label>
                <select id="role" name="role" required>
                    <option value="student">Student (TA)</option>
                    <option value="module-organiser">Module Organiser</option>
                    <option value="admin">Administrator</option>
                </select>
            </div>
            
            <button type="submit" class="btn">Create Account</button>
            
            <div class="login-link">
                <small>Already have an account? <a href="<%= request.getContextPath() %>/index.jsp">Sign In</a></small>
            </div>
        </form>
    </div>
</body>
</html>
