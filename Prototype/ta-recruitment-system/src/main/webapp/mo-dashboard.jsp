<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 统计数据
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    List<String> applications = DataFileUtil.readLines("applications.txt");

    int activeJobs = 0;
    int pendingApps = 0;
    int acceptedTAs = 0;

    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11 && parts[5].equals(userEmail) && "open".equals(parts[10])) {
            activeJobs++;
        }
    }

    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7) {
            String jobId = parts[1];
            // 检查是否是该 MO 的岗位
            for (String jobLine : jobs) {
                String[] jobParts = jobLine.split("\\|");
                if (jobParts.length >= 11 && jobParts[0].equals(jobId) && jobParts[5].equals(userEmail)) {
                    if ("pending".equals(parts[5])) {
                        pendingApps++;
                    } else if ("accepted".equals(parts[5])) {
                        acceptedTAs++;
                    }
                    break;
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Module Organiser Dashboard - TA Recruitment System</title>
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
        
        .btn-create {
            padding: 0.5rem 1rem;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            margin-bottom: 1.5rem;
        }
        
        .btn-create:hover {
            background: #1d4ed8;
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
            margin-bottom: 0.25rem;
        }
        
        .badge-status {
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        
        .badge-open {
            background: #dcfce7;
            color: #166534;
        }
        
        .badge-pending {
            background: #fef3c7;
            color: #92400e;
        }
        
        .badge-accepted {
            background: #dcfce7;
            color: #166534;
        }
        
        .applicant-card {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 6px;
            padding: 1rem;
            margin-bottom: 0.75rem;
        }
        
        .applicant-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 0.5rem;
        }
        
        .applicant-name {
            font-weight: 600;
            color: #111827;
            margin-bottom: 0.25rem;
        }
        
        .applicant-email {
            font-size: 0.875rem;
            color: #6b7280;
        }
        
        .match-score {
            text-align: right;
        }
        
        .match-score-value {
            font-size: 1.5rem;
            font-weight: 600;
            color: #2563eb;
        }
        
        .match-score-label {
            font-size: 0.75rem;
            color: #6b7280;
        }
        
        .btn-group {
            display: flex;
            gap: 0.5rem;
            margin-top: 0.75rem;
        }
        
        .btn-accept {
            padding: 0.375rem 0.75rem;
            background: #16a34a;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
        }
        
        .btn-accept:hover {
            background: #15803d;
        }
        
        .btn-reject {
            padding: 0.375rem 0.75rem;
            background: #dc2626;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 0.75rem;
            cursor: pointer;
        }
        
        .btn-reject:hover {
            background: #b91c1c;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Module Organiser Dashboard</h1>
                <p><%= userName %></p>
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
                    <span class="card-title">Active Job Posts</span>
                    <span class="card-icon">💼</span>
                </div>
                <div class="card-value"><%= activeJobs %></div>
                <p class="card-description">Open positions</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Pending Applications</span>
                    <span class="card-icon">👥</span>
                </div>
                <div class="card-value"><%= pendingApps %></div>
                <p class="card-description">Awaiting your review</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Accepted TAs</span>
                    <span class="card-icon">✓</span>
                </div>
                <div class="card-value"><%= acceptedTAs %></div>
                <p class="card-description">Currently hired</p>
            </div>
        </div>

        <!-- Tabs -->
        <div class="tabs">
            <div class="tab-list">
                <button class="tab-button active" onclick="switchTab('jobs')">My Job Posts</button>
                <button class="tab-button" onclick="switchTab('applications')">Applications</button>
            </div>

            <!-- My Job Posts Tab -->
            <div id="jobs" class="tab-content active">
                <a href="<%= request.getContextPath() %>/mo-post-job.jsp" class="btn-create" style="text-decoration: none;">
                    <span>+</span> Create New Job Post
                </a>

                <div class="card">
                    <%
                        List<String> myJobs = DataFileUtil.readLines("jobs.txt");
                        boolean hasJobs = false;

                        for (String line : myJobs) {
                            String[] parts = line.split("\\|");
                            if (parts.length >= 11 && parts[5].equals(userEmail)) {
                                hasJobs = true;
                                String jobId = parts[0];
                                String title = parts[1];
                                String moduleCode = parts[2];
                                String moduleName = parts[3];
                                String description = parts[6];
                                String skills = parts[7];
                                String hoursPerWeek = parts[8];
                                String duration = parts[9];
                                String status = parts[10];

                                // 统计该岗位的申请数
                                int applicantCount = 0;
                                for (String appLine : applications) {
                                    String[] appParts = appLine.split("\\|");
                                    if (appParts.length >= 7 && appParts[1].equals(jobId)) {
                                        applicantCount++;
                                    }
                                }

                                String statusBadge = "badge-open";
                                String statusText = "Open";
                                if ("closed".equals(status)) {
                                    statusBadge = "badge-closed";
                                    statusText = "Closed";
                                }
                    %>
                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                            <div>
                                <h3 class="job-title"><%= title %></h3>
                                <p class="job-subtitle"><%= moduleCode %> - <%= moduleName %></p>
                            </div>
                            <span class="badge-status <%= statusBadge %>"><%= statusText %></span>
                        </div>
                        <p style="color: #4b5563; font-size: 0.875rem; margin-bottom: 1rem;">
                            <%= description %>
                        </p>
                        <div style="margin-bottom: 1rem;">
                            <%
                                String[] skillList = skills.split(",");
                                for (String skill : skillList) {
                            %>
                            <span class="badge"><%= skill.trim() %></span>
                            <%
                                }
                            %>
                        </div>
                        <div style="display: flex; gap: 1.5rem; font-size: 0.875rem; color: #6b7280;">
                            <span>⏰ <%= hoursPerWeek %>h/week</span>
                            <span>📅 <%= duration %></span>
                            <span>📊 <%= applicantCount %> applicant<%= applicantCount != 1 ? "s" : "" %></span>
                        </div>
                    </div>
                    <%
                            }
                        }

                        if (!hasJobs) {
                    %>
                    <p style="color: #6b7280; text-align: center; padding: 2rem;">
                        You haven't posted any jobs yet. Click "Create New Job Post" to get started.
                    </p>
                    <%
                        }
                    %>
                </div>
            </div>

            <!-- Applications Tab -->
            <div id="applications" class="tab-content">
                <a href="<%= request.getContextPath() %>/mo-applications.jsp" class="btn-create" style="text-decoration: none; margin-bottom: 1rem; display: inline-block;">
                    View All Applications
                </a>

                <div class="card">
                    <%
                        // 按岗位分组显示申请
                        boolean hasAnyApplications = false;

                        for (String line : myJobs) {
                            String[] parts = line.split("\\|");
                            if (parts.length >= 11 && parts[5].equals(userEmail)) {
                                String jobId = parts[0];
                                String jobTitle = parts[1];
                                String moduleCode = parts[2];

                                // 获取该岗位的申请
                                List<String[]> jobApps = new java.util.ArrayList<>();
                                for (String appLine : applications) {
                                    String[] appParts = appLine.split("\\|");
                                    if (appParts.length >= 7 && appParts[1].equals(jobId)) {
                                        jobApps.add(appParts);
                                    }
                                }

                                if (!jobApps.isEmpty()) {
                                    hasAnyApplications = true;
                    %>
                    <h2 style="font-size: 1.25rem; margin-bottom: 1rem; <%= hasAnyApplications && !jobApps.isEmpty() ? "margin-top: 2rem;" : "" %>">
                        Applications for <%= jobTitle %> (<%= moduleCode %>)
                    </h2>

                    <%
                                    for (String[] app : jobApps) {
                                        String appId = app[0];
                                        String studentEmail = app[2];
                                        String studentName = app[3];
                                        String coverLetter = app[4];
                                        String status = app[5];
                                        String applyDate = app[6];
                    %>
                    <div class="applicant-card">
                        <div class="applicant-header">
                            <div>
                                <div class="applicant-name"><%= studentName %></div>
                                <div class="applicant-email"><%= studentEmail %></div>
                                <div style="font-size: 0.75rem; color: #9ca3af; margin-top: 0.25rem;">Applied: <%= applyDate %></div>
                            </div>
                            <% if ("pending".equals(status)) { %>
                            <span class="badge" style="background: #fef3c7; color: #92400e;">⏰ Pending</span>
                            <% } else if ("accepted".equals(status)) { %>
                            <span class="badge" style="background: #dcfce7; color: #166534;">✓ Accepted</span>
                            <% } else if ("rejected".equals(status)) { %>
                            <span class="badge" style="background: #fee2e2; color: #991b1b;">✗ Rejected</span>
                            <% } %>
                        </div>
                        <div style="margin: 0.75rem 0; font-size: 0.875rem; color: #4b5563;">
                            <strong>Cover Letter:</strong> <%= coverLetter %>
                        </div>
                        <% if ("pending".equals(status)) { %>
                        <div class="btn-group">
                            <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post" style="display: inline;">
                                <input type="hidden" name="appId" value="<%= appId %>">
                                <input type="hidden" name="status" value="accepted">
                                <button type="submit" class="btn-accept">✓ Accept</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post" style="display: inline-block; margin-left: 0.5rem;" id="rejectFormDash_<%= appId %>">
                                <input type="hidden" name="appId" value="<%= appId %>">
                                <input type="hidden" name="status" value="rejected">
                                <input type="hidden" name="blocked" id="blockedInputDash_<%= appId %>" value="false">
                                <button type="submit" class="btn-reject">✗ Reject</button>
                                <label style="display: inline-block; margin-left: 0.5rem; font-size: 0.875rem; color: #4b5563; cursor: pointer;">
                                    <input type="checkbox" id="blockCheckboxDash_<%= appId %>" onchange="document.getElementById('blockedInputDash_<%= appId %>').value = this.checked ? 'true' : 'false';" style="margin-right: 0.25rem;">
                                    Block student from reapplying
                                </label>
                            </form>
                        </div>
                        <% } %>
                    </div>
                    <%
                                    }
                                }
                            }
                        }

                        if (!hasAnyApplications) {
                    %>
                    <p style="color: #6b7280; text-align: center; padding: 2rem;">
                        No applications received yet for your posted jobs.
                    </p>
                    <%
                        }
                    %>
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
