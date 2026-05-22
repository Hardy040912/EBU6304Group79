<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.Properties" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    if (userEmail == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    DataFileUtil.initDataDir(application.getRealPath("/"));
    Properties resume = DataFileUtil.loadResume(userEmail);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Standard Resume Profile - TA Recruitment System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css">
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
        }
        .form-group { margin-bottom: 1rem; }
        label { display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem; }
        input[type="text"], input[type="email"], input[type="tel"], textarea, select {
            width: 100%;
            padding: 0.75rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 0.875rem;
            font-family: inherit;
            background: white;
        }
        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .readonly-input { background: #f9fafb !important; color: #4b5563; }
        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
        }
        .btn-submit {
            padding: 0.75rem 1.5rem;
            background: #2563eb;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 0.875rem;
            font-weight: 500;
            cursor: pointer;
        }
        .btn-submit:hover { background: #1d4ed8; }
        .success-message {
            background: #dcfce7;
            color: #166534;
            padding: 1rem;
            border-radius: 6px;
            margin-bottom: 1rem;
            text-align: center;
        }

        .template-box {
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            padding: 1.5rem;
            font-family: monospace;
            font-size: 0.8rem;
            color: #475569;
            white-space: pre-wrap;
            line-height: 1.7;
            margin-bottom: 1.5rem;
        }

        .section-title {
            font-size: 1.1rem;
            font-weight: 600;
            color: #111827;
            margin: 2rem 0 1rem;
            padding-bottom: 0.5rem;
            border-bottom: 2px solid #e5e7eb;
        }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Standard Resume Profile</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/student-dashboard.jsp" class="btn">← Dashboard</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <div class="container">
        <% if ("1".equals(request.getParameter("success"))) { %>
        <div class="success-message">✓ Your standard resume has been saved. It will be attached when you apply for positions.</div>
        <% } %>
        <% if ("2".equals(request.getParameter("success"))) { %>
        <div class="success-message">✓ Resume saved successfully!</div>
        <% } %>

        <div class="page-intro">
            <h2>Your account profile (standard CV)</h2>
            <p>This is saved once on your account, like a profile on Apple Jobs. When you apply for a position, organisers see this profile plus a separate cover letter you write for that job only.</p>
        </div>

        <form id="profileForm" action="<%= request.getContextPath() %>/uploadResume" method="post">
            <div class="layout-two-col has-preview">
                <div class="card">
                    <!-- Section 1 -->
                    <div class="template-section">
                        <div class="template-section-header">
                            <span class="section-number">1</span>
                            <div>
                                <h3>Contact &amp; education</h3>
                                <p>Name and email come from your account. Add the details recruiters expect at the top of a CV.</p>
                            </div>
                        </div>
                        <div class="form-grid">
                            <div class="form-group">
                                <label for="name">Full name</label>
                                <input type="text" id="name" value="<%= userName %>" readonly class="readonly-input">
                            </div>
                            <div class="form-group">
                                <label for="email">Email</label>
                                <input type="email" id="email" value="<%= userEmail %>" readonly class="readonly-input">
                            </div>
                            <div class="form-group">
                                <label for="phone" class="label-required">Phone</label>
                                <input type="tel" id="phone" name="phone" placeholder="+86 138 0000 0000" value="<%= resume.getProperty("phone","") %>">
                            </div>
                            <div class="form-group">
                                <label for="major" class="label-required">Major / programme</label>
                                <input type="text" id="major" name="major" placeholder="e.g. Computer Science and Technology" value="<%= resume.getProperty("major","") %>">
                            </div>
                            <div class="form-group">
                                <label for="grade" class="label-required">Year of study</label>
                                <select id="grade" name="year">
                                    <option value="">Select year</option>
                                    <option value="Year 1" <%= "Year 1".equals(resume.getProperty("year","")) ? "selected" : "" %>>Year 1</option>
                                    <option value="Year 2" <%= "Year 2".equals(resume.getProperty("year","")) ? "selected" : "" %>>Year 2</option>
                                    <option value="Year 3" <%= "Year 3".equals(resume.getProperty("year","")) ? "selected" : "" %>>Year 3</option>
                                    <option value="Year 4" <%= "Year 4".equals(resume.getProperty("year","")) ? "selected" : "" %>>Year 4</option>
                                    <option value="Postgraduate" <%= "Postgraduate".equals(resume.getProperty("year","")) ? "selected" : "" %>>Postgraduate</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label for="gpa">GPA / average score</label>
                                <input type="text" id="gpa" name="gpa" placeholder="e.g. 3.8 / 4.0 or 88/100" value="<%= resume.getProperty("gpa","") %>">
                            </div>
                            <div class="form-group" style="grid-column: 1 / -1;">
                                <label for="portfolio">LinkedIn / portfolio (optional)</label>
                                <input type="text" id="portfolio" name="portfolio" placeholder="https://linkedin.com/in/yourname" value="<%= resume.getProperty("portfolio","") %>">
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="education" class="label-required">Education</label>
                            <textarea id="education" name="education" class="template-area"
                                placeholder="BUPT International School | BEng Computer Science&#10;Expected graduation: June 2027&#10;Relevant coursework: Data Structures, Machine Learning, Software Engineering"><%= resume.getProperty("education","") %></textarea>
                            <p class="field-hint">One entry per school. Include degree, dates, and 2–3 relevant courses.</p>
                            <button type="button" class="btn-secondary" data-template="education">Insert example structure</button>
                        </div>
                    </div>

                    <!-- Section 2 -->
                    <div class="template-section">
                        <div class="template-section-header">
                            <span class="section-number">2</span>
                            <div>
                                <h3>Skills</h3>
                                <p>List technical and language skills that match TA roles (programming, tools, communication).</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="technicalSkills" class="label-required">Technical skills</label>
                            <input type="text" id="technicalSkills" name="technicalSkills" value="<%= resume.getProperty("technicalSkills","") %>"
                                   placeholder="e.g. Python, Java, SQL, Git, LaTeX, MATLAB">
                            <p class="field-example">Separate items with commas.</p>
                        </div>
                        <div class="form-group">
                            <label for="languageSkills" class="label-required">Language skills</label>
                            <input type="text" id="languageSkills" name="languageSkills" value="<%= resume.getProperty("languageSkills","") %>"
                                   placeholder="e.g. English (fluent), Chinese (native), IELTS 7.0">
                        </div>
                        <div class="form-group">
                            <label for="certifications">Awards &amp; certificates</label>
                            <textarea id="certifications" name="certifications" class="template-area"
                                placeholder="• Dean's List, 2024–2025&#10;• CET-6 / IELTS certificate&#10;• Programming competition award"><%= resume.getProperty("certifications","") %></textarea>
                            <button type="button" class="btn-secondary" data-template="certifications">Insert example structure</button>
                        </div>
                    </div>

                    <!-- Section 3 -->
                    <div class="template-section">
                        <div class="template-section-header">
                            <span class="section-number">3</span>
                            <div>
                                <h3>Experience</h3>
                                <p>Use bullet points (•) with action verbs: taught, assisted, graded, mentored.</p>
                            </div>
                        </div>
                        <div class="form-group">
                            <label for="teachingExperience" class="label-required">Teaching / tutoring experience</label>
                            <textarea id="teachingExperience" name="teachingExp" class="template-area template-area-lg"
                                placeholder="Course TA | Introduction to Programming (CS101) | Sep 2024 – Jan 2025&#10;• Assisted weekly labs for 60 students&#10;• Graded assignments and held office hours (2h/week)"><%= resume.getProperty("teachingExp","") %></textarea>
                            <button type="button" class="btn-secondary" data-template="teaching">Insert example structure</button>
                        </div>
                        <div class="form-group">
                            <label for="projectExperience">Project / research experience</label>
                            <textarea id="projectExperience" name="projectExp" class="template-area template-area-lg"
                                placeholder="ML Course Project | Team lead | Mar 2025&#10;• Built classification pipeline in Python (scikit-learn)&#10;• Presented results to faculty panel"><%= resume.getProperty("projectExp","") %></textarea>
                            <button type="button" class="btn-secondary" data-template="projects">Insert example structure</button>
                        </div>
                        <div class="form-group">
                            <label for="selfIntroduction" class="label-required">Summary for TA roles</label>
                            <textarea id="selfIntroduction" name="personalStatement" class="template-area"
                                placeholder="2–4 sentences: your strengths as a TA, subjects you can support, and how you help students learn."><%= resume.getProperty("personalStatement","") %></textarea>
                            <p class="field-hint">This short summary appears at the end of your saved resume.</p>
                        </div>
                    </div>

                    <div class="form-actions">
                        <button type="submit" class="btn-submit">💾 Save Resume</button>
                        <span class="save-hint">Saved resume is used automatically when you apply for jobs.</span>
                    </div>
                </div>

                <aside class="preview-panel">
                    <div class="preview-panel-header">
                        <h3>Live preview</h3>
                        <p>How organisers will see your standard resume</p>
                    </div>
                    <div id="resumePreview" class="preview-document"></div>
                </aside>
            </div>
        </form>
    </div>

    <script src="<%= request.getContextPath() %>/js/resume-forms.js"></script>
    <script>
        (function () {
            var RF = window.TaResumeForms;
            var userName = '<%= userName.replace("'", "\\'") %>';
            var userEmail = '<%= userEmail.replace("'", "\\'") %>';

            var templates = {
                education: "BUPT International School | BEng [Your Major]\nExpected graduation: [Month Year]\nRelevant coursework: [Course 1], [Course 2], [Course 3]",
                certifications: "• [Scholarship or Dean's List, year]\n• [Certificate, e.g. CET-6 / IELTS]\n• [Competition or honour]",
                teaching: "[Role] | [Course name] ([Module code]) | [Start – End]\n• [What you did — labs, grading, office hours]\n• [Outcome or class size]",
                projects: "[Project title] | [Your role] | [Date]\n• [What you built or researched]\n• [Tools / methods used]"
            };

            function readFields() {
                return {
                    phone: document.getElementById('phone').value,
                    major: document.getElementById('major').value,
                    grade: document.getElementById('grade').value,
                    gpa: document.getElementById('gpa').value,
                    portfolio: document.getElementById('portfolio').value,
                    education: document.getElementById('education').value,
                    teaching: document.getElementById('teachingExperience').value,
                    projects: document.getElementById('projectExperience').value,
                    awards: document.getElementById('certifications').value,
                    summary: document.getElementById('selfIntroduction').value
                };
            }

            function readSkills() {
                return {
                    tech: document.getElementById('technicalSkills').value,
                    lang: document.getElementById('languageSkills').value
                };
            }

            function updatePreview() {
                var fields = readFields();
                var skills = readSkills();
                document.getElementById('resumePreview').innerHTML =
                    RF.buildResumePreviewHtml(userName, userEmail, fields, skills);
            }

            document.querySelectorAll('[data-template]').forEach(function (btn) {
                btn.addEventListener('click', function () {
                    var key = btn.getAttribute('data-template');
                    var map = {
                        education: 'education',
                        certifications: 'certifications',
                        teaching: 'teachingExperience',
                        projects: 'projectExperience'
                    };
                    var el = document.getElementById(map[key]);
                    if (el && !el.value.trim()) {
                        el.value = templates[key];
                        updatePreview();
                    }
                });
            });

            document.getElementById('profileForm').addEventListener('input', updatePreview);
            document.getElementById('profileForm').addEventListener('change', updatePreview);

            updatePreview();
        })();
    </script>
</body>
</html>
