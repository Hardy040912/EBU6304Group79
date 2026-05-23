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

public class UpdateProfileServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private UpdateProfileServlet servlet;
    private StringBuilder redirectLocation;
    private HttpServletResponse response;

    @Before
    public void setUp() throws Exception {
        servlet = new UpdateProfileServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());
        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void authenticatedStudentProfileUpdateStoresSkillsAndExperienceInSession() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        HttpSession session = ServletTestSupport.session(sessionAttributes);
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(
                "skills", "TECH:Java,JSP|LANG:English,Chinese",
                "experience", "Education:\nBUPT Software Engineering"
        ), session);

        servlet.doPost(request, response);

        assertEquals("TECH:Java,JSP|LANG:English,Chinese", sessionAttributes.get("userSkills"));
        assertEquals("Education:\nBUPT Software Engineering", sessionAttributes.get("userExperience"));
        assertEquals("/ta/student-profile.jsp?success=1", redirectLocation.toString());
    }

    @Test
    public void anonymousProfileUpdateRedirectsToLoginPage() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        HttpSession session = ServletTestSupport.session(sessionAttributes);
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(
                "skills", "Java",
                "experience", "Teaching"
        ), session);

        servlet.doPost(request, response);

        assertEquals(null, sessionAttributes.get("userSkills"));
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
