<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String active = request.getParameter("active");
    if (active == null) {
        active = (String) request.getAttribute("studentNavActive");
    }
    if (active == null) {
        active = "";
    }
    String cp = request.getContextPath();
%>
<nav class="student-nav">
    <a href="<%= cp %>/student-dashboard.jsp"<%= "home".equals(active) ? " class=\"active\"" : "" %>>Home</a>
    <a href="<%= cp %>/student-jobs.jsp"<%= "jobs".equals(active) ? " class=\"active\"" : "" %>>Jobs</a>
    <a href="<%= cp %>/student-profile.jsp"<%= "profile".equals(active) ? " class=\"active\"" : "" %>>My Profile</a>
    <a href="<%= cp %>/student-applications.jsp"<%= "applications".equals(active) ? " class=\"active\"" : "" %>>Applications</a>
</nav>
