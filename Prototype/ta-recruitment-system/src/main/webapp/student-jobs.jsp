<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 获取该学生已申请的岗位
    List<String> applications = DataFileUtil.readLines("applications.txt");
    Map<String, String> appliedJobs = new HashMap<>(); // jobId -> status
    Map<String, Boolean> blockedJobs = new HashMap<>(); // jobId -> blocked

    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && parts[2].equals(userEmail)) {
            String jobId = parts[1];
            String status = parts[5];
            boolean blocked = parts.length >= 8 && "true".equals(parts[7]);

            // 只有 pending、accepted 或 被屏蔽的 rejected 才算"已申请"
            if ("pending".equals(status) || "accepted".equals(status) ||
                ("rejected".equals(status) && blocked)) {
                appliedJobs.put(jobId, status);
                blockedJobs.put(jobId, blocked);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Browse Jobs - TA Recruitment System</title>
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
            max-width: 80rem;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .job-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
            transition: box-shadow 0.15s;
        }
        
        .job-card:hover {
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
        }
        
        .job-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .job-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.25rem;
        }
        
        .job-subtitle {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .job-description {
            color: #4b5563;
            font-size: 0.875rem;
            margin-bottom: 1rem;
            line-height: 1.5;
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
        
        .job-details {
            display: flex;
            gap: 1.5rem;
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 1rem;
        }
        
        .btn-apply {
            padding: 0.5rem 1rem;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 1rem;
        }
        
        .btn-apply:hover {
            background: #1d4ed8;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Browse Jobs</h1>
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
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Available TA Positions</h2>
            
            <%
                List<String> jobs = DataFileUtil.readLines("jobs.txt");
                if (jobs.isEmpty()) {
            %>
                <p style="color: #6b7280; text-align: center; padding: 2rem;">No jobs available at the moment.</p>
            <%
                } else {
                    for (String line : jobs) {
                        String[] parts = line.split("\\|");
                        if (parts.length >= 11) {
                            String jobId = parts[0];
                            String title = parts[1];
                            String moduleCode = parts[2];
                            String moduleName = parts[3];
                            String organiser = parts[4];
                            String description = parts[6];
                            String skills = parts[7];
                            String hoursPerWeek = parts[8];
                            String duration = parts[9];
                            String status = parts[10];

                            // 检查是否已申请
                            String appliedStatus = appliedJobs.get(jobId);
                            boolean hasApplied = appliedStatus != null;

                            if ("open".equals(status)) {
            %>
            <div class="job-card">
                <div class="job-header">
                    <div style="flex: 1;">
                        <h3 class="job-title">
                            <%= title %>
                            <% if (hasApplied) { %>
                                <% if ("accepted".equals(appliedStatus)) { %>
                                    <span style="background: #dcfce7; color: #166534; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; margin-left: 0.5rem;">✓ Accepted</span>
                                <% } else if ("rejected".equals(appliedStatus) && blockedJobs.get(jobId)) { %>
                                    <span style="background: #fee2e2; color: #991b1b; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; margin-left: 0.5rem;">🚫 Blocked</span>
                                <% } else { %>
                                    <span style="background: #fef3c7; color: #92400e; padding: 0.25rem 0.5rem; border-radius: 4px; font-size: 0.75rem; margin-left: 0.5rem;">⏰ Applied</span>
                                <% } %>
                            <% } %>
                        </h3>
                        <p class="job-subtitle"><%= moduleCode %> - <%= moduleName %> | <%= organiser %></p>
                    </div>
                </div>
                <p class="job-description"><%= description %></p>
                <div>
                    <%
                        String[] skillList = skills.split(",");
                        for (String skill : skillList) {
                    %>
                    <span class="badge"><%= skill.trim() %></span>
                    <%
                        }
                    %>
                </div>
                <div class="job-details">
                    <span>⏰ <%= hoursPerWeek %>h/week</span>
                    <span>📅 <%= duration %></span>
                </div>
                <% if (hasApplied) { %>
                    <% if ("rejected".equals(appliedStatus) && blockedJobs.get(jobId)) { %>
                        <a href="<%= request.getContextPath() %>/student-applications.jsp" class="btn-apply" style="background: #ef4444; cursor: not-allowed;">
                            🚫 Blocked
                        </a>
                    <% } else { %>
                        <a href="<%= request.getContextPath() %>/student-applications.jsp" class="btn-apply" style="background: #9ca3af; cursor: default;">
                            Already Applied
                        </a>
                    <% } %>
                <% } else { %>
                    <a href="<%= request.getContextPath() %>/student-apply.jsp?jobId=<%= jobId %>" class="btn-apply">Apply Now</a>
                <% } %>
            </div>
            <%
                            }
                        }
                    }
                }
            %>
        </div>
    </div>
</body>
</html>
