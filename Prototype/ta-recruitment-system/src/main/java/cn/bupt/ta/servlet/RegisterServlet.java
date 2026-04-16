package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");

        // 简单验证
        if (password != null && password.equals(confirmPassword)) {
            // 保存到文件
            String fullName = firstName + " " + lastName;
            String userLine = email + "|" + password + "|" + role + "|" + fullName;
            DataFileUtil.appendLine("users.txt", userLine);

            // 注册成功，直接登录并跳转
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", email);
            session.setAttribute("userName", fullName);
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
        } else {
            // 密码不匹配，返回注册页
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=password");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/register.jsp");
    }
}
