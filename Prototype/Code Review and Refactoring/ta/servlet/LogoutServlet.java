package cn.bupt.ta.servlet;

import cn.bupt.ta.util.RoleNavigationUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 用户注销 Servlet。
 *
 * <p>该 Servlet 负责处理用户注销请求，是系统身份验证流程的重要组成部分。
 * 它终止当前用户的会话，清除所有会话属性，并将用户重定向到首页，
 * 从而完成安全的注销流程。</p>
 *
 * <h2>功能概述</h2>
 * <ul>
 *   <li>获取当前用户的 HttpSession（如果存在）</li>
 *   <li>使会话失效，清除所有会话数据</li>
 *   <li>将用户重定向到首页</li>
 * </ul>
 *
 * <h2>URL 映射</h2>
 * <table border="1">
 *   <tr><th>HTTP 方法</th><th>URL 路径</th><th>功能描述</th></tr>
 *   <tr><td>GET</td><td>/logout</td><td>处理注销请求</td></tr>
 *   <tr><td>POST</td><td>/logout</td><td>处理注销请求（委托给 doGet）</td></tr>
 * </table>
 *
 * <h2>会话处理</h2>
 * <p>该 Servlet 使用 {@link HttpServletRequest#getSession(boolean)} 方法
 * 获取现有会话（参数为 false），而不是创建新会话。这确保了：</p>
 * <ul>
 *   <li>如果用户已登录，会话将被正确终止</li>
 *   <li>如果用户未登录（无会话），不会创建不必要的会话</li>
 * </ul>
 *
 * <h2>安全考虑</h2>
 * <p>注销操作是 Web 应用安全的重要组成部分。正确的注销实现应：</p>
 * <ul>
 *   <li>完全清除服务器端的会话数据</li>
 *   <li>使会话 Cookie 失效</li>
 *   <li>防止会话固定攻击</li>
 *   <li>重定向到公开页面</li>
 * </ul>
 *
 * <p>当前实现通过 {@link HttpSession#invalidate()} 方法完成了上述大部分要求。
 * 在生产环境中，还可以考虑：</p>
 * <ul>
 *   <li>记录注销日志（用于审计）</li>
 *   <li>清除客户端 Cookie</li>
 *   <li>在注销后显示确认消息</li>
 * </ul>
 *
 * <h2>使用示例</h2>
 * <p>在 JSP 页面中添加注销链接：</p>
 * <pre>{@code
 * <a href="${pageContext.request.contextPath}/logout">Logout</a>
 * }</pre>
 *
 * <p>或通过表单提交：</p>
 * <pre>{@code
 * <form action="${pageContext.request.contextPath}/logout" method="post">
 *     <button type="submit">Logout</button>
 * </form>
 * }</pre>
 *
 * @author TA Recruitment System Team
 * @version 1.0
 * @since 1.0
 * @see LoginServlet
 * @see RoleNavigationUtil
 */
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {

    /**
     * 序列化版本号。
     *
     * <p>用于确保序列化和反序列化时的版本兼容性。
     * 当类的结构发生变化时，应更新此版本号。</p>
     */
    private static final long serialVersionUID = 1L;

    /**
     * 处理 GET 请求 - 执行用户注销。
     *
     * <p>该方法处理注销请求，执行以下步骤：</p>
     * <ol>
     *   <li>获取当前用户的 HttpSession（不创建新会话）</li>
     *   <li>如果会话存在，使其失效</li>
     *   <li>将用户重定向到首页</li>
     * </ol>
     *
     * <p>使用 {@code request.getSession(false)} 而非 {@code request.getSession()}
     * 是一个重要的设计决策。传入 false 参数表示：</p>
     * <ul>
     *   <li>如果当前请求有关联的会话，返回该会话</li>
     *   <li>如果没有关联的会话，返回 null 而不是创建新会话</li>
     * </ul>
     *
     * <p>这种做法避免了在注销过程中创建不必要的会话，
     * 提高了系统的效率和安全性。</p>
     *
     * @param request  HttpServletRequest 对象，包含客户端请求信息
     * @param response HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 当 Servlet 处理过程中发生错误时抛出
     * @throws IOException      当 I/O 操作失败时抛出
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 步骤1：获取现有会话（不创建新会话）
        HttpSession session = request.getSession(false);

        // 步骤2：如果会话存在，使其失效
        if (session != null) {
            session.invalidate();
        }

        // 步骤3：重定向到首页
        RoleNavigationUtil.redirectToIndex(request, response);
    }

    /**
     * 处理 POST 请求 - 委托给 doGet 方法。
     *
     * <p>该方法允许通过 POST 请求执行注销操作，提供了更灵活的注销方式。
     * POST 请求通常用于表单提交，而注销操作可能通过表单按钮触发。</p>
     *
     * <p>该实现遵循了 Servlet 设计的最佳实践：对于幂等操作（如注销），
     * GET 和 POST 请求应产生相同的结果。通过将 POST 请求委托给
     * doGet 方法，确保了行为的一致性。</p>
     *
     * <p><b>设计说明：</b>虽然 GET 请求用于状态改变操作（如注销）
     * 在某些安全标准中不被推荐，但在实际应用中，注销操作通常
     * 被视为一种特殊情况，因为：</p>
     * <ul>
     *   <li>注销不会泄露敏感信息</li>
     *   <li>注销操作是幂等的（多次注销结果相同）</li>
     *   <li>提供 GET 方式的注销链接便于使用</li>
     * </ul>
     *
     * @param request  HttpServletRequest 对象，包含客户端请求信息
     * @param response HttpServletResponse 对象，用于向客户端发送响应
     * @throws ServletException 当 Servlet 处理过程中发生错误时抛出
     * @throws IOException      当 I/O 操作失败时抛出
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
