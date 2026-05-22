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

    // 计算当前工作量
    List<String> applications = DataFileUtil.readLines("applications.txt");
    List<String> jobs = DataFileUtil.readLines("jobs.txt");

    Map<String, String[]> jobMap = new HashMap<>();
    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11) {
            jobMap.put(parts[0], parts);
        }
    }

    int totalHours = 0;
    int activeApplications = 0;
    int pendingApplications = 0;

    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && parts[2].equals(userEmail)) {
            activeApplications++;
            if ("pending".equals(parts[5])) {
                pendingApplications++;
            } else if ("accepted".equals(parts[5])) {
                String[] jobInfo = jobMap.get(parts[1]);
                if (jobInfo != null && jobInfo.length >= 9) {
                    try {
                        totalHours += Integer.parseInt(jobInfo[8].trim());
                    } catch (NumberFormatException e) {
                        // 忽略解析错误
                    }
                }
            }
        }
    }

    int maxHours = 20; // 固定为 20h
    int availableHours = maxHours - totalHours;
    if (availableHours < 0) availableHours = 0; // 如果超过，显示 0
    int workloadPercentage = maxHours > 0 ? (totalHours * 100) / maxHours : 0;
    boolean isOverloaded = totalHours > maxHours; // 是否超载
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Student Dashboard - TA Recruitment System</title>
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
        
        .btn-logout {
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
        
        .btn-logout:hover {
            background: #f9fafb;
        }
        
        .container {
            max-width: 80rem;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }
        
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }
        
        .card-title {
            font-size: 0.875rem;
            font-weight: 500;
            color: #6b7280;
        }
        
        .card-icon {
            color: #9ca3af;
            font-size: 1.25rem;
        }
        
        .card-value {
            font-size: 1.875rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.5rem;
        }
        
        .card-description {
            font-size: 0.75rem;
            color: #6b7280;
        }
        
        .progress-bar {
            width: 100%;
            height: 0.5rem;
            background: #e5e7eb;
            border-radius: 9999px;
            overflow: hidden;
            margin: 0.5rem 0;
        }
        
        .progress-fill {
            height: 100%;
            background: #2563eb;
            transition: width 0.3s;
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
        
        .tabs {
            margin-bottom: 1rem;
        }
        
        .tab-list {
            display: flex;
            gap: 0.5rem;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 1.5rem;
        }
        
        .tab-button {
            padding: 0.75rem 1rem;
            background: none;
            border: none;
            border-bottom: 2px solid transparent;
            color: #6b7280;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.15s;
        }
        
        .tab-button.active {
            color: #2563eb;
            border-bottom-color: #2563eb;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
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
        
        .match-score {
            text-align: right;
        }
        
        .match-score-value {
            font-size: 1.875rem;
            font-weight: 600;
            color: #2563eb;
        }
        
        .match-score-label {
            font-size: 0.75rem;
            color: #6b7280;
        }
        
        .job-description {
            color: #4b5563;
            font-size: 0.875rem;
            margin-bottom: 1rem;
            line-height: 1.5;
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
        }

        .btn-apply:hover {
            background: #1d4ed8;
        }
        
        .top-match-badge {
            display: inline-flex;
            align-items: center;
            gap: 0.25rem;
            padding: 0.25rem 0.5rem;
            background: #dcfce7;
            color: #166534;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
            margin-left: 0.5rem;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Student Dashboard</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <span>🚪</span> Logout
            </a>
        </div>
    </header>

    <div class="container">
        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Current Workload</span>
                    <span class="card-icon">💼</span>
                </div>
                <div class="card-value" style="<%= totalHours > maxHours ? "color: #ef4444;" : "" %>">
                    <%= totalHours %>h / <%= maxHours %>h
                </div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: <%= Math.min(workloadPercentage, 100) %>%; <%= totalHours > maxHours ? "background: #ef4444;" : "" %>"></div>
                </div>
                <p class="card-description" style="<%= totalHours > maxHours ? "color: #ef4444; font-weight: 600;" : "" %>">
                    <% if (totalHours > maxHours) { %>
                        ⚠️ Exceeded maximum by <%= totalHours - maxHours %>h
                    <% } else { %>
                        <%= availableHours %>h available
                    <% } %>
                </p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Active Applications</span>
                    <span class="card-icon">📄</span>
                </div>
                <div class="card-value"><%= activeApplications %></div>
                <p class="card-description"><%= pendingApplications %> pending review</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">My Skills</span>
                    <span class="card-icon">✨</span>
                </div>
                <div class="card-value">4</div>
                <div>
                    <span class="badge">Python</span>
                    <span class="badge">JavaScript</span>
                    <span class="badge">ML</span>
                </div>
            </div>
        </div>

        <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css">
        <nav class="student-nav" style="padding-left:0;padding-right:0;margin-top:1rem;">
            <a href="<%= request.getContextPath() %>/student-dashboard.jsp" class="active">Home</a>
            <a href="<%= request.getContextPath() %>/student-jobs.jsp">Jobs</a>
            <a href="<%= request.getContextPath() %>/student-profile.jsp">My Profile</a>
            <a href="<%= request.getContextPath() %>/student-applications.jsp">Applications</a>
        </nav>

        <div class="hub-grid">
            <a href="<%= request.getContextPath() %>/student-jobs.jsp" class="hub-card">
                <h3>Browse jobs</h3>
                <p>View open TA positions and apply with a role-specific cover letter.</p>
            </a>
            <a href="<%= request.getContextPath() %>/student-profile.jsp" class="hub-card">
                <h3>My profile</h3>
                <p>Update your standard CV once. It is attached to every application automatically.</p>
            </a>
            <a href="<%= request.getContextPath() %>/student-applications.jsp" class="hub-card">
                <h3>My applications</h3>
                <p>Track status of positions you have applied for.</p>
            </a>
        </div>

        <div class="tabs" style="display:none;">
            <div class="tab-list">
                <button class="tab-button active" onclick="switchTab('browse')">Browse Jobs</button>
                <button class="tab-button" onclick="switchTab('applications')">My Applications</button>
                <button class="tab-button" onclick="switchTab('profile')">Profile & CV</button>
            </div>

            <!-- Browse Jobs Tab -->
            <div id="browse" class="tab-content active">
                <div class="card">
                    <h2 style="font-size: 1.25rem; margin-bottom: 0.5rem; display: flex; align-items: center; gap: 0.5rem;">
                        <span>✨</span> AI-Powered Job Matching
                    </h2>
                    <p style="color: #6b7280; font-size: 0.875rem; margin-bottom: 1.5rem;">
                        Jobs ranked by skill compatibility using AI matching algorithm
                    </p>

                    <%
                        List<String> allJobs = DataFileUtil.readLines("jobs.txt");
                        if (allJobs.isEmpty()) {
                    %>
                        <p style="color: #6b7280; text-align: center; padding: 2rem;">No jobs available at the moment.</p>
                    <%
                        } else {
                            for (String line : allJobs) {
                                String[] parts = line.split("\\|");
                                if (parts.length >= 11 && "open".equals(parts[10])) {
                                    String jobId = parts[0];
                                    String title = parts[1];
                                    String moduleCode = parts[2];
                                    String moduleName = parts[3];
                                    String organiser = parts[4];
                                    String description = parts[6];
                                    String skills = parts[7];
                                    String hoursPerWeek = parts[8];
                                    String duration = parts[9];
                    %>
                    <div class="job-card">
                        <div class="job-header">
                            <div style="flex: 1;">
                                <h3 class="job-title"><%= title %></h3>
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
                        <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 1rem;">
                            <div class="job-details" style="margin: 0;">
                                <span>⏰ <%= hoursPerWeek %>h/week</span>
                                <span>📅 <%= duration %></span>
                            </div>
                            <a href="<%= request.getContextPath() %>/student-apply.jsp?jobId=<%= jobId %>" class="btn-apply">Apply Now</a>
                        </div>
                    </div>
                    <%
                                }
                            }
                        }
                    %>
                </div>
            </div>

            <!-- My Applications Tab -->
            <div id="applications" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">My Applications</h2>

                    <%
                        boolean hasApps = false;
                        for (String line : applications) {
                            String[] parts = line.split("\\|");
                            if (parts.length >= 7 && parts[2].equals(userEmail)) {
                                hasApps = true;
                                String appId = parts[0];
                                String jobId = parts[1];
                                String coverLetter = parts[4];
                                String status = parts[5];
                                String applyDate = parts[6];

                                String[] jobInfo = jobMap.get(jobId);
                                String jobTitle = jobInfo != null ? jobInfo[1] : "Unknown Job";
                                String moduleCode = jobInfo != null ? jobInfo[2] : "";
                                String moduleName = jobInfo != null ? jobInfo[3] : "";

                                String statusBadge = "background: #fef3c7; color: #92400e;";
                                String statusIcon = "⏰";
                                String statusText = "Pending";

                                if ("accepted".equals(status)) {
                                    statusBadge = "background: #dcfce7; color: #166534;";
                                    statusIcon = "✓";
                                    statusText = "Accepted";
                                } else if ("rejected".equals(status)) {
                                    statusBadge = "background: #fee2e2; color: #991b1b;";
                                    statusIcon = "✗";
                                    statusText = "Rejected";
                                }
                    %>
                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <div>
                                <h3 class="job-title"><%= jobTitle %></h3>
                                <p class="job-subtitle"><%= moduleCode %> - <%= moduleName %></p>
                                <div class="job-details" style="margin-top: 0.5rem;">
                                    <span>Applied: <%= applyDate %></span>
                                </div>
                            </div>
                            <span class="badge" style="<%= statusBadge %>"><%= statusIcon %> <%= statusText %></span>
                        </div>
                    </div>
                    <%
                            }
                        }
                        if (!hasApps) {
                    %>
                    <p style="color: #6b7280; text-align: center; padding: 2rem;">
                        You haven't submitted any applications yet.
                    </p>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Profile Tab -->
            <div id="profile" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Profile & CV</h2>
                    <div style="margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1rem; margin-bottom: 0.5rem;">Personal Information</h3>
                        <p style="color: #6b7280; font-size: 0.875rem;">Name: <%= userName %></p>
                        <p style="color: #6b7280; font-size: 0.875rem;">Email: <%= userEmail %></p>
                        <p style="color: #6b7280; font-size: 0.875rem;">Max Hours: <%= maxHours %>h/week</p>
                    </div>
                    <div>
                        <h3 style="font-size: 1rem; margin-bottom: 0.5rem;">Skills</h3>
                        <span class="badge">Python</span>
                        <span class="badge">JavaScript</span>
                        <span class="badge">Machine Learning</span>
                        <span class="badge">Data Analysis</span>
                    </div>
                    <div style="margin-top: 1.5rem;">
                        <a href="<%= request.getContextPath() %>/student-profile.jsp" class="btn-apply">Edit Profile & Upload CV</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tabName) {
            // Hide all tabs
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Remove active from all buttons
            const buttons = document.querySelectorAll('.tab-button');
            buttons.forEach(btn => btn.classList.remove('active'));
            
            // Show selected tab
            document.getElementById(tabName).classList.add('active');
            
            // Set active button
            event.target.classList.add('active');
        }
    </script>
</body>
</html>
