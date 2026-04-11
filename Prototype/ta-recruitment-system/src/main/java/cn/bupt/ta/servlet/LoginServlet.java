package cn.bupt.ta.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        // 简单的角色跳转逻辑（迭代2不做密码验证）
        HttpSession session = request.getSession();
        session.setAttribute("userEmail", email);
        session.setAttribute("userRole", role);
        
        // 根据角色跳转到对应的Dashboard
        if ("student".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/student-dashboard.jsp");
        } else if ("module-organiser".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/mo-dashboard.jsp");
        } else if ("admin".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
