<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String jobId = request.getParameter("jobId");

    if (userEmail == null || jobId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 检查是否已经申请过
    List<String> applications = DataFileUtil.readLines("applications.txt");
    boolean alreadyApplied = false;
    String existingStatus = "";
    boolean isBlocked = false;

    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && parts[1].equals(jobId) && parts[2].equals(userEmail)) {
            existingStatus = parts[5];

            // 检查是否被屏蔽
            if (parts.length >= 8 && "true".equals(parts[7])) {
                isBlocked = true;
                alreadyApplied = true;
                break;
            }

            // 如果是 pending 或 accepted，不能再申请
            if ("pending".equals(existingStatus) || "accepted".equals(existingStatus)) {
                alreadyApplied = true;
                break;
            }

            // 如果是 rejected 但没有被屏蔽，可以再次申请
            // 所以不设置 alreadyApplied = true
        }
    }

    // 获取岗位信息
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    String jobTitle = "";
    String moduleCode = "";
    String moduleName = "";
    String organiser = "";
    String description = "";
    String skills = "";
    String hoursPerWeek = "";
    String duration = "";

    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11 && parts[0].equals(jobId)) {
            jobTitle = parts[1];
            moduleCode = parts[2];
            moduleName = parts[3];
            organiser = parts[4];
            description = parts[6];
            skills = parts[7];
            hoursPerWeek = parts[8];
            duration = parts[9];
            break;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Job - TA Recruitment System</title>
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
        
        .job-info {
            background: #f9fafb;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .job-title {
            font-size: 1.25rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.5rem;
        }
        
        .job-subtitle {
            font-size: 0.875rem;
            color: #6b7280;
            margin-bottom: 1rem;
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            background: #e0e7ff;
            color: #3730a3;
            border-radius: 4px;
            font-size: 0.75rem;
            margin-right: 0.25rem;
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
        
        textarea {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            font-family: inherit;
            resize: vertical;
            min-height: 150px;
        }
        
        textarea:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
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

        .btn-submit:disabled {
            background: #9ca3af;
            cursor: not-allowed;
        }

        .warning-message {
            background: #fef3c7;
            color: #92400e;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            text-align: center;
            border: 1px solid #fbbf24;
        }

        .info-message {
            background: #dbeafe;
            color: #1e40af;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            text-align: center;
            border: 1px solid #60a5fa;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Apply for Position</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/student-jobs.jsp" class="btn">← Back to Jobs</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <% if (alreadyApplied) { %>
        <div class="<%= "accepted".equals(existingStatus) ? "info-message" : "warning-message" %>">
            <% if ("accepted".equals(existingStatus)) { %>
                ✓ You have already been accepted for this position!
            <% } else if ("rejected".equals(existingStatus) && isBlocked) { %>
                🚫 You are not allowed to apply for this position again. The organizer has blocked further applications from you for this role.
            <% } else if ("rejected".equals(existingStatus)) { %>
                ✗ Your previous application for this position was rejected. However, you may apply again if you wish.
            <% } else { %>
                ⏰ You have already applied for this position. Your application is pending review.
            <% } %>
            <br>
            <a href="<%= request.getContextPath() %>/student-applications.jsp" style="color: inherit; text-decoration: underline;">View your applications</a>
        </div>
        <% } %>

        <div class="card">
            <div class="job-info">
                <h2 class="job-title"><%= jobTitle %></h2>
                <p class="job-subtitle"><%= moduleCode %> - <%= moduleName %> | <%= organiser %></p>
                <p style="color: #4b5563; font-size: 0.875rem; margin-bottom: 1rem;"><%= description %></p>
                <div style="margin-bottom: 0.5rem;">
                    <%
                        String[] skillList = skills.split(",");
                        for (String skill : skillList) {
                    %>
                    <span class="badge"><%= skill.trim() %></span>
                    <%
                        }
                    %>
                </div>
                <p style="color: #6b7280; font-size: 0.875rem;">⏰ <%= hoursPerWeek %>h/week | 📅 <%= duration %></p>
            </div>

            <% if (!alreadyApplied) { %>
            <form action="<%= request.getContextPath() %>/applyJob" method="post">
                <input type="hidden" name="jobId" value="<%= jobId %>">

                <div class="form-group">
                    <label for="coverLetter">Cover Letter *</label>
                    <textarea id="coverLetter" name="coverLetter" required
                              placeholder="Please explain why you are interested in this position and how your skills match the requirements..."></textarea>
                </div>

                <button type="submit" class="btn-submit">Submit Application</button>
            </form>
            <% } else { %>
            <div style="text-align: center; padding: 2rem;">
                <% if (isBlocked) { %>
                    <p style="color: #6b7280; margin-bottom: 1rem;">You are blocked from applying to this position.</p>
                <% } else { %>
                    <p style="color: #6b7280; margin-bottom: 1rem;">You cannot apply for this position at this time.</p>
                <% } %>
                <a href="<%= request.getContextPath() %>/student-jobs.jsp" class="btn-submit" style="text-decoration: none; display: inline-block;">
                    Browse Other Jobs
                </a>
            </div>
            <% } %>
        </div>
    </div>
</body>
</html>
