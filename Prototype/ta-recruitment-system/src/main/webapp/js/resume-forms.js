/**
 * Frontend helpers for standard resume profile & cover letter forms.
 * Backend fields unchanged: skills, experience, coverLetter.
 */
(function (global) {
    'use strict';

    function escapeRegex(str) {
        return str.replace(/[.*+?^$()|[\]\\]/g, '\\$&');
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str)
            .replace(/&/g, '&amp;')
            .replace(/</g, '&lt;')
            .replace(/>/g, '&gt;')
            .replace(/"/g, '&quot;');
    }

    function parseSkillsField(raw) {
        var tech = '';
        var lang = '';
        if (!raw) return { tech: tech, lang: lang };
        var techMatch = raw.match(/TECH:([^|]*)/);
        var langMatch = raw.match(/LANG:([^|]*)/);
        if (techMatch || langMatch) {
            tech = techMatch ? techMatch[1].trim() : '';
            lang = langMatch ? langMatch[1].trim() : '';
        } else {
            tech = raw.trim();
        }
        return { tech: tech, lang: lang };
    }

    function serializeSkillsField(tech, lang) {
        var parts = [];
        if (tech && tech.trim()) parts.push('TECH:' + tech.trim());
        if (lang && lang.trim()) parts.push('LANG:' + lang.trim());
        return parts.join('|');
    }

    function extractSection(text, title) {
        if (!text) return '';
        var escapedTitle = escapeRegex(title);
        var pattern = new RegExp(escapedTitle + ':\\n([\\s\\S]*?)(?=\\n\\n[A-Za-z0-9 /&()\\-]+:\\n|$)');
        var match = text.match(pattern);
        return match ? match[1].trim() : '';
    }

    function buildExperienceBlock(fields) {
        var contactBlock = buildProfileDetails(fields);
        var sections = [];
        if (contactBlock) {
            sections.push(['Contact & Background', contactBlock]);
        }
        sections.push(
            ['Education', fields.education],
            ['Teaching / Tutoring Experience', fields.teaching],
            ['Project / Research Experience', fields.projects],
            ['Awards / Certificates', fields.awards],
            ['Summary for TA Roles', fields.summary]
        );
        return sections
            .filter(function (s) { return s[1] && s[1].trim(); })
            .map(function (s) { return s[0] + ':\n' + s[1].trim(); })
            .join('\n\n');
    }

    function buildProfileDetails(fields) {
        var lines = [
            ['Phone', fields.phone],
            ['Major', fields.major],
            ['Year of Study', fields.grade],
            ['GPA / Average Score', fields.gpa],
            ['LinkedIn / Portfolio', fields.portfolio]
        ];
        return lines
            .filter(function (l) { return l[1] && l[1].trim(); })
            .map(function (l) { return l[0] + ': ' + l[1].trim(); })
            .join('\n');
    }

    function buildResumePreviewHtml(name, email, fields, skills) {
        var html = '';
        html += '<div class="preview-name">' + escapeHtml(name || 'Your Name') + '</div>';
        var contactLines = [];
        if (email) contactLines.push(escapeHtml(email));
        var contact = buildProfileDetails(fields);
        if (contact) contactLines.push(escapeHtml(contact).replace(/\n/g, '<br>'));
        if (contactLines.length) {
            html += '<div class="preview-contact">' + contactLines.join('<br>') + '</div>';
        }
        if (skills.tech || skills.lang) {
            html += '<div class="preview-block-title">Skills</div>';
            if (skills.tech) html += '<div><strong>Technical:</strong> ' + escapeHtml(skills.tech) + '</div>';
            if (skills.lang) html += '<div><strong>Languages:</strong> ' + escapeHtml(skills.lang) + '</div>';
        }
        var blocks = [
            ['Education', fields.education],
            ['Teaching / Tutoring', fields.teaching],
            ['Projects / Research', fields.projects],
            ['Awards & Certificates', fields.awards],
            ['Summary', fields.summary]
        ];
        blocks.forEach(function (b) {
            if (b[1] && b[1].trim()) {
                html += '<div class="preview-block-title">' + escapeHtml(b[0]) + '</div>';
                html += '<div>' + escapeHtml(b[1].trim()).replace(/\n/g, '<br>') + '</div>';
            }
        });
        if (!skills.tech && !skills.lang && !fields.education && !fields.teaching && !fields.projects) {
            html += '<p class="preview-empty">Start filling the form to see your resume preview.</p>';
        }
        return html;
    }

    function buildPlainResumeText(name, email, fields, skills) {
        var lines = [];
        lines.push((name || 'Your Name').toUpperCase());
        if (email) lines.push(email);
        var contact = buildProfileDetails(fields);
        if (contact) lines.push(contact);
        lines.push('');
        if (skills.tech || skills.lang) {
            lines.push('SKILLS');
            if (skills.tech) lines.push('Technical: ' + skills.tech);
            if (skills.lang) lines.push('Languages: ' + skills.lang);
            lines.push('');
        }
        var blocks = [
            ['EDUCATION', fields.education],
            ['TEACHING / TUTORING EXPERIENCE', fields.teaching],
            ['PROJECT / RESEARCH EXPERIENCE', fields.projects],
            ['AWARDS / CERTIFICATES', fields.awards],
            ['SUMMARY', fields.summary]
        ];
        blocks.forEach(function (b) {
            if (b[1] && b[1].trim()) {
                lines.push(b[0]);
                lines.push(b[1].trim());
                lines.push('');
            }
        });
        return lines.join('\n').trim();
    }

    function parseSavedExperience(raw) {
        var fields = {
            phone: '',
            major: '',
            grade: '',
            gpa: '',
            portfolio: '',
            education: '',
            teaching: '',
            projects: '',
            awards: '',
            summary: ''
        };
        if (!raw) return fields;

        if (raw.indexOf('Teaching / Tutoring Experience:') !== -1 ||
            raw.indexOf('Education:') !== -1 ||
            raw.indexOf('Contact & Background:') !== -1) {
            fields.phone = extractSection(raw, 'Phone') || extractSection(raw, 'Phone Number');
            fields.major = extractSection(raw, 'Major');
            fields.grade = extractSection(raw, 'Year of Study');
            fields.gpa = extractSection(raw, 'GPA / Average Score');
            fields.portfolio = extractSection(raw, 'LinkedIn / Portfolio');
            fields.education = extractSection(raw, 'Education');
            fields.teaching = extractSection(raw, 'Teaching / Tutoring Experience');
            fields.projects = extractSection(raw, 'Project Experience') ||
                extractSection(raw, 'Project / Research Experience');
            fields.awards = extractSection(raw, 'Awards / Certificates');
            fields.summary = extractSection(raw, 'Summary for TA Roles') ||
                extractSection(raw, 'Personal Statement');
        } else if (raw.trim()) {
            fields.teaching = raw;
        }
        return fields;
    }

    function assembleCoverLetter(sections) {
        return [
            sections.greeting,
            sections.opening,
            sections.interest,
            sections.qualifications,
            sections.availability,
            sections.closing
        ]
            .map(function (s) { return (s || '').trim(); })
            .filter(Boolean)
            .join('\n\n');
    }

    function countWords(text) {
        if (!text || !text.trim()) return 0;
        return text.trim().split(/\s+/).length;
    }

    var MARKER_PROFILE = '<<<TA_PROFILE>>>';
    var MARKER_COVER = '<<<TA_COVER>>>';

    function packApplication(profileText, coverText) {
        return MARKER_PROFILE + '\n' +
            (profileText || '').trim() + '\n' +
            MARKER_COVER + '\n' +
            (coverText || '').trim();
    }

    function parseApplicationPayload(stored) {
        var decoded = stored || '';
        if (decoded.indexOf('B64:') === 0) {
            try {
                decoded = atob(decoded.substring(4));
            } catch (e) {
                /* keep raw */
            }
        }
        var profile = '';
        var cover = decoded;
        if (decoded.indexOf(MARKER_PROFILE) !== -1 && decoded.indexOf(MARKER_COVER) !== -1) {
            profile = decoded.substring(
                decoded.indexOf(MARKER_PROFILE) + MARKER_PROFILE.length,
                decoded.indexOf(MARKER_COVER)
            ).trim();
            cover = decoded.substring(decoded.indexOf(MARKER_COVER) + MARKER_COVER.length).trim();
        } else if (decoded.indexOf('=== STANDARD RESUME ===') !== -1) {
            profile = decoded.substring(
                decoded.indexOf('=== STANDARD RESUME ===') + 23,
                decoded.indexOf('=== COVER LETTER ===')
            ).trim();
            cover = decoded.substring(decoded.indexOf('=== COVER LETTER ===') + 20).trim();
        }
        return { profile: profile, cover: cover };
    }

    function createCoverLetterAutoSave(options) {
        var storageKey = options.storageKey;
        var getSections = options.getSections;
        var setSections = options.setSections;
        var onStatus = options.onStatus || function () {};
        var debounceTimer = null;

        function persist() {
            try {
                var payload = {
                    version: 1,
                    sections: getSections(),
                    savedAt: Date.now()
                };
                localStorage.setItem(storageKey, JSON.stringify(payload));
                onStatus(payload.savedAt);
            } catch (e) {
                /* storage full or disabled */
            }
        }

        function scheduleSave() {
            if (debounceTimer) clearTimeout(debounceTimer);
            debounceTimer = setTimeout(persist, 500);
        }

        return {
            load: function () {
                try {
                    var raw = localStorage.getItem(storageKey);
                    if (!raw) return false;
                    var data = JSON.parse(raw);
                    if (!data || !data.sections) return false;
                    setSections(data.sections);
                    onStatus(data.savedAt);
                    return true;
                } catch (e) {
                    return false;
                }
            },
            bind: function (root) {
                root.addEventListener('input', scheduleSave);
                root.addEventListener('change', scheduleSave);
            },
            clear: function () {
                try {
                    localStorage.removeItem(storageKey);
                } catch (e) { /* ignore */ }
            }
        };
    }

    global.TaResumeForms = {
        parseSkillsField: parseSkillsField,
        serializeSkillsField: serializeSkillsField,
        extractSection: extractSection,
        buildExperienceBlock: buildExperienceBlock,
        buildProfileDetails: buildProfileDetails,
        buildPlainResumeText: buildPlainResumeText,
        buildResumePreviewHtml: buildResumePreviewHtml,
        parseSavedExperience: parseSavedExperience,
        assembleCoverLetter: assembleCoverLetter,
        countWords: countWords,
        escapeHtml: escapeHtml,
        packApplication: packApplication,
        parseApplicationPayload: parseApplicationPayload,
        createCoverLetterAutoSave: createCoverLetterAutoSave,
        MARKER_PROFILE: MARKER_PROFILE,
        MARKER_COVER: MARKER_COVER
    };
})(typeof window !== 'undefined' ? window : this);
