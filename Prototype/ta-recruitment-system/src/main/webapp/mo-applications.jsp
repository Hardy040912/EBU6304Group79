<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ include file="includes/application-payload.jsp" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="cn.bupt.ta.util.SkillMatcher" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Properties" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String userRole = (String) session.getAttribute("userRole");
    boolean isAdmin = "admin".equals(userRole);
    if (userEmail == null || (!"module-organiser".equals(userRole) && !isAdmin)) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    // 初始化数据目录
    DataFileUtil.initDataDir(application.getRealPath("/"));

    // 获取该 MO 发布的岗位
    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    Map<String, String[]> myJobs = new HashMap<>();
    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11 && (isAdmin || parts[5].equals(userEmail))) {
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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bupt-brand.css?v=11">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css?v=7">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
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
        .header-title h1 { font-size: 1.5rem; color: #111827; margin-bottom: 0.25rem; }
        .header-title p { font-size: 0.875rem; color: #6b7280; }
        .header-nav { display: flex; gap: 1rem; align-items: center; }
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
        .btn:hover { background: #f9fafb; }
        .container { max-width: 80rem; margin: 0 auto; padding: 2rem; }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
            padding: 1.5rem;
            margin-bottom: 1.5rem;
        }
        .job-section { margin-bottom: 2rem; }
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
        .badge {
            display: inline-block;
            padding: 0.25rem 0.5rem;
            border-radius: 4px;
            font-size: 0.75rem;
            font-weight: 500;
        }
        .badge-pending { background: #fef3c7; color: #92400e; }
        .badge-accepted { background: #dcfce7; color: #166534; }
        .badge-rejected { background: #fee2e2; color: #991b1b; }
        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            text-align: center;
        }
        .resume-panel {
            display: none;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 1rem 1.25rem;
            margin-top: 0.75rem;
            font-size: 0.875rem;
            color: #374151;
            line-height: 1.8;
        }
        .resume-panel.open { display: block; }
        .resume-section { margin-bottom: 0.75rem; }
        .resume-section strong { color: #111827; }
        .match-panel {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 6px;
            padding: 0.75rem 1rem;
            margin: 0.75rem 0;
            font-size: 0.875rem;
            color: #475569;
            line-height: 1.5;
        }
        .match-panel strong { color: #111827; }
        .match-score { color: #2563eb; font-weight: 700; }
    </style>
</head>
<body class="mo-page">
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1><%= isAdmin ? "All Applications" : "Applications" %></h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <jsp:include page="includes/mo-nav.jsp">
        <jsp:param name="active" value="applications" />
    </jsp:include>

    <div class="container">
        <% if ("1".equals(request.getParameter("success"))) { %>
        <div class="success-message">✓ Application status updated successfully!</div>
        <% } %>
        
        <div class="card">
            <h2 class="mo-page-title"><%= isAdmin ? "Applications for All Jobs" : "Applications for My Jobs" %></h2>

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
                <h3 class="mo-job-heading"><%= jobTitle %> (<%= moduleCode %>)</h3>
                <% if (isAdmin) { %>
                <p style="font-size:0.875rem;color:#6b7280;margin-bottom:1rem;">
                    Posted by <%= jobInfo[4] %> (<%= jobInfo[5] %>)
                </p>
                <% } %>

                <%
                    for (String[] app : jobApplications) {
                        String appId = app[0];
                        String studentEmail = app[2];
                        String studentName = app[3];
                        String coverLetter = app[4];
                        String status = app[5];
                        String applyDate = app[6];

                        String statusBadge = "badge-pending";
                        String statusText = "Pending";

                        if ("accepted".equals(status)) {
                            statusBadge = "badge-accepted";
                            statusText = "Accepted";
                        } else if ("rejected".equals(status)) {
                            statusBadge = "badge-rejected";
                            statusText = "Rejected";
                        }
                %>
                <div class="application-card">
                    <div class="applicant-header">
                        <div>
                            <div class="mo-applicant-name"><%= studentName %></div>
                            <div class="mo-applicant-email"><%= studentEmail %></div>
                            <div class="mo-applicant-meta">Applied: <%= applyDate %></div>
                        </div>
                        <span class="badge badge-with-icon <%= statusBadge %>"><% if ("Pending".equals(statusText)) { %><span class="ui-icon ui-icon-clock ui-icon-sm" aria-hidden="true"></span><% } else if ("Accepted".equals(statusText)) { %>✓<% } else { %>✗<% } %> <%= statusText %></span>
                    </div>

                    <% String profileText = ApplicationPayload.profile(coverLetter); String coverOnly = ApplicationPayload.coverLetter(coverLetter); %>
                    <div class="review-panel" style="margin-bottom:0.75rem;"><div class="review-panel-title">Applicant profile (account CV)</div><div class="review-panel-body"><%= ApplicationPayload.htmlWithBreaks(profileText.isEmpty() ? "No profile snapshot." : profileText) %></div></div>
                    <div class="review-panel"><div class="review-panel-title">Cover letter for this position</div><div class="review-panel-body"><%= ApplicationPayload.htmlWithBreaks(coverOnly) %></div></div>

                    <%
                        Properties resumeData = DataFileUtil.loadResume(studentEmail);
                        boolean hasResume = !resumeData.isEmpty();
                        SkillMatcher.MatchResult match = SkillMatcher.match(jobInfo[7], resumeData);
                    %>
                    <div class="match-panel">
                        <div><strong>Skill match:</strong> <span class="match-score"><%= match.getScore() %>%</span></div>
                        <div><strong>Matched:</strong> <%= match.getMatchedSummary() %></div>
                        <div><strong>Missing:</strong> <%= match.getMissingSummary() %></div>
                    </div>
                    <% if (hasResume) { %>
                    <button type="button" class="btn-resume" onclick="toggleResume('<%= appId %>')"><span class="ui-icon ui-icon-document" aria-hidden="true"></span> View Resume</button>
                    <div id="resume_<%= appId %>" class="resume-panel">
                        <div class="resume-section">
                            <strong>Basic Information</strong><br>
                            Phone: <%= resumeData.getProperty("phone","—") %><br>
                            Major: <%= resumeData.getProperty("major","—") %><br>
                            Year: <%= resumeData.getProperty("year","—") %><br>
                            GPA: <%= resumeData.getProperty("gpa","—") %>
                        </div>
                        <div class="resume-section">
                            <strong>Skills Overview</strong><br>
                            Technical Skills: <%= resumeData.getProperty("technicalSkills","—") %><br>
                            Language Skills: <%= resumeData.getProperty("languageSkills","—") %><br>
                            Certifications/Awards: <%= resumeData.getProperty("certifications","—") %>
                        </div>
                        <div class="resume-section">
                            <strong>Teaching / Tutoring Experience</strong><br>
                            <%= resumeData.getProperty("teachingExp","—").replace("\n","<br>") %>
                        </div>
                        <div class="resume-section">
                            <strong>Project Experience</strong><br>
                            <%= resumeData.getProperty("projectExp","—").replace("\n","<br>") %>
                        </div>
                        <div class="resume-section">
                            <strong>Personal Statement</strong><br>
                            <%= resumeData.getProperty("personalStatement","—") %>
                        </div>
                    </div>
                    <% } else { %>
                    <span style="font-size:0.8rem;color:#9ca3af;">No resume uploaded</span>
                    <% } %>

                    <% if ("pending".equals(status)) { %>
                    <div class="mo-action-buttons">
                        <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post" style="display: inline;">
                            <input type="hidden" name="appId" value="<%= appId %>">
                            <input type="hidden" name="status" value="accepted">
                            <button type="submit" class="btn-accept">Accept</button>
                        </form>
                        <form action="<%= request.getContextPath() %>/updateApplicationStatus" method="post" style="display: inline-block;" id="rejectForm_<%= appId %>">
                            <input type="hidden" name="appId" value="<%= appId %>">
                            <input type="hidden" name="status" value="rejected">
                            <input type="hidden" name="blocked" id="blockedInput_<%= appId %>" value="false">
                            <button type="submit" class="btn-reject">Reject</button>
                            <label style="display: inline-block; margin-left: 0.5rem; font-size: 0.875rem; color: #4b5563; cursor: pointer;">
                                <input type="checkbox" id="blockCheckbox_<%= appId %>" onchange="document.getElementById('blockedInput_<%= appId %>').value = this.checked ? 'true' : 'false';" style="margin-right: 0.25rem;">
                                Block student from reapplying
                            </label>
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
                <%= isAdmin ? "No applications have been submitted yet." : "No applications received yet for your posted jobs." %>
            </p>
            <%
                }
            %>
        </div>
    </div>
    <script>
        function toggleResume(appId) {
            const panel = document.getElementById('resume_' + appId);
            panel.classList.toggle('open');
        }
    </script>
</body>
</html>
