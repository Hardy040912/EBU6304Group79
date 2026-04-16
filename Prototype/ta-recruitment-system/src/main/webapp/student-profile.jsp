<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload CV - TA Recruitment System</title>
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
        
        input[type="text"], input[type="email"], textarea {
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
        
        .file-upload {
            border: 2px dashed #d1d5db;
            border-radius: 8px;
            padding: 2rem;
            text-align: center;
            background: #f9fafb;
            cursor: pointer;
            transition: all 0.15s;
        }
        
        .file-upload:hover {
            border-color: #2563eb;
            background: #eff6ff;
        }
        
        .file-upload input[type="file"] {
            display: none;
        }
        
        .file-upload-icon {
            font-size: 3rem;
            margin-bottom: 1rem;
        }
        
        .file-upload-text {
            color: #6b7280;
            font-size: 0.875rem;
        }
        
        .file-name {
            margin-top: 0.5rem;
            color: #2563eb;
            font-weight: 500;
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
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            background: #e0e7ff;
            color: #3730a3;
            border-radius: 4px;
            font-size: 0.75rem;
            margin-right: 0.25rem;
            margin-bottom: 0.25rem;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Profile & CV</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/student-dashboard.jsp" class="btn">← Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <div class="card">
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Personal Information</h2>
            
            <form onsubmit="handleSubmit(event)">
                <div class="form-group">
                    <label for="name">Full Name</label>
                    <input type="text" id="name" value="<%= userName %>" readonly style="background: #f9fafb;">
                </div>
                
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" value="<%= userEmail %>" readonly style="background: #f9fafb;">
                </div>
                
                <div class="form-group">
                    <label for="skills">Skills (comma separated)</label>
                    <input type="text" id="skills" placeholder="e.g., Python, JavaScript, Machine Learning" value="Python, JavaScript, Machine Learning">
                </div>
                
                <div class="form-group">
                    <label for="experience">Experience</label>
                    <textarea id="experience" placeholder="Describe your relevant experience...">I have experience in teaching and tutoring students in various programming courses.</textarea>
                </div>
                
                <div class="form-group">
                    <label>Upload CV (PDF)</label>
                    <div class="file-upload" onclick="document.getElementById('cvFile').click()">
                        <input type="file" id="cvFile" accept=".pdf" onchange="showFileName(this)">
                        <div class="file-upload-icon">📄</div>
                        <div class="file-upload-text">
                            Click to upload or drag and drop<br>
                            <small>PDF (MAX. 5MB)</small>
                        </div>
                        <div id="fileName" class="file-name"></div>
                    </div>
                </div>
                
                <button type="submit" class="btn-submit">Save Profile</button>
            </form>
        </div>
    </div>

    <script>
        function showFileName(input) {
            const fileName = input.files[0]?.name;
            if (fileName) {
                document.getElementById('fileName').textContent = '✓ ' + fileName;
            }
        }
        
        function handleSubmit(event) {
            event.preventDefault();
            alert('Profile saved successfully! (Demo mode - file upload not implemented in V3)');
        }
    </script>
</body>
</html>
