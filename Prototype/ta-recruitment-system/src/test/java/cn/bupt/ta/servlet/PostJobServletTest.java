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
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class PostJobServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private PostJobServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private StringBuilder redirectLocation;

    @Before
    public void setUp() throws Exception {
        servlet = new PostJobServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());

        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "dr.smith@bupt.edu.cn");
        sessionAttributes.put("userName", "Dr Smith");
        sessionAttributes.put("userRole", "module-organiser");
        session = ServletTestSupport.session(sessionAttributes);
        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void postJobStoresOpenJobForCurrentOrganiser() throws Exception {
        request = ServletTestSupport.request(ServletTestSupport.params(
                "title", "Web Development Tutor",
                "moduleCode", "CS302",
                "moduleName", "Web Technologies",
                "description", "Support lab sessions",
                "skills", "JavaScript,JSP",
                "hoursPerWeek", "10",
                "duration", "16 weeks"
        ), session);

        servlet.doPost(request, response);

        List<String> jobs = DataFileUtil.readLines("jobs.txt");
        assertEquals(1, jobs.size());
        String[] parts = jobs.get(0).split("\\|");
        assertEquals("Web Development Tutor", parts[1]);
        assertEquals("CS302", parts[2]);
        assertEquals("Dr Smith", parts[4]);
        assertEquals("dr.smith@bupt.edu.cn", parts[5]);
        assertEquals("open", parts[10]);
        assertTrue(parts[0].contains("_"));
        assertEquals("/ta/mo-dashboard.jsp?success=1", redirectLocation.toString());
    }

    @Test
    public void nonOrganiserCannotPostJob() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        sessionAttributes.put("userName", "Alice");
        sessionAttributes.put("userRole", "student");
        session = ServletTestSupport.session(sessionAttributes);
        request = ServletTestSupport.request(ServletTestSupport.params(
                "title", "Invalid",
                "moduleCode", "CS000",
                "moduleName", "Invalid",
                "description", "Invalid",
                "skills", "Java",
                "hoursPerWeek", "10",
                "duration", "4 weeks"
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("jobs.txt").size());
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
