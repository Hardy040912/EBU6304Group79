package cn.bupt.ta.servlet;

import cn.bupt.ta.constant.AppConstants;
import cn.bupt.ta.util.RoleNavigationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户登录 Servlet。
 *
 * <p>该 Servlet 负责处理用户登录请求，是系统身份验证流程的核心组件。
 * 它接收用户提交的登录表单数据，验证用户身份，并根据用户角色
 * 将用户重定向到相应的仪表板页面。</p>
 *
 * <h2>功能概述</h2>
 * <ul>
 *   <li>接收 POST 请求处理登录表单提交</li>
 *   <li>提取用户邮箱、密码和角色信息</li>
 *   <li>创建用户会话并存储基本信息</li>
 *   <li>根据用户角色执行页面跳转</li>
 * </ul>
 *
 * <h2>URL 映射</h2>
 * <table border="1">
 *   <tr><th>HTTP 方法</th><th>URL 路径</th><th>功能描述</th></tr>
 *   <tr><td>POST</td><td>/login</td><td>处理登录表单提交</td></tr>
 *   <tr><td>GET</td><td>/login</td><td>重定向到首页</td></tr>
 * </table>
 *
 * <h2>请求参数</h2>
 * <table border="1">
 *   <tr><th>参数名</th><th>类型</th><th>必填</th><th>描述</th></tr>
 *   <tr><td>email</td><td>String</td><td>是</td><td>用户邮箱地址</td></tr>
 *   <tr><td>password</td><td>String</td><td>是</td><td>用户密码</td></tr>
 *   <tr><td>role</td><td>String</td><td>是</td><td>用户角色（student/module-organiser/admin）</td></tr>
 * </table>
 *
 * <h2>会话属性</h2>
 * <p>登录成功后，以下属性将被存储在 HttpSession 中：</p>
 * <ul>
 *   <li>{@link AppConstants#SESSION_USER_EMAIL} - 用户邮箱</li>
 *   <li>{@link AppConstants#SESSION_USER_ROLE} - 用户角色</li>
 * </ul>
 *
 * <h2>设计说明</h2>
 * <p>当前版本（迭代2）采用简化的登录逻辑，不进行密码验证。
 * 实际的用户认证将在后续迭代中实现，届时将集成数据库验证
 * 和密码加密功能。</p>
 *
 * <h2>安全考虑</h2>
 * <p>在生产环境中，应考虑以下安全措施：</p>
 * <ul>
 *   <li>使用 HTTPS 保护传输中的凭据</li>
 *   <li>实现密码加密存储（如 BCrypt）</li>
 *   <li>添加登录失败次数限制</li>
 *   <li>实现 CSRF 防护</li>
 * </ul>
 *
 * @author TA Recruitment System Team
 * @version 1.0
 * @since 1.0
 * @see LogoutServlet
 * @see RegisterServlet
 * @see RoleNavigationUtil
 * @see AppConstants
 */
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    /**
     * 序列化版本号。
     *
     * <p>用于确保序列化和反序列化时的版本兼容性。
     * 当类的结构发生变化时，应更新此版本号。</p>
     */
    private static final long serialVersionUID = 1L;

    /**
     * 处理 POST 请求 - 执行用户登录。
     *
     * <p>该方法处理登录表单的提交，执行以下步骤：</p>
     * <ol>
     *   <li>从请求中提取登录参数（邮箱、密码、角色）</li>
     *   <li>创建或获取用户的 HttpSession</li>
     *   <li>将用户信息存储到会话中</li>
     *   <li>根据用户角色重定向到相应的仪表板页面</li>
     * </ol>
     *
     * <p><b>注意：</b>当前版本不进行密码验证，任何邮箱和密码组合
     * 都可以成功登录。这是为了迭代2的演示目的，实际验证逻辑
     * 将在后续迭代中添加。</p>
     *
     * @param request  HttpServletRequest 对象，包含客户端请求信息
     * @param response HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 当 Servlet 处理过程中发生错误时抛出
     * @throws IOException      当 I/O 操作失败时抛出
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 步骤1：提取登录表单参数
        String email = extractLoginParameter(request, "email");
        String password = extractLoginParameter(request, "password");
        String role = extractLoginParameter(request, "role");

        // 步骤2：创建用户会话
        HttpSession session = request.getSession();

        // 步骤3：存储用户信息到会话
        // 注意：当前迭代不进行密码验证，直接设置会话属性
        session.setAttribute(AppConstants.SESSION_USER_EMAIL, email);
        session.setAttribute(AppConstants.SESSION_USER_ROLE, role);

        // 步骤4：根据角色重定向到对应页面
        RoleNavigationUtil.redirectByRole(request, response, role);
    }

    /**
     * 处理 GET 请求 - 重定向到首页。
     *
     * <p>直接访问登录 URL 的 GET 请求将被重定向到首页。
     * 这确保了用户通过正确的流程（首页表单）进行登录，
     * 而不是直接访问登录 URL。</p>
     *
     * <p>此设计遵循了 Web 应用的最佳实践：登录表单通过 POST 方法提交，
     * GET 请求仅用于页面导航。</p>
     *
     * @param request  HttpServletRequest 对象，包含客户端请求信息
     * @param response HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 当 Servlet 处理过程中发生错误时抛出
     * @throws IOException      当 I/O 操作失败时抛出
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RoleNavigationUtil.redirectToIndex(request, response);
    }

    /**
     * 从请求中提取登录参数。
     *
     * <p>这是一个辅助方法，用于从 HttpServletRequest 中获取指定的参数值。
     * 该方法封装了 {@link HttpServletRequest#getParameter(String)} 调用，
     * 便于后续添加参数验证和日志记录功能。</p>
     *
     * <p><b>扩展点：</b>在后续迭代中，可以在此方法中添加：</p>
     * <ul>
     *   <li>参数非空验证</li>
     *   <li>参数格式验证（如邮箱格式）</li>
     *   <li>参数清理（防止 XSS 攻击）</li>
     *   <li>参数值日志记录（用于调试）</li>
     * </ul>
     *
     * @param request    HttpServletRequest 对象
     * @param paramName  参数名称
     * @return 参数值，如果参数不存在则返回 null
     */
    private String extractLoginParameter(HttpServletRequest request, String paramName) {
        return request.getParameter(paramName);
    }
}
