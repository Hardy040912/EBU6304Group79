package cn.bupt.ta.util;

import org.junit.Test;

import java.util.List;
import java.util.Properties;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

public class SkillMatcherTest {

    @Test
    public void matchScoresRequiredSkillsAgainstResumeFields() {
        Properties resume = new Properties();
        resume.setProperty("technicalSkills", "Java, JSP, SQL");
        resume.setProperty("languageSkills", "English, Mandarin");
        resume.setProperty("projectExp", "Built a servlet based web app.");

        SkillMatcher.MatchResult result = SkillMatcher.match("Java, JSP, Python, English", resume);

        assertEquals(75, result.getScore());
        assertEquals("Java, JSP, English", result.getMatchedSummary());
        assertEquals("Python", result.getMissingSummary());
    }

    @Test
    public void parseSkillsRemovesEmptyAndDuplicateValues() {
        List<String> skills = SkillMatcher.parseSkills("Java, JSP; Java\nPython / English");

        assertEquals(4, skills.size());
        assertTrue(skills.contains("Java"));
        assertTrue(skills.contains("JSP"));
        assertTrue(skills.contains("Python"));
        assertTrue(skills.contains("English"));
    }

    @Test
    public void emptyRequirementProducesZeroScoreAndNoMissingSkills() {
        SkillMatcher.MatchResult result = SkillMatcher.match("", new Properties());

        assertEquals(0, result.getScore());
        assertTrue(result.getMatchedSkills().isEmpty());
        assertTrue(result.getMissingSkills().isEmpty());
    }
}
