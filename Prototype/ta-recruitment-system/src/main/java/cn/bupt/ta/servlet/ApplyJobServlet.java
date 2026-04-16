package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

@WebServlet("/applyJob")
public class ApplyJobServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 初始化数据目录
        DataFileUtil.initDataDir(getServletContext().getRealPath("/"));

        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String studentEmail = (String) session.getAttribute("userEmail");
        String studentName = (String) session.getAttribute("userName");
        
        String jobId = request.getParameter("jobId");
        String coverLetter = request.getParameter("coverLetter");
        
        // 生成申请ID
        String appId = System.currentTimeMillis() + "_" + (int)(Math.random() * 10000);
        
        // 获取当前日期
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        String applyDate = sdf.format(new Date());

        // 格式: appId|jobId|studentEmail|studentName|coverLetter|status|applyDate|blocked
        String appLine = appId + "|" + jobId + "|" + studentEmail + "|" +
                        studentName + "|" + coverLetter + "|pending|" + applyDate + "|false";

        DataFileUtil.appendLine("applications.txt", appLine);

        response.sendRedirect(request.getContextPath() + "/student-applications.jsp?success=1");
    }
}
