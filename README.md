# EBU6304Group79

HCC-yyds：231224918(Member)
lihaoyang 231224745
abcdeme0316 221170928(Member)
jp2023213572 231224767(Member)
pptreader101-code 231224365(Member)

## How to Run

### Tech Stack
- Java 11+
- Java Servlet (no Spring Boot, meets course requirements)
- JSP frontend
- JSON file storage (no database)

### Run Steps

#### Option 1: IntelliJ IDEA
1. Open project: `Prototype/ta-recruitment-system/`
2. Configure Tomcat 9+: `Run` → `Edit Configurations` → `Add` → `Tomcat Server` → `Local`
3. Set Deployment: Add webapp folder
4. Run → Access `http://localhost:8080/ta-recruitment-system/`

#### Option 2: Command Line (Tomcat required)
```bash
# 1. Copy project to Tomcat webapps
cp -r Prototype/ta-recruitment-system /path/to/tomcat/webapps/

# 2. Start Tomcat
cd /path/to/tomcat/bin
./catalina.sh run   # Linux/Mac
catalina.bat run    # Windows

# 3. Access in browser
open http://localhost:8080/ta-recruitment-system/
```

### Demo Login Credentials

| Role | Username | Password |
|------|----------|----------|
| Student | student1 | password |
| MO (Module Organiser) | mo1 | password |
| Admin | admin | password |

### Data Storage
- All data stored in JSON files (no database)
- Location: `WEB-INF/data/`
- Files: `users.json`, `jobs.json`, `applications.json`

### Feedback Implemented (from prototype testing)
Based on user feedback in `feedback.md`:
- ✅ Increased spacing between Login/Register buttons
- ✅ Increased font size for module names
- ✅ Added CV upload confirmation message
- ✅ Added "Back to List" button on job details
