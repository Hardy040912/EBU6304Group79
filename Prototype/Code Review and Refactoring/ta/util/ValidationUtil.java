package cn.bupt.ta.util;

/**
 * 参数验证工具类。
 *
 * <p>该类提供了通用的参数验证方法，用于在方法入口处验证参数的有效性。
 * 通过使用这些验证方法，可以：</p>
 * <ul>
 *   <li>在方法开始时快速失败（fail-fast），避免无效参数导致的后续问题</li>
 *   <li>提供清晰、一致的错误消息</li>
 *   <li>减少重复的验证代码</li>
 *   <li>提高代码的可读性和可维护性</li>
 * </ul>
 *
 * <h2>使用示例</h2>
 * <pre>{@code
 * public void processUser(String name, String email, int age) {
 *     ValidationUtil.requireNonEmpty(name, "name");
 *     ValidationUtil.requireNonEmpty(email, "email");
 *     ValidationUtil.requirePositive(age, "age");
 *     // 处理用户逻辑...
 * }
 * }</pre>
 *
 * @author TA Recruitment System Team
 * @version 1.0
 * @since 1.0
 */
public final class ValidationUtil {

    /**
     * 私有构造函数，防止实例化。
     *
     * <p>这是一个纯静态工具类，不应该被实例化。
     * 将构造函数设为私有可以防止外部代码创建该类的实例。</p>
     */
    private ValidationUtil() {
        throw new UnsupportedOperationException("Utility class cannot be instantiated");
    }

    /**
     * 验证对象不为 null。
     *
     * <p>检查指定的对象是否为 null，如果为 null 则抛出
     * {@link IllegalArgumentException} 异常。</p>
     *
     * @param value     要验证的对象
     * @param paramName 参数名称，用于构建错误消息
     * @throws IllegalArgumentException 当 value 为 null 时抛出
     */
    public static void requireNonNull(Object value, String paramName) {
        if (value == null) {
            throw new IllegalArgumentException(paramName + " cannot be null");
        }
    }

    /**
     * 验证字符串不为空（不为 null 且不为空字符串）。
     *
     * <p>检查指定的字符串是否为 null 或空字符串（""），
     * 如果是则抛出 {@link IllegalArgumentException} 异常。</p>
     *
     * <p>注意：此方法不会去除字符串两端的空白字符。
     * 如果需要验证字符串非空白，请使用 {@link #requireNonBlank(String, String)}。</p>
     *
     * @param value     要验证的字符串
     * @param paramName 参数名称，用于构建错误消息
     * @throws IllegalArgumentException 当 value 为 null 或空字符串时抛出
     * @see #requireNonBlank(String, String)
     */
    public static void requireNonEmpty(String value, String paramName) {
        if (value == null || value.isEmpty()) {
            throw new IllegalArgumentException(paramName + " cannot be null or empty");
        }
    }

    /**
     * 验证字符串不为空白（不为 null 且不全是空白字符）。
     *
     * <p>检查指定的字符串是否为 null 或仅包含空白字符，
     * 如果是则抛出 {@link IllegalArgumentException} 异常。</p>
     *
     * <p>空白字符包括空格、制表符、换行符等。
     * 此方法使用 {@link String#trim()} 方法去除两端空白后判断是否为空。</p>
     *
     * @param value     要验证的字符串
     * @param paramName 参数名称，用于构建错误消息
     * @throws IllegalArgumentException 当 value 为 null 或仅包含空白字符时抛出
     */
    public static void requireNonBlank(String value, String paramName) {
        if (value == null || value.trim().isEmpty()) {
            throw new IllegalArgumentException(paramName + " cannot be null or blank");
        }
    }

    /**
     * 验证整数为正数（大于 0）。
     *
     * <p>检查指定的整数是否大于 0，如果不是则抛出
     * {@link IllegalArgumentException} 异常。</p>
     *
     * @param value     要验证的整数
     * @param paramName 参数名称，用于构建错误消息
     * @throws IllegalArgumentException 当 value 小于或等于 0 时抛出
     */
    public static void requirePositive(int value, String paramName) {
        if (value <= 0) {
            throw new IllegalArgumentException(paramName + " must be positive, but was: " + value);
        }
    }

    /**
     * 验证整数非负（大于或等于 0）。
     *
     * <p>检查指定的整数是否大于或等于 0，如果不是则抛出
     * {@link IllegalArgumentException} 异常。</p>
     *
     * @param value     要验证的整数
     * @param paramName 参数名称，用于构建错误消息
     * @throws IllegalArgumentException 当 value 小于 0 时抛出
     */
    public static void requireNonNegative(int value, String paramName) {
        if (value < 0) {
            throw new IllegalArgumentException(paramName + " cannot be negative, but was: " + value);
        }
    }

    /**
     * 验证条件为 true。
     *
     * <p>检查指定的条件是否为 true，如果为 false 则抛出
     * {@link IllegalArgumentException} 异常。常用于验证业务规则。</p>
     *
     * <h3>使用示例</h3>
     * <pre>{@code
     * // 验证密码匹配
     * ValidationUtil.requireTrue(
     *     password.equals(confirmPassword),
     *     "Passwords do not match"
     * );
     * }</pre>
     *
     * @param condition 要验证的条件
     * @param message   条件为 false 时的错误消息
     * @throws IllegalArgumentException 当 condition 为 false 时抛出
     */
    public static void requireTrue(boolean condition, String message) {
        if (!condition) {
            throw new IllegalArgumentException(message);
        }
    }

    /**
     * 验证两个字符串相等。
     *
     * <p>检查两个字符串是否相等（区分大小写），如果不相等则抛出
     * {@link IllegalArgumentException} 异常。该方法可以正确处理 null 值。</p>
     *
     * @param value1   第一个字符串
     * @param value2   第二个字符串
     * @param message  不相等时的错误消息
     * @throws IllegalArgumentException 当两个字符串不相等时抛出
     */
    public static void requireEquals(String value1, String value2, String message) {
        if (value1 == null ? value2 != null : !value1.equals(value2)) {
            throw new IllegalArgumentException(message);
        }
    }
}
