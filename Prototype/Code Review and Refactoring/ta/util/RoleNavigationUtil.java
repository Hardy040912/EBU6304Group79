package cn.bupt.ta.util;

import cn.bupt.ta.constant.AppConstants;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 角色导航工具类。
 *
 * <p>该类提供了与用户角色相关的导航和会话管理功能，
 * 主要用于处理用户登录后的页面跳转逻辑。通过将跳转逻辑
 * 集中管理，实现了以下目标：</p>
 * <ul>
 *   <li>消除重复代码：多个 Servlet 中的跳转逻辑被统一处理</li>
 *   <li>提高可维护性：修改跳转逻辑只需修改一处</li>
 *   <li>增强可扩展性：新增角色只需添加对应的映射关系</li>
 *   <li>简化测试：跳转逻辑独立，便于单元测试</li>
 * </ul>
 *
 * <p>该类采用静态方法设计，所有方法均为线程安全的，
 * 因为它们只操作方法参数传入的对象，不共享可变状态。</p>
 *
 * <h2>使用示例</h2>
 * <pre>{@code
 * // 根据角色跳转到对应页面
 * RoleNavigationUtil.redirectByRole(request, response, "student");
 *
 * // 设置用户会话属性
 * RoleNavigationUtil.setUserSession(session, "user@example.com", "John Doe", "student");
 * }</pre>
 *
 * @author TA Recruitment System Team
 * @version 1.0
 * @since 1.0
 * @see AppConstants
 */
public final class RoleNavigationUtil {

