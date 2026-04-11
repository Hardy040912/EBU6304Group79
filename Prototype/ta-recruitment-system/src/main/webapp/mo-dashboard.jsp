<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <p>Dr. Smith</p>
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
                <div class="card-value">2</div>
                <p class="card-description">0 closed positions</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Pending Applications</span>
                    <span class="card-icon">👥</span>
                </div>
                <div class="card-value">2</div>
                <p class="card-description">Awaiting your review</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Accepted TAs</span>
                    <span class="card-icon">✓</span>
                </div>
                <div class="card-value">1</div>
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
                <button class="btn-create">
                    <span>+</span> Create New Job Post
                </button>

                <div class="card">
                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                            <div>
                                <h3 class="job-title">Machine Learning Lab Assistant</h3>
                                <p class="job-subtitle">CS401 - Introduction to Machine Learning</p>
                            </div>
                            <span class="badge-status badge-open">Open</span>
                        </div>
                        <p style="color: #4b5563; font-size: 0.875rem; margin-bottom: 1rem;">
                            Assist students with ML lab exercises, help debug Python code, and support with assignment grading.
                        </p>
                        <div style="margin-bottom: 1rem;">
                            <span class="badge">Python</span>
                            <span class="badge">Machine Learning</span>
                            <span class="badge">Teaching</span>
                        </div>
                        <div style="display: flex; gap: 1.5rem; font-size: 0.875rem; color: #6b7280;">
                            <span>⏰ 8h/week</span>
                            <span>📅 12 weeks</span>
                            <span>📊 2 applicants</span>
                        </div>
                    </div>

                    <div class="job-card">
                        <div style="display: flex; justify-content: space-between; align-items: start; margin-bottom: 1rem;">
                            <div>
                                <h3 class="job-title">Data Structures TA</h3>
                                <p class="job-subtitle">CS201 - Data Structures & Algorithms</p>
                            </div>
                            <span class="badge-status badge-open">Open</span>
                        </div>
                        <p style="color: #4b5563; font-size: 0.875rem; margin-bottom: 1rem;">
                            Help students understand complex algorithms, grade assignments, and hold office hours.
                        </p>
                        <div style="margin-bottom: 1rem;">
                            <span class="badge">C++</span>
                            <span class="badge">Data Structures</span>
                            <span class="badge">Algorithms</span>
                        </div>
                        <div style="display: flex; gap: 1.5rem; font-size: 0.875rem; color: #6b7280;">
                            <span>⏰ 12h/week</span>
                            <span>📅 14 weeks</span>
                            <span>📊 1 applicant</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Applications Tab -->
            <div id="applications" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.25rem; margin-bottom: 1rem;">Applications for Machine Learning Lab Assistant</h2>
                    
                    <div class="applicant-card">
                        <div class="applicant-header">
                            <div>
                                <div class="applicant-name">Alice Chen</div>
                                <div class="applicant-email">alice.chen@bupt.edu.cn</div>
                            </div>
                            <div class="match-score">
                                <div class="match-score-value">71%</div>
                                <div class="match-score-label">Match</div>
                            </div>
                        </div>
                        <div style="margin: 0.75rem 0;">
                            <span class="badge">Python</span>
                            <span class="badge">JavaScript</span>
                            <span class="badge">Machine Learning</span>
                            <span class="badge">Data Analysis</span>
                        </div>
                        <div style="font-size: 0.875rem; color: #6b7280; margin-bottom: 0.5rem;">
                            Current workload: 12h/20h | Available: 8h
                        </div>
                        <div class="btn-group">
                            <button class="btn-accept">✓ Accept</button>
                            <button class="btn-reject">✗ Reject</button>
                        </div>
                    </div>

                    <div class="applicant-card">
                        <div class="applicant-header">
                            <div>
                                <div class="applicant-name">David Zhang</div>
                                <div class="applicant-email">david.zhang@bupt.edu.cn</div>
                            </div>
                            <div class="match-score">
                                <div class="match-score-value">39%</div>
                                <div class="match-score-label">Match</div>
                            </div>
                        </div>
                        <div style="margin: 0.75rem 0;">
                            <span class="badge">Python</span>
                            <span class="badge">Statistics</span>
                            <span class="badge">Research</span>
                            <span class="badge">MATLAB</span>
                        </div>
                        <div style="font-size: 0.875rem; color: #6b7280; margin-bottom: 0.5rem;">
                            Current workload: 18h/18h | Available: 0h
                        </div>
                        <div class="btn-group">
                            <button class="btn-accept">✓ Accept</button>
                            <button class="btn-reject">✗ Reject</button>
                        </div>
                    </div>

                    <h2 style="font-size: 1.25rem; margin: 2rem 0 1rem;">Applications for Data Structures TA</h2>
                    
                    <div class="applicant-card">
                        <div class="applicant-header">
                            <div>
                                <div class="applicant-name">Carol Li</div>
                                <div class="applicant-email">carol.li@bupt.edu.cn</div>
                            </div>
                            <div class="match-score">
                                <div class="match-score-value">100%</div>
                                <div class="match-score-label">Match</div>
                            </div>
                        </div>
                        <div style="margin: 0.75rem 0;">
                            <span class="badge">C++</span>
                            <span class="badge">Data Structures</span>
                            <span class="badge">Algorithms</span>
                            <span class="badge">Teaching</span>
                        </div>
                        <div style="font-size: 0.875rem; color: #6b7280; margin-bottom: 0.5rem;">
                            Current workload: 8h/20h | Available: 12h
                        </div>
                        <div style="margin-top: 0.75rem;">
                            <span class="badge-status badge-accepted">✓ Accepted</span>
                        </div>
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
