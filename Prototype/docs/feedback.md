### Team Feedback - Layout & Buttons
**Summary:** We checked the first draft of the website prototype together.

**Feedback 1: Login Page**
The "Login" and "Register" buttons were too close to each other. On a mobile phone screen, it might be easy to click the wrong one.
- **Action:** Added more space between the two buttons.
- **Status:** Done.

**Feedback 2: Job List**
The text for the "Module Name" was a bit small. It was hard to read the course titles quickly.
- **Action:** Increased font size for course titles.
- **Status:** Done.

### Peer Review - Application Process
**Summary:** Asked a roommate to try out the prototype.

**Feedback 1: CV Upload**
After clicking "Upload CV," there wasn't a clear message saying the file was successfully selected. 
- **Action:** Added a simple text note "File_name.pdf attached" next to the button to show it's working.
- **Status:** Updated in the design notes.

**Feedback 2: Back Button**
On the job detail page, there was no easy way to go back to the full list without using the browser's back button.
- **Action:** Added a "Back to List" link at the top left.
- **Status:** Integrated into the navigation flow.

---

### Sprint 3 — User & Peer Feedback: Profile / Cover Letter Split (Yizhou Ma, jp2023213572)

**Summary:** After the first integrated JSP prototype, we ran an informal walkthrough (2 students, 1 MO) focused on “apply to a TA post” and “review an application.” Findings drove the Sprint 3 UX refactor documented in `design_notes.md`.

**Feedback 3: Duplicate CV on every application**
Students said applying to a second job felt like “filling the same resume again,” and they were unsure which fields MOs actually read.
- **Action:** Introduced a dedicated **My Profile** page for the standard CV; apply flow only asks for a **per-job cover letter** and shows profile as read-only preview.
- **Status:** Done (`student-profile.jsp`, `student-apply.jsp`).

**Feedback 4: One big block of text for MOs**
The MO participant could not quickly separate “background / skills” from “why this module.”
- **Action:** Application review split into two labelled panels — **Applicant profile** and **Cover letter for this position** (`mo-applications.jsp`, `student-applications.jsp`).
- **Status:** Done.

**Feedback 5: Lost cover letter after refresh**
A student closed the tab mid-application and lost several paragraphs of the letter.
- **Action:** Added **local autosave** for the cover letter form (debounced `localStorage` + visible “draft saved” status); draft cleared on successful submit.
- **Status:** Done (`resume-forms.js`, `student-apply.jsp`).

**Feedback 6: Dashboard felt repetitive**
Testers noticed “Browse jobs” and “My applications” appeared both as **tabs on the dashboard** and as **separate menu pages**, which was confusing.
- **Action:** Dashboard redesigned as a **hub** (three cards + shared top navigation); redundant tab content hidden from the default path.
- **Status:** Done (`student-dashboard.jsp`).

**Feedback 7: Wording — “Resume” vs “Cover letter”**
Some students thought uploading a PDF was required because the old label said “CV / resume” on the apply page.
- **Action:** Copy updated to distinguish **Profile (account)** vs **Cover letter (this job)**; apply step labels and intro text clarified.
- **Status:** Done.

---

### Team Review — Sprint 3 PR (`feature/profile-cover-letter-ui`)

**Summary:** Internal review before merge to `main`.

**Review point 1: Backward compatibility**
Older applications in `applications.txt` may still use the previous single-field format.
- **Action:** `application-payload.jsp` supports legacy section headers as well as new `<<<TA_PROFILE>>>` / `<<<TA_COVER>>>` markers.
- **Status:** Done.

**Review point 2: Line breaks in stored applications**
Plain-text storage previously flattened newlines, making profiles unreadable in the MO view.
- **Action:** `ApplyJobServlet` encodes payload as Base64 (`B64:` prefix) before writing to file.
- **Status:** Done; backend team notified in PR description.

