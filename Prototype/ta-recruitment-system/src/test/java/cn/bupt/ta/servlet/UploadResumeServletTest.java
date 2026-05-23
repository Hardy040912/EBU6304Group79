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
import java.util.Properties;

import static org.junit.Assert.assertEquals;

public class UploadResumeServletTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    private UploadResumeServlet servlet;
    private StringBuilder redirectLocation;
    private HttpServletResponse response;

    @Before
    public void setUp() throws Exception {
        servlet = new UploadResumeServlet();
        ServletTestSupport.initServlet(servlet, temporaryFolder.getRoot());
        redirectLocation = new StringBuilder();
        response = ServletTestSupport.response(redirectLocation);
    }

    @Test
    public void authenticatedStudentResumeUploadStoresProfileProperties() throws Exception {
        Map<String, Object> sessionAttributes = new HashMap<>();
        sessionAttributes.put("userEmail", "alice@bupt.edu.cn");
        HttpSession session = ServletTestSupport.session(sessionAttributes);
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(
                "phone", "123456",
                "major", "Software Engineering",
                "year", "Year 3",
                "gpa", "85",
                "portfolio", "https://example.com",
                "education", "BUPT",
                "technicalSkills", "Java,JSP",
                "languageSkills", "English,Chinese",
                "certifications", "Oracle Java",
                "teachingExp", "Java lab helper",
                "projectExp", "Recruitment system",
                "personalStatement", "Careful and reliable"
        ), session);

        servlet.doPost(request, response);

        Properties resume = DataFileUtil.loadResume("alice@bupt.edu.cn");
        assertEquals("123456", resume.getProperty("phone"));
        assertEquals("Software Engineering", resume.getProperty("major"));
        assertEquals("Java,JSP", resume.getProperty("technicalSkills"));
        assertEquals("Careful and reliable", resume.getProperty("personalStatement"));
        assertEquals("/ta/student-profile.jsp?success=2", redirectLocation.toString());
    }

    @Test
    public void anonymousResumeUploadRedirectsToIndexWithoutSavingProfile() throws Exception {
        HttpSession session = ServletTestSupport.session(new HashMap<>());
        HttpServletRequest request = ServletTestSupport.request(ServletTestSupport.params(
                "major", "Software Engineering"
        ), session);

        servlet.doPost(request, response);

        assertEquals(0, DataFileUtil.loadResume("anonymous@bupt.edu.cn").size());
        assertEquals("/ta/index.jsp", redirectLocation.toString());
    }
}
