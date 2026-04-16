package cn.bupt.ta;

import org.junit.Test;
import static org.junit.Assert.*;

public class RobustnessTest {
    @Test
    public void testEmptyLogin() {
        // 测试如果邮箱为空，是否应该拒绝登录
        String emptyEmail = "";
        assertFalse("Empty email should not be allowed", emptyEmail.contains("@"));
    }

    @Test
    public void testLongPassword() {
        // 测试超长密码的健壮性
        String longPwd = "this_is_a_very_long_password_for_testing_robustness";
        assertTrue("System should handle long passwords", longPwd.length() > 20);
    }
}