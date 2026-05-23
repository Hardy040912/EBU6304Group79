package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/postJob")
public class PostJobServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 初始化数据目录
        DataFileUtil.initDataDir(getServletContext().getRealPath("/"));

        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession(false);
        if (session == null || !"module-organiser".equals(session.getAttribute("userRole"))) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        String organiserEmail = (String) session.getAttribute("userEmail");
        String organiserName = (String) session.getAttribute("userName");
        
        String title = DataFileUtil.safeField(request.getParameter("title"));
        String moduleCode = DataFileUtil.safeField(request.getParameter("moduleCode"));
        String moduleName = DataFileUtil.safeField(request.getParameter("moduleName"));
        String description = DataFileUtil.safeField(request.getParameter("description"));
        String skills = DataFileUtil.safeField(request.getParameter("skills"));
        String hoursPerWeek = DataFileUtil.safeField(request.getParameter("hoursPerWeek"));
        String duration = DataFileUtil.safeField(request.getParameter("duration"));
        
        // 生成岗位ID
        String jobId = System.currentTimeMillis() + "_" + (int)(Math.random() * 10000);
        
        // 格式: jobId|title|moduleCode|module|organiser|organiserId|description|skills|hoursPerWeek|duration|status
        String jobLine = jobId + "|" + title + "|" + moduleCode + "|" + moduleName + "|" + 
                        organiserName + "|" + organiserEmail + "|" + description + "|" + 
                        skills + "|" + hoursPerWeek + "|" + duration + "|open";
        
        DataFileUtil.appendLine("jobs.txt", jobLine);
        
        response.sendRedirect(request.getContextPath() + "/mo-dashboard.jsp?success=1");
    }
}
