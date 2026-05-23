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

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 初始化数据目录
        DataFileUtil.initDataDir(getServletContext().getRealPath("/"));

        request.setCharacterEncoding("UTF-8");

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String role = request.getParameter("role");
        String staffId = DataFileUtil.safeField(request.getParameter("staffId"));
        String safeEmail = DataFileUtil.safeField(email);

        // 简单验证
        if (!isAllowedRole(role)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=role");
            return;
        }
        if (emailExists(safeEmail)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=duplicate");
            return;
        }
        if ("module-organiser".equals(role) && !isValidStaffId(staffId)) {
            response.sendRedirect(request.getContextPath() + "/register.jsp?error=staff");
            return;
        }

        if (password != null && password.equals(confirmPassword)) {
            // 保存到文件
            String fullName = DataFileUtil.safeField(firstName) + " " + DataFileUtil.safeField(lastName);
            String userLine = safeEmail + "|" +
                    DataFileUtil.safeField(password) + "|" +
                    role + "|" +
                    fullName.trim() +
                    ("module-organiser".equals(role) ? "|" + staffId : "");
            DataFileUtil.appendLine("users.txt", userLine);

            // 注册成功，直接登录并跳转
            HttpSession session = request.getSession();
            session.setAttribute("userEmail", safeEmail);
            session.setAttribute("userName", fullName);
            session.setAttribute("userRole", role);
            if ("module-organiser".equals(role)) {
                session.setAttribute("staffId", staffId);
            }

            // 根据角色跳转到对应的Dashboard
            if ("student".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/student-dashboard.jsp");
            } else if ("module-organiser".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/mo-dashboard.jsp");
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

    private boolean isAllowedRole(String role) {
        return "student".equals(role) || "module-organiser".equals(role);
    }

    private boolean emailExists(String email) {
        if (email == null || email.trim().isEmpty()) {
            return false;
        }
        List<String> users = DataFileUtil.readLines("users.txt");
        for (String line : users) {
            String[] parts = line.split("\\|");
            if (parts.length >= 1 && email.equalsIgnoreCase(parts[0])) {
                return true;
            }
        }
        return false;
    }

    private boolean isValidStaffId(String staffId) {
        if (staffId == null || staffId.trim().isEmpty()) {
            return false;
        }
        List<String> staffIds = DataFileUtil.readLines("staff_ids.txt");
        for (String line : staffIds) {
            String[] parts = line.split("\\|");
            if (parts.length >= 1 && staffId.equalsIgnoreCase(parts[0])) {
                return true;
            }
        }
        return false;
    }
}
