<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="cn.bupt.ta.util.SkillMatcher" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Properties" %>
<%@ page import="java.util.HashSet" %>
<%@ page import="java.util.Set" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 统计系统数据
    List<String> users = DataFileUtil.readLines("users.txt");
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    List<String> applications = DataFileUtil.readLines("applications.txt");

    // 统计学生数量
    int totalStudents = 0;
    for (String line : users) {
        String[] parts = line.split("\\|");
        if (parts.length >= 3 && "student".equals(parts[2])) {
            totalStudents++;
        }
    }

    // 统计开放岗位数量
    int activeJobs = 0;
    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11 && "open".equals(parts[10])) {
            activeJobs++;
        }
    }

    // 统计申请总数
    int totalApplications = applications.size();

    // 统计需要关注的工作量警告
    int criticalAlerts = 0;
    Set<String> studentEmails = new HashSet<>();
    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && "accepted".equals(parts[5])) {
            studentEmails.add(parts[2]);
        }
    }
    // 简单统计：假设超过 16 小时为 critical
    for (String email : studentEmails) {
        int hours = 0;
        for (String line : applications) {
            String[] parts = line.split("\\|");
            if (parts.length >= 7 && parts[2].equals(email) && "accepted".equals(parts[5])) {
                for (String jobLine : jobs) {
                    String[] jobParts = jobLine.split("\\|");
                    if (jobParts.length >= 11 && jobParts[0].equals(parts[1])) {
                        try {
                            hours += Integer.parseInt(jobParts[8].trim());
                        } catch (NumberFormatException e) {
                            // 忽略
                        }
                        break;
                    }
                }
            }
        }
        if (hours >= 16) {
            criticalAlerts++;
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administrator Dashboard - TA Recruitment System</title>
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
        
        .alert {
            background: #fffbeb;
            border: 1px solid #fde68a;
            border-radius: 8px;
            padding: 1rem;
            margin-bottom: 2rem;
            display: flex;
            align-items: start;
            gap: 0.75rem;
        }
        
        .alert-icon {
            color: #d97706;
            font-size: 1.25rem;
        }
        
        .alert-content {
            color: #92400e;
            font-size: 0.875rem;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2.5rem;
        }
        
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
        }

        .stat-card {
            min-height: 128px;
            border: 2px solid transparent;
            cursor: pointer;
            text-align: left;
            transition: transform 0.15s, box-shadow 0.15s, border-color 0.15s;
        }

        .stat-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 14px 28px rgba(15, 23, 42, 0.10);
        }

        .stat-card.active {
            border-color: #2563eb;
            box-shadow: 0 12px 26px rgba(37, 99, 235, 0.16);
        }

        .stat-card:focus {
            outline: 3px solid rgba(37, 99, 235, 0.25);
            outline-offset: 3px;
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
        
        .tabs {
            margin-bottom: 1rem;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        .chart-container {
            background: white;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        .chart-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 1rem;
        }
        
        .bar-chart {
            display: flex;
            flex-direction: column;
            gap: 1rem;
        }
        
        .bar-item {
            display: flex;
            align-items: center;
            gap: 1rem;
        }
        
        .bar-label {
            width: 80px;
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .bar-container {
            flex: 1;
            height: 32px;
            background: #f3f4f6;
            border-radius: 4px;
            position: relative;
            overflow: hidden;
        }
        
        .bar-fill {
            height: 100%;
            border-radius: 4px;
            display: flex;
            align-items: center;
            padding: 0 0.5rem;
            color: white;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .bar-green {
            background: #10b981;
        }
        
        .bar-yellow {
            background: #f59e0b;
        }
        
        .bar-red {
            background: #ef4444;
        }
        
        .student-list {
            display: grid;
            gap: 1rem;
        }
        
        .student-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1rem;
        }
        
        .student-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 0.75rem;
        }
        
        .student-name {
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.25rem;
        }
        
        .student-email {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .workload-info {
            font-size: 0.875rem;
            color: #6b7280;
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
        
        .alert-badge {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .alert-critical {
            background: #fee2e2;
            color: #991b1b;
        }
        
        .alert-warning {
            background: #fef3c7;
            color: #92400e;
        }

        .alert-success {
            background: #dcfce7;
            color: #166534;
        }

        .action-row {
            display: flex;
            flex-wrap: wrap;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }

        .action-link {
            text-decoration: none;
            padding: 0.65rem 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            border: 1px solid #d1d5db;
            color: #374151;
            background: white;
        }

        .action-link.primary {
            color: white;
            background: #2563eb;
            border-color: #2563eb;
        }

        .application-card {
            background: white;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1rem;
        }

        .btn-mini {
            border: none;
            border-radius: 6px;
            color: white;
            cursor: pointer;
            font-size: 0.8rem;
            font-weight: 600;
            padding: 0.45rem 0.75rem;
        }

        .btn-accept {
            background: #16a34a;
        }

        .btn-reject {
            background: #dc2626;
        }

        .recommendation-panel {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 0.75rem;
            margin: 0.75rem 0;
            font-size: 0.875rem;
            color: #475569;
        }

        .recommendation-title {
            color: #111827;
            font-weight: 700;
            margin-bottom: 0.35rem;
        }

        .recommendation-strong {
            border-color: #86efac;
            background: #f0fdf4;
        }

        .recommendation-good {
            border-color: #bfdbfe;
            background: #eff6ff;
        }

        .recommendation-risk {
            border-color: #fecaca;
            background: #fef2f2;
        }
    </style>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bupt-brand.css?v=11">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css?v=7">
</head>
<body class="admin-page">
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Administrator Dashboard</h1>
                <p><%= userName %></p>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <span>🚪</span> Logout
            </a>
        </div>
    </header>

    <jsp:include page="includes/admin-nav.jsp">
        <jsp:param name="active" value="home" />
    </jsp:include>

    <div class="container">
        <!-- Alert -->
        <% if (criticalAlerts > 0) { %>
        <div class="alert">
            <span class="alert-icon">⚠️</span>
            <div class="alert-content">
                <strong><%= criticalAlerts %> workload alert<%= criticalAlerts > 1 ? "s" : "" %></strong> requiring attention. Click the Critical Alerts card for details.
            </div>
        </div>
        <% } %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="card stat-card active" data-tab="students" onclick="switchTab('students', this)" tabindex="0" onkeydown="openCardFromKeyboard(event, 'students', this)">
                <div class="card-header">
                    <span class="card-title">Total Students</span>
                    <span class="card-icon">👥</span>
                </div>
                <div class="card-value"><%= totalStudents %></div>
                <p class="card-description">Registered TAs</p>
            </div>

            <div class="card stat-card" data-tab="recruitment" onclick="switchTab('recruitment', this)" tabindex="0" onkeydown="openCardFromKeyboard(event, 'recruitment', this)">
                <div class="card-header">
                    <span class="card-title">Active Jobs</span>
                    <span class="card-icon">💼</span>
                </div>
                <div class="card-value"><%= activeJobs %></div>
                <p class="card-description">Open positions</p>
            </div>

            <div class="card stat-card" data-tab="applications" onclick="switchTab('applications', this)" tabindex="0" onkeydown="openCardFromKeyboard(event, 'applications', this)">
                <div class="card-header">
                    <span class="card-title">Applications</span>
                    <span class="card-icon">📈</span>
                </div>
                <div class="card-value"><%= totalApplications %></div>
                <p class="card-description">Total submitted</p>
            </div>

            <div class="card stat-card" data-tab="workload" onclick="switchTab('workload', this)" tabindex="0" onkeydown="openCardFromKeyboard(event, 'workload', this)">
                <div class="card-header">
                    <span class="card-title">Critical Alerts</span>
                    <span class="card-icon">⚠️</span>
                </div>
                <div class="card-value"><%= criticalAlerts %></div>
                <p class="card-description">Needs attention</p>
            </div>
        </div>

        <!-- Tabs -->
        <div class="tabs">
            <!-- Overview Tab -->
            <div id="overview" class="tab-content">
                <div class="chart-container">
                    <h2 class="chart-title">Student Workload Distribution</h2>
                    <div class="bar-chart">
                        <%
                            // 统计每个学生的工作量
                            java.util.Map<String, Integer> studentHours = new java.util.HashMap<>();
                            java.util.Map<String, String> studentNameMap = new java.util.HashMap<>();

                            for (String line : applications) {
                                String[] parts = line.split("\\|");
                                if (parts.length >= 7 && "accepted".equals(parts[5])) {
                                    String email = parts[2];
                                    String name = parts[3];
                                    studentNameMap.put(email, name);

                                    for (String jobLine : jobs) {
                                        String[] jobParts = jobLine.split("\\|");
                                        if (jobParts.length >= 11 && jobParts[0].equals(parts[1])) {
                                            try {
                                                int hours = Integer.parseInt(jobParts[8].trim());
                                                studentHours.put(email, studentHours.getOrDefault(email, 0) + hours);
                                            } catch (NumberFormatException e) {
                                                // 忽略
                                            }
                                            break;
                                        }
                                    }
                                }
                            }

                            if (studentHours.isEmpty()) {
                        %>
                        <p style="color: #6b7280; text-align: center; padding: 2rem;">No student workload data available.</p>
                        <%
                            } else {
                                for (java.util.Map.Entry<String, Integer> entry : studentHours.entrySet()) {
                                    String email = entry.getKey();
                                    int hours = entry.getValue();
                                    String name = studentNameMap.get(email);
                                    int maxHours = 20;
                                    int percentage = (hours * 100) / maxHours;

                                    String barColor = "bar-green";
                                    String labelStyle = "";
                                    if (hours > maxHours) {
                                        barColor = "bar-red";
                                        labelStyle = "color: #ef4444; font-weight: 700;";
                                    } else if (percentage >= 80) {
                                        barColor = "bar-red";
                                    } else if (percentage >= 60) {
                                        barColor = "bar-yellow";
                                    }
                        %>
                        <div class="bar-item">
                            <div class="bar-label" style="<%= labelStyle %>">
                                <%= name %>
                                <% if (hours > maxHours) { %>
                                    <span style="color: #ef4444; font-size: 0.75rem;"> ⚠️ OVERLOADED</span>
                                <% } %>
                            </div>
                            <div class="bar-container">
                                <div class="bar-fill <%= barColor %>" style="width: <%= Math.min(percentage, 100) %>%;">
                                    <%= hours %>h / <%= maxHours %>h (<%= percentage %>%)
                                    <% if (hours > maxHours) { %>
                                        - Exceeded by <%= hours - maxHours %>h
                                    <% } %>
                                </div>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>

                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">Recent Activity</h2>
                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                        <%
                            // 显示最近的申请（最多 5 条）
                            int count = 0;
                            for (int i = applications.size() - 1; i >= 0 && count < 5; i--) {
                                String line = applications.get(i);
                                String[] parts = line.split("\\|");
                                if (parts.length >= 7) {
                                    String studentName = parts[3];
                                    String jobId = parts[1];
                                    String status = parts[5];
                                    String date = parts[6];

                                    String jobTitle = "Unknown Job";
                                    for (String jobLine : jobs) {
                                        String[] jobParts = jobLine.split("\\|");
                                        if (jobParts.length >= 11 && jobParts[0].equals(jobId)) {
                                            jobTitle = jobParts[1];
                                            break;
                                        }
                                    }

                                    String activity = "";
                                    if ("accepted".equals(status)) {
                                        activity = studentName + " accepted for " + jobTitle;
                                    } else if ("rejected".equals(status)) {
                                        activity = studentName + " rejected for " + jobTitle;
                                    } else {
                                        activity = studentName + " applied for " + jobTitle;
                                    }
                                    count++;
                        %>
                        <div style="padding: 0.75rem; background: #f9fafb; border-radius: 6px; font-size: 0.875rem;">
                            <span style="color: #6b7280;"><%= date %>:</span> <%= activity %>
                        </div>
                        <%
                                }
                            }

                            if (count == 0) {
                        %>
                        <p style="color: #6b7280; text-align: center; padding: 1rem;">No recent activity.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Recruitment Management Tab -->
            <div id="recruitment" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">Recruitment Controls</h2>
                    <p style="font-size: 0.875rem; color: #6b7280; margin-bottom: 1.25rem;">
                        Administrators can perform Module Organiser actions across the whole school, including posting jobs and reviewing applications for any module.
                    </p>
                    <div style="display: flex; flex-wrap: wrap; gap: 0.75rem; margin-bottom: 1.5rem;">
                        <a href="<%= request.getContextPath() %>/mo-post-job.jsp" style="text-decoration: none; padding: 0.65rem 1rem; background: #2563eb; border-radius: 6px; color: white; font-size: 0.875rem; font-weight: 500;">
                            Post New Job
                        </a>
                        <a href="<%= request.getContextPath() %>/mo-dashboard.jsp" style="text-decoration: none; padding: 0.65rem 1rem; background: white; border: 1px solid #d1d5db; border-radius: 6px; color: #374151; font-size: 0.875rem; font-weight: 500;">
                            View All Job Posts
                        </a>
                        <a href="<%= request.getContextPath() %>/mo-applications.jsp" style="text-decoration: none; padding: 0.65rem 1rem; background: white; border: 1px solid #d1d5db; border-radius: 6px; color: #374151; font-size: 0.875rem; font-weight: 500;">
                            Review All Applications
                        </a>
                    </div>

                    <h3 style="font-size: 1rem; font-weight: 600; margin-bottom: 0.75rem;">Open Jobs by Organiser</h3>
                    <div class="student-list">
                        <%
                            boolean hasRecruitmentJobs = false;
                            for (String jobLine : jobs) {
                                String[] jobParts = jobLine.split("\\|");
                                if (jobParts.length >= 11) {
                                    hasRecruitmentJobs = true;
                        %>
                        <div class="student-card">
                            <div class="student-header">
                                <div>
                                    <div class="student-name"><%= jobParts[1] %></div>
                                    <div class="student-email"><%= jobParts[2] %> - <%= jobParts[3] %></div>
                                    <div class="student-email">Posted by <%= jobParts[4] %> (<%= jobParts[5] %>)</div>
                                </div>
                                <span class="badge"><%= jobParts[10] %></span>
                            </div>
                            <div class="workload-info">
                                <%= jobParts[8] %>h/week for <%= jobParts[9] %> | Skills: <%= jobParts[7] %>
                            </div>
                        </div>
                        <%
                                }
                            }
                            if (!hasRecruitmentJobs) {
                        %>
                        <p style="color: #6b7280; text-align: center; padding: 2rem;">No job posts have been created yet.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Applications Tab -->
            <div id="applications" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">Applications</h2>
                    <div class="action-row">
                        <a href="<%= request.getContextPath() %>/mo-applications.jsp" class="action-link primary">Open Full Review Page</a>
                    </div>
                    <div class="student-list">
                        <%
                            boolean hasApplicationRows = false;
                            for (String appLine : applications) {
                                String[] appParts = appLine.split("\\|");
                                if (appParts.length >= 7) {
                                    hasApplicationRows = true;
                                    String appId = appParts[0];
                                    String jobId = appParts[1];
                                    String studentEmail = appParts[2];
                                    String studentName = appParts[3];
                                    String status = appParts[5];
                                    String applyDate = appParts[6];

                                    String jobTitle = "Unknown Job";
                                    String organiser = "Unknown organiser";
                                    String requiredSkills = "";
                                    for (String jobLine : jobs) {
                                        String[] jobParts = jobLine.split("\\|");
                                        if (jobParts.length >= 11 && jobParts[0].equals(jobId)) {
                                            jobTitle = jobParts[1] + " (" + jobParts[2] + ")";
                                            organiser = jobParts[4] + " (" + jobParts[5] + ")";
                                            requiredSkills = jobParts[7];
                                            break;
                                        }
                                    }

                                    int currentHours = 0;
                                    for (String acceptedLine : applications) {
                                        String[] acceptedParts = acceptedLine.split("\\|");
                                        if (acceptedParts.length >= 7 && acceptedParts[2].equals(studentEmail) && "accepted".equals(acceptedParts[5])) {
                                            for (String workloadJobLine : jobs) {
                                                String[] workloadJobParts = workloadJobLine.split("\\|");
                                                if (workloadJobParts.length >= 11 && workloadJobParts[0].equals(acceptedParts[1])) {
                                                    try {
                                                        currentHours += Integer.parseInt(workloadJobParts[8].trim());
                                                    } catch (NumberFormatException e) {
                                                        // Ignore malformed demo data.
                                                    }
                                                    break;
                                                }
                                            }
                                        }
                                    }

                                    Properties resumeData = DataFileUtil.loadResume(studentEmail);
                                    SkillMatcher.MatchResult match = SkillMatcher.match(requiredSkills, resumeData);
                                    String recommendationClass = "recommendation-panel";
                                    String recommendationTitle = "Review manually";
                                    String recommendationReason = "Moderate signal. Check resume details and module needs.";
                                    if (currentHours >= 16) {
                                        recommendationClass += " recommendation-risk";
                                        recommendationTitle = "Workload risk";
                                        recommendationReason = "This TA is already close to the 20h/week limit.";
                                    } else if (match.getScore() >= 80 && currentHours <= 8) {
                                        recommendationClass += " recommendation-strong";
                                        recommendationTitle = "Strong recommendation";
                                        recommendationReason = "High skill match and low current workload.";
                                    } else if (match.getScore() >= 60 && currentHours <= 12) {
                                        recommendationClass += " recommendation-good";
                                        recommendationTitle = "Good candidate";
                                        recommendationReason = "Useful skill match with manageable workload.";
                                    }

                                    String statusClass = "badge";
                                    String statusLabel = status;
                                    if ("pending".equals(status)) {
                                        statusClass = "alert-badge alert-warning";
                                        statusLabel = "Pending";
                                    } else if ("accepted".equals(status)) {
                                        statusClass = "alert-badge alert-success";
                                        statusLabel = "Accepted";
                                    } else if ("rejected".equals(status)) {
                                        statusClass = "alert-badge alert-critical";
                                        statusLabel = "Rejected";
                                    }
                        %>
                        <div class="application-card">
                            <div class="student-header">
                                <div>
                                    <div class="student-name"><%= studentName %></div>
                                    <div class="student-email"><%= studentEmail %></div>
	                                    <div class="student-email"><%= jobTitle %> | <%= organiser %></div>
	                                    <div class="workload-info">Applied: <%= applyDate %></div>
	                                </div>
	                                <span class="<%= statusClass %>"><%= statusLabel %></span>
	                            </div>
                            <div class="<%= recommendationClass %>">
                                <div class="recommendation-title"><%= recommendationTitle %></div>
                                <div>Skill match: <strong><%= match.getScore() %>%</strong> | Current workload: <strong><%= currentHours %>h/week</strong></div>
                                <div><%= recommendationReason %></div>
                                <div>Matched: <%= match.getMatchedSummary() %></div>
                                <div>Missing: <%= match.getMissingSummary() %></div>
                            </div>
	                            <% if ("pending".equals(status)) { %>
                            <div style="display:flex;flex-wrap:wrap;gap:0.5rem;">
                                <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post">
                                    <input type="hidden" name="appId" value="<%= appId %>">
                                    <input type="hidden" name="status" value="accepted">
                                    <button type="submit" class="btn-mini btn-accept">Accept</button>
                                </form>
                                <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post">
                                    <input type="hidden" name="appId" value="<%= appId %>">
                                    <input type="hidden" name="status" value="rejected">
                                    <input type="hidden" name="blocked" value="false">
                                    <button type="submit" class="btn-mini btn-reject">Reject</button>
                                </form>
                            </div>
                            <% } %>
                        </div>
                        <%
                                }
                            }
                            if (!hasApplicationRows) {
                        %>
                        <p style="color: #6b7280; text-align: center; padding: 2rem;">No applications have been submitted yet.</p>
                        <%
                            }
                        %>
                    </div>
                </div>
            </div>

            <!-- Workload Balancing Tab -->
            <div id="workload" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">Workload Alerts</h2>

                    <%
                        // 统计每个学生的工作量并显示警告
                        java.util.Map<String, Integer> workloadMap = new java.util.HashMap<>();
                        java.util.Map<String, String> nameMap = new java.util.HashMap<>();

                        for (String line : applications) {
                            String[] parts = line.split("\\|");
                            if (parts.length >= 7 && "accepted".equals(parts[5])) {
                                String email = parts[2];
                                String name = parts[3];
                                nameMap.put(email, name);

                                for (String jobLine : jobs) {
                                    String[] jobParts = jobLine.split("\\|");
                                    if (jobParts.length >= 11 && jobParts[0].equals(parts[1])) {
                                        try {
                                            int hours = Integer.parseInt(jobParts[8].trim());
                                            workloadMap.put(email, workloadMap.getOrDefault(email, 0) + hours);
                                        } catch (NumberFormatException e) {
                                            // 忽略
                                        }
                                        break;
                                    }
                                }
                            }
                        }

                        boolean hasAlerts = false;

                        // 显示 alerts (>= 16h)
                        for (java.util.Map.Entry<String, Integer> entry : workloadMap.entrySet()) {
                            String email = entry.getKey();
                            int hours = entry.getValue();
                            String name = nameMap.get(email);
                            int maxHours = 20;
                            int percentage = (hours * 100) / maxHours;

                            if (hours >= 16) {
                                hasAlerts = true;
                                String borderColor = hours >= 18 ? "#ef4444" : "#f59e0b";
                                String alertType = hours >= 18 ? "Critical" : "Warning";
                                String alertClass = hours >= 18 ? "alert-critical" : "alert-warning";
                    %>
                    <div class="student-card" style="border-left: 4px solid <%= borderColor %>;">
                        <div class="student-header">
                            <div>
                                <div class="student-name"><%= name %></div>
                                <div class="student-email"><%= email %></div>
                            </div>
                            <span class="alert-badge <%= alertClass %>"><%= alertType %></span>
                        </div>
                        <div class="workload-info">
                            Current: <%= hours %>h / Max: <%= maxHours %>h (<%= percentage %>% utilization)
                        </div>
                        <p style="font-size: 0.875rem; color: #6b7280; margin-top: 0.5rem;">
                            <% if (hours >= 18) { %>
                            Student has reached high workload. Monitor closely for burnout risk.
                            <% } else { %>
                            Student approaching maximum workload capacity. Limited availability for new assignments.
                            <% } %>
                        </p>
                    </div>
                    <%
                            }
                        }

                        if (!hasAlerts) {
                    %>
                    <p style="color: #6b7280; text-align: center; padding: 2rem;">
                        No workload alerts. All students are within normal capacity.
                    </p>
                    <%
                        }
                    %>
                </div>

                <a href="<%= request.getContextPath() %>/admin-workload.jsp" style="text-decoration: none; display: inline-block; margin-top: 1rem; padding: 0.5rem 1rem; background: white; border: 1px solid #d1d5db; border-radius: 6px; color: #374151; font-size: 0.875rem;">
                    View Full Workload Report →
                </a>
            </div>

            <!-- Student Management Tab -->
            <div id="students" class="tab-content active">
                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">All Students</h2>
                    <div class="student-list">
                        <%
                            // 显示所有学生及其工作量
                            for (String line : users) {
                                String[] parts = line.split("\\|");
                                if (parts.length >= 4 && "student".equals(parts[2])) {
                                    String email = parts[0];
                                    String name = parts[3];

                                    // 计算该学生的工作量
                                    int hours = 0;
                                    for (String appLine : applications) {
                                        String[] appParts = appLine.split("\\|");
                                        if (appParts.length >= 7 && appParts[2].equals(email) && "accepted".equals(appParts[5])) {
                                            for (String jobLine : jobs) {
                                                String[] jobParts = jobLine.split("\\|");
                                                if (jobParts.length >= 11 && jobParts[0].equals(appParts[1])) {
                                                    try {
                                                        hours += Integer.parseInt(jobParts[8].trim());
                                                    } catch (NumberFormatException e) {
                                                        // 忽略
                                                    }
                                                    break;
                                                }
                                            }
                                        }
                                    }

                                    int maxHours = 20;
                                    int percentage = maxHours > 0 ? (hours * 100) / maxHours : 0;
                                    String color = "#10b981"; // green
                                    String warningText = "";

                                    if (hours > maxHours) {
                                        color = "#ef4444"; // red
                                        warningText = "⚠️ OVERLOADED by " + (hours - maxHours) + "h";
                                    } else if (percentage >= 80) {
                                        color = "#ef4444"; // red
                                    } else if (percentage >= 60) {
                                        color = "#2563eb"; // blue
                                    }
                        %>
                        <div class="student-card" style="<%= hours > maxHours ? "border-left: 4px solid #ef4444;" : "" %>">
                            <div class="student-header">
                                <div>
                                    <div class="student-name" style="<%= hours > maxHours ? "color: #ef4444; font-weight: 700;" : "" %>">
                                        <%= name %>
                                        <% if (hours > maxHours) { %>
                                            <span style="color: #ef4444; font-size: 0.875rem; font-weight: 700;"> ⚠️ OVERLOADED</span>
                                        <% } %>
                                    </div>
                                    <div class="student-email"><%= email %></div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600; color: <%= color %>;"><%= hours %>h / <%= maxHours %>h</div>
                                    <div style="font-size: 0.75rem; color: <%= hours > maxHours ? "#ef4444" : "#6b7280" %>; font-weight: <%= hours > maxHours ? "700" : "normal" %>;">
                                        <%= percentage %>% utilized
                                        <% if (hours > maxHours) { %>
                                            <br><span style="color: #ef4444;">Exceeded by <%= hours - maxHours %>h</span>
                                        <% } %>
                                    </div>
                                </div>
                            </div>
                            <div>
                                <span class="badge">Skills: View profile for details</span>
                            </div>
                        </div>
                        <%
                                }
                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function switchTab(tabName, sourceCard) {
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            const cards = document.querySelectorAll('.stat-card');
            cards.forEach(card => card.classList.remove('active'));

            const target = document.getElementById(tabName);
            if (target) {
                target.classList.add('active');
            }

            if (sourceCard) {
                sourceCard.classList.add('active');
            } else {
                const matchingCard = document.querySelector('.stat-card[data-tab="' + tabName + '"]');
                if (matchingCard) {
                    matchingCard.classList.add('active');
                }
            }
        }

        function openCardFromKeyboard(event, tabName, sourceCard) {
            if (event.key === 'Enter' || event.key === ' ') {
                event.preventDefault();
                switchTab(tabName, sourceCard);
            }
        }
    </script>
</body>
</html>
