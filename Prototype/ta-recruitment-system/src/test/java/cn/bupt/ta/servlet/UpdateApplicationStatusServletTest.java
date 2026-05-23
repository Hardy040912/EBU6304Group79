package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;

public class UpdateApplicationStatusServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private UpdateApplicationStatusServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private StringBuilder redirectLocation;

    @Before
    public void setUp() throws Exception {
        servlet = new UpdateApplicationStatusServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());

        DataFileUtil.writeLines("applications.txt", Arrays.asList(
                "app1|j1|alice@bupt.edu.cn|Alice|B64:first|pending|2026-05-20|false",
                "app2|j2|bob@bupt.edu.cn|Bob|B64:second|pending|2026-05-20"
        ));

        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userRole", "module-organiser");
        sessionAttributes.put("userEmail", "mo@bupt.edu.cn");
        session = ServletTestSupport.session(sessionAttributes);
    }

    @Test
    public void rejectedApplicationCanBeBlockedAndLegacyRowsKeepBlockedFlag() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "appId", "app1",
                "status", "rejected",
                "blocked", "true"
        ), session);

        servlet.doPost(request, response);

        List<String> applications = DataFileUtil.readLines("applications.txt");
        assertEquals("app1|j1|alice@bupt.edu.cn|Alice|B64:first|rejected|2026-05-20|true", applications.get(0));
        assertEquals("app2|j2|bob@bupt.edu.cn|Bob|B64:second|pending|2026-05-20|false", applications.get(1));
        assertEquals("/ta/mo-applications.jsp?success=1", redirectLocation.toString());
    }

    @Test
    public void acceptedApplicationUpdatesStatusWithoutBlocking() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "appId", "app1",
                "status", "accepted"
        ), session);

        servlet.doPost(request, response);

        List<String> applications = DataFileUtil.readLines("applications.txt");
        assertEquals("app1|j1|alice@bupt.edu.cn|Alice|B64:first|accepted|2026-05-20|false", applications.get(0));
        assertEquals("app2|j2|bob@bupt.edu.cn|Bob|B64:second|pending|2026-05-20|false", applications.get(1));
        assertEquals("/ta/mo-applications.jsp?success=1", redirectLocation.toString());
    }

    @Test
    public void nonMatchingApplicationIdKeepsRowsButNormalizesLegacyBlockedFlag() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "appId", "missing",
                "status", "accepted"
        ), session);

        servlet.doPost(request, response);

        List<String> applications = DataFileUtil.readLines("applications.txt");
        assertEquals("app1|j1|alice@bupt.edu.cn|Alice|B64:first|pending|2026-05-20|false", applications.get(0));
        assertEquals("app2|j2|bob@bupt.edu.cn|Bob|B64:second|pending|2026-05-20|false", applications.get(1));
        assertEquals("/ta/mo-applications.jsp?success=1", redirectLocation.toString());
    }

    @Test
    public void nonOrganiserCannotUpdateApplicationStatus() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userRole", "student");
        session = ServletTestSupport.session(sessionAttributes);
        request = ServletTestSupport.request(ServletTestSupport.params(
                "appId", "app1",
                "status", "accepted"
        ), session);

        servlet.doPost(request, response);

        List<String> applications = DataFileUtil.readLines("applications.txt");
        assertEquals("app1|j1|alice@bupt.edu.cn|Alice|B64:first|pending|2026-05-20|false", applications.get(0));
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
