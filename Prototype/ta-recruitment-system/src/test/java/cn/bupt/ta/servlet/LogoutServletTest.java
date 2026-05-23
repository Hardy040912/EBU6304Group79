package cn.bupt.ta.servlet;

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
import static org.junit.Assert.assertTrue;

public class LogoutServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private LogoutServlet servlet;
    private StringBuilder redirectLocation;
    private HttpServletResponse response;

    @Before
    public void setUp() throws Exception {
        servlet = new LogoutServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());
        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void getLogoutInvalidatesExistingSessionAndRedirectsToIndex() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        HttpSession session = ServletTestSupport.session(sessionAttributes);
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(), session);

        servlet.doGet(request, response);

        assertTrue((Boolean) sessionAttributes.get("__invalidated"));
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }

    @Test
    public void postLogoutUsesSameBehaviourAsGetLogout() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        HttpSession session = ServletTestSupport.session(sessionAttributes);
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(), session);

        servlet.doPost(request, response);

        assertTrue((Boolean) sessionAttributes.get("__invalidated"));
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }

    @Test
    public void logoutWithoutSessionStillRedirectsToIndex() throws Exception {
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(), null);

        servlet.doGet(request, response);

        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
