<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String active = request.getParameter("active");
    if (active == null) {
        active = (String) request.getAttribute("moNavActive");
    }
    if (active == null) {
        active = "";
    }
    String cp = request.getContextPath();
%>
<nav class="student-nav">
    <a href="<%= cp %>/mo-dashboard.jsp"<%= "home".equals(active) ? " class=\"active\"" : "" %>>Home</a>
    <a href="<%= cp %>/mo-post-job.jsp"<%= "post".equals(active) ? " class=\"active\"" : "" %>>Post Job</a>
    <a href="<%= cp %>/mo-applications.jsp"<%= "applications".equals(active) ? " class=\"active\"" : "" %>>Applications</a>
</nav>
