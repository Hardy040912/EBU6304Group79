package cn.bupt.ta.listener;

import cn.bupt.ta.util.DataFileUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.util.Properties;

@WebListener
public class DataInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String webAppPath = sce.getServletContext().getRealPath("/");
        DataFileUtil.initDataDir(webAppPath);

        createFileIfNotExists("users.txt", getDefaultUsers());
        createFileIfNotExists("staff_ids.txt", getDefaultStaffIds());
        createFileIfNotExists("jobs.txt", getDefaultJobs());
        createFileIfNotExists("applications.txt", getDefaultApplications());
        createDefaultResumeIfMissing();

        System.out.println("Data directory initialized.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 清理资源（如果需要）
    }
    
    private void createFileIfNotExists(String fileName, String content) {
        if (DataFileUtil.readLines(fileName).isEmpty()) {
            DataFileUtil.appendLine(fileName, content.trim());
        }
    }
    
    private String getDefaultUsers() {
        return "# 格式: email|password|role|name|staffId(optional)\n" +
               "student@bupt.edu.cn|123456|student|Zhang San\n" +
               "mo@bupt.edu.cn|123456|module-organiser|Li Si|T1001\n" +
               "admin@bupt.edu.cn|123456|admin|Wang Wu\n";
    }

    private String getDefaultStaffIds() {
        return "# 格式: staffId|name\n" +
               "T1001|Li Si\n" +
               "T1002|Dr Smith\n" +
               "T1003|Dr Wang\n";
    }
    
    private String getDefaultJobs() {
        return "# 格式: jobId|title|moduleCode|module|organiser|organiserId|description|skills|hoursPerWeek|duration|status\n" +
               "j1|Programming Lab Teaching Assistant|EBU6304|Software Engineering Group Project|Li Si|mo@bupt.edu.cn|Support weekly software engineering labs, answer Java/JSP questions, and help students prepare Agile deliverables.|Java,JSP,Servlet,Agile,Testing|8|12 weeks|open\n" +
               "j2|Machine Learning Lab Assistant|EBU6602|Artificial Intelligence and Machine Learning|Li Si|mo@bupt.edu.cn|Assist students with Python notebooks, model evaluation, and troubleshooting machine learning lab exercises.|Python,Machine Learning,Data Analysis,Teaching|6|10 weeks|open\n" +
               "j3|Web Development Coursework Tutor|EBU6405|Web Programming|Li Si|mo@bupt.edu.cn|Provide drop-in support for HTML, CSS, JavaScript, backend integration, and coursework debugging.|JavaScript,HTML,CSS,Web Development,Communication|5|8 weeks|open\n";
    }
    
    private String getDefaultApplications() {
        return "# 格式: appId|jobId|studentEmail|studentName|coverLetter|status|applyDate|blocked\n" +
               "app1|j1|student@bupt.edu.cn|Zhang San|B64:PDw8VEFfUFJPRklMRT4+PgpaSEFORyBTQU4Kc3R1ZGVudEBidXB0LmVkdS5jbgpQaG9uZTogMTM4MDAwMDAwMDAKTWFqb3I6IFNvZnR3YXJlIEVuZ2luZWVyaW5nClllYXIgb2YgU3R1ZHk6IFllYXIgMwpHUEEgLyBBdmVyYWdlIFNjb3JlOiA4OC8xMDAKTGlua2VkSW4gLyBQb3J0Zm9saW86IGh0dHBzOi8vZXhhbXBsZS5jb20vc3R1ZGVudC1wb3J0Zm9saW8KClNLSUxMUwpUZWNobmljYWw6IEphdmEsIEpTUCwgU2VydmxldCwgUHl0aG9uLCBKYXZhU2NyaXB0LCBUZXN0aW5nCkxhbmd1YWdlczogRW5nbGlzaCwgTWFuZGFyaW4KCkVEVUNBVElPTgpCVVBUIEludGVybmF0aW9uYWwgU2Nob29sLCBCU2MgU29mdHdhcmUgRW5naW5lZXJpbmcuCgpURUFDSElORyAvIFRVVE9SSU5HIEVYUEVSSUVOQ0UKSGVscGVkIGNsYXNzbWF0ZXMgZGVidWcgSmF2YSBjb3Vyc2V3b3JrIGFuZCBleHBsYWluZWQgbGFiIGV4ZXJjaXNlcyBkdXJpbmcgZ3JvdXAgc3R1ZHkgc2Vzc2lvbnMuCgpQUk9KRUNUIC8gUkVTRUFSQ0ggRVhQRVJJRU5DRQpCdWlsdCBhIEphdmEgU2VydmxldC9KU1AgcmVjcnVpdG1lbnQgc3lzdGVtIHVzaW5nIHRleHQtZmlsZSBwZXJzaXN0ZW5jZSBhbmQgSlVuaXQgdGVzdHMuCgpBV0FSRFMgLyBDRVJUSUZJQ0FURVMKQWdpbGUgcHJvamVjdCB0ZWFtd29yaywgSmF2YSB3ZWIgY291cnNld29yawoKU1VNTUFSWQpJbnRlcmVzdGVkIGluIHN1cHBvcnRpbmcgc3R1ZGVudHMgd2l0aCBwcm9ncmFtbWluZyBsYWJzLCBkZWJ1Z2dpbmcsIGFuZCBzb2Z0d2FyZSBlbmdpbmVlcmluZyB0ZWFtd29yay4KPDw8VEFfQ09WRVI+Pj4KRGVhciBMaSBTaSwKCkkgYW0gd3JpdGluZyB0byBhcHBseSBmb3IgdGhlIFByb2dyYW1taW5nIExhYiBUZWFjaGluZyBBc3Npc3RhbnQgcG9zaXRpb24gZm9yIEVCVTYzMDQgU29mdHdhcmUgRW5naW5lZXJpbmcgR3JvdXAgUHJvamVjdC4gSSBoYXZlIHN0cm9uZyBleHBlcmllbmNlIHdpdGggSmF2YSwgSlNQLCBTZXJ2bGV0IGRldmVsb3BtZW50LCB0ZXN0aW5nLCBhbmQgQWdpbGUgdGVhbXdvcmsuCgpJIGFtIGludGVyZXN0ZWQgaW4gdGhpcyByb2xlIGJlY2F1c2UgSSBlbmpveSBoZWxwaW5nIGNsYXNzbWF0ZXMgZGVidWcgY29kZSBhbmQgdW5kZXJzdGFuZCBzb2Z0d2FyZSBlbmdpbmVlcmluZyBjb25jZXB0cy4gTXkgcHJvamVjdCBleHBlcmllbmNlIGhhcyBnaXZlbiBtZSBwcmFjdGljYWwga25vd2xlZGdlIG9mIHdlYiBhcHBsaWNhdGlvbiBkZXZlbG9wbWVudCwgdGV4dC1maWxlIHBlcnNpc3RlbmNlLCBhbmQgSlVuaXQgdGVzdGluZy4KCkkgY2FuIGNvbW1pdCB0byB0aGUgcmVxdWlyZWQgd29ya2xvYWQgb2YgOCBob3VycyBwZXIgd2VlayBmb3IgMTIgd2Vla3MgYW5kIGFtIGF2YWlsYWJsZSB0byBzdXBwb3J0IGxhYnMsIGFuc3dlciBzdHVkZW50IHF1ZXN0aW9ucywgYW5kIGhlbHAgd2l0aCBjb3Vyc2V3b3JrIHByZXBhcmF0aW9uLgoKVGhhbmsgeW91IGZvciBjb25zaWRlcmluZyBteSBhcHBsaWNhdGlvbi4gSSB3b3VsZCB3ZWxjb21lIHRoZSBvcHBvcnR1bml0eSB0byBzdXBwb3J0IHN0dWRlbnRzIGluIHRoaXMgbW9kdWxlLgoKU2luY2VyZWx5LApaaGFuZyBTYW4=|pending|2026-05-23|false\n";
    }

    private void createDefaultResumeIfMissing() {
        if (!DataFileUtil.loadResume("student@bupt.edu.cn").isEmpty()) {
            return;
        }

        Properties resume = new Properties();
        resume.setProperty("phone", "13800000000");
        resume.setProperty("major", "Software Engineering");
        resume.setProperty("year", "Year 3");
        resume.setProperty("gpa", "88/100");
        resume.setProperty("portfolio", "https://example.com/student-portfolio");
        resume.setProperty("education", "BUPT International School, BSc Software Engineering.");
        resume.setProperty("technicalSkills", "Java, JSP, Servlet, Python, JavaScript, Testing");
        resume.setProperty("languageSkills", "English, Mandarin");
        resume.setProperty("certifications", "Agile project teamwork, Java web coursework");
        resume.setProperty("teachingExp", "Helped classmates debug Java coursework and explained lab exercises during group study sessions.");
        resume.setProperty("projectExp", "Built a Java Servlet/JSP recruitment system using text-file persistence and JUnit tests.");
        resume.setProperty("personalStatement", "Interested in supporting students with programming labs, debugging, and software engineering teamwork.");
        DataFileUtil.saveResume("student@bupt.edu.cn", resume);
    }
}
