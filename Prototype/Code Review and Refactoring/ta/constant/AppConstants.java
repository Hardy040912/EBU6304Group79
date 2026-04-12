package cn.bupt.ta.constant;

/**
 * 应用程序常量定义类。
 *
 * <p>该类集中管理系统中使用的所有常量值，包括用户角色、
 * 会话属性名称、URL路径等。采用常量类的设计模式可以：
 * </p>
 * <ul>
 *   <li>避免硬编码字符串分散在代码各处</li>
 *   <li>便于统一管理和修改常量值</li>
 *   <li>减少因拼写错误导致的运行时错误</li>
 *   <li>提高代码的可维护性和可读性</li>
 * </ul>
 *
 * <p>所有常量均定义为 {@code public static final}，遵循 Java 常量命名规范，
 * 使用大写字母和下划线分隔单词。</p>
 *
 * @author TA Recruitment System Team
 * @version 1.0
 * @since 1.0
 */
public final class AppConstants {

    // ========================================
    // 用户角色常量
    // ========================================

    /**
     * 学生角色标识符。
     *
     * <p>学生用户可以浏览可用的 TA 职位、提交申请、
     * 查看申请状态等操作。</p>
     */
    public static final String ROLE_STUDENT = "student";

    /**
     * 模块组织者角色标识符。
     *
     * <p>模块组织者（Module Organiser）负责管理特定课程模块，
     * 可以发布 TA 职位、审核申请、选择候选人等操作。</p>
     */
    public static final String ROLE_MODULE_ORGANISER = "module-organiser";

    /**
     * 管理员角色标识符。
     *
     * <p>管理员拥有系统的最高权限，可以管理用户账户、
     * 审核模块组织者账户申请、查看系统统计信息等。</p>
     */
    public static final String ROLE_ADMIN = "admin";

    // ========================================
    // 会话属性名称常量
    // ========================================

    /**
     * 会话中存储用户邮箱的属性名称。
     *
     * <p>用户登录成功后，其邮箱地址会被存储在 HttpSession 中，
     * 用于后续的身份验证和用户信息获取。</p>
     */
    public static final String SESSION_USER_EMAIL = "userEmail";

    /**
     * 会话中存储用户全名的属性名称。
     *
     * <p>用户注册或登录成功后，其全名（名 + 姓）会被存储在
     * HttpSession 中，用于页面显示欢迎信息等。</p>
     */
    public static final String SESSION_USER_NAME = "userName";

    /**
     * 会话中存储用户角色的属性名称。
     *
     * <p>用户角色决定了用户可以访问的功能模块和页面，
     * 系统根据此属性进行权限控制和页面跳转。</p>
     */
    public static final String SESSION_USER_ROLE = "userRole";

    // ========================================
    // JSP 页面路径常量
    // ========================================

    /**
     * 首页（登录页）JSP 路径。
     *
     * <p>这是系统的入口页面，用户可以在此页面进行登录操作，
     * 或跳转到注册页面。</p>
     */
    public static final String PAGE_INDEX = "/index.jsp";

    /**
     * 注册页面 JSP 路径。
     *
     * <p>新用户可以在此页面创建账户，需要填写姓名、邮箱、
     * 密码并选择用户角色。</p>
     */
    public static final String PAGE_REGISTER = "/register.jsp";

    /**
     * 学生仪表板页面 JSP 路径。
     *
     * <p>学生登录后的主页面，显示可申请的 TA 职位列表、
     * 申请状态等信息。</p>
     */
    public static final String PAGE_STUDENT_DASHBOARD = "/student-dashboard.jsp";

    /**
     * 模块组织者仪表板页面 JSP 路径。
     *
     * <p>模块组织者登录后的主页面，显示管理的课程模块、
     * TA 职位发布、申请审核等功能。</p>
     */
    public static final String PAGE_MO_DASHBOARD = "/mo-dashboard.jsp";

    /**
     * 管理员仪表板页面 JSP 路径。
     *
     * <p>管理员登录后的主页面，显示用户管理、系统统计、
     * 审核功能等。</p>
     */
    public static final String PAGE_ADMIN_DASHBOARD = "/admin-dashboard.jsp";

    // ========================================
    // 错误参数常量
    // ========================================

    /**
     * 密码不匹配错误参数。
     *
     * <p>当用户注册时两次输入的密码不一致，
     * 重定向到注册页面时会携带此错误参数。</p>
     */
    public static final String ERROR_PASSWORD_MISMATCH = "password";

    /**
     * 私有构造函数，防止实例化。
     *
     * <p>这是一个纯静态常量类，不应该被实例化。
     * 将构造函数设为私有可以防止外部代码创建该类的实例。</p>
     */
    private AppConstants() {
        throw new UnsupportedOperationException("Constants class cannot be instantiated");
    }
}
