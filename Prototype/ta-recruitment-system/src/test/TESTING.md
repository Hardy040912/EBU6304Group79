# Testing Guide

## Test scope

The replacement suite is stored in the Maven test folders and covers the main nodes of the JSP/Servlet recruitment system:

- application data-file reading, writing, append operations, delimiter-safe field handling, application ID generation, resume property persistence, and explainable skill matching;
- startup creation of default `users.txt`, `staff_ids.txt`, `jobs.txt`, and `applications.txt` data files;
- login and registration redirects for student, module organiser, and admin roles;
- invalid login, duplicate email registration, invalid MO staff ID registration, invalid role registration, and GET redirect branches;
- module organiser job posting and role protection;
- student application authentication, validation, Base64 cover-letter storage, and redirect branches;
- module organiser application acceptance, rejection, rejection blocking, invalid status handling, missing ID handling, role protection, and old-row compatibility;
- profile update, resume upload, and anonymous-user redirects;
- GET/POST logout and session invalidation;
- frontend resume helper parsing, payload packing, Base64 parsing, HTML escaping, word counting, and cover-letter assembly.

## Run Java tests

```bash
mvn test
```

## Run frontend helper tests

```bash
node src/test/js/resume-forms.test.js
```

## Expected Java result

The Java suite contains 41 JUnit tests after the skill matching, role-protection, staff ID validation, duplicate email checks, and safe text-file field coverage is included.
