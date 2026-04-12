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
 * 用户注册 Servlet。
 *
 * <p>该 Servlet 负责处理新用户注册请求，是系统用户管理流程的核心组件。
 * 它接收用户提交的注册表单数据，执行基本验证，创建用户会话，
 * 并根据用户角色将用户重定向到相应的仪表板页面。</p>
 *
 * <h2>功能概述</h2>
 * <ul>
 *   <li>接收 POST 请求处理注册表单提交</li>
 *   <li>提取用户姓名、邮箱、密码和角色信息</li>
 *   <li>验证密码和确认密码是否匹配</li>
 *   <li>创建用户会话并存储基本信息</li>
 *   <li>根据用户角色执行页面跳转</li>
 * </ul>
 *
 * <h2>URL 映射</h2>
 * <table border="1">
 *   <tr><th>HTTP 方法</th><th>URL 路径</th><th>功能描述</th></tr>
 *   <tr><td>POST</td><td>/register</td><td>处理注册表单提交</td></tr>
 *   <tr><td>GET</td><td>/register</td><td>重定向到注册页面</td></tr>
 * </table>
 *
 * <h2>请求参数</h2>
 * <table border="1">
 *   <tr><th>参数名</th><th>类型</th><th>必填</th><th>描述</th></tr>
 *   <tr><td>firstName</td><td>String</td><td>是</td><td>用户名字</td></tr>
 *   <tr><td>lastName</td><td>String</td><td>是</td><td>用户姓氏</td></tr>
 *   <tr><td>email</td><td>String</td><td>是</td><td>用户邮箱地址</td></tr>
 *   <tr><td>password</td><td>String</td><td>是</td><td>用户密码</td></tr>
 *   <tr><td>confirmPassword</td><td>String</td><td>是</td><td>确认密码</td></tr>
 *   <tr><td>role</td><td>String</td><td>是</td><td>用户角色（student/module-organiser/admin）</td></tr>
 * </table>
 *
 * <h2>会话属性</h2>
 * <p>注册成功后，以下属性将被存储在 HttpSession 中：</p>
 * <ul>
 *   <li>{@link AppConstants#SESSION_USER_EMAIL} - 用户邮箱</li>
 *   <li>{@link AppConstants#SESSION_USER_NAME} - 用户全名（名 + 姓）</li>
 *   <li>{@link AppConstants#SESSION_USER_ROLE} - 用户角色</li>
 * </ul>
 *
 * <h2>验证逻辑</h2>
 * <p>当前版本（迭代2）实现了基本的密码匹配验证：</p>
 * <ul>
 *   <li>检查密码是否非空</li>
 *   <li>检查密码与确认密码是否一致</li>
 * </ul>
 *
 * <p>如果验证失败，用户将被重定向回注册页面，并显示相应的错误信息。
 * 错误信息通过 URL 参数传递，格式为：{@code /register.jsp?error=password}</p>
 *
 * <h2>设计说明</h2>
 * <p>当前版本采用简化的注册逻辑，不进行以下验证：</p>
 * <ul>
 *   <li>邮箱格式验证</li>
 *   <li>邮箱唯一性检查</li>
 *   <li>密码强度验证</li>
 *   <li>数据库持久化</li>
 * </ul>
 *
 * <p>这些功能将在后续迭代中实现，届时将集成数据库操作和更完善的验证机制。</p>
 *
 * <h2>安全考虑</h2>
 * <p>在生产环境中，应考虑以下安全措施：</p>
 * <ul>
 *   <li>使用 HTTPS 保护传输中的数据</li>
 *   <li>实现密码加密存储（如 BCrypt）</li>
 *   <li>添加邮箱验证流程</li>
 *   <li>实现 CAPTCHA 防止机器人注册</li>
 *   <li>添加密码强度要求</li>
 *   <li>实现 CSRF 防护</li>
 * </ul>
 *
 * @author TA Recruitment System Team
 * @version 1.0
 * @since 1.0
 * @see LoginServlet
 * @see RoleNavigationUtil
 * @see AppConstants
 */
@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    /**
     * 序列化版本号。
     *
     * <p>用于确保序列化和反序列化时的版本兼容性。
     * 当类的结构发生变化时，应更新此版本号。</p>
     */
    private static final long serialVersionUID = 1L;

    /**
     * 处理 POST 请求 - 执行用户注册。
     *
     * <p>该方法处理注册表单的提交，执行以下步骤：</p>
     * <ol>
     *   <li>从请求中提取注册参数（姓名、邮箱、密码、角色）</li>
     *   <li>验证密码和确认密码是否匹配</li>
     *   <li>如果验证失败，重定向回注册页面并显示错误</li>
     *   <li>如果验证成功，创建用户会话并存储用户信息</li>
     *   <li>根据用户角色重定向到相应的仪表板页面</li>
     * </ol>
     *
     * <p><b>密码验证：</b>当前版本仅检查密码是否非空以及两次输入是否一致。
     * 不检查密码强度、长度或复杂度要求。</p>
     *
     * <p><b>自动登录：</b>注册成功后，用户将自动登录系统，无需再次输入凭据。
     * 这是常见的用户体验优化，但需要确保注册流程的安全性。</p>
     *
     * @param request  HttpServletRequest 对象，包含客户端请求信息
     * @param response HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 当 Servlet 处理过程中发生错误时抛出
     * @throws IOException      当 I/O 操作失败时抛出
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 步骤1：提取注册表单参数
        RegistrationForm form = extractRegistrationForm(request);

        // 步骤2：验证密码匹配
        if (!isPasswordValid(form.password, form.confirmPassword)) {
            // 密码验证失败，重定向回注册页面
            RoleNavigationUtil.redirectToRegisterWithError(
                    request, response, AppConstants.ERROR_PASSWORD_MISMATCH);
            return;
        }

        // 步骤3：创建用户会话
        HttpSession session = request.getSession();

        // 步骤4：存储用户信息到会话
        String fullName = buildFullName(form.firstName, form.lastName);
        RoleNavigationUtil.setUserSession(session, form.email, fullName, form.role);

        // 步骤5：根据角色重定向到对应页面
        RoleNavigationUtil.redirectByRole(request, response, form.role);
    }

    /**
     * 处理 GET 请求 - 重定向到注册页面。
     *
     * <p>直接访问注册 URL 的 GET 请求将被重定向到注册页面。
     * 这确保了用户通过正确的流程（注册表单）进行注册，
     * 而不是直接访问注册 URL。</p>
     *
     * <p>此设计遵循了 Web 应用的最佳实践：注册表单通过 POST 方法提交，
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
        RoleNavigationUtil.redirectToPage(request, response, AppConstants.PAGE_REGISTER);
    }

    /**
     * 从请求中提取注册表单数据。
     *
     * <p>该方法从 HttpServletRequest 中提取所有注册相关的参数，
     * 并封装成一个 {@link RegistrationForm} 对象。使用数据传输对象（DTO）
     * 模式可以：</p>
     * <ul>
     *   <li>减少方法参数数量</li>
     *   <li>便于后续添加新的表单字段</li>
     *   <li>集中管理表单数据验证</li>
     * </ul>
     *
     * @param request HttpServletRequest 对象
     * @return 包含所有注册表单数据的 RegistrationForm 对象
     */
    private RegistrationForm extractRegistrationForm(HttpServletRequest request) {
        RegistrationForm form = new RegistrationForm();
        form.firstName = request.getParameter("firstName");
        form.lastName = request.getParameter("lastName");
        form.email = request.getParameter("email");
        form.password = request.getParameter("password");
        form.confirmPassword = request.getParameter("confirmPassword");
        form.role = request.getParameter("role");
        return form;
    }

    /**
     * 验证密码有效性。
     *
     * <p>检查密码是否满足基本要求：</p>
     * <ul>
     *   <li>密码不为 null</li>
     *   <li>密码与确认密码一致</li>
     * </ul>
     *
     * <p><b>扩展点：</b>在后续迭代中，可以添加以下验证：</p>
     * <ul>
     *   <li>最小/最大长度要求</li>
     *   <li>字符复杂度要求（大小写、数字、特殊字符）</li>
     *   <li>常见密码黑名单检查</li>
     * </ul>
     *
     * @param password        用户输入的密码
     * @param confirmPassword 用户输入的确认密码
     * @return 如果密码有效返回 true，否则返回 false
     */
    private boolean isPasswordValid(String password, String confirmPassword) {
        return password != null && password.equals(confirmPassword);
    }

    /**
     * 构建用户全名。
     *
     * <p>将用户的名字和姓氏组合成全名，中间用空格分隔。
     * 该方法处理以下情况：</p>
     * <ul>
     *   <li>如果名字和姓氏都存在，返回 "名 姓" 格式</li>
     *   <li>如果其中一个为 null，将 null 视为空字符串</li>
     * </ul>
     *
     * @param firstName 用户名字
     * @param lastName  用户姓氏
     * @return 用户全名
     */
    private String buildFullName(String firstName, String lastName) {
        String first = (firstName != null) ? firstName : "";
        String last = (lastName != null) ? lastName : "";
        return (first + " " + last).trim();
    }

    /**
     * 注册表单数据传输对象。
     *
     * <p>该内部类用于封装注册表单的所有字段，提供了一种
     * 结构化的方式来处理表单数据。使用 DTO 模式的优势包括：</p>
     * <ul>
     *   <li>代码可读性：字段名称清晰可见</li>
     *   <li>可扩展性：添加新字段只需修改此类</li>
     *   <li>便于验证：可以在此类中添加验证方法</li>
     *   <li>减少参数传递：避免方法参数过多</li>
     * </ul>
     *
     * <p><b>注意：</b>这是一个简单的数据容器类，字段直接访问，
     * 不提供 getter/setter 方法，以保持代码简洁。</p>
     */
    private static class RegistrationForm {
        /** 用户名字 */
        String firstName;

        /** 用户姓氏 */
        String lastName;

        /** 用户邮箱地址 */
        String email;

        /** 用户密码 */
        String password;

        /** 确认密码 */
        String confirmPassword;

        /** 用户角色 */
        String role;
    }
}
