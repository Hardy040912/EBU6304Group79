package cn.bupt.ta.util;

import java.util.ArrayList;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Properties;
import java.util.Set;

public class SkillMatcher {

    public static MatchResult match(String requiredSkills, Properties resume) {
        List<String> required = parseSkills(requiredSkills);
        Set<String> applicantTokens = applicantTokens(resume);
        List<String> matched = new ArrayList<>();
        List<String> missing = new ArrayList<>();

        for (String skill : required) {
            if (containsSkill(applicantTokens, skill)) {
                matched.add(skill);
            } else {
                missing.add(skill);
            }
        }

        int score = required.isEmpty() ? 0 : Math.round((matched.size() * 100f) / required.size());
        return new MatchResult(score, matched, missing);
    }

    public static List<String> parseSkills(String skills) {
        List<String> result = new ArrayList<>();
        if (skills == null || skills.trim().isEmpty()) {
            return result;
        }

        String[] parts = skills.split("[,;\\n/]+");
        Set<String> unique = new LinkedHashSet<>();
        for (String part : parts) {
            String clean = part.trim();
            if (!clean.isEmpty()) {
                unique.add(clean);
            }
        }
        result.addAll(unique);
        return result;
    }

    private static Set<String> applicantTokens(Properties resume) {
        Set<String> tokens = new LinkedHashSet<>();
        if (resume == null) {
            return tokens;
        }

        addTokens(tokens, resume.getProperty("technicalSkills"));
        addTokens(tokens, resume.getProperty("languageSkills"));
        addTokens(tokens, resume.getProperty("certifications"));
        addTokens(tokens, resume.getProperty("education"));
        addTokens(tokens, resume.getProperty("teachingExp"));
        addTokens(tokens, resume.getProperty("projectExp"));
        addTokens(tokens, resume.getProperty("personalStatement"));
        return tokens;
    }

    private static void addTokens(Set<String> tokens, String value) {
        if (value == null || value.trim().isEmpty()) {
            return;
        }

        String normalized = normalize(value);
        tokens.add(normalized);
        for (String part : normalized.split("[^a-z0-9+#.]+")) {
            if (!part.isEmpty()) {
                tokens.add(part);
            }
        }
    }

    private static boolean containsSkill(Set<String> applicantTokens, String requiredSkill) {
        String normalizedSkill = normalize(requiredSkill);
        if (normalizedSkill.isEmpty()) {
            return false;
        }
        if (applicantTokens.contains(normalizedSkill)) {
            return true;
        }
        for (String token : applicantTokens) {
            if (token.contains(normalizedSkill) || normalizedSkill.contains(token)) {
                return true;
            }
        }
        return false;
    }

    private static String normalize(String text) {
        return text == null ? "" : text.toLowerCase(Locale.ROOT).trim();
    }

    public static class MatchResult {
        private final int score;
        private final List<String> matchedSkills;
        private final List<String> missingSkills;

        MatchResult(int score, List<String> matchedSkills, List<String> missingSkills) {
            this.score = score;
            this.matchedSkills = matchedSkills;
            this.missingSkills = missingSkills;
        }

        public int getScore() {
            return score;
        }

        public List<String> getMatchedSkills() {
            return matchedSkills;
        }

        public List<String> getMissingSkills() {
            return missingSkills;
        }

        public String getMatchedSummary() {
            return matchedSkills.isEmpty() ? "No direct skill matches yet" : String.join(", ", matchedSkills);
        }

        public String getMissingSummary() {
            return missingSkills.isEmpty() ? "No missing required skills" : String.join(", ", missingSkills);
        }
    }
}
