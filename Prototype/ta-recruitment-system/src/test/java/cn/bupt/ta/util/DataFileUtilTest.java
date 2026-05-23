package cn.bupt.ta.util;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.rules.TemporaryFolder;

import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.Arrays;
import java.util.List;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class DataFileUtilTest {

    @Rule
    public TemporaryFolder temporaryFolder = new TemporaryFolder();

    @Before
    public void setUp() {
        DataFileUtil.initDataDir(temporaryFolder.getRoot().getAbsolutePath());
    }

    @Test
    public void readLinesIgnoresCommentsAndBlankLines() throws Exception {
        File file = new File(temporaryFolder.getRoot(), "data/users.txt");
        Files.write(file.toPath(), Arrays.asList(
                "# email|password|role|name",
                "",
                "alice@bupt.edu.cn|123456|student|Alice",
                "   ",
                "mo@bupt.edu.cn|123456|module-organiser|Dr Smith"
        ), StandardCharsets.UTF_8);

        List<String> lines = DataFileUtil.readLines("users.txt");

        assertEquals(2, lines.size());
        assertEquals("alice@bupt.edu.cn|123456|student|Alice", lines.get(0));
        assertEquals("mo@bupt.edu.cn|123456|module-organiser|Dr Smith", lines.get(1));
    }

    @Test
    public void appendLineAddsContentToDataFile() {
        DataFileUtil.appendLine("jobs.txt", "j1|Tutor|CS101|Programming|Dr Li|li@bupt.edu.cn|Help labs|Java|8|12 weeks|open");

        List<String> lines = DataFileUtil.readLines("jobs.txt");

        assertEquals(1, lines.size());
        assertTrue(lines.get(0).startsWith("j1|Tutor|CS101"));
    }

    @Test
    public void writeLinesAddsFormatHeaderAndReadableRows() {
        DataFileUtil.writeLines("applications.txt", Arrays.asList(
                "app1|j1|alice@bupt.edu.cn|Alice|B64:test|pending|2026-05-20|false"
        ));

        List<String> lines = DataFileUtil.readLines("applications.txt");

        assertEquals(1, lines.size());
        assertEquals("app1|j1|alice@bupt.edu.cn|Alice|B64:test|pending|2026-05-20|false", lines.get(0));
    }

    @Test
    public void nextIdContinuesFromHighestExistingNumericSuffix() {
        DataFileUtil.writeLines("applications.txt", Arrays.asList(
                "app1|j1|alice@bupt.edu.cn|Alice|B64:first|pending|2026-05-20|false",
                "legacy|j2|bob@bupt.edu.cn|Bob|B64:old|pending|2026-05-20|false",
                "app9|j3|carol@bupt.edu.cn|Carol|B64:last|pending|2026-05-20|false"
        ));

        assertEquals("app10", DataFileUtil.nextId("app", "applications.txt"));
    }

    @Test
    public void safeFieldRemovesLineBreaksAndPipeDelimiters() {
        assertEquals("Advanced / Java Lab", DataFileUtil.safeField(" Advanced | Java\nLab "));
    }
}
