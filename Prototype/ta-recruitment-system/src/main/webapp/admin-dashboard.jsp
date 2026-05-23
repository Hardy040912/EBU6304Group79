<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
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
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Administrator Dashboard</h1>
                <p>BUPT International School TA System</p>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <span>🚪</span> Logout
            </a>
        </div>
    </header>

    <div class="container">
        <!-- Alert -->
        <% if (criticalAlerts > 0) { %>
        <div class="alert">
            <span class="alert-icon">⚠️</span>
            <div class="alert-content">
                <strong><%= criticalAlerts %> workload alert<%= criticalAlerts > 1 ? "s" : "" %></strong> requiring attention. Check the workload balancing tab for details.
            </div>
        </div>
        <% } %>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Total Students</span>
                    <span class="card-icon">👥</span>
                </div>
                <div class="card-value"><%= totalStudents %></div>
                <p class="card-description">Registered TAs</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Active Jobs</span>
                    <span class="card-icon">💼</span>
                </div>
                <div class="card-value"><%= activeJobs %></div>
                <p class="card-description">Open positions</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Applications</span>
                    <span class="card-icon">📈</span>
                </div>
                <div class="card-value"><%= totalApplications %></div>
                <p class="card-description">Total submitted</p>
            </div>

            <div class="card">
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
            <div class="tab-list">
                <button class="tab-button active" onclick="switchTab('overview')">System Overview</button>
                <button class="tab-button" onclick="switchTab('workload')">Workload Balancing</button>
                <button class="tab-button" onclick="switchTab('students')">Student Management</button>
            </div>

            <!-- Overview Tab -->
            <div id="overview" class="tab-content active">
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
            <div id="students" class="tab-content">
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
        function switchTab(tabName) {
            const tabs = document.querySelectorAll('.tab-content');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            const buttons = document.querySelectorAll('.tab-button');
            buttons.forEach(btn => btn.classList.remove('active'));
            
            document.getElementById(tabName).classList.add('active');
            event.target.classList.add('active');
        }
    </script>
</body>
</html>
