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
        
        table {
            width: 100%;
            border-collapse: collapse;
        }
        
        thead {
            background: #f9fafb;
        }
        
        th {
            text-align: left;
            padding: 0.75rem 1rem;
            font-size: 0.875rem;
            font-weight: 600;
            color: #374151;
            border-bottom: 2px solid #e5e7eb;
        }
        
        td {
            padding: 1rem;
            font-size: 0.875rem;
            color: #4b5563;
            border-bottom: 1px solid #e5e7eb;
        }
        
        tr:hover {
            background: #f9fafb;
        }
        
        .workload-bar {
            width: 100%;
            max-width: 200px;
            height: 0.5rem;
            background: #e5e7eb;
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
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>TA Workload Overview</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/admin-dashboard.jsp" class="btn">← Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

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

                            int percentage = (hours * 100) / 20; // 假设最大20小时
                            String statusClass = "badge-low";
                            String statusText = "Normal";
                            String fillClass = "";

                            if (hours >= 16) {
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
                        <td><strong><%= hours %>h</strong> / 20h</td>
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
