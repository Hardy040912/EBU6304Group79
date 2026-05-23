<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null || !"module-organiser".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Post New Job - TA Recruitment System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bupt-brand.css?v=10">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css?v=5">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f9fafb;
            min-height: 100vh;
        }
        
        .header {
            background: white;
            border-bottom: 1px solid #e5e7eb;
            padding: 1rem 0;
        }
        
        .header-content {
            max-width: 80rem;
            margin: 0 auto;
            padding: 0 2rem;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .header-title h1 {
            font-size: 1.5rem;
            color: #111827;
            margin-bottom: 0.25rem;
        }
        
        .header-title p {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .header-nav {
            display: flex;
            gap: 1rem;
            align-items: center;
        }
        
        .btn {
            padding: 0.5rem 1rem;
            background: white;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            color: #374151;
            font-size: 0.875rem;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
        }
        
        .btn:hover {
            background: #f9fafb;
        }
        
        .container {
            max-width: 60rem;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 2rem;
        }
        
        .form-group {
            margin-bottom: 1.5rem;
        }
        
        label {
            display: block;
            font-size: 0.875rem;
            font-weight: 500;
            color: #374151;
            margin-bottom: 0.5rem;
        }
        
        input[type="text"], input[type="number"], textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            font-family: inherit;
        }
        
        input:focus, textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        
        textarea {
            resize: vertical;
            min-height: 100px;
        }
        
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }
        
        .btn-submit {
            padding: 0.75rem 1.5rem;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
        }
        
        .btn-submit:hover {
            background: #1d4ed8;
        }
        
        .help-text {
            font-size: 0.75rem;
            color: #6b7280;
            margin-top: 0.25rem;
        }
    </style>
</head>
<body class="app-page">
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Post New TA Position</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <jsp:include page="includes/mo-nav.jsp">
        <jsp:param name="active" value="post" />
    </jsp:include>

    <div class="container">
        <div class="card">
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Job Details</h2>
            
            <form action="<%= request.getContextPath() %>/postJob" method="post">
                <div class="form-group">
                    <label for="title">Job Title *</label>
                    <input type="text" id="title" name="title" required 
                           placeholder="e.g., Machine Learning Lab Assistant">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="moduleCode">Module Code *</label>
                        <input type="text" id="moduleCode" name="moduleCode" required 
                               placeholder="e.g., CS401">
                    </div>
                    
                    <div class="form-group">
                        <label for="moduleName">Module Name *</label>
                        <input type="text" id="moduleName" name="moduleName" required 
                               placeholder="e.g., Introduction to Machine Learning">
                    </div>
                </div>
                
                <div class="form-group">
                    <label for="description">Job Description *</label>
                    <textarea id="description" name="description" required 
                              placeholder="Describe the responsibilities and requirements..."></textarea>
                </div>
                
                <div class="form-group">
                    <label for="skills">Required Skills *</label>
                    <input type="text" id="skills" name="skills" required 
                           placeholder="e.g., Python,Machine Learning,Teaching">
                    <p class="help-text">Separate multiple skills with commas</p>
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label for="hoursPerWeek">Hours per Week *</label>
                        <input type="number" id="hoursPerWeek" name="hoursPerWeek" required 
                               min="1" max="20" placeholder="e.g., 8">
                    </div>
                    
                    <div class="form-group">
                        <label for="duration">Duration *</label>
                        <input type="text" id="duration" name="duration" required 
                               placeholder="e.g., 12 weeks">
                    </div>
                </div>
                
                <button type="submit" class="btn-submit">Post Job</button>
            </form>
        </div>
    </div>
</body>
</html>
