<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String active = request.getParameter("active");
    if (active == null) {
        active = (String) request.getAttribute("adminNavActive");
    }
    if (active == null) {
        active = "";
    }
    String cp = request.getContextPath();
%>
<nav class="student-nav">
    <a href="<%= cp %>/admin-dashboard.jsp"<%= "home".equals(active) ? " class=\"active\"" : "" %>>Overview</a>
    <a href="<%= cp %>/mo-dashboard.jsp"<%= "recruitment".equals(active) ? " class=\"active\"" : "" %>>Recruitment</a>
    <a href="<%= cp %>/mo-post-job.jsp"<%= "post".equals(active) ? " class=\"active\"" : "" %>>Post Job</a>
    <a href="<%= cp %>/mo-applications.jsp"<%= "applications".equals(active) ? " class=\"active\"" : "" %>>Applications</a>
    <a href="<%= cp %>/admin-workload.jsp"<%= "workload".equals(active) ? " class=\"active\"" : "" %>>Workload</a>
</nav>
