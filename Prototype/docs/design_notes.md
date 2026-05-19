## Design Overview: TA Recruitment System
**Role:** Prototype Designer
**Objective:** Create a low-fidelity web interface to streamline the TA recruitment process for BUPT International School.

### Core Design Philosophy:
- **Simplicity:** Minimize the learning curve for students and Module Organisers (MO).
- **Transparency:** Ensure students can track their application status in real-time.
- **AI Integration:** Use AI to assist MOs in matching candidates based on skills and workload balance.

---

## Sprint 3 — Application Data Model & Student UX (Yizhou Ma, jp2023213572)

### Problem statement
In the earlier prototype, students re-entered CV-style content on every job application, and MOs saw one long text block labelled “Cover Letter.” This mixed **account-level identity** (who the applicant is) with **job-specific intent** (why they want *this* TA role). The flow also duplicated navigation (dashboard tabs vs. separate pages), which felt heavier than mainstream job portals (e.g. Apple Jobs: one profile, many applications).

### Design decision: Profile vs. Cover Letter
We split the submission into two logical artefacts:

| Artefact | Scope | Primary page | Reviewer view |
|----------|--------|--------------|---------------|
| **Profile** | Account-level standard CV (skills, education, experience) | `student-profile.jsp` | “Applicant profile” panel |
| **Cover Letter** | Per-job letter (salutation, motivation, availability, closing) | `student-apply.jsp` | “Cover letter for this position” panel |

**Rationale:** Profile is maintained once and reused; the cover letter answers “why this module / this semester.” At apply time, a **snapshot** of the profile is stored with the application so MOs see what the student submitted even if they edit their profile later.

### Application payload (technical note for backend integration)
Submitted content is packed into one stored field for compatibility with the existing servlet API, using explicit markers:

```
<<<TA_PROFILE>>>
{profile snapshot at submit time}
<<<TA_COVER>>>
{cover letter text only}
```

`ApplyJobServlet` stores the payload as **Base64** so line breaks are preserved in `applications.txt`. Parsing and HTML display for reviewers are centralized in `includes/application-payload.jsp` (legacy `=== STANDARD RESUME ===` / `=== COVER LETTER ===` formats remain supported).

### Student navigation (hub model)
**`student-dashboard.jsp`** was simplified to a **hub**: three entry cards — Jobs, My Profile, Applications — plus a shared top nav (`Home | Jobs | My Profile | Applications`). Tabbed duplicates of full page content were removed from the default view to reduce cognitive load.

**`student-apply.jsp`** uses a **two-step** layout:
1. Step 1 — read-only profile preview (link to edit profile).
2. Step 2 — structured cover letter form with live preview.

### Cover letter autosave (client-side)
**Requirement:** Students often lose long-form text when navigating away or refreshing.

**Solution:** Debounced (~500 ms) save to `localStorage` under key `ta-cover-{email}-{jobId}`. A status line shows “Draft saved locally at …”. Draft is cleared after successful submit.

**Limitation (documented):** Autosave is device-local only; it is not a server draft and does not sync across browsers.

### Shared front-end modules
To keep JSP pages thin and consistent:
- **`css/resume-forms.css`** — form layout, step indicator, review panels, hub cards.
- **`js/resume-forms.js`** — profile/cover serialization, payload pack/unpack, live preview, autosave helper.
- **`includes/application-payload.jsp`** — server-side decode/split for MO and student application views.

### MO review UX
**`mo-applications.jsp`** renders two stacked **review panels** instead of a single paragraph, so evaluators can scan qualifications first and read motivation second. **`student-applications.jsp`** uses the same split for student self-check after submit.

### References & constraints
- Aligns with Product Backlog themes: clearer application journey, reduced duplicate data entry, improved MO readability.
- Frontend-only scope where possible; one servlet change (`ApplyJobServlet`) was required for multiline storage.
- Branch: `feature/profile-cover-letter-ui` → PR into `main` under `Prototype/ta-recruitment-system/`.

### Open items (future sprints)
- Profile autosave (optional, same pattern as cover letter).
- Align **`mo-dashboard.jsp`** application preview with dual-panel layout.
- Server-side draft API if cross-device resume is required.