    /**
     * 私有构造函数，防止实例化。
     *
     * <p>这是一个纯静态工具类，不应该被实例化。
     * 将构造函数设为私有可以防止外部代码创建该类的实例。</p>
     */
    private RoleNavigationUtil() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }

    /**
     * 根据用户角色重定向到对应的仪表板页面。
     *
     * <p>该方法根据传入的角色字符串，将用户重定向到相应的仪表板页面。
     * 支持的角色包括学生、模块组织者和管理员。如果角色无法识别，
     * 则重定向到首页。</p>
     *
     * <h3>角色与页面映射关系</h3>
     * <table border="1">
     *   <tr><th>角色</th><th>目标页面</th></tr>
     *   <tr><td>student</td><td>学生仪表板</td></tr>
     *   <tr><td>module-organiser</td><td>模块组织者仪表板</td></tr>
     *   <tr><td>admin</td><td>管理员仪表板</td></tr>
     *   <tr><td>其他/未知</td><td>首页</td></tr>
     * </table>
     *
     * @param request  HttpServletRequest 对象，用于获取上下文路径
     * @param response HttpServletResponse 对象，用于执行重定向操作
     * @param role     用户角色字符串，应为 {@link AppConstants} 中定义的角色常量之一
     * @throws IOException 当重定向操作发生 I/O 错误时抛出
     * @throws IllegalArgumentException 当 request 或 response 为 null 时抛出
     * @see AppConstants#ROLE_STUDENT
     * @see AppConstants#ROLE_MODULE_ORGANISER
     * @see AppConstants#ROLE_ADMIN
     */
    public static void redirectByRole(HttpServletRequest request,
                                      HttpServletResponse response,
                                      String role) throws IOException {
        validateRequestResponse(request, response);

        String targetPage = determineTargetPage(role);
        response.sendRedirect(request.getContextPath() + targetPage);
    }

    /**
     * 根据角色确定目标页面路径。
     *
     * <p>这是一个内部辅助方法，封装了角色到页面的映射逻辑。
     * 使用 if-else 链而非 switch 语句，以便于后续扩展和添加
     * 更复杂的角色判断逻辑。</p>
     *
     * @param role 用户角色字符串
     * @return 对应的目标页面路径，如果角色无法识别则返回首页路径
     */
    private static String determineTargetPage(String role) {
        if (AppConstants.ROLE_STUDENT.equals(role)) {
            return AppConstants.PAGE_STUDENT_DASHBOARD;
        } else if (AppConstants.ROLE_MODULE_ORGANISER.equals(role)) {
            return AppConstants.PAGE_MO_DASHBOARD;
        } else if (AppConstants.ROLE_ADMIN.equals(role)) {
            return AppConstants.PAGE_ADMIN_DASHBOARD;
        } else {
            return AppConstants.PAGE_INDEX;
        }
    }

    /**
     * 设置用户会话属性。
     *
     * <p>在用户登录或注册成功后调用此方法，将用户的基本信息
     * 存储到会话中，以便后续请求可以访问这些信息。</p>
     *
     * <h3>存储的会话属性</h3>
     * <ul>
     *   <li>{@link AppConstants#SESSION_USER_EMAIL} - 用户邮箱</li>
     *   <li>{@link AppConstants#SESSION_USER_NAME} - 用户全名</li>
     *   <li>{@link AppConstants#SESSION_USER_ROLE} - 用户角色</li>
     * </ul>
     *
     * @param session  HttpSession 对象，用于存储用户信息
     * @param email    用户邮箱地址
     * @param fullName 用户全名（名 + 姓）
     * @param role     用户角色
     * @throws IllegalArgumentException 当 session 为 null 时抛出
     * @see AppConstants#SESSION_USER_EMAIL
     * @see AppConstants#SESSION_USER_NAME
     * @see AppConstants#SESSION_USER_ROLE
     */
    public static void setUserSession(HttpSession session,
                                      String email,
                                      String fullName,
                                      String role) {
        if (session == null) {
            throw new IllegalArgumentException("Session cannot be null");
        }

        session.setAttribute(AppConstants.SESSION_USER_EMAIL, email);
        session.setAttribute(AppConstants.SESSION_USER_NAME, fullName);
        session.setAttribute(AppConstants.SESSION_USER_ROLE, role);
    }

    /**
     * 设置用户会话属性（不包含用户名）。
     *
     * <p>这是 {@link #setUserSession(HttpSession, String, String, String)}
     * 的重载版本，用于登录场景，此时可能不需要设置用户全名。</p>
     *
     * @param session HttpSession 对象，用于存储用户信息
     * @param email   用户邮箱地址
     * @param role    用户角色
     * @throws IllegalArgumentException 当 session 为 null 时抛出
     */
    public static void setUserSession(HttpSession session,
                                      String email,
                                      String role) {
        setUserSession(session, email, null, role);
    }

    /**
     * 重定向到指定页面。
     *
     * <p>这是一个通用的重定向方法，封装了获取上下文路径和
     * 执行重定向的逻辑，简化 Servlet 中的重定向代码。</p>
     *
     * @param request    HttpServletRequest 对象
     * @param response   HttpServletResponse 对象
     * @param targetPage 目标页面路径，应为 {@link AppConstants} 中定义的页面常量
     * @throws IOException 当重定向操作发生 I/O 错误时抛出
     * @throws IllegalArgumentException 当 request 或 response 为 null 时抛出
     */
    public static void redirectToPage(HttpServletRequest request,
                                      HttpServletResponse response,
                                      String targetPage) throws IOException {
        validateRequestResponse(request, response);

        response.sendRedirect(request.getContextPath() + targetPage);
    }

    /**
     * 重定向到首页。
     *
     * <p>便捷方法，用于将用户重定向到系统首页（登录页）。
     * 常用于注销操作或访问被拒绝时的跳转。</p>
     *
     * @param request  HttpServletRequest 对象
     * @param response HttpServletResponse 对象
     * @throws IOException 当重定向操作发生 I/O 错误时抛出
     */
    public static void redirectToIndex(HttpServletRequest request,
                                       HttpServletResponse response) throws IOException {
        redirectToPage(request, response, AppConstants.PAGE_INDEX);
    }

    /**
     * 重定向到注册页面并携带错误参数。
     *
     * <p>当注册过程中发生错误（如密码不匹配）时，
     * 使用此方法重定向到注册页面并显示相应的错误信息。</p>
     *
     * @param request     HttpServletRequest 对象
     * @param response    HttpServletResponse 对象
     * @param errorType   错误类型，应为 {@link AppConstants} 中定义的错误常量
     * @throws IOException 当重定向操作发生 I/O 错误时抛出
     */
    public static void redirectToRegisterWithError(HttpServletRequest request,
                                                   HttpServletResponse response,
                                                   String errorType) throws IOException {
        validateRequestResponse(request, response);

        String redirectUrl = request.getContextPath() + AppConstants.PAGE_REGISTER
                + "?error=" + errorType;
        response.sendRedirect(redirectUrl);
    }

    /**
     * 验证 request 和 response 参数是否有效。
     *
     * <p>这是一个内部辅助方法，用于在执行操作前验证必要的参数。
     * 如果参数无效，将抛出 {@link IllegalArgumentException}。</p>
     *
     * @param request  HttpServletRequest 对象
     * @param response HttpServletResponse 对象
     * @throws IllegalArgumentException 当 request 或 response 为 null 时抛出
     */
    private static void validateRequestResponse(HttpServletRequest request,
                                                HttpServletResponse response) {
        if (request == null) {
            throw new IllegalArgumentException("HttpServletRequest cannot be null");
        }
        if (response == null) {
            throw new IllegalArgumentException("HttpServletResponse cannot be null");
        }
    }
}
