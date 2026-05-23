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

---

## Sprint 4 — Global Branding & Role-Based UI Shell (Yizhou Ma, jp2023213572 / S1LNCE-Y)

### Design note 1: BUPT visual identity and per-role page themes
**Problem:** After Sprint 3, inner pages still looked like separate Bootstrap-style screens — inconsistent fonts, no school identity, and every role shared the same grey background. Login/register had been styled, but dashboards felt disconnected from BUPT International School branding.

**Decision:** Introduce a shared shell in **`css/bupt-brand.css`**:
- **Typography:** Lexend for UI text; Zen Tokyo Zoo for the large “BUPT” watermark.
- **Watermark:** Fixed full-viewport background on all app pages; blurred on inner pages so content stays readable.
- **Role-specific `<body>` classes and backgrounds:**

| Role | Body class | Background |
|------|------------|------------|
| Student | `app-page` | Grey `#e9edf2` (unchanged from Sprint 3) |
| Module Organiser | `mo-page` | Light blue `#dceaf7` |
| Administrator | `admin-page` | Dark `#0f1419` |

**Rationale:** Students keep the familiar neutral workspace; MO and Admin get visually distinct environments that match their task context (recruitment ops vs. system oversight). Header shows **“BUPT International School”** above the page title on all roles for consistent identity.

**Implementation:** Auth pages use `auth-page`; app pages load `bupt-brand.css` + `resume-forms.css`. Dark-theme overrides for admin cards, tables, stat tabs, and action links live in `bupt-brand.css` so JSP inline styles stay minimal.

**Branch:** `feature/ui-branding-nav-mo-yizhou` → PR into `main`.

---

### Design note 2: Shared pill navigation and MO review polish
**Problem:** Student pages gained a hub nav in Sprint 3, but MO and Admin still used one-off links (`← Dashboard`, underline tabs, mixed button styles). MO application review also used loud green/red buttons and emoji for hours/duration, which felt inconsistent with a professional recruitment tool.

**Decision:**
1. **Reusable pill nav** (`includes/student-nav.jsp`, `mo-nav.jsp`, `admin-nav.jsp`) — same `.student-nav` pattern everywhere:

| Role | Nav items |
|------|-----------|
| Student | Home · Jobs · My Profile · Applications |
| MO | Home · Post Job · Applications |
| Admin | Overview · Recruitment · Post Job · Applications · Workload |

2. **MO Applications UI** — larger job/applicant headings (`.mo-job-heading`, `.mo-applicant-name`); muted Accept/Reject buttons; **View Resume** with grey document icon (`.ui-icon-document`); job hours/duration via **`includes/job-meta.jsp`** (clock/calendar SVG icons instead of emoji).

3. **MO dashboard tabs** restyled as pill buttons (`.mo-tab-list` / `.mo-tab-button`) to match student/MO top nav.

**Rationale:** One navigation language across roles reduces re-learning when switching accounts in demos. Grey meta icons and softer actions keep focus on applicant content, not chrome.

**Open items:** When Admin is logged in, `mo-nav.jsp` also exposes Admin Overview / Workload links on MO pages — consider consolidating fully into `admin-nav.jsp` in a later sprint to avoid duplicate nav patterns.
