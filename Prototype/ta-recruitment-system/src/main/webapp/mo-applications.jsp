<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }
    
    // 获取该 MO 发布的岗位
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    Map<String, String[]> myJobs = new HashMap<>();
    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11 && parts[5].equals(userEmail)) {
            myJobs.put(parts[0], parts);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Applications - TA Recruitment System</title>
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
        
        .job-section {
            margin-bottom: 2rem;
        }
        
        .job-section-title {
            font-size: 1.125rem;
            font-weight: 600;
            color: #111827;
            margin-bottom: 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e5e7eb;
        }
        
        .application-card {
            background: #f9fafb;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 1.5rem;
            margin-bottom: 1rem;
        }
        
        .applicant-header {
            display: flex;
            justify-content: space-between;
            align-items: start;
            margin-bottom: 1rem;
        }
        
        .applicant-name {
            font-size: 1rem;
            font-weight: 600;
            color: #111827;
        }
        
        .applicant-email {
            font-size: 0.875rem;
            color: #6b7280;
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
        
        .cover-letter {
            background: white;
            padding: 1rem;
            border-radius: 6px;
            font-size: 0.875rem;
            color: #4b5563;
            margin-bottom: 1rem;
            line-height: 1.5;
        }
        
        .action-buttons {
            display: flex;
            gap: 0.5rem;
        }
        
        .btn-accept {
            padding: 0.5rem 1rem;
            background: #16a34a;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            cursor: pointer;
        }
        
        .btn-accept:hover {
            background: #15803d;
        }
        
        .btn-reject {
            padding: 0.5rem 1rem;
            background: #dc2626;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            cursor: pointer;
        }
        
        .btn-reject:hover {
            background: #b91c1c;
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
                <h1>Applications</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/mo-dashboard.jsp" class="btn">← Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <% if ("1".equals(request.getParameter("success"))) { %>
        <div class="success-message">✓ Application status updated successfully!</div>
        <% } %>
        
        <div class="card">
            <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Applications for My Jobs</h2>

            <%
                List<String> applications = DataFileUtil.readLines("applications.txt");
                boolean hasApplications = false;

                // 按岗位分组显示申请
                for (Map.Entry<String, String[]> entry : myJobs.entrySet()) {
                    String jobId = entry.getKey();
                    String[] jobInfo = entry.getValue();
                    String jobTitle = jobInfo[1];
                    String moduleCode = jobInfo[2];

                    List<String[]> jobApplications = new ArrayList<>();
                    for (String line : applications) {
                        String[] parts = line.split("\\|");
                        if (parts.length >= 7 && parts[1].equals(jobId)) {
                            jobApplications.add(parts);
                        }
                    }

                    if (!jobApplications.isEmpty()) {
                        hasApplications = true;
            %>
            <div class="job-section">
                <h3 class="job-section-title"><%= jobTitle %> (<%= moduleCode %>)</h3>

                <%
                    for (String[] app : jobApplications) {
                        String appId = app[0];
                        String studentEmail = app[2];
                        String studentName = app[3];
                        String coverLetter = app[4];
                        String status = app[5];
                        String applyDate = app[6];

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
                <div class="application-card">
                    <div class="applicant-header">
                        <div>
                            <div class="applicant-name"><%= studentName %></div>
                            <div class="applicant-email"><%= studentEmail %></div>
                            <div style="font-size: 0.75rem; color: #9ca3af; margin-top: 0.25rem;">Applied: <%= applyDate %></div>
                        </div>
                        <span class="badge <%= statusBadge %>"><%= statusIcon %> <%= statusText %></span>
                    </div>

                    <div style="margin-bottom: 0.5rem; font-size: 0.875rem; font-weight: 500; color: #374151;">Cover Letter:</div>
                    <div class="cover-letter"><%= coverLetter %></div>

                    <% if ("pending".equals(status)) { %>
                    <div class="action-buttons">
                        <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post" style="display: inline;">
                            <input type="hidden" name="appId" value="<%= appId %>">
                            <input type="hidden" name="status" value="accepted">
                            <button type="submit" class="btn-accept">✓ Accept</button>
                        </form>
                        <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post" style="display: inline;">
                            <input type="hidden" name="appId" value="<%= appId %>">
                            <input type="hidden" name="status" value="rejected">
                            <button type="submit" class="btn-reject">✗ Reject</button>
                        </form>
                    </div>
                    <% } %>
                </div>
                <%
                    }
                %>
            </div>
            <%
                    }
                }

                if (!hasApplications) {
            %>
            <p style="color: #6b7280; text-align: center; padding: 2rem;">
                No applications received yet for your posted jobs.
            </p>
            <%
                }
            %>
        </div>
    </div>
</body>
</html>
