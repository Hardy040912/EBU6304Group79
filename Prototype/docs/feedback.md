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
