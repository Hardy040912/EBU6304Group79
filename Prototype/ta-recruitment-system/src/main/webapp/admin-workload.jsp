<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null || !"admin".equals(session.getAttribute("userRole"))) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 统计每个学生的工作量
    Map<String, Integer> studentWorkload = new HashMap<>();
    Map<String, String> studentNames = new HashMap<>();

    List<String> applications = DataFileUtil.readLines("applications.txt");
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    
    // 创建岗位映射
    Map<String, String[]> jobMap = new HashMap<>();
    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11) {
            jobMap.put(parts[0], parts);
        }
    }
    
    // 统计已接受的申请
    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && "accepted".equals(parts[5])) {
            String studentEmail = parts[2];
            String studentName = parts[3];
            String jobId = parts[1];
            
            studentNames.put(studentEmail, studentName);
            
            // 获取该岗位的工作时长
            String[] jobInfo = jobMap.get(jobId);
            if (jobInfo != null) {
                int hours = Integer.parseInt(jobInfo[8]);
                studentWorkload.put(studentEmail, studentWorkload.getOrDefault(studentEmail, 0) + hours);
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TA Workload - TA Recruitment System</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        .container {
            max-width: 80rem;
            margin: 0 auto;
            padding: 2rem;
        }
        
        .card {
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        th {
            text-align: left;
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            font-weight: 600;
            border-bottom: 2px solid rgba(255, 255, 255, 0.1);
        }
        
        td {
            padding: 1rem;
            font-size: 0.875rem;
            border-bottom: 1px solid rgba(255, 255, 255, 0.06);
        }
        
        .workload-bar {
            width: 100%;
            max-width: 200px;
            height: 0.5rem;
            border-radius: 9999px;
            overflow: hidden;
        }
        
        .workload-fill {
            height: 100%;
            background: #2563eb;
            transition: width 0.3s;
        }
        
        .workload-fill.high {
            background: #dc2626;
        }
        
        .workload-fill.medium {
            background: #f59e0b;
        }
        
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .badge-low {
            background: #dcfce7;
            color: #166534;
        }
        
        .badge-medium {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-high {
            background: #fee2e2;
            color: #991b1b;
        }
    </style>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bupt-brand.css?v=11">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css?v=7">
</head>
<body class="admin-page">
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>TA Workload Overview</h1>
                <p><%= userName %></p>
            </div>
            <a href="<%= request.getContextPath() %>/logout" class="btn-logout">
                <span>🚪</span> Logout
            </a>
        </div>
    </header>

    <jsp:include page="includes/admin-nav.jsp">
        <jsp:param name="active" value="workload" />
    </jsp:include>

    <div class="container">
        <div class="card">
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">All TA Workload</h2>

            <% if (studentWorkload.isEmpty()) { %>
            <p style="color: #6b7280; text-align: center; padding: 2rem;">
                No TA assignments yet.
            </p>
            <% } else { %>
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Email</th>
                        <th>Total Hours/Week</th>
                        <th>Workload</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        for (Map.Entry<String, Integer> entry : studentWorkload.entrySet()) {
                            String email = entry.getKey();
                            int hours = entry.getValue();
                            String name = studentNames.get(email);

                            int maxHours = 20; // 固定最大 20 小时
                            int percentage = (hours * 100) / maxHours;
                            String statusClass = "badge-low";
                            String statusText = "Normal";
                            String fillClass = "";
                            String textColor = "";

                            if (hours > maxHours) {
                                statusClass = "badge-high";
                                statusText = "⚠️ OVERLOADED";
                                fillClass = "high";
                                textColor = "color: #ef4444; font-weight: 700;";
                            } else if (hours >= 16) {
                                statusClass = "badge-high";
                                statusText = "High";
                                fillClass = "high";
                            } else if (hours >= 12) {
                                statusClass = "badge-medium";
                                statusText = "Medium";
                                fillClass = "medium";
                            }
                    %>
                    <tr>
                        <td><strong><%= name %></strong></td>
                        <td><%= email %></td>
                        <td style="<%= textColor %>">
                            <strong><%= hours %>h</strong> / <%= maxHours %>h
                            <% if (hours > maxHours) { %>
                                <span style="color: #ef4444; font-weight: 700;"> (Exceeded by <%= hours - maxHours %>h)</span>
                            <% } %>
                        </td>
                        <td>
                            <div class="workload-bar">
                                <div class="workload-fill <%= fillClass %>" style="width: <%= Math.min(percentage, 100) %>%"></div>
                            </div>
                        </td>
                        <td>
                            <span class="badge <%= statusClass %>"><%= statusText %></span>
                        </td>
                    </tr>
                    <%
                        }
                    %>
                </tbody>
            </table>
            <% } %>
        </div>
    </div>
</body>
</html>
