const assert = require('assert');
const fs = require('fs');
const path = require('path');
const vm = require('vm');

const scriptPath = path.join(__dirname, '../../main/webapp/js/resume-forms.js');
const script = fs.readFileSync(scriptPath, 'utf8');
const sandbox = {
  window: {},
  atob: (value) => Buffer.from(value, 'base64').toString('utf8'),
  setTimeout,
  clearTimeout,
  localStorage: {
    data: {},
    getItem(key) {
      return this.data[key] || null;
    },
    setItem(key, value) {
      this.data[key] = String(value);
    },
    removeItem(key) {
      delete this.data[key];
    }
  }
};
vm.createContext(sandbox);
vm.runInContext(script, sandbox);

const RF = sandbox.window.TaResumeForms;

const skills = RF.parseSkillsField('TECH:Java,JSP|LANG:English,Chinese');
assert.strictEqual(skills.tech, 'Java,JSP');
assert.strictEqual(skills.lang, 'English,Chinese');
assert.strictEqual(RF.serializeSkillsField(' Java ', ' English '), 'TECH:Java|LANG:English');

const experience = RF.buildExperienceBlock({
  phone: '123456',
  major: 'Software Engineering',
  grade: 'Year 3',
  gpa: '85',
  portfolio: 'https://example.com',
  education: 'BUPT',
  teaching: 'Java lab tutor',
  projects: 'JSP recruitment system',
  awards: 'Scholarship',
  summary: 'Reliable TA candidate'
});
const parsed = RF.parseSavedExperience(experience);
assert.strictEqual(parsed.education, 'BUPT');
assert.strictEqual(parsed.teaching, 'Java lab tutor');
assert.strictEqual(parsed.projects, 'JSP recruitment system');

assert.strictEqual(RF.countWords('I can support Java labs'), 5);
assert.strictEqual(RF.assembleCoverLetter({
  greeting: 'Dear organiser,',
  opening: 'I am applying.',
  interest: '',
  qualifications: 'I know Java.',
  availability: 'Available weekly.',
  closing: 'Kind regards'
}), 'Dear organiser,\n\nI am applying.\n\nI know Java.\n\nAvailable weekly.\n\nKind regards');

const packed = RF.packApplication('PROFILE TEXT', 'COVER TEXT');
const parsedPacked = RF.parseApplicationPayload(packed);
assert.strictEqual(parsedPacked.profile, 'PROFILE TEXT');
assert.strictEqual(parsedPacked.cover, 'COVER TEXT');

const encoded = 'B64:' + Buffer.from(packed, 'utf8').toString('base64');
const parsedEncoded = RF.parseApplicationPayload(encoded);
assert.strictEqual(parsedEncoded.profile, 'PROFILE TEXT');
assert.strictEqual(parsedEncoded.cover, 'COVER TEXT');

const preview = RF.buildResumePreviewHtml(
  '<Alice>',
  'alice@bupt.edu.cn',
  {
    phone: '',
    major: '',
    grade: '',
    gpa: '',
    portfolio: '',
    education: '<script>alert(1)</script>',
    teaching: '',
    projects: '',
    awards: '',
    summary: ''
  },
  { tech: 'Java', lang: '' }
);
assert(preview.includes('&lt;Alice&gt;'));
assert(preview.includes('&lt;script&gt;alert(1)&lt;/script&gt;'));

console.log('resume-forms.test.js: OK');
