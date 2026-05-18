package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.time.LocalDate;
import java.util.Base64;

@WebServlet("/applyJob")
public class ApplyJobServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }

        DataFileUtil.initDataDir(getServletContext().getRealPath("/"));

        String jobId = request.getParameter("jobId");
        String coverLetter = request.getParameter("coverLetter");
        String email = (String) session.getAttribute("userEmail");
        String name = (String) session.getAttribute("userName");

        if (jobId == null || coverLetter == null || coverLetter.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/student-jobs.jsp");
            return;
        }

        String appId = DataFileUtil.nextId("app", "applications.txt");
        String line = String.join("|",
                appId,
                jobId,
                email,
                name == null ? "" : name,
                "B64:" + Base64.getEncoder().encodeToString(coverLetter.getBytes(StandardCharsets.UTF_8)),
                "pending",
                LocalDate.now().toString(),
                "false");
        DataFileUtil.appendLine("applications.txt", line);
        response.sendRedirect(request.getContextPath() + "/student-applications.jsp");
    }
}
