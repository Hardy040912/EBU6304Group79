# Mid-Term Report - Group 79

**Project:** TA Recruitment System for BUPT International School
**Assessment Date:** 12th April 2026

---

## 1. Iteration Plan

### Sprint 1 (Mar 6 - Mar 22)
**Completed:**
- Role-based login (Student/MO/Admin) with Servlet
- User registration with password confirmation
- Basic session management and logout

### Sprint 2 (Mar 23 - Apr 12)
**Completed:**
- Student dashboard: job browsing, AI match scores, application status
- MO dashboard: job posting, applicant review, Accept/Reject buttons
- Admin dashboard: workload chart, capacity alerts

### Sprint 3 (Apr 13 - May 3) - Planned
- JSON file storage (replace hardcoded data)
- Accept/Reject backend logic
- CV upload functionality

---

## 2. Estimation Method

**Method:** Fibonacci story points (1, 2, 3, 5, 8)

**Reference story:** System Login = 3 points

**Process:** Planning poker with all team members

| Story | Points | Justification |
|-------|--------|----------------|
| System Login | 3 | Basic UI + role redirect |
| Data Persistence | 8 | No database constraint, JSON I/O |
| Profile & CV | 5 | File upload + form validation |
| Job Posting | 5 | Form + status management |
| Job Search | 5 | Filter logic + UI |
| Application | 3 | Modal + cover letter |
| Application Review | 8 | Multi-applicant + status update |

---

## 3. Improvements Based on User Feedback

**Source:** Prototype testing (recorded in feedback.md)

| Feedback | Action Taken | Status |
|----------|--------------|--------|
| Login/Register buttons too close | Increased spacing | ✅ Done |
| Module name text too small | Increased font size | ✅ Done |
| No CV upload confirmation | Added "file attached" text | ✅ Done |
| No back button on job detail | Added "Back to List" link | ✅ Done |

All feedback has been implemented and verified.

---

## 4. GitHub Branch Management

- Main branch: stable release
- Feature branches per member, all merged to main
- Active commits from all 6 members

---

**Prepared by:** Yiyang Guo
**Date:** 11th April 2026
