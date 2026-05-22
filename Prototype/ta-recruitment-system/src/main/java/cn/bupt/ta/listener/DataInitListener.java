package cn.bupt.ta.listener;

import cn.bupt.ta.util.DataFileUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class DataInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        String webAppPath = sce.getServletContext().getRealPath("/");
        DataFileUtil.initDataDir(webAppPath);

        createFileIfNotExists("users.txt", getDefaultUsers());
        createFileIfNotExists("jobs.txt", getDefaultJobs());
        createFileIfNotExists("applications.txt", getDefaultApplications());

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
        return "# 格式: email|password|role|name\n" +
               "student@bupt.edu.cn|123456|student|Zhang San\n" +
               "mo@bupt.edu.cn|123456|module-organiser|Li Si\n" +
               "admin@bupt.edu.cn|123456|admin|Wang Wu\n";
    }
    
    private String getDefaultJobs() {
        return "# 格式: jobId|title|moduleCode|module|organiser|organiserId|description|skills|hoursPerWeek|duration|status\n";
    }
    
    private String getDefaultApplications() {
        return "# 格式: appId|jobId|studentEmail|studentName|coverLetter|status|applyDate|blocked\n";
    }
}
