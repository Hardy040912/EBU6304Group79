package cn.bupt.ta.listener;

import cn.bupt.ta.util.DataFileUtil;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

@WebListener
public class DataInitListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // 初始化数据目录
        String webAppPath = sce.getServletContext().getRealPath("/");
        DataFileUtil.initDataDir(webAppPath);
        
        // 创建初始数据文件（如果不存在）
        String dataDir = webAppPath + File.separator + "data" + File.separator;
        
        createFileIfNotExists(dataDir + "users.txt", getDefaultUsers());
        createFileIfNotExists(dataDir + "jobs.txt", getDefaultJobs());
        createFileIfNotExists(dataDir + "applications.txt", getDefaultApplications());
        
        System.out.println("Data directory initialized at: " + dataDir);
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // 清理资源（如果需要）
    }
    
    private void createFileIfNotExists(String filePath, String content) {
        File file = new File(filePath);
        if (!file.exists()) {
            try (FileWriter writer = new FileWriter(file)) {
                writer.write(content);
                System.out.println("Created initial data file: " + filePath);
            } catch (IOException e) {
                e.printStackTrace();
            }
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
