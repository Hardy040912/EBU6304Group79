<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.bupt.ta.util.DataFileUtil" %>
<%@ page import="java.util.List" %>
<%
    String userEmail = (String) session.getAttribute("userEmail");
    String userName = (String) session.getAttribute("userName");
    String jobId = request.getParameter("jobId");

    if (userEmail == null || jobId == null) {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
        return;
    }

    DataFileUtil.initDataDir(application.getRealPath("/"));

    List<String> applications = DataFileUtil.readLines("applications.txt");
    boolean alreadyApplied = false;
    String existingStatus = "";
    boolean isBlocked = false;

    for (String line : applications) {
        String[] parts = line.split("\\|");
        if (parts.length >= 7 && parts[1].equals(jobId) && parts[2].equals(userEmail)) {
            existingStatus = parts[5];
            if (parts.length >= 8 && "true".equals(parts[7])) {
                isBlocked = true;
                alreadyApplied = true;
                break;
            }
            if ("pending".equals(existingStatus) || "accepted".equals(existingStatus)) {
                alreadyApplied = true;
                break;
            }
        }
    }

    List<String> jobs = DataFileUtil.readLines("jobs.txt");
    String jobTitle = "";
    String moduleCode = "";
    String moduleName = "";
    String organiser = "";
    String description = "";
    String skills = "";
    String hoursPerWeek = "";
    String duration = "";

    String userSkills = (String) session.getAttribute("userSkills");
    String userExperience = (String) session.getAttribute("userExperience");
    if (userSkills == null) userSkills = "";
    if (userExperience == null) userExperience = "";
    boolean profileIncomplete = userSkills.trim().isEmpty() && userExperience.trim().isEmpty();

    for (String line : jobs) {
        String[] parts = line.split("\\|");
        if (parts.length >= 11 && parts[0].equals(jobId)) {
            jobTitle = parts[1];
            moduleCode = parts[2];
            moduleName = parts[3];
            organiser = parts[4];
            description = parts[6];
            skills = parts[7];
            hoursPerWeek = parts[8];
            duration = parts[9];
            break;
        }
    }

    String escJobTitle = jobTitle.replace("&", "&amp;").replace("<", "&lt;").replace("\"", "&quot;");
    String escModuleCode = moduleCode.replace("&", "&amp;").replace("<", "&lt;");
    String escModuleName = moduleName.replace("&", "&amp;").replace("<", "&lt;");
    String escOrganiser = organiser.replace("&", "&amp;").replace("<", "&lt;");
    String greetingName = organiser.trim().isEmpty() ? "Hiring Committee" : organiser;
    String escGreetingName = greetingName.replace("&", "&amp;").replace("\"", "&quot;");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Apply for Job - TA Recruitment System</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/resume-forms.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
            background-color: #f9fafb;
            min-height: 100vh;
        }
        .header { background: white; border-bottom: 1px solid #e5e7eb; padding: 1rem 0; }
        .header-content {
            max-width: 80rem; margin: 0 auto; padding: 0 2rem;
            display: flex; justify-content: space-between; align-items: center;
        }
        .header-title h1 { font-size: 1.5rem; color: #111827; margin-bottom: 0.25rem; }
        .header-title p { font-size: 0.875rem; color: #6b7280; }
        .header-nav { display: flex; gap: 1rem; align-items: center; }
        .btn {
            padding: 0.5rem 1rem; background: white; border: 1px solid #d1d5db;
            border-radius: 6px; color: #374151; font-size: 0.875rem; text-decoration: none;
        }
        .btn:hover { background: #f9fafb; }
        .container { max-width: 52rem; margin: 0 auto; padding: 2rem; }
        .card {
            background: white; border-radius: 8px;
            box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); padding: 2rem;
        }
        .job-info {
            background: #f8fafc; border: 1px solid #e2e8f0;
            border-radius: 8px; padding: 1.5rem; margin-bottom: 1.5rem;
        }
        .job-title { font-size: 1.25rem; font-weight: 600; color: #111827; margin-bottom: 0.5rem; }
        .job-subtitle { font-size: 0.875rem; color: #6b7280; margin-bottom: 1rem; }
        .badge {
            display: inline-block; padding: 0.25rem 0.5rem;
            background: #e0e7ff; color: #3730a3; border-radius: 4px;
            font-size: 0.75rem; margin-right: 0.25rem;
        }
        .form-group { margin-bottom: 1rem; }
        label { display: block; font-size: 0.875rem; font-weight: 500; color: #374151; margin-bottom: 0.5rem; }
        textarea, input[type="text"] {
            width: 100%; padding: 0.75rem; border: 1px solid #d1d5db;
            border-radius: 6px; font-size: 0.875rem; font-family: inherit;
        }
        textarea { resize: vertical; min-height: 5.5rem; line-height: 1.55; }
        textarea:focus, input:focus {
            outline: none; border-color: #2563eb;
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }
        .btn-submit {
            padding: 0.75rem 1.5rem; background: #2563eb; color: white;
            border: none; border-radius: 6px; font-size: 0.875rem; font-weight: 500; cursor: pointer;
        }
        .btn-submit:hover { background: #1d4ed8; }
        .warning-message {
            background: #fef3c7; color: #92400e; padding: 1rem; border-radius: 6px;
            margin-bottom: 1rem; text-align: center; border: 1px solid #fbbf24;
        }
        .info-message {
            background: #dbeafe; color: #1e40af; padding: 1rem; border-radius: 6px;
            margin-bottom: 1rem; text-align: center; border: 1px solid #60a5fa;
        }
        .section-heading {
            font-size: 1.125rem; font-weight: 600; color: #111827;
            margin: 1.5rem 0 0.75rem; padding-bottom: 0.5rem; border-bottom: 1px solid #e5e7eb;
        }
        .section-heading:first-of-type { margin-top: 0; }
    </style>
</head>
<body>
    <header class="header">
        <div class="header-content">
            <div class="header-title">
                <h1>Apply for position</h1>
                <p>Welcome, <%= userName %></p>
            </div>
            <div class="header-nav">
                <a href="<%= request.getContextPath() %>/student-jobs.jsp" class="btn">�?Back to Jobs</a>
                <a href="<%= request.getContextPath() %>/logout" class="btn">🚪 Logout</a>
            </div>
        </div>
    </header>

    <nav class="student-nav">
        <a href="<%= request.getContextPath() %>/student-dashboard.jsp">Home</a>
        <a href="<%= request.getContextPath() %>/student-jobs.jsp" class="active">Jobs</a>
        <a href="<%= request.getContextPath() %>/student-profile.jsp">My Profile</a>
        <a href="<%= request.getContextPath() %>/student-applications.jsp">Applications</a>
    </nav>

    <div class="container">
        <% if (alreadyApplied) { %>
        <div class="<%= "accepted".equals(existingStatus) ? "info-message" : "warning-message" %>">
            <% if ("accepted".equals(existingStatus)) { %>
                �?You have already been accepted for this position!
            <% } else if ("rejected".equals(existingStatus) && isBlocked) { %>
                🚫 You cannot apply for this position again.
            <% } else if ("rejected".equals(existingStatus)) { %>
                �?Your previous application was rejected. You may apply again.
            <% } else { %>
                �?Your application is pending review.
            <% } %>
            <br><a href="<%= request.getContextPath() %>/student-applications.jsp" style="color: inherit; text-decoration: underline;">View your applications</a>
        </div>
        <% } %>

        <div class="card">
            <div class="job-info">
                <h2 class="job-title"><%= escJobTitle %></h2>
                <p class="job-subtitle"><%= escModuleCode %> - <%= escModuleName %> | <%= escOrganiser %></p>
                <p style="color: #4b5563; font-size: 0.875rem; margin-bottom: 1rem;"><%= description.replace("<", "&lt;") %></p>
                <div style="margin-bottom: 0.5rem;">
                    <% if (skills != null && !skills.trim().isEmpty()) {
                        for (String skill : skills.split(",")) {
                            if (!skill.trim().isEmpty()) { %>
                    <span class="badge"><%= skill.trim() %></span>
                    <%      }
                        }
                    } %>
                </div>
                <p style="color: #6b7280; font-size: 0.875rem;">�?<%= hoursPerWeek %>h/week | 📅 <%= duration %></p>
            </div>

            <% if (!alreadyApplied) { %>

            <% if (profileIncomplete) { %>
            <div class="alert-banner">
                Your standard resume profile is empty.
                <a href="<%= request.getContextPath() %>/student-profile.jsp">Complete your resume first</a>
                so organisers receive structured information with your application.
            </div>
            <% } %>

            <form id="applyForm" action="<%= request.getContextPath() %>/applyJob" method="post">
                <input type="hidden" name="jobId" value="<%= jobId %>">
                <textarea id="bootSkills" class="hidden-submit-field"><%= userSkills %></textarea>
                <textarea id="bootExperience" class="hidden-submit-field"><%= userExperience %></textarea>
                <input type="hidden" id="bootEmail" value="<%= userEmail %>">

                <div class="apply-steps">
                    <div class="apply-step <%= profileIncomplete ? "" : "done" %>">
                        <strong>Step 1 · Account profile</strong>
                        <%= profileIncomplete ? "Complete in My Profile" : "Saved on your account" %>
                    </div>
                    <div class="apply-step active">
                        <strong>Step 2 · Cover letter</strong>
                        For this job only (auto-saved locally)
                    </div>
                </div>

                <div class="profile-snapshot-card">
                    <div class="snapshot-header">
                        <div>
                            <div style="font-weight: 600; color: #111827;">Your profile (attached)</div>
                            <p class="field-hint" style="margin: 0;">Account CV. <a href="<%= request.getContextPath() %>/student-profile.jsp">Edit profile</a></p>
                        </div>
                    </div>
                    <div id="resumePreviewBox" class="resume-readonly-box"></div>
                </div>

                <h3 class="section-heading">Cover letter for this position</h3>
                <p class="field-hint" style="margin-bottom: 0.5rem;">Reviewers see this separately from your profile.</p>
                <p id="autosaveStatus" class="autosave-status">Draft not saved yet</p>

                <!-- REMOVED_DUP
                <h3 class="section-heading REMOVE_START">Part 1 �?Your standard resume (from profile)</h3>
                <p class="field-hint" style="margin-bottom: 0.75rem;">
                    This is loaded from <strong>Profile &amp; CV</strong>. To update it,
                    <a href="<%= request.getContextPath() %>/student-profile.jsp">edit your profile</a> before submitting.
                </p>
                <div id="resumePreviewBox" class="resume-readonly-box"></div>

                <h3 class="section-heading">Part 2 �?Cover letter for this position</h3>
                <div class="page-intro" style="margin-bottom: 1.25rem;">
                    <h2>Structured cover letter template</h2>
                    <p>Fill in each paragraph (typical UK/US academic job letter). Aim for about 250�?00 words in total. Only the cover letter section is editable here; your resume is attached automatically.</p>
                </div> REMOVED_DUP -->

                <div class="cover-section">
                    <label for="coverGreeting">Salutation</label>
                    <input type="text" id="coverGreeting" name="coverGreeting"
                           value="Dear <%= escGreetingName %>,"
                           placeholder="Dear Dr. Smith,">
                </div>

                <div class="cover-section">
                    <label for="coverOpening" class="label-required">Opening �?state the role you are applying for</label>
                    <textarea id="coverOpening" class="template-area" required
                        placeholder="I am writing to apply for the [position] supporting [module] in [semester/year]."></textarea>
                    <p class="field-example">Mention <%= escJobTitle %> and <%= escModuleCode %> explicitly.</p>
                </div>

                <div class="cover-section">
                    <label for="coverInterest" class="label-required">Why you are interested</label>
                    <textarea id="coverInterest" class="template-area" required
                        placeholder="Explain your interest in this module and how the role fits your academic goals (2�? sentences)."></textarea>
                </div>

                <div class="cover-section">
                    <label for="coverQualifications" class="label-required">Relevant qualifications &amp; experience</label>
                    <textarea id="coverQualifications" class="template-area template-area-lg" required
                        placeholder="Highlight teaching/tutoring, technical skills, and coursework that match the job requirements. Use bullet points if helpful."></textarea>
                    <p class="field-hint">Refer to skills required: <%= skills.replace("<", "&lt;") %></p>
                </div>

                <div class="cover-section">
                    <label for="coverAvailability" class="label-required">Availability &amp; commitment</label>
                    <textarea id="coverAvailability" class="template-area" required
                        placeholder="Confirm you can meet the weekly hours (e.g. <%= hoursPerWeek %>h/week) and duration (<%= duration %>), and any scheduling constraints."></textarea>
                </div>

                <div class="cover-section">
                    <label for="coverClosing" class="label-required">Closing</label>
                    <textarea id="coverClosing" class="template-area" required
                        placeholder="Thank the reader and express willingness to discuss further."></textarea>
                    <p class="field-example">e.g. “Thank you for your consideration. I look forward to supporting students in this module.�?/p>
                </div>

                <p id="wordCount" class="word-count">0 words</p>

                <textarea id="coverLetter" name="coverLetter" class="hidden-submit-field"></textarea>

                <div class="form-actions" style="border-top: none; margin-top: 1rem;">
                    <button type="button" class="btn-secondary" id="fillCoverTemplate">Fill cover letter template</button>
                    <button type="submit" class="btn-submit">Submit application</button>
                </div>
            </form>
            <% } else if (isBlocked) { %>
            <div style="text-align: center; padding: 2rem;">
                <p style="color: #6b7280; margin-bottom: 1rem;">You are blocked from applying to this position again.</p>
                <a href="<%= request.getContextPath() %>/student-jobs.jsp" class="btn-submit" style="text-decoration: none; display: inline-block;">Browse other jobs</a>
            </div>
            <% } %>
        </div>
    </div>

    <script src="<%= request.getContextPath() %>/js/resume-forms.js"></script>
    <script>
        (function () {
            var RF = window.TaResumeForms;
            var form = document.getElementById('applyForm');
            if (!form) return;

            var userName = '<%= userName.replace("'", "\\'") %>';
            var jobTitle = '<%= escJobTitle.replace("'", "\\'") %>';
            var moduleCode = '<%= escModuleCode.replace("'", "\\'") %>';
            var moduleName = '<%= escModuleName.replace("'", "\\'") %>';
            var hours = '<%= hoursPerWeek.replace("'", "\\'") %>';
            var duration = '<%= duration.replace("'", "\\'") %>';

            var userSkills = document.getElementById('bootSkills').value;
            var userExperience = document.getElementById('bootExperience').value;
            var userEmail = document.getElementById('bootEmail').value;
            var jobId = '<%= jobId.replace("'", "\\'") %>';

            function setCoverSections(sections) {
                document.getElementById('coverGreeting').value = sections.greeting || '';
                document.getElementById('coverOpening').value = sections.opening || '';
                document.getElementById('coverInterest').value = sections.interest || '';
                document.getElementById('coverQualifications').value = sections.qualifications || '';
                document.getElementById('coverAvailability').value = sections.availability || '';
                document.getElementById('coverClosing').value = sections.closing || '';
            }

            function formatAutosaveTime(ts) {
                if (!ts) return 'Draft not saved yet';
                var d = new Date(ts);
                return 'Draft saved locally at ' + d.toLocaleTimeString();
            }

            function renderResume() {
                var parsedSkills = RF.parseSkillsField(userSkills);
                var fields = RF.parseSavedExperience(userExperience);
                var box = document.getElementById('resumePreviewBox');
                if (!userSkills.trim() && !userExperience.trim()) {
                    box.textContent = 'No resume saved yet. Please complete your Profile & CV first.';
                    box.classList.add('preview-empty');
                    return;
                }
                box.classList.remove('preview-empty');
                box.innerHTML = RF.buildResumePreviewHtml(userName, '', fields, parsedSkills);
            }

            function readCoverSections() {
                return {
                    greeting: document.getElementById('coverGreeting').value,
                    opening: document.getElementById('coverOpening').value,
                    interest: document.getElementById('coverInterest').value,
                    qualifications: document.getElementById('coverQualifications').value,
                    availability: document.getElementById('coverAvailability').value,
                    closing: document.getElementById('coverClosing').value
                };
            }

            var autoSave = RF.createCoverLetterAutoSave({
                storageKey: 'ta-cover-' + userEmail + '-' + jobId,
                getSections: readCoverSections,
                setSections: setCoverSections,
                onStatus: function (ts) {
                    var el = document.getElementById('autosaveStatus');
                    el.textContent = formatAutosaveTime(ts);
                    el.classList.add('saved');
                }
            });

            function updateWordCount() {
                var text = RF.assembleCoverLetter(readCoverSections());
                var count = RF.countWords(text);
                var el = document.getElementById('wordCount');
                el.textContent = count + ' words';
                el.classList.toggle('warn', count > 0 && (count < 150 || count > 500));
            }

            document.getElementById('fillCoverTemplate').addEventListener('click', function () {
                if (!document.getElementById('coverOpening').value.trim()) {
                    document.getElementById('coverOpening').value =
                        'I am writing to apply for the ' + jobTitle + ' position for ' +
                        moduleCode + ' (' + moduleName + ').';
                }
                if (!document.getElementById('coverInterest').value.trim()) {
                    document.getElementById('coverInterest').value =
                        'I am motivated to support students in this module because [explain your interest in the subject and teaching]. ' +
                        'This role aligns with my academic background and my goal to develop professional teaching experience.';
                }
                if (!document.getElementById('coverQualifications').value.trim()) {
                    document.getElementById('coverQualifications').value =
                        'My relevant experience includes:\n' +
                        '�?[Teaching/tutoring example]\n' +
                        '�?[Technical skill or project related to the module]\n' +
                        '�?[Communication or teamwork example]';
                }
                if (!document.getElementById('coverAvailability').value.trim()) {
                    document.getElementById('coverAvailability').value =
                        'I can commit to the required workload (' + hours + ' hours per week for ' + duration + ') and am available for labs, office hours, and marking as scheduled.';
                }
                if (!document.getElementById('coverClosing').value.trim()) {
                    document.getElementById('coverClosing').value =
                        'Thank you for considering my application. I would welcome the opportunity to contribute to the module and am happy to provide any further information.\n\nSincerely,\n' + userName;
                }
                updateWordCount();
            });

            form.addEventListener('input', updateWordCount);
            form.addEventListener('change', updateWordCount);

            form.addEventListener('submit', function (e) {
                var sections = readCoverSections();
                var letter = RF.assembleCoverLetter(sections);
                if (!letter || RF.countWords(letter) < 80) {
                    e.preventDefault();
                    alert('Please complete all cover letter sections (at least ~80 words).');
                    return;
                }

                var resumeText = RF.buildPlainResumeText(
                    userName,
                    '',
                    RF.parseSavedExperience(userExperience),
                    RF.parseSkillsField(userSkills)
                );

                document.getElementById('coverLetter').value =
                    RF.packApplication(resumeText, letter);
                autoSave.clear();
            });

            autoSave.load();
            autoSave.bind(form);
            renderResume();
            updateWordCount();
        })();
    </script>
</body>
</html>
