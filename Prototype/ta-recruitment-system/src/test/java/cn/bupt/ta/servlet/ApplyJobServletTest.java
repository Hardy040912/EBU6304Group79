package cn.bupt.ta.servlet;

import cn.bupt.ta.util.DataFileUtil;
import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.nio.charset.StandardCharsets;
import java.util.Base64;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class ApplyJobServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private ApplyJobServlet servlet;
    private HttpServletRequest request;
    private HttpServletResponse response;
    private HttpSession session;
    private StringBuilder redirectLocation;

    @Before
    public void setUp() throws Exception {
        servlet = new ApplyJobServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());

        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void unauthenticatedStudentIsRedirectedToLoginPage() throws Exception {
        request = ServletTestSupport.request(new HashMap<>(), null);

        servlet.doPost(request, response);

        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }

    @Test
    public void validApplicationIsStoredWithEncodedCoverLetter() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        sessionAttributes.put("userName", "Alice Chen");
        sessionAttributes.put("userRole", "student");
        session = ServletTestSupport.session(sessionAttributes);
        request = ServletTestSupport.request(ServletTestSupport.params(
                "jobId", "j1",
                "coverLetter", "I can help with Java labs."
        ), session);

        servlet.doPost(request, response);

        List<String> applications = DataFileUtil.readLines("applications.txt");
        assertEquals(1, applications.size());
        String[] parts = applications.get(0).split("\\|");
        assertEquals("app1", parts[0]);
        assertEquals("j1", parts[1]);
        assertEquals("alice@bupt.edu.cn", parts[2]);
        assertEquals("Alice Chen", parts[3]);
        assertEquals("pending", parts[5]);
        assertEquals("false", parts[7]);
        String encodedCoverLetter = "B64:" + Base64.getEncoder()
                .encodeToString("I can help with Java labs.".getBytes(StandardCharsets.UTF_8));
        assertEquals(encodedCoverLetter, parts[4]);
        assertTrue(parts[6].matches("\\d{4}-\\d{2}-\\d{2}"));
        assertEquals("/ta/student-applications.jsp", redirectLocation.toString());
    }

    @Test
    public void emptyCoverLetterRedirectsBackToJobListWithoutSaving() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        sessionAttributes.put("userName", "Alice Chen");
        sessionAttributes.put("userRole", "student");
        session = ServletTestSupport.session(sessionAttributes);
        request = ServletTestSupport.request(ServletTestSupport.params(
                "jobId", "j1",
                "coverLetter", "   "
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("applications.txt").size());
        assertEquals("/ta/student-jobs.jsp", redirectLocation.toString());
    }

    @Test
    public void missingJobIdRedirectsBackToJobListWithoutSaving() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        sessionAttributes.put("userName", "Alice Chen");
        sessionAttributes.put("userRole", "student");
        session = ServletTestSupport.session(sessionAttributes);
        request = ServletTestSupport.request(ServletTestSupport.params(
                "coverLetter", "I can help."
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("applications.txt").size());
        assertEquals("/ta/student-jobs.jsp", redirectLocation.toString());
    }

    @Test
    public void nonStudentCannotApplyForJob() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "dr.smith@bupt.edu.cn");
        sessionAttributes.put("userName", "Dr Smith");
        sessionAttributes.put("userRole", "module-organiser");
        session = ServletTestSupport.session(sessionAttributes);
        request = ServletTestSupport.request(ServletTestSupport.params(
                "jobId", "j1",
                "coverLetter", "I should not be able to apply."
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.readLines("applications.txt").size());
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
