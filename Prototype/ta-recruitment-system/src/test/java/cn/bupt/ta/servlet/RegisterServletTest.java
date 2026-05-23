package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class RegisterServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private RegisterServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private Map<String, Object> sessionAttributes;
    private StringBuilder redirectLocation;

    @Before
    public void setUp() throws Exception {
        servlet = new RegisterServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());
        DataFileUtil.appendLine("staff_ids.txt", "T1001|Li Si");

        sessionAttributes = new HashMap<>();
        session = ServletTestSupport.session(sessionAttributes);
        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void matchingPasswordsCreateUserAndLoginSession() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "firstName", "Alice",
                "lastName", "Chen",
                "email", "alice@bupt.edu.cn",
                "password", "123456",
                "confirmPassword", "123456",
                "role", "student"
        ), session);

        servlet.doPost(request, response);

        assertEquals("alice@bupt.edu.cn|123456|student|Alice Chen", DataFileUtil.readLines("users.txt").get(0));
        assertEquals("alice@bupt.edu.cn", sessionAttributes.get("userEmail"));
        assertEquals("Alice Chen", sessionAttributes.get("userName"));
        assertEquals("student", sessionAttributes.get("userRole"));
        assertEquals("/ta/student-dashboard.jsp", redirectLocation.toString());
    }

    @Test
    public void moduleOrganiserRegistrationRedirectsToMoDashboard() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "firstName", "Li",
                "lastName", "Si",
                "email", "li.si@bupt.edu.cn",
                "password", "123456",
                "confirmPassword", "123456",
                "role", "module-organiser",
                "staffId", "T1001"
        ), session);

        servlet.doPost(request, response);

        assertEquals("li.si@bupt.edu.cn|123456|module-organiser|Li Si|T1001", DataFileUtil.readLines("users.txt").get(0));
        assertEquals("module-organiser", sessionAttributes.get("userRole"));
        assertEquals("T1001", sessionAttributes.get("staffId"));
        assertEquals("/ta/mo-dashboard.jsp", redirectLocation.toString());
    }

    @Test
    public void duplicateEmailRegistrationIsRejected() throws Exception {
        DataFileUtil.appendLine("users.txt", "alice@bupt.edu.cn|123456|student|Alice Chen");
        request = ServletTestSupport.request(ServletTestSupport.params(
                "firstName", "Alice",
                "lastName", "Duplicate",
                "email", "alice@bupt.edu.cn",
                "password", "123456",
                "confirmPassword", "123456",
                "role", "student"
        ), session);

        servlet.doPost(request, response);

        assertEquals(1, DataFileUtil.readLines("users.txt").size());
        assertEquals("/ta/register.jsp?error=duplicate", redirectLocation.toString());
    }

    @Test
    public void moduleOrganiserRegistrationRequiresValidStaffId() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "firstName", "Invalid",
                "lastName", "MO",
                "email", "invalid.mo@bupt.edu.cn",
                "password", "123456",
                "confirmPassword", "123456",
                "role", "module-organiser",
                "staffId", "BAD-ID"
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("users.txt").size());
        assertEquals("/ta/register.jsp?error=staff", redirectLocation.toString());
    }

    @Test
    public void adminRegistrationIsRejectedBecauseSchoolProvidesAdminAccounts() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "firstName", "Admin",
                "lastName", "User",
                "email", "admin@bupt.edu.cn",
                "password", "123456",
                "confirmPassword", "123456",
                "role", "admin"
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("users.txt").size());
        assertEquals("/ta/register.jsp?error=role", redirectLocation.toString());
    }

    @Test
    public void unknownRoleRegistrationIsRejected() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "firstName", "Test",
                "lastName", "User",
                "email", "test@bupt.edu.cn",
                "password", "123456",
                "confirmPassword", "123456",
                "role", "guest"
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("users.txt").size());
        assertEquals("/ta/register.jsp?error=role", redirectLocation.toString());
    }

    @Test
    public void passwordMismatchRedirectsBackToRegisterPage() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "password", "123456",
                "confirmPassword", "different",
                "role", "student"
        ), session);

        servlet.doPost(request, response);

        assertEquals("/ta/register.jsp?error=password", redirectLocation.toString());
    }

    @Test
    public void getRegisterRedirectsToRegisterPage() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(), session);

        servlet.doGet(request, response);

        assertEquals("/ta/register.jsp", redirectLocation.toString());
    }
}
