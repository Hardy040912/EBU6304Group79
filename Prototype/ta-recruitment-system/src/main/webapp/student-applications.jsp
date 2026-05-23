<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/application-payload.jsp" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null || !"student".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 获取岗位信息映射
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    Map<String, String[]> jobMap = new HashMap<>();
    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11) {
            jobMap.put(parts[0], parts);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Applications - TA Recruitment System</title>
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
        
        .job-details {
            display: flex;
            gap: 1.5rem;
            font-size: 0.875rem;
            color: #6b7280;
            margin-top: 0.5rem;
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-accepted {
            background: #dcfce7;
            color: #166534;
        }
        
        .badge-rejected {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            text-align: center;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>My Applications</h1>
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
        <div class="success-message">✓ Application submitted successfully!</div>
        <% } %>
        
        <div class="card">
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Application History</h2>
            
            <%
                List<String> applications = DataFileUtil.readLines("applications.txt");
                boolean hasApplications = false;
                
                for (String line : applications) {
                    String[] parts = line.split("\\|");
                    if (parts.length >= 7 && parts[2].equals(userEmail)) {
                        hasApplications = true;
                        String appId = parts[0];
                        String jobId = parts[1];
                        String coverLetter = parts[4];
                        String status = parts[5];
                        String applyDate = parts[6];
                        
                        String[] jobInfo = jobMap.get(jobId);
                        String jobTitle = jobInfo != null ? jobInfo[1] : "Unknown Job";
                        String moduleCode = jobInfo != null ? jobInfo[2] : "";
                        String moduleName = jobInfo != null ? jobInfo[3] : "";
                        
                        String statusBadge = "badge-pending";
                        String statusIcon = "⏰";
                        String statusText = "Pending";
                        
                        if ("accepted".equals(status)) {
                            statusBadge = "badge-accepted";
                            statusIcon = "✓";
                            statusText = "Accepted";
                        } else if ("rejected".equals(status)) {
                            statusBadge = "badge-rejected";
                            statusIcon = "✗";
                            statusText = "Rejected";
                        }
            %>
            <div class="job-card">
                <div style="display: flex; justify-content: space-between; align-items: start;">
                    <div style="flex: 1;">
                        <h3 class="job-title"><%= jobTitle %></h3>
                        <p class="job-subtitle"><%= moduleCode %> - <%= moduleName %></p>
                        <div class="job-details">
                            <span>Applied: <%= applyDate %></span>
                        </div>
                        <%
                            String profileSnap = ApplicationPayload.profile(coverLetter);
                            String coverOnly = ApplicationPayload.coverLetter(coverLetter);
                        %>
                        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css">
                        <div class="review-panel" style="margin-top:0.75rem;">
                            <div class="review-panel-title">Profile submitted</div>
                            <div class="review-panel-body"><%= ApplicationPayload.htmlWithBreaks(profileSnap.isEmpty() ? "(legacy application)" : profileSnap) %></div>
                        </div>
                        <div class="review-panel" style="margin-top:0.5rem;">
                            <div class="review-panel-title">Cover letter for this job</div>
                            <div class="review-panel-body"><%= ApplicationPayload.htmlWithBreaks(coverOnly) %></div>
                        </div>
                    </div>
                    <span class="badge <%= statusBadge %>"><%= statusIcon %> <%= statusText %></span>
                </div>
            </div>
            <%
                    }
                }
                
                if (!hasApplications) {
            %>
            <p style="color: #6b7280; text-align: center; padding: 2rem;">
                You haven't submitted any applications yet. 
                <a href="<%= request.getContextPath() %>/student-jobs.jsp" style="color: #2563eb;">Browse available jobs</a>
            </p>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
