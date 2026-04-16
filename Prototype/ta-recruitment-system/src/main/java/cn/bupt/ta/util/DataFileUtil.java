package cn.bupt.ta.util;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

public class DataFileUtil {
    
    private static final String DATA_DIR = "D:\\prototype\\EBU6304Group79\\Prototype\\ta-recruitment-system\\data\\";
    
    public static List<String> readLines(String fileName) {
        List<String> lines = new ArrayList<>();
        File file = new File(DATA_DIR + fileName);
        
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
        File file = new File(DATA_DIR + fileName);
        
        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(file, true), StandardCharsets.UTF_8))) {
            writer.write(line);
            writer.newLine();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public static void writeLines(String fileName, List<String> lines) {
        File file = new File(DATA_DIR + fileName);
        
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
            return "appId|jobId|studentEmail|studentName|coverLetter|status|applyDate";
        }
        return "";
    }
}
