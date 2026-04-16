package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        // V3: 验证用户信息
        List<String> users = DataFileUtil.readLines("users.txt");
        boolean loginSuccess = false;
        String userName = "";

        for (String line : users) {
            String[] parts = line.split("\\|");
            if (parts.length >= 4) {
                String fileEmail = parts[0];
                String filePassword = parts[1];
                String fileRole = parts[2];
                String fileName = parts[3];

                if (fileEmail.equals(email) && filePassword.equals(password) && fileRole.equals(role)) {
                    loginSuccess = true;
                    userName = fileName;
                    break;
                }
            }
        }

        if (loginSuccess) {
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", email);
            session.setAttribute("userRole", role);
            session.setAttribute("userName", userName);

            // 根据角色跳转到对应的Dashboard
            if ("student".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/student-dashboard.jsp");
            } else if ("module-organiser".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/mo-dashboard.jsp");
            } else if ("admin".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/admin-dashboard.jsp");
            }
        } else {
            response.sendRedirect(request.getContextPath() + "/index.jsp?error=1");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/index.jsp");
    }
}
