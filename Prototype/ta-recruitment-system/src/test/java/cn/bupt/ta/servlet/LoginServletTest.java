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

public class LoginServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private LoginServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private Map<String, Object> sessionAttributes;
    private StringBuilder redirectLocation;

    @Before
    public void setUp() throws Exception {
        servlet = new LoginServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());

        DataFileUtil.appendLine("users.txt", "alice@bupt.edu.cn|123456|student|Alice Chen");

        sessionAttributes = new HashMap<>();
        session = ServletTestSupport.session(sessionAttributes);
        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void validStudentLoginCreatesSessionAndRedirectsToStudentDashboard() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "email", "alice@bupt.edu.cn",
                "password", "123456",
                "role", "student"
        ), session);

        servlet.doPost(request, response);

        assertEquals("alice@bupt.edu.cn", sessionAttributes.get("userEmail"));
        assertEquals("student", sessionAttributes.get("userRole"));
        assertEquals("Alice Chen", sessionAttributes.get("userName"));
        assertEquals("/ta/student-dashboard.jsp", redirectLocation.toString());
    }

    @Test
    public void validModuleOrganiserLoginRedirectsToMoDashboard() throws Exception {
        DataFileUtil.appendLine("users.txt", "mo@bupt.edu.cn|123456|module-organiser|Dr Smith");
        request = ServletTestSupport.request(ServletTestSupport.params(
                "email", "mo@bupt.edu.cn",
                "password", "123456",
                "role", "module-organiser"
        ), session);

        servlet.doPost(request, response);

        assertEquals("mo@bupt.edu.cn", sessionAttributes.get("userEmail"));
        assertEquals("module-organiser", sessionAttributes.get("userRole"));
        assertEquals("Dr Smith", sessionAttributes.get("userName"));
        assertEquals("/ta/mo-dashboard.jsp", redirectLocation.toString());
    }

    @Test
    public void validAdminLoginRedirectsToAdminDashboard() throws Exception {
        DataFileUtil.appendLine("users.txt", "admin@bupt.edu.cn|123456|admin|Administrator");
        request = ServletTestSupport.request(ServletTestSupport.params(
                "email", "admin@bupt.edu.cn",
                "password", "123456",
                "role", "admin"
        ), session);

        servlet.doPost(request, response);

        assertEquals("admin@bupt.edu.cn", sessionAttributes.get("userEmail"));
        assertEquals("admin", sessionAttributes.get("userRole"));
        assertEquals("Administrator", sessionAttributes.get("userName"));
        assertEquals("/ta/admin-dashboard.jsp", redirectLocation.toString());
    }

    @Test
    public void invalidLoginRedirectsWithErrorFlag() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "email", "alice@bupt.edu.cn",
                "password", "wrong",
                "role", "student"
        ), session);

        servlet.doPost(request, response);

        assertEquals("/ta/index.jsp?error=1", redirectLocation.toString());
    }

    @Test
    public void getLoginRedirectsToIndexPage() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(), session);

        servlet.doGet(request, response);

        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
