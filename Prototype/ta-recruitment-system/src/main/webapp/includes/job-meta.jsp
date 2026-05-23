<%@ page contentType="text/html;charset=UTF-8" language="java" trimDirectiveWhitespaces="true" %>
<%
    String hours = request.getParameter("hours");
    String duration = request.getParameter("duration");
    String layout = request.getParameter("layout");
    if (hours == null) hours = "";
    if (duration == null) duration = "";
    if (layout == null) layout = "";
    boolean inline = "row".equals(layout);
%>
<% if (inline) { %><span class="job-meta-row"><% } %>
<span class="job-meta"><span class="ui-icon ui-icon-clock" aria-hidden="true"></span><%= hours %>h/week</span>
<% if (inline) { %><span class="job-meta-sep">|</span><% } %>
<span class="job-meta"><span class="ui-icon ui-icon-calendar" aria-hidden="true"></span><%= duration %></span>
<% if (inline) { %></span><% } %>
