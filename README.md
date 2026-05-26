# EBU6304Group79
# TA Recruitment System - BUPT International School

A Java Servlet/JSP web application for TA recruitment.

## Team Members

| Name | QM Number | GitHub |
|------|-----------|--------|
| Haoyang Li | 231224745 | lihaoyang |
| Chuyuan Su | 221170928 | abcdeme0316 |
| Yiyang Guo | 231224365 | pptreader101-code |
| Yizhou Ma | 231224767 | jp2023213572 |
| Lingran Qin | 221170799 |  |Mavericks-77
| Changcheng Huang | 231224918 | HCC-yyds |

## Tech Stack
- Java 11+
- Java Servlet
- JSP
- Apache Tomcat 9+

## Project Structure

Prototype/ta-recruitment-system/
├── src/main/java/cn/bupt/ta/servlet/
├── src/main/webapp/
│   ├── index.jsp
│   ├── register.jsp
│   ├── student-dashboard.jsp
│   ├── mo-dashboard.jsp
│   └── admin-dashboard.jsp
└── WEB-INF/web.xml

## How to Run

IntelliJ IDEA:
1. Open Prototype/ta-recruitment-system/
2. Configure Tomcat 9+ and run
3. Access http://localhost:8080/ta-recruitment-system/

Command Line:
cp -r Prototype/ta-recruitment-system /path/to/tomcat/webapps/
cd /path/to/tomcat/bin && ./catalina.sh run

## Login
Select role (Student / Module Organiser / Admin) and enter any credentials

## Features

Student:
- Browse jobs with AI match scores
- Track application status
- View profile and workload

Module Organiser:
- Post job openings
- Review applicants with Accept/Reject buttons

Admin:
- View workload balancing chart
- Capacity alerts (Warning / Critical)
