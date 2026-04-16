# 手动创建MO和Admin Dashboard指南

由于文件系统问题，需要手动创建这两个文件。

## 文件1: mo-dashboard.jsp

**位置：** `src/main/webapp/mo-dashboard.jsp`

**完整代码：** 见下方

---

## 文件2: admin-dashboard.jsp

**位置：** `src/main/webapp/admin-dashboard.jsp`

**完整代码：** 见下方

---

## 创建步骤

1. 在IDE或文本编辑器中创建新文件
2. 复制下面的代码
3. 保存到对应位置
4. 重启Tomcat测试

---

## mo-dashboard.jsp 完整代码

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.FileUtil,java.util.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
    
    FileUtil.initDefaultData(application.getRealPath("/"));
    
    // 读取我的职位
    List<String> jobLines = FileUtil.readAllLines("jobs.txt");
    List<String[]> myJobs = new ArrayList<>();
    for (String line : jobLines) {
        if (!line.startsWith("#") && !line.trim().isEmpty()) {
            String[] parts = line.split("\\|");
            if (parts.length >= 11 && parts[5].equals(userEmail)) {
                myJobs.add(parts);
            }
        }
    }
    
    // 读取申请
    List<String> appLines = FileUtil.readAllLines("applications.txt");
    List<String[]> allApps = new ArrayList<>();
    int pendingCount = 0, acceptedCount = 0;
    for (String line : appLines) {
        if (!line.startsWith("#") && !line.trim().isEmpty()) {
            String[] parts = line.split("\\|");
            if (parts.length >= 7) {
                for (String[] job : myJobs) {
                    if (job[0].equals(parts[1])) {
                        allApps.add(parts);
                        if ("pending".equals(parts[5])) pendingCount++;
                        if ("accepted".equals(parts[5])) acceptedCount++;
                        break;
                    }
                }
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MO Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .header { background: white; padding: 1rem 2rem; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        .success { background: #d4edda; color: #155724; padding: 1rem; border-radius: 4px; margin-bottom: 1rem; }
        .stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 2rem; }
        .stat-card { background: white; padding: 1.5rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .stat-value { font-size: 2rem; font-weight: bold; }
        .stat-label { color: #666; font-size: 0.9rem; margin-top: 0.5rem; }
        .tabs { background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .tab-buttons { display: flex; border-bottom: 1px solid #ddd; }
        .tab-btn { padding: 1rem 2rem; background: none; border: none; cursor: pointer; border-bottom: 2px solid transparent; }
        .tab-btn.active { border-bottom-color: #2563eb; color: #2563eb; }
        .tab-content { display: none; padding: 1.5rem; }
        .tab-content.active { display: block; }
        .card { border: 1px solid #ddd; padding: 1.5rem; margin-bottom: 1rem; border-radius: 8px; background: white; }
        .title { font-size: 1.2rem; margin-bottom: 0.5rem; }
        .meta { color: #666; font-size: 0.9rem; margin-bottom: 1rem; }
        .badge { display: inline-block; padding: 0.25rem 0.75rem; background: #e3f2fd; color: #1976d2; border-radius: 12px; font-size: 0.8rem; margin-right: 0.5rem; }
        .btn { padding: 0.5rem 1rem; background: #2563eb; color: white; border: none; border-radius: 4px; cursor: pointer; margin-right: 0.5rem; text-decoration: none; display: inline-block; }
        .btn:hover { background: #1d4ed8; }
        .btn-logout { background: white; color: #333; border: 1px solid #ddd; }
        .btn-accept { background: #28a745; }
        .btn-reject { background: #dc3545; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); align-items: center; justify-content: center; }
        .modal.active { display: flex; }
        .modal-content { background: white; padding: 2rem; border-radius: 8px; max-width: 600px; width: 90%; }
        .form-group { margin-bottom: 1rem; }
        .form-group label { display: block; margin-bottom: 0.5rem; font-weight: bold; }
        .form-group input, .form-group textarea { width: 100%; padding: 0.5rem; border: 1px solid #ddd; border-radius: 4px; }
    </style>
</head>
<body>
    <div class="header">
        <div><h1>Module Organiser Dashboard</h1><p>Welcome, <%= userName %></p></div>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
    </div>
    
    <div class="container">
        <% if ("job_created".equals(request.getParameter("success"))) { %>
            <div class="success">✓ Job posted successfully!</div>
        <% } else if ("updated".equals(request.getParameter("success"))) { %>
            <div class="success">✓ Application status updated!</div>
        <% } %>
        
        <div class="stats">
            <div class="stat-card"><div class="stat-value"><%= myJobs.size() %></div><div class="stat-label">Active Job Posts</div></div>
            <div class="stat-card"><div class="stat-value"><%= pendingCount %></div><div class="stat-label">Pending Applications</div></div>
            <div class="stat-card"><div class="stat-value"><%= acceptedCount %></div><div class="stat-label">Accepted TAs</div></div>
        </div>
        
        <div class="tabs">
            <div class="tab-buttons">
                <button class="tab-btn active" onclick="switchTab('jobs')">My Job Posts</button>
                <button class="tab-btn" onclick="switchTab('apps')">Applications</button>
            </div>
            
            <div id="jobs" class="tab-content active">
                <button class="btn" onclick="document.getElementById('modal').classList.add('active')" style="margin-bottom: 1rem;">+ Create New Job</button>
                <% if (myJobs.isEmpty()) { %>
                    <p>No jobs posted yet.</p>
                <% } else { for (String[] job : myJobs) { %>
                    <div class="card">
                        <div class="title"><%= job[1] %></div>
                        <div class="meta"><%= job[2] %> - <%= job[3] %></div>
                        <p style="margin-bottom: 1rem; color: #666;"><%= job[6] %></p>
                        <div style="margin-bottom: 1rem;">
                            <% for (String skill : job[7].split(",")) { %>
                                <span class="badge"><%= skill.trim() %></span>
                            <% } %>
                        </div>
                        <div style="color: #666; font-size: 0.9rem;">⏰ <%= job[8] %>h/week | 📅 <%= job[9] %></div>
                    </div>
                <% }} %>
            </div>
            
            <div id="apps" class="tab-content">
                <% if (allApps.isEmpty()) { %>
                    <p>No applications yet.</p>
                <% } else { for (String[] app : allApps) { 
                    String jobTitle = "";
                    for (String[] job : myJobs) {
                        if (job[0].equals(app[1])) { jobTitle = job[1]; break; }
                    }
                %>
                    <div class="card">
                        <div class="title"><%= app[3] %></div>
                        <div class="meta"><%= app[2] %> | Applied for: <%= jobTitle %></div>
                        <p style="margin: 1rem 0; color: #666;"><strong>Cover Letter:</strong> <%= app[4] %></p>
                        <div style="color: #666; margin-bottom: 1rem;">Status: <%= app[5] %> | Date: <%= app[6] %></div>
                        <% if ("pending".equals(app[5])) { %>
                            <form action="<%= request.getContextPath() %>/application" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="appId" value="<%= app[0] %>">
                                <input type="hidden" name="status" value="accepted">
                                <button type="submit" class="btn btn-accept">✓ Accept</button>
                            </form>
                            <form action="<%= request.getContextPath() %>/application" method="post" style="display: inline;">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="appId" value="<%= app[0] %>">
                                <input type="hidden" name="status" value="rejected">
                                <button type="submit" class="btn btn-reject">✗ Reject</button>
                            </form>
                        <% } %>
                    </div>
                <% }} %>
            </div>
        </div>
    </div>
    
    <div id="modal" class="modal">
        <div class="modal-content">
            <h2>Create New Job Post</h2>
            <form action="<%= request.getContextPath() %>/job" method="post">
                <input type="hidden" name="action" value="create">
                <div class="form-group"><label>Job Title:</label><input type="text" name="title" required></div>
                <div class="form-group"><label>Module Code:</label><input type="text" name="moduleCode" required></div>
                <div class="form-group"><label>Module Name:</label><input type="text" name="module" required></div>
                <div class="form-group"><label>Description:</label><textarea name="description" rows="3" required></textarea></div>
                <div class="form-group"><label>Skills (comma-separated):</label><input type="text" name="skills" placeholder="Python,Java,Teaching" required></div>
                <div class="form-group"><label>Hours per Week:</label><input type="number" name="hoursPerWeek" min="1" max="20" required></div>
                <div class="form-group"><label>Duration:</label><input type="text" name="duration" placeholder="12 weeks" required></div>
                <div style="display: flex; gap: 1rem; margin-top: 1rem;">
                    <button type="submit" class="btn">Create Job</button>
                    <button type="button" class="btn" style="background: #6c757d;" onclick="document.getElementById('modal').classList.remove('active')">Cancel</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function switchTab(tab) {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            event.target.classList.add('active');
            document.getElementById(tab).classList.add('active');
        }
    </script>
</body>
</html>
```

---

## admin-dashboard.jsp 完整代码

```jsp
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.FileUtil,java.util.*" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) { response.sendRedirect(request.getContextPath() + "/index.jsp"); return; }
    
    FileUtil.initDefaultData(application.getRealPath("/"));
    
    // 读取所有用户
    List<String> userLines = FileUtil.readAllLines("users.txt");
    List<String[]> allUsers = new ArrayList<>();
    int studentCount = 0;
    for (String line : userLines) {
        if (!line.startsWith("#") && !line.trim().isEmpty()) {
            String[] parts = line.split("\\|");
            if (parts.length >= 4) {
                allUsers.add(parts);
                if ("student".equals(parts[2])) studentCount++;
            }
        }
    }
    
    // 读取所有职位
    List<String> jobLines = FileUtil.readAllLines("jobs.txt");
    List<String[]> allJobs = new ArrayList<>();
    int openJobs = 0;
    for (String line : jobLines) {
        if (!line.startsWith("#") && !line.trim().isEmpty()) {
            String[] parts = line.split("\\|");
            if (parts.length >= 11) {
                allJobs.add(parts);
                if ("open".equals(parts[10])) openJobs++;
            }
        }
    }
    
    // 读取所有申请
    List<String> appLines = FileUtil.readAllLines("applications.txt");
    List<String[]> allApps = new ArrayList<>();
    for (String line : appLines) {
        if (!line.startsWith("#") && !line.trim().isEmpty()) {
            String[] parts = line.split("\\|");
            if (parts.length >= 7) {
                allApps.add(parts);
            }
        }
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: Arial, sans-serif; background: #f5f5f5; }
        .header { background: white; padding: 1rem 2rem; border-bottom: 1px solid #ddd; display: flex; justify-content: space-between; align-items: center; }
        .container { max-width: 1200px; margin: 2rem auto; padding: 0 2rem; }
        .stats { display: grid; grid-template-columns: repeat(4, 1fr); gap: 1rem; margin-bottom: 2rem; }
        .stat-card { background: white; padding: 1.5rem; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .stat-value { font-size: 2rem; font-weight: bold; }
        .stat-label { color: #666; font-size: 0.9rem; margin-top: 0.5rem; }
        .tabs { background: white; border-radius: 8px; box-shadow: 0 2px 4px rgba(0,0,0,0.1); }
        .tab-buttons { display: flex; border-bottom: 1px solid #ddd; }
        .tab-btn { padding: 1rem 2rem; background: none; border: none; cursor: pointer; border-bottom: 2px solid transparent; }
        .tab-btn.active { border-bottom-color: #2563eb; color: #2563eb; }
        .tab-content { display: none; padding: 1.5rem; }
        .tab-content.active { display: block; }
        .card { border: 1px solid #ddd; padding: 1.5rem; margin-bottom: 1rem; border-radius: 8px; background: white; }
        .title { font-size: 1.2rem; margin-bottom: 0.5rem; }
        .meta { color: #666; font-size: 0.9rem; }
        .badge { display: inline-block; padding: 0.25rem 0.75rem; background: #e3f2fd; color: #1976d2; border-radius: 12px; font-size: 0.8rem; margin-right: 0.5rem; }
        .btn { padding: 0.5rem 1rem; background: #2563eb; color: white; border: none; border-radius: 4px; cursor: pointer; text-decoration: none; display: inline-block; }
        .btn-logout { background: white; color: #333; border: 1px solid #ddd; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 0.75rem; text-align: left; border-bottom: 1px solid #ddd; }
        th { background: #f9fafb; font-weight: 600; }
    </style>
</head>
<body>
    <div class="header">
        <div><h1>Administrator Dashboard</h1><p>BUPT International School TA System</p></div>
        <a href="<%= request.getContextPath() %>/logout" class="btn btn-logout">Logout</a>
    </div>
    
    <div class="container">
        <div class="stats">
            <div class="stat-card"><div class="stat-value"><%= studentCount %></div><div class="stat-label">Total Students</div></div>
            <div class="stat-card"><div class="stat-value"><%= openJobs %></div><div class="stat-label">Active Jobs</div></div>
            <div class="stat-card"><div class="stat-value"><%= allApps.size() %></div><div class="stat-label">Total Applications</div></div>
            <div class="stat-card"><div class="stat-value"><%= allUsers.size() %></div><div class="stat-label">Total Users</div></div>
        </div>
        
        <div class="tabs">
            <div class="tab-buttons">
                <button class="tab-btn active" onclick="switchTab('users')">Users</button>
                <button class="tab-btn" onclick="switchTab('jobs')">Jobs</button>
                <button class="tab-btn" onclick="switchTab('apps')">Applications</button>
            </div>
            
            <div id="users" class="tab-content active">
                <h2 style="margin-bottom: 1rem;">All Users</h2>
                <table>
                    <thead>
                        <tr><th>Name</th><th>Email</th><th>Role</th></tr>
                    </thead>
                    <tbody>
                        <% for (String[] user : allUsers) { %>
                            <tr>
                                <td><%= user[3] %></td>
                                <td><%= user[0] %></td>
                                <td><span class="badge"><%= user[2] %></span></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
            
            <div id="jobs" class="tab-content">
                <h2 style="margin-bottom: 1rem;">All Jobs</h2>
                <% for (String[] job : allJobs) { %>
                    <div class="card">
                        <div class="title"><%= job[1] %></div>
                        <div class="meta"><%= job[2] %> - <%= job[3] %> | <%= job[4] %></div>
                        <p style="margin: 0.5rem 0; color: #666;"><%= job[6] %></p>
                        <div style="margin: 0.5rem 0;">
                            <% for (String skill : job[7].split(",")) { %>
                                <span class="badge"><%= skill.trim() %></span>
                            <% } %>
                        </div>
                        <div class="meta">⏰ <%= job[8] %>h/week | 📅 <%= job[9] %> | Status: <%= job[10] %></div>
                    </div>
                <% } %>
            </div>
            
            <div id="apps" class="tab-content">
                <h2 style="margin-bottom: 1rem;">All Applications</h2>
                <table>
                    <thead>
                        <tr><th>Student</th><th>Job ID</th><th>Status</th><th>Date</th></tr>
                    </thead>
                    <tbody>
                        <% for (String[] app : allApps) { %>
                            <tr>
                                <td><%= app[3] %></td>
                                <td><%= app[1] %></td>
                                <td><span class="badge"><%= app[5] %></span></td>
                                <td><%= app[6] %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    
    <script>
        function switchTab(tab) {
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            event.target.classList.add('active');
            document.getElementById(tab).classList.add('active');
        }
    </script>
</body>
</html>
```

---

## 创建后测试

1. 用MO账号登录：dr.smith@bupt.edu.cn / 123456
2. 用Admin账号登录：admin@bupt.edu.cn / 123456
3. 测试创建职位、审核申请等功能

完成后V3版本就100%完成了！
