<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
            margin-top: 1rem;
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
                <p>Welcome, Alice Chen</p>
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
                <div class="card-value">12h / 20h</div>
                <div class="progress-bar">
                    <div class="progress-fill" style="width: 60%"></div>
                </div>
                <p class="card-description">8h available</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Active Applications</span>
                    <span class="card-icon">📄</span>
                </div>
                <div class="card-value">3</div>
                <p class="card-description">2 pending review</p>
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

        <!-- Quick Actions -->
        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 2rem;">
            <a href="<%= request.getContextPath() %>/student-jobs.jsp" style="text-decoration: none;">
                <div class="card" style="cursor: pointer; transition: transform 0.15s;">
                    <div style="text-align: center;">
                        <div style="font-size: 2rem; margin-bottom: 0.5rem;">📋</div>
                        <div style="font-weight: 600; color: #111827;">Browse Jobs</div>
                        <div style="font-size: 0.75rem; color: #6b7280; margin-top: 0.25rem;">View available positions</div>
                    </div>
                </div>
            </a>
            <a href="<%= request.getContextPath() %>/student-applications.jsp" style="text-decoration: none;">
                <div class="card" style="cursor: pointer; transition: transform 0.15s;">
                    <div style="text-align: center;">
                        <div style="font-size: 2rem; margin-bottom: 0.5rem;">📄</div>
                        <div style="font-weight: 600; color: #111827;">My Applications</div>
                        <div style="font-size: 0.75rem; color: #6b7280; margin-top: 0.25rem;">Track application status</div>
                    </div>
                </div>
            </a>
            <a href="<%= request.getContextPath() %>/student-profile.jsp" style="text-decoration: none;">
                <div class="card" style="cursor: pointer; transition: transform 0.15s;">
                    <div style="text-align: center;">
                        <div style="font-size: 2rem; margin-bottom: 0.5rem;">👤</div>
                        <div style="font-weight: 600; color: #111827;">Profile & CV</div>
                        <div style="font-size: 0.75rem; color: #6b7280; margin-top: 0.25rem;">Update your profile</div>
                    </div>
                </div>
            </a>
        </div>

        <!-- Tabs -->
        <div class="tabs">
            <div class="tab-list">
                <button class="tab-button active" onclick="switchTab('browse')">Recent Jobs</button>
                <button class="tab-button" onclick="switchTab('applications')">Recent Applications</button>
                <button class="tab-button" onclick="switchTab('profile')">Profile Summary</button>
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

                    <div class="job-card">
                        <div class="job-header">
                            <div style="flex: 1;">
                                <h3 class="job-title">
                                    Machine Learning Lab Assistant
                                    <span class="top-match-badge">✨ Top Match</span>
                                </h3>
                                <p class="job-subtitle">CS401 - Introduction to Machine Learning | Dr. Smith</p>
                            </div>
                            <div class="match-score">
                                <div class="match-score-value">71%</div>
                                <p class="match-score-label">Match Score</p>
                            </div>
                        </div>
                        <p class="job-description">
                            Assist students with ML lab exercises, help debug Python code, and support with assignment grading.
                        </p>
                        <div>
                            <span class="badge">Python</span>
                            <span class="badge">Machine Learning</span>
                            <span class="badge">Teaching</span>
                        </div>
                        <div class="job-details">
                            <span>⏰ 8h/week</span>
                            <span>📅 12 weeks</span>
                            <span>📌 Posted: 2026-03-15</span>
                        </div>
                        <button class="btn-apply">Apply Now</button>
                    </div>

                    <div class="job-card">
                        <div class="job-header">
                            <div style="flex: 1;">
                                <h3 class="job-title">Web Development Tutor</h3>
                                <p class="job-subtitle">CS302 - Web Technologies | Prof. Johnson</p>
                            </div>
                            <div class="match-score">
                                <div class="match-score-value">39%</div>
                                <p class="match-score-label">Match Score</p>
                            </div>
                        </div>
                        <p class="job-description">
                            Support students with React and Node.js projects, conduct tutorial sessions.
                        </p>
                        <div>
                            <span class="badge">JavaScript</span>
                            <span class="badge">React</span>
                            <span class="badge">Web Development</span>
                        </div>
                        <div class="job-details">
                            <span>⏰ 10h/week</span>
                            <span>📅 16 weeks</span>
                            <span>📌 Posted: 2026-03-14</span>
                        </div>
                        <button class="btn-apply">Apply Now</button>
                    </div>

                    <div class="job-card">
                        <div class="job-header">
                            <div style="flex: 1;">
                                <h3 class="job-title">Data Structures TA</h3>
                                <p class="job-subtitle">CS201 - Data Structures & Algorithms | Dr. Brown</p>
                            </div>
                            <div class="match-score">
                                <div class="match-score-value">39%</div>
                                <p class="match-score-label">Match Score</p>
                            </div>
                        </div>
                        <p class="job-description">
                            Help students understand complex algorithms, grade assignments, and hold office hours.
                        </p>
                        <div>
                            <span class="badge">C++</span>
                            <span class="badge">Data Structures</span>
                            <span class="badge">Algorithms</span>
                        </div>
                        <div class="job-details">
                            <span>⏰ 12h/week</span>
                            <span>📅 14 weeks</span>
                            <span>📌 Posted: 2026-03-13</span>
                        </div>
                        <button class="btn-apply">Apply Now</button>
                    </div>
                </div>
            </div>

            <!-- My Applications Tab -->
            <div id="applications" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">My Applications</h2>
                    
                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <div>
                                <h3 class="job-title">Machine Learning Lab Assistant</h3>
                                <p class="job-subtitle">CS401 - Introduction to Machine Learning</p>
                                <div class="job-details" style="margin-top: 0.5rem;">
                                    <span>Applied: 2026-03-16</span>
                                </div>
                            </div>
                            <span class="badge" style="background: #fef3c7; color: #92400e;">⏰ Pending</span>
                        </div>
                    </div>

                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <div>
                                <h3 class="job-title">Web Development Tutor</h3>
                                <p class="job-subtitle">CS302 - Web Technologies</p>
                                <div class="job-details" style="margin-top: 0.5rem;">
                                    <span>Applied: 2026-03-15</span>
                                </div>
                            </div>
                            <span class="badge" style="background: #dcfce7; color: #166534;">✓ Accepted</span>
                        </div>
                    </div>

                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start;">
                            <div>
                                <h3 class="job-title">Statistics Lab Assistant</h3>
                                <p class="job-subtitle">MATH305 - Applied Statistics</p>
                                <div class="job-details" style="margin-top: 0.5rem;">
                                    <span>Applied: 2026-03-14</span>
                                </div>
                            </div>
                            <span class="badge" style="background: #fef3c7; color: #92400e;">⏰ Pending</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Profile Tab -->
            <div id="profile" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.25rem; margin-bottom: 1.5rem;">Profile & CV</h2>
                    <div style="margin-bottom: 1.5rem;">
                        <h3 style="font-size: 1rem; margin-bottom: 0.5rem;">Personal Information</h3>
                        <p style="color: #6b7280; font-size: 0.875rem;">Name: Alice Chen</p>
                        <p style="color: #6b7280; font-size: 0.875rem;">Email: alice.chen@bupt.edu.cn</p>
                        <p style="color: #6b7280; font-size: 0.875rem;">Max Hours: 20h/week</p>
                    </div>
                    <div>
                        <h3 style="font-size: 1rem; margin-bottom: 0.5rem;">Skills</h3>
                        <span class="badge">Python</span>
                        <span class="badge">JavaScript</span>
                        <span class="badge">Machine Learning</span>
                        <span class="badge">Data Analysis</span>
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
