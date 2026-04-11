<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
        <div class="alert">
            <span class="alert-icon">⚠️</span>
            <div class="alert-content">
                <strong>3 workload alerts</strong> requiring attention. Check the workload balancing tab for details.
            </div>
        </div>

        <!-- Stats Cards -->
        <div class="stats-grid">
            <div class="card">
                <div class="card-header">
                    <span class="card-title">Total Students</span>
                    <span class="card-icon">👥</span>
                </div>
                <div class="card-value">4</div>
                <p class="card-description">Registered TAs</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Active Jobs</span>
                    <span class="card-icon">💼</span>
                </div>
                <div class="card-value">4</div>
                <p class="card-description">Open positions</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Applications</span>
                    <span class="card-icon">📈</span>
                </div>
                <div class="card-value">6</div>
                <p class="card-description">Total submitted</p>
            </div>

            <div class="card">
                <div class="card-header">
                    <span class="card-title">Critical Alerts</span>
                    <span class="card-icon">⚠️</span>
                </div>
                <div class="card-value">1</div>
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
                        <div class="bar-item">
                            <div class="bar-label">Alice</div>
                            <div class="bar-container">
                                <div class="bar-fill bar-yellow" style="width: 60%;">12h / 20h (60%)</div>
                            </div>
                        </div>
                        <div class="bar-item">
                            <div class="bar-label">Bob</div>
                            <div class="bar-container">
                                <div class="bar-fill bar-red" style="width: 100%;">15h / 15h (100%)</div>
                            </div>
                        </div>
                        <div class="bar-item">
                            <div class="bar-label">Carol</div>
                            <div class="bar-container">
                                <div class="bar-fill bar-green" style="width: 40%;">8h / 20h (40%)</div>
                            </div>
                        </div>
                        <div class="bar-item">
                            <div class="bar-label">David</div>
                            <div class="bar-container">
                                <div class="bar-fill bar-red" style="width: 100%;">18h / 18h (100%)</div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">Recent Activity</h2>
                    <div style="display: flex; flex-direction: column; gap: 0.75rem;">
                        <div style="padding: 0.75rem; background: #f9fafb; border-radius: 6px; font-size: 0.875rem;">
                            <span style="color: #6b7280;">2026-03-16:</span> Alice Chen applied for Machine Learning Lab Assistant
                        </div>
                        <div style="padding: 0.75rem; background: #f9fafb; border-radius: 6px; font-size: 0.875rem;">
                            <span style="color: #6b7280;">2026-03-15:</span> Dr. Smith posted new job: Machine Learning Lab Assistant
                        </div>
                        <div style="padding: 0.75rem; background: #f9fafb; border-radius: 6px; font-size: 0.875rem;">
                            <span style="color: #6b7280;">2026-03-15:</span> Carol Li accepted for Data Structures TA
                        </div>
                    </div>
                </div>
            </div>

            <!-- Workload Balancing Tab -->
            <div id="workload" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">Workload Alerts</h2>
                    
                    <div class="student-card" style="border-left: 4px solid #ef4444;">
                        <div class="student-header">
                            <div>
                                <div class="student-name">Bob Wang</div>
                                <div class="student-email">bob.wang@bupt.edu.cn</div>
                            </div>
                            <span class="alert-badge alert-critical">Critical</span>
                        </div>
                        <div class="workload-info">
                            Current: 15h / Max: 15h (100% utilization)
                        </div>
                        <p style="font-size: 0.875rem; color: #6b7280; margin-top: 0.5rem;">
                            Student has reached maximum workload capacity. Cannot accept additional assignments.
                        </p>
                    </div>

                    <div class="student-card" style="border-left: 4px solid #f59e0b;">
                        <div class="student-header">
                            <div>
                                <div class="student-name">David Zhang</div>
                                <div class="student-email">david.zhang@bupt.edu.cn</div>
                            </div>
                            <span class="alert-badge alert-warning">Warning</span>
                        </div>
                        <div class="workload-info">
                            Current: 18h / Max: 18h (100% utilization)
                        </div>
                        <p style="font-size: 0.875rem; color: #6b7280; margin-top: 0.5rem;">
                            Student has reached maximum workload capacity. Cannot accept additional assignments.
                        </p>
                    </div>

                    <div class="student-card" style="border-left: 4px solid #f59e0b;">
                        <div class="student-header">
                            <div>
                                <div class="student-name">Alice Chen</div>
                                <div class="student-email">alice.chen@bupt.edu.cn</div>
                            </div>
                            <span class="alert-badge alert-warning">Warning</span>
                        </div>
                        <div class="workload-info">
                            Current: 12h / Max: 20h (60% utilization)
                        </div>
                        <p style="font-size: 0.875rem; color: #6b7280; margin-top: 0.5rem;">
                            Pending application for 8h/week position would bring total to 20h (100% capacity).
                        </p>
                    </div>
                </div>
            </div>

            <!-- Student Management Tab -->
            <div id="students" class="tab-content">
                <div class="card">
                    <h2 style="font-size: 1.125rem; font-weight: 600; margin-bottom: 1rem;">All Students</h2>
                    <div class="student-list">
                        <div class="student-card">
                            <div class="student-header">
                                <div>
                                    <div class="student-name">Alice Chen</div>
                                    <div class="student-email">alice.chen@bupt.edu.cn</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600; color: #2563eb;">12h / 20h</div>
                                    <div style="font-size: 0.75rem; color: #6b7280;">60% utilized</div>
                                </div>
                            </div>
                            <div>
                                <span class="badge">Python</span>
                                <span class="badge">JavaScript</span>
                                <span class="badge">Machine Learning</span>
                                <span class="badge">Data Analysis</span>
                            </div>
                        </div>

                        <div class="student-card">
                            <div class="student-header">
                                <div>
                                    <div class="student-name">Bob Wang</div>
                                    <div class="student-email">bob.wang@bupt.edu.cn</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600; color: #ef4444;">15h / 15h</div>
                                    <div style="font-size: 0.75rem; color: #6b7280;">100% utilized</div>
                                </div>
                            </div>
                            <div>
                                <span class="badge">Java</span>
                                <span class="badge">Web Development</span>
                                <span class="badge">React</span>
                                <span class="badge">Node.js</span>
                            </div>
                        </div>

                        <div class="student-card">
                            <div class="student-header">
                                <div>
                                    <div class="student-name">Carol Li</div>
                                    <div class="student-email">carol.li@bupt.edu.cn</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600; color: #10b981;">8h / 20h</div>
                                    <div style="font-size: 0.75rem; color: #6b7280;">40% utilized</div>
                                </div>
                            </div>
                            <div>
                                <span class="badge">C++</span>
                                <span class="badge">Data Structures</span>
                                <span class="badge">Algorithms</span>
                                <span class="badge">Teaching</span>
                            </div>
                        </div>

                        <div class="student-card">
                            <div class="student-header">
                                <div>
                                    <div class="student-name">David Zhang</div>
                                    <div class="student-email">david.zhang@bupt.edu.cn</div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-weight: 600; color: #ef4444;">18h / 18h</div>
                                    <div style="font-size: 0.75rem; color: #6b7280;">100% utilized</div>
                                </div>
                            </div>
                            <div>
                                <span class="badge">Python</span>
                                <span class="badge">Statistics</span>
                                <span class="badge">Research</span>
                                <span class="badge">MATLAB</span>
                            </div>
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
