package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/updateApplicationStatus")
public class UpdateApplicationStatusServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        
        String appId = request.getParameter("appId");
        String newStatus = request.getParameter("status");
        
        List<String> applications = DataFileUtil.readLines("applications.txt");
        List<String> updatedApplications = new ArrayList<>();
        
        for (String line : applications) {
            String[] parts = line.split("\\|");
            if (parts.length >= 7 && parts[0].equals(appId)) {
                // 更新状态
                parts[5] = newStatus;
                line = String.join("|", parts);
            }
            updatedApplications.add(line);
        }
        
        DataFileUtil.writeLines("applications.txt", updatedApplications);
        
        response.sendRedirect(request.getContextPath() + "/mo-applications.jsp?success=1");
    }
}
