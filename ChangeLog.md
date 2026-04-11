# Changelog - TA Recruitment System

All notable changes to this project will be documented in this file.

## [Sprint 2] - 2026-04-05

### Added - Backend Servlets (Huang Changcheng)
- `LoginServlet.java` - Role-based login (Student/MO/Admin redirect)
- `LogoutServlet.java` - Session invalidation and logout
- `RegisterServlet.java` - New user registration with password confirmation
- `web.xml` - Servlet configuration with session timeout (30 min)

### Added - JSP Frontend Pages (Huang Changcheng)
- `index.jsp` - Login page with role dropdown (Student/MO/Admin)
- `register.jsp` - Registration page with first/last name fields
- `student-dashboard.jsp` - Student view with:
  - Workload progress bar (12h/20h)
  - AI-powered match scores (71%, 39%, 100%)
  - Job browsing with skill badges
  - Application status tracking (Pending/Accepted)
  - Profile & CV section
- `mo-dashboard.jsp` - Module Organiser view with:
  - Job posts list (Machine Learning TA, Data Structures TA)
  - Applicant management with Accept/Reject buttons
  - Match score display for each applicant
  - Workload availability indicators
- `admin-dashboard.jsp` - Admin view with:
  - Workload balancing bar chart
  - Critical/Warning alerts (15h+ / 18h+)
  - Student management with skill tags

### UI Improvements (Based on feedback.md)
- Login/Register buttons spacing increased
- Module name font size increased
- CV upload confirmation message added (planned for Sprint 3)
- "Back to List" button added to job detail (planned for Sprint 3)

### Known Limitations (Sprint 2)
- Data is currently hardcoded in JSP (no JSON file persistence yet)
- Accept/Reject buttons are UI-only (backend logic pending Sprint 3)
- CV upload is UI placeholder (full implementation in Sprint 3)

---

## [Sprint 1] - 2026-03-22

### Added
- GitHub repository setup with main branch
- Project structure: Java Servlet + JSP + Maven (implied)
- Team member branches established

---

## [Upcoming] - Sprint 3 (Apr 13 - May 3)

### Planned (Backend Integration)
- JSON file storage for users, jobs, applications
- Accept/Reject logic with status persistence
- CV upload file handling
- Real data binding (replacing hardcoded JSP data)

---

## Branch Merge History

| Branch | Merge To | Description |
|--------|----------|-------------|
| feature/login | main | LoginServlet + index.jsp |
| feature/register | main | RegisterServlet + register.jsp |
| feature/student-dashboard | main | Student dashboard JSP |
| feature/mo-dashboard | main | MO dashboard JSP |
| feature/admin-dashboard | main | Admin dashboard JSP |
| feature/frontend | main | All JSP pages merged |

---

**Maintained by:** Yiyang Guo 
**Group:** 79
