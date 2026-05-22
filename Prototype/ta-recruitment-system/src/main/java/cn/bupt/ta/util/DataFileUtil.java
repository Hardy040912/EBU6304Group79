package cn.bupt.ta.util;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class DataFileUtil {

    // 使用相对路径，部署时会自动解析到 WEB-INF/classes/data 或 webapp/data
    private static String dataDir = null;

    // 初始化数据目录
    public static void initDataDir(String webAppPath) {
        if (dataDir == null) {
            dataDir = "D:" + File.separator + "ta-recruitment-data" + File.separator;
            File dir = new File(dataDir);
            if (!dir.exists()) {
                dir.mkdirs();
            }
        }
    }

    public static List<String> readLines(String fileName) {
        List<String> lines = new ArrayList<>();
        if (dataDir == null) {
            throw new RuntimeException("Data directory not initialized. Call initDataDir() first.");
        }
        File file = new File(dataDir + fileName);
        
        if (!file.exists()) {
            return lines;
        }
        
        try (BufferedReader reader = new BufferedReader(
                new InputStreamReader(new FileInputStream(file), StandardCharsets.UTF_8))) {
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty() && !line.startsWith("#")) {
                    lines.add(line);
                }
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        return lines;
    }

    public static void appendLine(String fileName, String line) {
        if (dataDir == null) {
            throw new RuntimeException("Data directory not initialized. Call initDataDir() first.");
        }
        File file = new File(dataDir + fileName);
        
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(file, true), StandardCharsets.UTF_8))) {
            writer.write(line);
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void writeLines(String fileName, List<String> lines) {
        if (dataDir == null) {
            throw new RuntimeException("Data directory not initialized. Call initDataDir() first.");
        }
        File file = new File(dataDir + fileName);
        
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(file), StandardCharsets.UTF_8))) {
            writer.write("# 格式: " + getFormatComment(fileName));
            writer.newLine();
            for (String line : lines) {
                writer.write(line);
                writer.newLine();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    private static String getFormatComment(String fileName) {
        if (fileName.equals("users.txt")) {
            return "email|password|role|name";
        } else if (fileName.equals("jobs.txt")) {
            return "jobId|title|moduleCode|module|organiser|organiserId|description|skills|hoursPerWeek|duration|status";
        } else if (fileName.equals("applications.txt")) {
            return "appId|jobId|studentEmail|studentName|coverLetter|status|applyDate|blocked";
        }
        return "";
    }

    /** 生成自增 ID，格式为 prefix + 数字，基于文件中已有的行数 */
    public static synchronized String nextId(String prefix, String fileName) {
        List<String> lines = readLines(fileName);
        return prefix + (lines.size() + 1);
    }

    /** 将简历保存为 data/resumes/{email}.properties */
    public static void saveResume(String email, java.util.Properties props) {
        String resumeDir = dataDir + "resumes" + File.separator;
        new File(resumeDir).mkdirs();
        String path = resumeDir + email.replace("@", "_at_").replace(".", "_") + ".properties";
        try (OutputStream out = new FileOutputStream(path)) {
            props.store(out, "Resume for " + email);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /** 读取简历，若不存在返回空 Properties */
    public static java.util.Properties loadResume(String email) {
        java.util.Properties props = new java.util.Properties();
        if (dataDir == null) return props;
        String path = dataDir + "resumes" + File.separator
                + email.replace("@", "_at_").replace(".", "_") + ".properties";
        File file = new File(path);
        if (!file.exists()) return props;
        try (InputStream in = new FileInputStream(file)) {
            props.load(in);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return props;
    }
}