**Review point 3: Maven / deployment path**
New assets must live under `src/main/webapp/` (`css/`, `js/`, `includes/`) for WAR packaging.
- **Action:** All Sprint 3 files placed under `Prototype/ta-recruitment-system/src/main/webapp/` per project structure.
- **Status:** Done.

---

### Reflection (contributor note)
The highest-impact change was **separating concerns** (profile vs. letter) rather than adding more UI chrome. Peer comments confirmed that MOs care about structure at review time, and students care about not retyping the same CV. Autosave addressed a real failure mode without requiring new server endpoints. Remaining pain points (MO dashboard preview parity, server-side drafts) are logged in `design_notes.md` for the next sprint.

---

### Sprint 4 — User & Team Feedback: Branding, Navigation & Admin Integration (Yizhou Ma, jp2023213572 / S1LNCE-Y)

**Summary:** After merging the Sprint 3 profile/cover-letter flow, we ran a team walkthrough (Admin + MO + Student roles) and integrated a teammate’s Admin dashboard branch (`sync111`). Feedback focused on visual consistency, cross-page navigation for Admin, and MO review readability.

**Feedback 8: Admin and MO pages felt like different products**
Testers switching between `admin-dashboard.jsp`, `admin-workload.jsp`, and MO recruitment pages noticed mismatched headers, fonts, and back-links instead of a coherent top nav.
- **Action:** Added shared pill navigation — **`admin-nav.jsp`** (Overview · Recruitment · Post Job · Applications · Workload) and updated **`mo-nav.jsp`** so Admin users see Admin Overview / Recruitment / Workload when on MO pages. Applied **`admin-page`** dark theme and **`mo-page`** light-blue theme via `bupt-brand.css`.
- **Status:** Done (`feature/ui-branding-nav-mo-yizhou`).

**Feedback 9: MO application actions were too loud; job metadata used emoji**
During MO review, bright Accept/Reject buttons competed with applicant names, and ⏰/📅 emoji on job cards looked informal next to the new BUPT branding.
- **Action:** Restyled MO actions to muted buttons; enlarged job/applicant titles; replaced emoji with grey SVG icons in **`job-meta.jsp`** (`.ui-icon-clock`, `.ui-icon-calendar`, `.ui-icon-document` for resume link).
- **Status:** Done (`mo-applications.jsp`, `resume-forms.css`).

---

### Team Review — Sprint 4 PR (`feature/ui-branding-nav-mo-yizhou`)

**Summary:** Internal review after merging teammate Admin features (clickable stat cards, SkillMatcher recommendations, Admin access to all MO jobs/applications) with Sprint 4 UI shell.

**Review point 1: Two sources of truth for Admin navigation**
Admin routes were reachable via dashboard action links, `← Dashboard` on workload, and MO nav — easy to miss pages in demos.
- **Action:** Standardized on **`admin-nav.jsp`** + admin-aware **`mo-nav.jsp`**; removed redundant back button on **`admin-workload.jsp`**.
- **Status:** Done.

**Review point 2: Teammate Admin logic vs. new UI theme**
`sync111` Admin dashboard added SkillMatcher panels and stat-card tabs on a light theme; Sprint 4 UI required dark admin styling without losing functionality.
- **Action:** Kept teammate’s **`admin-dashboard.jsp`** behaviour (stat-card tabs, application review, SkillMatcher); layered dark-theme CSS and shared nav on top; merged into `Prototype/ta-recruitment-system/src/main/webapp/`.
- **Status:** Done; pushed to `feature/ui-branding-nav-mo-yizhou`.

---

### Reflection — Sprint 4 (contributor note)
The main lesson was **merge behaviour first, theme second**: teammate Admin work (data visibility, SkillMatcher, cross-role access) had to stay intact while the shell (nav, colours, icons) was unified. Role-based backgrounds (grey / light blue / dark) made demos easier to follow when three accounts are shown in sequence. Next improvement: single Admin nav component used on every Admin and MO page to remove the remaining duplicate links.
