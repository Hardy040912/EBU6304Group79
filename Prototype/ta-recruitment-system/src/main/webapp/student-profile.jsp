<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.Properties" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 加载已保存的简历
    DataFileUtil.initDataDir(application.getRealPath("/"));
    Properties resume = DataFileUtil.loadResume(userEmail);
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

        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            text-align: center;
        }

        .template-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.5rem;
            font-family: monospace;
            font-size: 0.8rem;
            color: #475569;
            white-space: pre-wrap;
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #111827;
            margin: 2rem 0 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e5e7eb;
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
        <% if ("1".equals(request.getParameter("success"))) { %>
        <div class="success-message">✓ Profile saved successfully!</div>
        <% } %>
        <% if ("2".equals(request.getParameter("success"))) { %>
        <div class="success-message">✓ Resume saved successfully!</div>
        <% } %>

        <!-- Profile Card -->
        <div class="card" style="margin-bottom:1.5rem;">
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Personal Information</h2>
            <form action="<%= request.getContextPath() %>/updateProfile" method="post">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" value="<%= userName %>" readonly style="background:#f9fafb;">
                </div>
                <div class="form-group">
                    <label>Email</label>
                    <input type="email" value="<%= userEmail %>" readonly style="background:#f9fafb;">
                </div>
                <button type="submit" class="btn-submit">Save Profile</button>
            </form>
        </div>

        <!-- Resume Card -->
        <div class="card">
            <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem;">📄 Resume</h2>

            <!-- Template -->
            <p class="section-title">Resume Template</p>
            <div class="template-box">Basic Information:
Phone: xxx
Major: xxx
Year: xxx
GPA: xxx

Skills Overview:
Technical Skills: xxx, xxx
Language Skills: xxx
Certifications/Awards: xxx

Teaching / Tutoring Experience:
- ...

Project Experience:
- ...

Personal Statement:
...</div>

            <!-- Fill Form -->
            <p class="section-title">Fill in Your Resume</p>
            <form action="<%= request.getContextPath() %>/uploadResume" method="post">

                <p style="font-weight:600;color:#374151;margin-bottom:1rem;">Basic Information</p>
                <div class="form-group">
                    <label>Phone</label>
                    <input type="text" name="phone" placeholder="e.g., +86 138 0000 0000" value="<%= resume.getProperty("phone","") %>">
                </div>
                <div class="form-group">
                    <label>Major</label>
                    <input type="text" name="major" placeholder="e.g., Computer Science" value="<%= resume.getProperty("major","") %>">
                </div>
                <div class="form-group">
                    <label>Year</label>
                    <input type="text" name="year" placeholder="e.g., Year 3" value="<%= resume.getProperty("year","") %>">
                </div>
                <div class="form-group">
                    <label>GPA</label>
                    <input type="text" name="gpa" placeholder="e.g., 3.8 / 4.0" value="<%= resume.getProperty("gpa","") %>">
                </div>

                <p style="font-weight:600;color:#374151;margin:1.5rem 0 1rem;">Skills Overview</p>
                <div class="form-group">
                    <label>Technical Skills</label>
                    <input type="text" name="technicalSkills" placeholder="e.g., Python, Java, SQL" value="<%= resume.getProperty("technicalSkills","") %>">
                </div>
                <div class="form-group">
                    <label>Language Skills</label>
                    <input type="text" name="languageSkills" placeholder="e.g., English (Fluent), Mandarin (Native)" value="<%= resume.getProperty("languageSkills","") %>">
                </div>
                <div class="form-group">
                    <label>Certifications / Awards</label>
                    <input type="text" name="certifications" placeholder="e.g., AWS Certified, Dean's List" value="<%= resume.getProperty("certifications","") %>">
                </div>

                <p style="font-weight:600;color:#374151;margin:1.5rem 0 1rem;">Teaching / Tutoring Experience</p>
                <div class="form-group">
                    <textarea name="teachingExp" rows="4" placeholder="- Tutored 10 students in Data Structures (2023)&#10;- TA for EBU6304 Software Engineering (2024)"><%= resume.getProperty("teachingExp","") %></textarea>
                </div>

                <p style="font-weight:600;color:#374151;margin:1.5rem 0 1rem;">Project Experience</p>
                <div class="form-group">
                    <textarea name="projectExp" rows="4" placeholder="- Built a web app using Spring Boot and React&#10;- Developed ML model for image classification"><%= resume.getProperty("projectExp","") %></textarea>
                </div>

                <p style="font-weight:600;color:#374151;margin:1.5rem 0 1rem;">Personal Statement</p>
                <div class="form-group">
                    <textarea name="personalStatement" rows="5" placeholder="Briefly describe your motivation and goals..."><%= resume.getProperty("personalStatement","") %></textarea>
                </div>

                <button type="submit" class="btn-submit">💾 Save Resume</button>
            </form>
        </div>
    </div>

    <script>
        function showFileName(input) {
            const fileName = input.files[0]?.name;
            if (fileName) document.getElementById('fileName').textContent = '✓ ' + fileName;
        }
    </script>
</body>
</html>
