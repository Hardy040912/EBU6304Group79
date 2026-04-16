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

@WebServlet("/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 初始化数据目录
        DataFileUtil.initDataDir(getServletContext().getRealPath("/"));

        request.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        
        if (userEmail == null) {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
            return;
        }
        
        String skills = request.getParameter("skills");
        String experience = request.getParameter("experience");
        
        // 注意：这里只是演示，实际上我们没有在 users.txt 中存储 skills 和 experience
        // 如果需要完整实现，需要扩展 users.txt 的格式或创建新的数据文件
        
        // 简单实现：将信息存储在 session 中
        session.setAttribute("userSkills", skills);
        session.setAttribute("userExperience", experience);
        
        response.sendRedirect(request.getContextPath() + "/student-profile.jsp?success=1");
    }
}
