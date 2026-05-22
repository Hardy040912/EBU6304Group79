<%!
    /** Parse application payload stored in applications.txt field 4. */
    public static class ApplicationPayload {
        private static final String MARKER_PROFILE = "<<<TA_PROFILE>>>";
        private static final String MARKER_COVER = "<<<TA_COVER>>>";

        public static String decodeStored(String stored) {
            if (stored == null) return "";
            if (stored.startsWith("B64:")) {
                try {
                    byte[] bytes = java.util.Base64.getDecoder().decode(stored.substring(4));
                    return new String(bytes, java.nio.charset.StandardCharsets.UTF_8);
                } catch (IllegalArgumentException ex) {
                    return stored;
                }
            }
            return stored;
        }

        public static String profile(String stored) {
            String decoded = decodeStored(stored);
            if (decoded.contains(MARKER_PROFILE) && decoded.contains(MARKER_COVER)) {
                int start = decoded.indexOf(MARKER_PROFILE) + MARKER_PROFILE.length();
                int end = decoded.indexOf(MARKER_COVER);
                if (end > start) return decoded.substring(start, end).trim();
            }
            if (decoded.contains("=== STANDARD RESUME ===")) {
                int start = decoded.indexOf("=== STANDARD RESUME ===") + 23;
                int end = decoded.indexOf("=== COVER LETTER ===");
                if (end > start) return decoded.substring(start, end).trim();
            }
            return "";
        }

        public static String coverLetter(String stored) {
            String decoded = decodeStored(stored);
            if (decoded.contains(MARKER_COVER)) {
                return decoded.substring(decoded.indexOf(MARKER_COVER) + MARKER_COVER.length()).trim();
            }
            if (decoded.contains("=== COVER LETTER ===")) {
                return decoded.substring(decoded.indexOf("=== COVER LETTER ===") + 20).trim();
            }
            return decoded.trim();
        }

        public static String htmlEscape(String value) {
            if (value == null) return "";
            return value
                    .replace("&", "&amp;")
                    .replace("<", "&lt;")
                    .replace(">", "&gt;")
                    .replace("\"", "&quot;");
        }

        public static String htmlWithBreaks(String value) {
            return htmlEscape(value).replace("\n", "<br>");
        }
    }
%>
