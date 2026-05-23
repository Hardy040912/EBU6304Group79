package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/updateApplicationStatus")
public class UpdateApplicationStatusServlet extends HttpServlet {
    
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

        String appId = request.getParameter("appId");
        String newStatus = request.getParameter("status");
        String blocked = request.getParameter("blocked"); // "true" 或 null

        if (!"accepted".equals(newStatus) && !"rejected".equals(newStatus)) {
            response.sendRedirect(request.getContextPath() + "/mo-applications.jsp?error=invalidStatus");
            return;
        }

        List<String> applications = DataFileUtil.readLines("applications.txt");
        List<String> updatedApplications = new ArrayList<>();

        for (String line : applications) {
            String[] parts = line.split("\\|");
            if (parts.length >= 7 && parts[0].equals(appId)) {
                // 更新状态
                parts[5] = newStatus;

                // 如果是拒绝且勾选了屏蔽，设置 blocked = true
                if ("rejected".equals(newStatus) && "true".equals(blocked)) {
                    if (parts.length >= 8) {
                        parts[7] = "true";
                    } else {
                        // 兼容旧数据，添加 blocked 字段
                        line = line + "|true";
                        parts = line.split("\\|");
                    }
                } else {
                    // 确保有 blocked 字段
                    if (parts.length < 8) {
                        line = line + "|false";
                        parts = line.split("\\|");
                    }
                }

                line = String.join("|", parts);
            } else {
                // 兼容旧数据，确保有 blocked 字段
                String[] parts2 = line.split("\\|");
                if (parts2.length == 7) {
                    line = line + "|false";
                }
            }
            updatedApplications.add(line);
        }

        DataFileUtil.writeLines("applications.txt", updatedApplications);

        response.sendRedirect(request.getContextPath() + "/mo-applications.jsp?success=1");
    }
}
