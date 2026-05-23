package cn.bupt.ta.listener;

import cn.bupt.ta.servlet.ServletTestSupport;
import cn.bupt.ta.util.DataFileUtil;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class DataInitListenerTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    @Test
    public void contextInitializedCreatesDefaultDataFiles() {
        DataInitListener listener = new DataInitListener();

        listener.contextInitialized(ServletTestSupport.contextEvent(temporaryFolder.getRoot()));

        File dataDir = new File(temporaryFolder.getRoot(), "data");
        assertTrue(new File(dataDir, "users.txt").exists());
        assertTrue(new File(dataDir, "staff_ids.txt").exists());
        assertTrue(new File(dataDir, "jobs.txt").exists());
        assertTrue(new File(dataDir, "applications.txt").exists());
        assertEquals(3, DataFileUtil.readLines("users.txt").size());
        assertEquals(3, DataFileUtil.readLines("staff_ids.txt").size());
        assertEquals(3, DataFileUtil.readLines("jobs.txt").size());
        assertEquals(1, DataFileUtil.readLines("applications.txt").size());
        assertEquals("Software Engineering", DataFileUtil.loadResume("student@bupt.edu.cn").getProperty("major"));
    }

    @Test
    public void contextInitializedDoesNotOverwriteExistingUserFile() throws Exception {
        File dataDir = new File(temporaryFolder.getRoot(), "data");
        assertTrue(dataDir.mkdirs());
        File usersFile = new File(dataDir, "users.txt");
        Files.write(usersFile.toPath(),
                java.util.Arrays.asList("# custom", "custom@bupt.edu.cn|secret|student|Custom User"),
                StandardCharsets.UTF_8);

        DataInitListener listener = new DataInitListener();
        listener.contextInitialized(ServletTestSupport.contextEvent(temporaryFolder.getRoot()));

        List<String> users = DataFileUtil.readLines("users.txt");
        assertEquals(1, users.size());
        assertEquals("custom@bupt.edu.cn|secret|student|Custom User", users.get(0));
    }
}
