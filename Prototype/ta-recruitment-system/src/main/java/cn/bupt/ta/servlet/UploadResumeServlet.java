package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Properties;

@WebServlet("/uploadResume")
public class UploadResumeServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        DataFileUtil.initDataDir(getServletContext().getRealPath("/"));

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        if (userEmail == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        Properties props = new Properties();
        props.setProperty("phone",             nvl(request.getParameter("phone")));
        props.setProperty("major",             nvl(request.getParameter("major")));
        props.setProperty("year",              nvl(request.getParameter("year")));
        props.setProperty("gpa",               nvl(request.getParameter("gpa")));
        props.setProperty("portfolio",         nvl(request.getParameter("portfolio")));
        props.setProperty("education",         nvl(request.getParameter("education")));
        props.setProperty("technicalSkills",   nvl(request.getParameter("technicalSkills")));
        props.setProperty("languageSkills",    nvl(request.getParameter("languageSkills")));
        props.setProperty("certifications",    nvl(request.getParameter("certifications")));
        props.setProperty("teachingExp",       nvl(request.getParameter("teachingExp")));
        props.setProperty("projectExp",        nvl(request.getParameter("projectExp")));
        props.setProperty("personalStatement", nvl(request.getParameter("personalStatement")));

        DataFileUtil.saveResume(userEmail, props);

        response.sendRedirect(request.getContextPath() + "/student-profile.jsp?success=2");
    }

    private String nvl(String s) { return s == null ? "" : s; }
}
